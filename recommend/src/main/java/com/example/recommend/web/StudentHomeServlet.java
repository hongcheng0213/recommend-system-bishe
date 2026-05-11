package com.example.recommend.web;

import com.example.recommend.dao.StudentDAO;
import com.example.recommend.dao.StudentExtDAO;
import com.example.recommend.model.Student;
import com.example.recommend.model.StudentExt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "StudentHomeServlet", urlPatterns = "/student/home")
public class StudentHomeServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final StudentExtDAO studentExtDAO = new StudentExtDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int studentId = (int) session.getAttribute("studentId");
        Student student = studentDAO.findById(studentId);
        if (student != null) {
            req.setAttribute("student", student);
            StudentExt ext = studentExtDAO.findByStudentId(studentId);
            req.setAttribute("studentExt", ext);
        }
        req.getRequestDispatcher("/studentHome.jsp").forward(req, resp);
    }
}

