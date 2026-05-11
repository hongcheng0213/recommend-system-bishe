package com.example.recommend.web;

import com.example.recommend.dao.StudentDAO;
import com.example.recommend.dao.StudentExtDAO;
import com.example.recommend.model.Student;
import com.example.recommend.model.StudentExt;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final StudentExtDAO studentExtDAO = new StudentExtDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String password = req.getParameter("password");
        String gender = req.getParameter("gender");
        String major = req.getParameter("major");
        String grade = req.getParameter("grade");
        String interests = req.getParameter("interests");
        String scoreStr = req.getParameter("score");
        String gpaStr = req.getParameter("gpa");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        double score = 0.0;
        try {
            if (scoreStr != null && !scoreStr.isEmpty()) {
                score = Double.parseDouble(scoreStr);
            }
        } catch (NumberFormatException ignored) {
        }

        double gpa = 0.0;
        try {
            if (gpaStr != null && !gpaStr.isEmpty()) {
                gpa = Double.parseDouble(gpaStr);
            }
        } catch (NumberFormatException ignored) {
        }

        Student student = new Student();
        student.setName(name);
        student.setGender(gender);
        student.setMajor(major);
        student.setGrade(grade);
        student.setInterests(interests);
        student.setScore(score);

        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
        boolean success = studentDAO.create(student, passwordHash);
        if (success) {
            StudentExt ext = new StudentExt();
            ext.setStudentId(student.getId());
            ext.setGrade(grade);
            ext.setGpa(gpa);
            ext.setPhone(phone);
            ext.setEmail(email);
            studentExtDAO.saveOrUpdate(ext);
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            req.setAttribute("error", "注册失败，请稍后重试");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }
}

