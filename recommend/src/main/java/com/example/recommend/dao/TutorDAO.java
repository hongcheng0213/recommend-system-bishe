package com.example.recommend.dao;

import com.example.recommend.config.DBUtil;
import com.example.recommend.model.Tutor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TutorDAO {

    public List<Tutor> findAll() {
        List<Tutor> list = new ArrayList<>();
        String sql = "SELECT t.*, te.title, te.research_achievement, te.student_quota " +
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
        String sql = "SELECT t.*, te.title, te.research_achievement, te.student_quota " +
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
        StringBuilder sql = new StringBuilder("SELECT t.*, te.title, te.research_achievement, te.student_quota " +
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

        if (keyword != null && !keyword.isEmpty()) {
            List<Tutor> filteredList = new ArrayList<>();
            for (Tutor tutor : list) {
                if (keyword.equals(tutor.getName())) {
                    filteredList.add(tutor);
                }
                else if (tutor.getResearchFields() != null && tutor.getResearchFields().contains(keyword)) {
                    filteredList.add(tutor);
                }
                else if (tutor.getName() != null && tutor.getName().contains(keyword)) {
                    String name = tutor.getName();
                    int index = name.indexOf(keyword);
                    if (index == 0 && (name.length() == keyword.length() || !Character.isLetterOrDigit(name.charAt(index + keyword.length())))) {
                        filteredList.add(tutor);
                    }
                    else if (index > 0 && index + keyword.length() < name.length() &&
                             !Character.isLetterOrDigit(name.charAt(index - 1)) &&
                             !Character.isLetterOrDigit(name.charAt(index + keyword.length()))) {
                        filteredList.add(tutor);
                    }
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

    public int insert(Tutor t) {
        String sql = "INSERT INTO tutors (name, gender, university, department, research_fields, quota, photo, homepage_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getGender());
            ps.setString(3, t.getUniversity());
            ps.setString(4, t.getDepartment());
            ps.setString(5, t.getResearchFields());
            if (t.getQuota() > 0) ps.setInt(6, t.getQuota()); else ps.setNull(6, Types.INTEGER);
            ps.setString(7, t.getPhoto());
            ps.setString(8, t.getHomepageUrl());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean update(Tutor t) {
        String sql = "UPDATE tutors SET name=?, gender=?, university=?, department=?, " +
                     "research_fields=?, quota=?, photo=?, homepage_url=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getGender());
            ps.setString(3, t.getUniversity());
            ps.setString(4, t.getDepartment());
            ps.setString(5, t.getResearchFields());
            if (t.getQuota() > 0) ps.setInt(6, t.getQuota()); else ps.setNull(6, Types.INTEGER);
            ps.setString(7, t.getPhoto());
            ps.setString(8, t.getHomepageUrl());
            ps.setInt(9, t.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
        t.setPhoto(rs.getString("photo"));
        t.setHomepageUrl(rs.getString("homepage_url"));
        return t;
    }
}
