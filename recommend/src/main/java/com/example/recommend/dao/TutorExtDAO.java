package com.example.recommend.dao;

import com.example.recommend.config.DBUtil;
import com.example.recommend.model.TutorExt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TutorExtDAO {
    public boolean saveOrUpdate(TutorExt ext) {
        String sql = "REPLACE INTO tutor_ext(tutor_id, title, research_achievement, student_quota, hot_score) VALUES(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ext.getTutorId());
            ps.setString(2, ext.getTitle());
            ps.setString(3, ext.getResearchAchievement());
            ps.setInt(4, ext.getStudentQuota());
            ps.setInt(5, ext.getHotScore());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public TutorExt findByTutorId(int tutorId) {
        String sql = "SELECT * FROM tutor_ext WHERE tutor_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TutorExt ext = new TutorExt();
                ext.setTutorId(rs.getInt("tutor_id"));
                ext.setTitle(rs.getString("title"));
                ext.setResearchAchievement(rs.getString("research_achievement"));
                ext.setStudentQuota(rs.getInt("student_quota"));
                ext.setHotScore(rs.getInt("hot_score"));
                return ext;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TutorExt> findAll() {
        String sql = "SELECT * FROM tutor_ext";
        List<TutorExt> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TutorExt ext = new TutorExt();
                ext.setTutorId(rs.getInt("tutor_id"));
                ext.setTitle(rs.getString("title"));
                ext.setResearchAchievement(rs.getString("research_achievement"));
                ext.setStudentQuota(rs.getInt("student_quota"));
                ext.setHotScore(rs.getInt("hot_score"));
                list.add(ext);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
