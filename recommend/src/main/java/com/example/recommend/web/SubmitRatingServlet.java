package com.example.recommend.web;

import com.example.recommend.dao.PreferenceDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SubmitRatingServlet", urlPatterns = "/student/rate")
public class SubmitRatingServlet extends HttpServlet {

    private final PreferenceDAO preferenceDAO = new PreferenceDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int studentId = (int) session.getAttribute("studentId");
        req.setCharacterEncoding("UTF-8");
        boolean updated = false;
        for (String paramName : req.getParameterMap().keySet()) {
            if (paramName.startsWith("score_")) {
                String tutorIdStr = paramName.substring("score_".length());
                String scoreStr = req.getParameter(paramName);
                try {
                    int tutorId = Integer.parseInt(tutorIdStr);
                    double score = Double.parseDouble(scoreStr);
                    preferenceDAO.saveOrUpdatePreference(studentId, tutorId, score);
                    updated = true;
                } catch (NumberFormatException ignored) {
                }
            }
        }
        if (!updated) {
            String tutorIdStr = req.getParameter("tutorId");
            String scoreStr = req.getParameter("score");
            try {
                int tutorId = Integer.parseInt(tutorIdStr);
                double score = Double.parseDouble(scoreStr);
                preferenceDAO.saveOrUpdatePreference(studentId, tutorId, score);
            } catch (NumberFormatException ignored) {
            }
        }
        resp.sendRedirect(req.getContextPath() + "/student/tutors");
    }
}

