package com.example.recommend.web;

import com.example.recommend.dao.RecommendLogDAO;
import com.example.recommend.model.TutorScore;
import com.example.recommend.service.RecommendationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RecommendServlet", urlPatterns = "/student/recommend")
public class RecommendServlet extends HttpServlet {

    private final RecommendationService recommendationService = new RecommendationService();
    private final RecommendLogDAO recommendLogDAO = new RecommendLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int studentId = (int) session.getAttribute("studentId");
        List<TutorScore> recommendations = recommendationService.recommendForStudent(studentId, 5);
        recommendLogDAO.deleteByStudentId(studentId);
        if (recommendations != null) {
            for (TutorScore ts : recommendations) {
                recommendLogDAO.insertLog(studentId, ts.getTutor().getId(), ts.getScore());
            }
        }
        req.setAttribute("recommendations", recommendations);
        req.getRequestDispatcher("/recommendResult.jsp").forward(req, resp);
    }
}

