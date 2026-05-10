package com.example.recommend.web;

import com.example.recommend.dao.PreferenceDAO;
import com.example.recommend.dao.TutorDAO;
import com.example.recommend.model.StudentPreference;
import com.example.recommend.model.Tutor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "TutorListServlet", urlPatterns = "/student/tutors")
public class TutorListServlet extends HttpServlet {

    private final TutorDAO tutorDAO = new TutorDAO();
    private final PreferenceDAO preferenceDAO = new PreferenceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int studentId = (int) session.getAttribute("studentId");
        List<Tutor> tutors = tutorDAO.findAll();
        Map<Integer, Double> ratingMap = new HashMap<>();
        for (StudentPreference sp : preferenceDAO.findByStudentId(studentId)) {
            ratingMap.put(sp.getTutorId(), sp.getScore());
        }
        req.setAttribute("tutors", tutors);
        req.setAttribute("ratingMap", ratingMap);
        req.getRequestDispatcher("/tutors.jsp").forward(req, resp);
    }
}

