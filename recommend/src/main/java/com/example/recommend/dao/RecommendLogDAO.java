package com.example.recommend.dao;

import com.example.recommend.config.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RecommendLogDAO {
    public void deleteByStudentId(int studentId) {
        String sql = "DELETE FROM recommend_log WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean insertLog(int studentId, int tutorId, double recommendScore) {
        String sql = "INSERT INTO recommend_log(student_id, tutor_id, recommend_score, create_time) VALUES(?,?,?,NOW())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, tutorId);
            ps.setDouble(3, recommendScore);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
