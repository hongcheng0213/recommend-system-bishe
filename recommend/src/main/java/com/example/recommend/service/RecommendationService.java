package com.example.recommend.service;

import com.example.recommend.dao.PreferenceDAO;
import com.example.recommend.dao.StudentDAO;
import com.example.recommend.dao.StudentExtDAO;
import com.example.recommend.dao.TutorDAO;
import com.example.recommend.model.Student;
import com.example.recommend.model.StudentExt;
import com.example.recommend.model.StudentPreference;
import com.example.recommend.model.Tutor;
import com.example.recommend.model.TutorScore;

import java.util.*;
import java.util.stream.Collectors;

public class RecommendationService {

    private static final double W_INTEREST = 1.5;
    private static final double W_MAJOR = 2.0;
    private static final double W_GPA = 2.0;
    private static final double W_SCORE = 3.0;
    private static final double CONTENT_WEIGHT = 0.6;
    private static final double CF_WEIGHT = 0.4;

    private final PreferenceDAO preferenceDAO = new PreferenceDAO();
    private final TutorDAO tutorDAO = new TutorDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final StudentExtDAO studentExtDAO = new StudentExtDAO();

    public List<TutorScore> recommendForStudent(int studentId, int topN) {
        Student target = studentDAO.findById(studentId);
        if (target == null) {
            return Collections.emptyList();
        }

        List<Tutor> tutors = tutorDAO.findAll();
        Map<Integer, Tutor> tutorMap = tutors.stream().collect(Collectors.toMap(Tutor::getId, t -> t));

        // 始终计算内容匹配分数
        Map<Integer, Double> contentScores = computeContentScores(target, tutors);

        // 尝试协同过滤
        Map<Integer, Double> cfPredictions = computeCFPredictions(studentId, tutors);

        // 混合评分
        List<TutorScore> results = new ArrayList<>();

        // 找到内容分数的最大值用于归一化
        double maxContent = contentScores.values().stream().max(Double::compareTo).orElse(1.0);

        for (Tutor tutor : tutors) {
            Double contentScore = contentScores.get(tutor.getId());
            if (contentScore == null) continue;

            // 归一化内容分数到 0-1
            double contentNorm = maxContent > 0 ? contentScore / maxContent : 0;

            double finalScore;
            String reason;

            Double cfPred = cfPredictions.get(tutor.getId());
            if (cfPred != null) {
                // 有协同过滤预测：60%内容 + 40%协同
                double cfNorm = cfPred / 5.0;
                finalScore = CONTENT_WEIGHT * contentNorm + CF_WEIGHT * cfNorm;
                reason = "基于内容匹配(60%)与相似学生评分(40%)的混合推荐";
            } else {
                // 无协同过滤预测：100%内容匹配
                finalScore = contentNorm;
                reason = "基于专业、兴趣、GPA和考研成绩的内容匹配推荐";
            }

            results.add(new TutorScore(tutor, finalScore, reason));
        }

        Collections.sort(results);
        return results.stream().limit(topN).collect(Collectors.toList());
    }

    private Map<Integer, Double> computeContentScores(Student student, List<Tutor> tutors) {
        Map<Integer, Double> scores = new LinkedHashMap<>();

        String interests = cleanStr(student.getInterests());
        String major = cleanStr(student.getMajor());

        StudentExt studentExt = studentExtDAO.findByStudentId(student.getId());
        double gpa = studentExt != null ? studentExt.getGpa() : 2.0;
        double studentScore = student.getScore();

        for (Tutor tutor : tutors) {
            String fields = cleanStr(tutor.getResearchFields());
            String dept = cleanStr(tutor.getDepartment());

            double score = 0.0;

            // 兴趣关键词匹配
            if (!interests.isEmpty()) {
                String[] parts = interests.split("[,，;；\\s]+");
                for (String p : parts) {
                    if (!p.isEmpty() && fields.contains(p)) {
                        score += W_INTEREST;
                    }
                }
            }

            // 专业与院系匹配
            if (!major.isEmpty() && dept.contains(major)) {
                score += W_MAJOR;
            }

            // GPA 贡献 (0-4 → 0-2)
            score += (gpa / 4.0) * W_GPA;

            // 考研分数贡献 (0-500 → 0-3.0)
            score += Math.min(studentScore / 500.0, 1.0) * W_SCORE;

            scores.put(tutor.getId(), score);
        }

        return scores;
    }

    private Map<Integer, Double> computeCFPredictions(int studentId, List<Tutor> tutors) {
        Map<Integer, Double> predictions = new LinkedHashMap<>();

        List<StudentPreference> allPrefs = preferenceDAO.findAll();
        if (allPrefs.isEmpty()) return predictions;

        Map<Integer, Map<Integer, Double>> ratingMatrix = buildRatingMatrix(allPrefs);
        Map<Integer, Double> targetRatings = ratingMatrix.get(studentId);
        if (targetRatings == null || targetRatings.size() < 1) return predictions;

        // 计算与其他学生的相似度
        Map<Integer, Double> similarities = new HashMap<>();
        for (Map.Entry<Integer, Map<Integer, Double>> entry : ratingMatrix.entrySet()) {
            int otherId = entry.getKey();
            if (otherId == studentId) continue;
            double sim = cosineSimilarity(targetRatings, entry.getValue());
            if (sim > 0) {
                similarities.put(otherId, sim);
            }
        }

        if (similarities.isEmpty()) return predictions;

        // 预测未评分导师的分数
        Set<Integer> ratedTutors = targetRatings.keySet();
        for (Tutor tutor : tutors) {
            if (ratedTutors.contains(tutor.getId())) continue;

            double numerator = 0.0;
            double denominator = 0.0;
            for (Map.Entry<Integer, Double> simEntry : similarities.entrySet()) {
                int otherStudentId = simEntry.getKey();
                double sim = simEntry.getValue();
                Map<Integer, Double> otherRatings = ratingMatrix.get(otherStudentId);
                if (otherRatings != null && otherRatings.containsKey(tutor.getId())) {
                    numerator += sim * otherRatings.get(tutor.getId());
                    denominator += Math.abs(sim);
                }
            }
            if (denominator > 0) {
                predictions.put(tutor.getId(), numerator / denominator);
            }
        }

        return predictions;
    }

    private Map<Integer, Map<Integer, Double>> buildRatingMatrix(List<StudentPreference> prefs) {
        Map<Integer, Map<Integer, Double>> matrix = new HashMap<>();
        for (StudentPreference sp : prefs) {
            matrix.computeIfAbsent(sp.getStudentId(), k -> new HashMap<>())
                    .put(sp.getTutorId(), sp.getScore());
        }
        return matrix;
    }

    private double cosineSimilarity(Map<Integer, Double> a, Map<Integer, Double> b) {
        Set<Integer> common = new HashSet<>(a.keySet());
        common.retainAll(b.keySet());
        if (common.isEmpty()) return 0.0;

        double dot = 0.0;
        double normA = 0.0;
        double normB = 0.0;
        for (int item : common) {
            double va = a.get(item);
            double vb = b.get(item);
            dot += va * vb;
        }
        for (double va : a.values()) {
            normA += va * va;
        }
        for (double vb : b.values()) {
            normB += vb * vb;
        }
        if (normA == 0 || normB == 0) return 0.0;
        return dot / (Math.sqrt(normA) * Math.sqrt(normB));
    }

    private static String cleanStr(String s) {
        if (s == null) return "";
        return s.replace("\r", "").replace("\n", "").trim();
    }
}
