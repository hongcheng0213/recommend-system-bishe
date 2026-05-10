package com.example.recommend.dao;

import com.example.recommend.config.DBUtil;
import com.example.recommend.model.StudentPreference;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PreferenceDAO {

    public void saveOrUpdatePreference(int studentId, int tutorId, double score) {
        String sql = "REPLACE INTO student_preferences(student_id, tutor_id, preference_score) VALUES(?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, tutorId);
            ps.setDouble(3, score);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<StudentPreference> findByStudentId(int studentId) {
        List<StudentPreference> list = new ArrayList<>();
        String sql = "SELECT * FROM student_preferences WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentPreference sp = new StudentPreference();
                sp.setStudentId(rs.getInt("student_id"));
                sp.setTutorId(rs.getInt("tutor_id"));
                sp.setScore(rs.getDouble("preference_score"));
                list.add(sp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<StudentPreference> findAll() {
        List<StudentPreference> list = new ArrayList<>();
        String sql = "SELECT * FROM student_preferences";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentPreference sp = new StudentPreference();
                sp.setStudentId(rs.getInt("student_id"));
                sp.setTutorId(rs.getInt("tutor_id"));
                sp.setScore(rs.getDouble("preference_score"));
                list.add(sp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

