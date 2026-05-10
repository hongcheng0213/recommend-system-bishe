package com.example.recommend.dao;

import com.example.recommend.config.DBUtil;
import com.example.recommend.model.Tutor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TutorDAO {

    public List<Tutor> findAll() {
        List<Tutor> list = new ArrayList<>();
        String sql = "SELECT t.*, te.title, te.research_achievement, te.student_quota, te.hot_score " +
                "FROM tutors t LEFT JOIN tutor_ext te ON t.id = te.tutor_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Tutor findById(int id) {
        String sql = "SELECT t.*, te.title, te.research_achievement, te.student_quota, te.hot_score " +
                "FROM tutors t LEFT JOIN tutor_ext te ON t.id = te.tutor_id WHERE t.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Tutor> findByFilter(String university, String department, String keyword) {
        List<Tutor> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.*, te.title, te.research_achievement, te.student_quota, te.hot_score " +
                "FROM tutors t LEFT JOIN tutor_ext te ON t.id = te.tutor_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (university != null && !university.isEmpty()) {
            sql.append(" AND t.university = ?");
            params.add(university);
        }
        if (department != null && !department.isEmpty()) {
            sql.append(" AND t.department = ?");
            params.add(department);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (t.name LIKE ? OR t.research_fields LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // 对搜索结果进行过滤，确保只有完全匹配或包含完整关键词的结果被返回
        if (keyword != null && !keyword.isEmpty()) {
            List<Tutor> filteredList = new ArrayList<>();
            for (Tutor tutor : list) {
                // 检查姓名是否完全匹配
                if (keyword.equals(tutor.getName())) {
                    filteredList.add(tutor);
                }
                // 检查研究方向是否包含关键词
                else if (tutor.getResearchFields() != null && tutor.getResearchFields().contains(keyword)) {
                    filteredList.add(tutor);
                }
                // 检查姓名是否包含关键词且不是作为其他词的前缀
                else if (tutor.getName() != null && tutor.getName().contains(keyword)) {
                    // 确保关键词在姓名中是一个完整的词
                    String name = tutor.getName();
                    int index = name.indexOf(keyword);
                    // 检查关键词是否在开头且后面是边界
                    if (index == 0 && (name.length() == keyword.length() || !Character.isLetterOrDigit(name.charAt(index + keyword.length())))) {
                        filteredList.add(tutor);
                    }
                    // 检查关键词是否在中间且前后都是边界
                    else if (index > 0 && index + keyword.length() < name.length() && 
                             !Character.isLetterOrDigit(name.charAt(index - 1)) && 
                             !Character.isLetterOrDigit(name.charAt(index + keyword.length()))) {
                        filteredList.add(tutor);
                    }
                    // 检查关键词是否在结尾且前面是边界
                    else if (index + keyword.length() == name.length() && !Character.isLetterOrDigit(name.charAt(index - 1))) {
                        filteredList.add(tutor);
                    }
                }
            }
            return filteredList;
        }
        
        return list;
    }

    public List<String> getUniversities() {
        List<String> universities = new ArrayList<>();
        String sql = "SELECT DISTINCT university FROM tutors WHERE university IS NOT NULL AND university != ''";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                universities.add(rs.getString("university"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return universities;
    }

    public List<String> getDepartments(String university) {
        List<String> departments = new ArrayList<>();
        String sql = "SELECT DISTINCT department FROM tutors WHERE department IS NOT NULL AND department != ''";
        if (university != null && !university.isEmpty()) {
            sql += " AND university = ?";
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (university != null && !university.isEmpty()) {
                ps.setString(1, university);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                departments.add(rs.getString("department"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return departments;
    }

    private Tutor mapRow(ResultSet rs) throws SQLException {
        Tutor t = new Tutor();
        t.setId(rs.getInt("id"));
        t.setName(rs.getString("name"));
        t.setGender(rs.getString("gender"));
        t.setUniversity(rs.getString("university"));
        t.setDepartment(rs.getString("department"));
        t.setResearchFields(rs.getString("research_fields"));
        t.setQuota(rs.getInt("quota"));
        t.setTitle(rs.getString("title"));
        t.setResearchAchievement(rs.getString("research_achievement"));
        t.setStudentQuota(rs.getInt("student_quota"));
        t.setHotScore(rs.getInt("hot_score"));
        t.setPhoto(rs.getString("photo"));
        t.setHomepageUrl(rs.getString("homepage_url"));
        return t;
    }
}

