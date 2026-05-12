package com.example.recommend.web;

import com.example.recommend.dao.StudentDAO;
import com.example.recommend.model.Student;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String redirect = req.getParameter("redirect");

        Student student = studentDAO.findByName(username);
        if (student != null && BCrypt.checkpw(password, student.getPasswordHash())) {
            // Admin login: must be an admin
            if ("admin".equals(redirect) && !student.isAdmin()) {
                req.setAttribute("error", "该账号没有管理员权限");
                req.getRequestDispatcher("/admin_login.jsp").forward(req, resp);
                return;
            }
            HttpSession session = req.getSession();
            session.setAttribute("studentId", student.getId());
            session.setAttribute("studentName", student.getName());
            session.setAttribute("isAdmin", student.isAdmin());
            if ("admin".equals(redirect)) {
                resp.sendRedirect(req.getContextPath() + "/admin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/home");
            }
        } else {
            req.setAttribute("error", "用户名或密码错误");
            if ("admin".equals(redirect)) {
                req.getRequestDispatcher("/admin_login.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        }
    }
}

