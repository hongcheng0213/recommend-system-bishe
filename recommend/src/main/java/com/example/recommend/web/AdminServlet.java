package com.example.recommend.web;

import com.example.recommend.dao.TutorDAO;
import com.example.recommend.dao.TutorExtDAO;
import com.example.recommend.model.Tutor;
import com.example.recommend.model.TutorExt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = "/admin")
public class AdminServlet extends HttpServlet {

    private final TutorDAO tutorDAO = new TutorDAO();
    private final TutorExtDAO tutorExtDAO = new TutorExtDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Tutor> tutors = tutorDAO.findAll();
        req.setAttribute("tutors", tutors);
        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String tutorIdStr = req.getParameter("tutorId");
        String title = req.getParameter("title");
        String achievement = req.getParameter("researchAchievement");
        String studentQuotaStr = req.getParameter("studentQuota");
        String hotScoreStr = req.getParameter("hotScore");

        int tutorId = 0;
        int studentQuota = 0;
        int hotScore = 0;
        try { tutorId = Integer.parseInt(tutorIdStr); } catch (Exception ignored) {}
        try { studentQuota = Integer.parseInt(studentQuotaStr); } catch (Exception ignored) {}
        try { hotScore = Integer.parseInt(hotScoreStr); } catch (Exception ignored) {}

        if (tutorId > 0) {
            TutorExt ext = new TutorExt();
            ext.setTutorId(tutorId);
            ext.setTitle(title);
            ext.setResearchAchievement(achievement);
            ext.setStudentQuota(studentQuota);
            ext.setHotScore(hotScore);
            tutorExtDAO.saveOrUpdate(ext);
            req.setAttribute("success", "导师信息已保存");
        } else {
            req.setAttribute("error", "请选择有效导师并填写正确信息");
        }
        doGet(req, resp);
    }
}
