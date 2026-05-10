package com.example.recommend.dao;

import com.example.recommend.config.DBUtil;
import com.example.recommend.model.StudentExt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StudentExtDAO {
    public boolean saveOrUpdate(StudentExt ext) {
        String sql = "REPLACE INTO student_ext(student_id, grade, gpa, phone, email) VALUES(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ext.getStudentId());
            ps.setString(2, ext.getGrade());
            ps.setDouble(3, ext.getGpa());
            ps.setString(4, ext.getPhone());
            ps.setString(5, ext.getEmail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public StudentExt findByStudentId(int studentId) {
        String sql = "SELECT * FROM student_ext WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                StudentExt ext = new StudentExt();
                ext.setStudentId(rs.getInt("student_id"));
                ext.setGrade(rs.getString("grade"));
                ext.setGpa(rs.getDouble("gpa"));
                ext.setPhone(rs.getString("phone"));
                ext.setEmail(rs.getString("email"));
                return ext;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
