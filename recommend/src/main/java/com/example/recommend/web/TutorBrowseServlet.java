package com.example.recommend.web;

import com.example.recommend.dao.TutorDAO;
import com.example.recommend.model.Tutor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TutorBrowseServlet", urlPatterns = "/student/tutorBrowse")
public class TutorBrowseServlet extends HttpServlet {

    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 获取筛选参数并处理编码
        String university = null;
        String department = null;
        String keyword = null;
        
        try {
            if (req.getParameter("university") != null) {
                university = new String(req.getParameter("university").getBytes("ISO-8859-1"), "UTF-8");
            }
            if (req.getParameter("department") != null) {
                department = new String(req.getParameter("department").getBytes("ISO-8859-1"), "UTF-8");
            }
            if (req.getParameter("keyword") != null) {
                keyword = new String(req.getParameter("keyword").getBytes("ISO-8859-1"), "UTF-8");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 获取学校列表
        List<String> universities = tutorDAO.getUniversities();
        req.setAttribute("universities", universities);

        // 根据选择的学校获取院系列表
        List<String> departments = tutorDAO.getDepartments(university);
        req.setAttribute("departments", departments);

        // 根据筛选条件获取导师列表
        List<Tutor> tutors = tutorDAO.findByFilter(university, department, keyword);

        // 分页
        int page = 1;
        int pageSize = 6;
        try {
            String pageStr = req.getParameter("page");
            if (pageStr != null) page = Integer.parseInt(pageStr);
        } catch (NumberFormatException ignored) {}
        int total = tutors.size();
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, total);
        List<Tutor> pageTutors = total > 0 ? tutors.subList(fromIndex, toIndex) : tutors;

        req.setAttribute("tutors", pageTutors);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalTutors", total);

        req.getRequestDispatcher("/tutorBrowse.jsp").forward(req, resp);
    }
}
