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

    // 权重常量
    private static final double W_INTEREST = 1.5;
    private static final double W_MAJOR = 2.0;
    private static final double W_GPA = 2.0;
    private static final double W_SCORE = 3.0;

    private final PreferenceDAO preferenceDAO = new PreferenceDAO();
    private final TutorDAO tutorDAO = new TutorDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final StudentExtDAO studentExtDAO = new StudentExtDAO();

    public List<TutorScore> recommendForStudent(int studentId, int topN) {
        Student target = studentDAO.findById(studentId);
        if (target == null) {
            return Collections.emptyList();
        }

        List<StudentPreference> allPrefs = preferenceDAO.findAll();
        if (allPrefs.isEmpty()) {
            return contentBasedFallback(target, topN);
        }

        Map<Integer, Map<Integer, Double>> ratingMatrix = buildRatingMatrix(allPrefs);
        Map<Integer, Double> targetRatings = ratingMatrix.get(studentId);
        if (targetRatings == null || targetRatings.size() < 1) {
            return contentBasedFallback(target, topN);
        }

        Map<Integer, Double> similarities = new HashMap<>();
        for (Map.Entry<Integer, Map<Integer, Double>> entry : ratingMatrix.entrySet()) {
            int otherId = entry.getKey();
            if (otherId == studentId) continue;
            double sim = cosineSimilarity(targetRatings, entry.getValue());
            if (sim > 0) {
                similarities.put(otherId, sim);
            }
        }

        if (similarities.isEmpty()) {
            return contentBasedFallback(target, topN);
        }

        Set<Integer> ratedTutors = targetRatings.keySet();
        List<Tutor> tutors = tutorDAO.findAll();
        Map<Integer, Tutor> tutorMap = tutors.stream().collect(Collectors.toMap(Tutor::getId, t -> t));

        List<TutorScore> predictions = new ArrayList<>();
        for (Tutor tutor : tutors) {
            if (ratedTutors.contains(tutor.getId())) {
                continue;
            }
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
                double predicted = numerator / denominator;
                predictions.add(new TutorScore(tutorMap.get(tutor.getId()), predicted,
                        "基于与你相似学生的评分的协同过滤推荐"));
            }
        }

        if (predictions.isEmpty()) {
            return contentBasedFallback(target, topN);
        }

        Collections.sort(predictions);
        return predictions.stream().limit(topN).collect(Collectors.toList());
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

    private List<TutorScore> contentBasedFallback(Student student, int topN) {
        List<Tutor> tutors = tutorDAO.findAll();
        List<TutorScore> list = new ArrayList<>();

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

            if (score > 0) {
                list.add(new TutorScore(tutor, score, "基于专业、兴趣、GPA和考研成绩的内容匹配推荐"));
            }
        }

        Collections.sort(list);
        return list.stream().limit(topN).collect(Collectors.toList());
    }

    private static String cleanStr(String s) {
        if (s == null) return "";
        return s.replace("\r", "").replace("\n", "").trim();
    }
}
