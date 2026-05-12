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
        String action = req.getParameter("action");

        if ("saveBasic".equals(action)) {
            saveBasic(req, resp);
        } else {
            saveExt(req, resp);
        }
    }

    private void saveBasic(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tutorIdStr = req.getParameter("tutorId");
        String name = req.getParameter("name");
        String gender = req.getParameter("gender");
        String university = req.getParameter("university");
        String department = req.getParameter("department");
        String researchFields = req.getParameter("researchFields");
        String quotaStr = req.getParameter("quota");
        String photo = req.getParameter("photo");
        String homepageUrl = req.getParameter("homepageUrl");

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "导师姓名不能为空");
            doGet(req, resp);
            return;
        }

        Tutor t = new Tutor();
        t.setName(name.trim());
        t.setGender(gender != null ? gender.trim() : null);
        t.setUniversity(university != null ? university.trim() : null);
        t.setDepartment(department != null ? department.trim() : null);
        t.setResearchFields(researchFields != null ? researchFields.trim() : null);
        t.setPhoto(photo != null ? photo.trim() : null);
        t.setHomepageUrl(homepageUrl != null ? homepageUrl.trim() : null);

        if (quotaStr != null && !quotaStr.trim().isEmpty()) {
            try { t.setQuota(Integer.parseInt(quotaStr.trim())); } catch (Exception ignored) {}
        }

        int tutorId = 0;
        if (tutorIdStr != null && !tutorIdStr.trim().isEmpty()) {
            try { tutorId = Integer.parseInt(tutorIdStr.trim()); } catch (Exception ignored) {}
        }

        if (tutorId > 0) {
            t.setId(tutorId);
            if (tutorDAO.update(t)) {
                req.setAttribute("success", "导师基础信息已更新");
            } else {
                req.setAttribute("error", "更新失败");
            }
        } else {
            int newId = tutorDAO.insert(t);
            if (newId > 0) {
                req.setAttribute("success", "新增导师成功，ID=" + newId);
            } else {
                req.setAttribute("error", "新增失败");
            }
        }
        doGet(req, resp);
    }

    private void saveExt(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tutorIdStr = req.getParameter("tutorId");
        String title = req.getParameter("title");
        String achievement = req.getParameter("researchAchievement");
        String studentQuotaStr = req.getParameter("studentQuota");

        int tutorId = 0;
        try { tutorId = Integer.parseInt(tutorIdStr); } catch (Exception ignored) {}

        if (tutorId > 0) {
            TutorExt existing = tutorExtDAO.findByTutorId(tutorId);

            TutorExt ext = new TutorExt();
            ext.setTutorId(tutorId);

            if (title != null && !title.trim().isEmpty()) {
                ext.setTitle(title.trim());
            } else if (existing != null) {
                ext.setTitle(existing.getTitle());
            }

            if (achievement != null && !achievement.trim().isEmpty()) {
                ext.setResearchAchievement(achievement.trim());
            } else if (existing != null) {
                ext.setResearchAchievement(existing.getResearchAchievement());
            }

            if (studentQuotaStr != null && !studentQuotaStr.trim().isEmpty()) {
                try { ext.setStudentQuota(Integer.parseInt(studentQuotaStr.trim())); } catch (Exception ignored) {}
            } else if (existing != null) {
                ext.setStudentQuota(existing.getStudentQuota());
            }

            tutorExtDAO.saveOrUpdate(ext);
            req.setAttribute("success", "导师扩展信息已保存");
        } else {
            req.setAttribute("error", "请选择导师");
        }
        doGet(req, resp);
    }
}
