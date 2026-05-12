# Admin Page Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite admin page as left-right two-column layout managing both tutors and tutor_ext tables, remove dead hot_score code, add tutor insert/update capability.

**Architecture:** Two-phase cleanup-then-build. Tasks 1-4 remove hotScore from all layers (model → DAO). Tasks 5-6 add new functionality (AdminServlet saveBasic, admin.jsp rewrite). Each task is self-contained and commit-able.

**Tech Stack:** Java 8, Servlet/JSP, JDBC, MySQL, Bootstrap 3, JSP EL

---

### Task 1: Remove hotScore from TutorExt model

**Files:**
- Modify: `recommend/src/main/java/com/example/recommend/model/TutorExt.java`

- [ ] **Step 1: Remove hotScore field, getter, and setter**

Replace the entire file:

```java
package com.example.recommend.model;

public class TutorExt {
    private int tutorId;
    private String title;
    private String researchAchievement;
    private int studentQuota;

    public int getTutorId() {
        return tutorId;
    }

    public void setTutorId(int tutorId) {
        this.tutorId = tutorId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getResearchAchievement() {
        return researchAchievement;
    }

    public void setResearchAchievement(String researchAchievement) {
        this.researchAchievement = researchAchievement;
    }

    public int getStudentQuota() {
        return studentQuota;
    }

    public void setStudentQuota(int studentQuota) {
        this.studentQuota = studentQuota;
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add recommend/src/main/java/com/example/recommend/model/TutorExt.java
git commit -m "refactor: remove hotScore from TutorExt model"
```

---

### Task 2: Remove hot_score from TutorExtDAO

**Files:**
- Modify: `recommend/src/main/java/com/example/recommend/dao/TutorExtDAO.java`

- [ ] **Step 1: Remove hot_score from saveOrUpdate SQL and parameters**

Replace the `saveOrUpdate` method:

```java
public boolean saveOrUpdate(TutorExt ext) {
    String sql = "INSERT INTO tutor_ext(tutor_id, title, research_achievement, student_quota) " +
                 "VALUES(?,?,?,?) ON DUPLICATE KEY UPDATE " +
                 "title=VALUES(title), research_achievement=VALUES(research_achievement), " +
                 "student_quota=VALUES(student_quota)";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, ext.getTutorId());
        ps.setString(2, ext.getTitle());
        ps.setString(3, ext.getResearchAchievement());
        ps.setInt(4, ext.getStudentQuota());
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
```

- [ ] **Step 2: Remove hot_score from findByTutorId**

Replace the `findByTutorId` method:

```java
public TutorExt findByTutorId(int tutorId) {
    String sql = "SELECT tutor_id, title, research_achievement, student_quota FROM tutor_ext WHERE tutor_id = ?";
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
            return ext;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
```

- [ ] **Step 3: Remove hot_score from findAll**

Replace the `findAll` method:

```java
public List<TutorExt> findAll() {
    String sql = "SELECT tutor_id, title, research_achievement, student_quota FROM tutor_ext";
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
            list.add(ext);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
```

- [ ] **Step 4: Commit**

```bash
git add recommend/src/main/java/com/example/recommend/dao/TutorExtDAO.java
git commit -m "refactor: remove hot_score from TutorExtDAO"
```

---

### Task 3: Remove hotScore from Tutor model

**Files:**
- Modify: `recommend/src/main/java/com/example/recommend/model/Tutor.java`

- [ ] **Step 1: Remove hotScore field, getter, and setter**

Remove lines 13 (`private int hotScore;`), lines 90-96 (getter and setter):

Replace the entire file:

```java
package com.example.recommend.model;

public class Tutor {
    private int id;
    private String name;
    private String gender;
    private String university;
    private String department;
    private String researchFields;
    private int quota;
    private String title;
    private String researchAchievement;
    private int studentQuota;
    private String photo;
    private String homepageUrl;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getResearchFields() {
        return researchFields;
    }

    public void setResearchFields(String researchFields) {
        this.researchFields = researchFields;
    }

    public int getQuota() {
        return quota;
    }

    public void setQuota(int quota) {
        this.quota = quota;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getResearchAchievement() {
        return researchAchievement;
    }

    public void setResearchAchievement(String researchAchievement) {
        this.researchAchievement = researchAchievement;
    }

    public int getStudentQuota() {
        return studentQuota;
    }

    public void setStudentQuota(int studentQuota) {
        this.studentQuota = studentQuota;
    }

    public String getUniversity() {
        return university;
    }

    public void setUniversity(String university) {
        this.university = university;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getHomepageUrl() {
        return homepageUrl;
    }

    public void setHomepageUrl(String homepageUrl) {
        this.homepageUrl = homepageUrl;
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add recommend/src/main/java/com/example/recommend/model/Tutor.java
git commit -m "refactor: remove hotScore from Tutor model"
```

---

### Task 4: Remove hot_score from TutorDAO queries + add insert/update

**Files:**
- Modify: `recommend/src/main/java/com/example/recommend/dao/TutorDAO.java`

- [ ] **Step 1: Remove hot_score from all SELECT queries and mapRow, add insert() and update() methods**

Replace the entire file:

```java
package com.example.recommend.dao;

import com.example.recommend.config.DBUtil;
import com.example.recommend.model.Tutor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TutorDAO {

    public List<Tutor> findAll() {
        List<Tutor> list = new ArrayList<>();
        String sql = "SELECT t.*, te.title, te.research_achievement, te.student_quota " +
                "FROM tutors t LEFT JOIN tutor_ext te ON t.id = te.tutor_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Tutor findById(int id) {
        String sql = "SELECT t.*, te.title, te.research_achievement, te.student_quota " +
                "FROM tutors t LEFT JOIN tutor_ext te ON t.id = te.tutor_id WHERE t.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Tutor> findByFilter(String university, String department, String keyword) {
        List<Tutor> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.*, te.title, te.research_achievement, te.student_quota " +
                "FROM tutors t LEFT JOIN tutor_ext te ON t.id = te.tutor_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (university != null && !university.isEmpty()) {
            sql.append(" AND t.university = ?");
            params.add(university);
        }
        if (department != null && !department.isEmpty()) {
            sql.append(" AND t.department = ?");
            params.add(department);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (t.name LIKE ? OR t.research_fields LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        if (keyword != null && !keyword.isEmpty()) {
            List<Tutor> filteredList = new ArrayList<>();
            for (Tutor tutor : list) {
                if (keyword.equals(tutor.getName())) {
                    filteredList.add(tutor);
                }
                else if (tutor.getResearchFields() != null && tutor.getResearchFields().contains(keyword)) {
                    filteredList.add(tutor);
                }
                else if (tutor.getName() != null && tutor.getName().contains(keyword)) {
                    String name = tutor.getName();
                    int index = name.indexOf(keyword);
                    if (index == 0 && (name.length() == keyword.length() || !Character.isLetterOrDigit(name.charAt(index + keyword.length())))) {
                        filteredList.add(tutor);
                    }
                    else if (index > 0 && index + keyword.length() < name.length() && 
                             !Character.isLetterOrDigit(name.charAt(index - 1)) && 
                             !Character.isLetterOrDigit(name.charAt(index + keyword.length()))) {
                        filteredList.add(tutor);
                    }
                    else if (index + keyword.length() == name.length() && !Character.isLetterOrDigit(name.charAt(index - 1))) {
                        filteredList.add(tutor);
                    }
                }
            }
            return filteredList;
        }
        
        return list;
    }

    public List<String> getUniversities() {
        List<String> universities = new ArrayList<>();
        String sql = "SELECT DISTINCT university FROM tutors WHERE university IS NOT NULL AND university != ''";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                universities.add(rs.getString("university"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return universities;
    }

    public List<String> getDepartments(String university) {
        List<String> departments = new ArrayList<>();
        String sql = "SELECT DISTINCT department FROM tutors WHERE department IS NOT NULL AND department != ''";
        if (university != null && !university.isEmpty()) {
            sql += " AND university = ?";
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (university != null && !university.isEmpty()) {
                ps.setString(1, university);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                departments.add(rs.getString("department"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return departments;
    }

    public int insert(Tutor t) {
        String sql = "INSERT INTO tutors (name, gender, university, department, research_fields, quota, photo, homepage_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getGender());
            ps.setString(3, t.getUniversity());
            ps.setString(4, t.getDepartment());
            ps.setString(5, t.getResearchFields());
            if (t.getQuota() > 0) ps.setInt(6, t.getQuota()); else ps.setNull(6, Types.INTEGER);
            ps.setString(7, t.getPhoto());
            ps.setString(8, t.getHomepageUrl());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean update(Tutor t) {
        String sql = "UPDATE tutors SET name=?, gender=?, university=?, department=?, " +
                     "research_fields=?, quota=?, photo=?, homepage_url=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getGender());
            ps.setString(3, t.getUniversity());
            ps.setString(4, t.getDepartment());
            ps.setString(5, t.getResearchFields());
            if (t.getQuota() > 0) ps.setInt(6, t.getQuota()); else ps.setNull(6, Types.INTEGER);
            ps.setString(7, t.getPhoto());
            ps.setString(8, t.getHomepageUrl());
            ps.setInt(9, t.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Tutor mapRow(ResultSet rs) throws SQLException {
        Tutor t = new Tutor();
        t.setId(rs.getInt("id"));
        t.setName(rs.getString("name"));
        t.setGender(rs.getString("gender"));
        t.setUniversity(rs.getString("university"));
        t.setDepartment(rs.getString("department"));
        t.setResearchFields(rs.getString("research_fields"));
        t.setQuota(rs.getInt("quota"));
        t.setTitle(rs.getString("title"));
        t.setResearchAchievement(rs.getString("research_achievement"));
        t.setStudentQuota(rs.getInt("student_quota"));
        t.setPhoto(rs.getString("photo"));
        t.setHomepageUrl(rs.getString("homepage_url"));
        return t;
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add recommend/src/main/java/com/example/recommend/dao/TutorDAO.java
git commit -m "refactor: remove hot_score from TutorDAO, add insert/update methods"
```

---

### Task 5: Rewrite AdminServlet with saveBasic/saveExt actions

**Files:**
- Modify: `recommend/src/main/java/com/example/recommend/web/AdminServlet.java`

- [ ] **Step 1: Rewrite AdminServlet**

Replace the entire file:

```java
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
```

- [ ] **Step 2: Commit**

```bash
git add recommend/src/main/java/com/example/recommend/web/AdminServlet.java
git commit -m "feat: add saveBasic/saveExt actions to AdminServlet, remove hotScore"
```

---

### Task 6: Rewrite admin.jsp with two-column layout

**Files:**
- Modify: `recommend/src/main/webapp/admin.jsp`

- [ ] **Step 1: Rewrite admin.jsp**

Replace the entire file:

```jsp
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.recommend.model.Tutor" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>管理员配置 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f5f6fa; }
        .body-padding { padding-top: 70px; padding-bottom: 40px; }
        .panel-heading-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .panel-heading-custom h3 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
        }
        .photo-preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #ddd;
            background: #f0f0f0;
        }
        .photo-preview[src=""], .photo-preview:not([src]) {
            display: none;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navMain">
                <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/student/home">
                <i class="fa fa-graduation-cap"></i> 导师推荐系统
            </a>
        </div>
        <div class="collapse navbar-collapse" id="navMain">
            <ul class="nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/student/home">首页</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin">管理员</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container body-padding">
    <div class="page-header">
        <h3><i class="fa fa-cog"></i> 管理员：导师信息管理</h3>
    </div>

    <%
        String success = (String) request.getAttribute("success");
        String error = (String) request.getAttribute("error");
        if (success != null) {
    %>
        <div class="alert alert-success"><i class="fa fa-check-circle"></i> <%= success %></div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <%= error %></div>
    <% } %>

    <div class="row">
        <!-- Left Column: Basic Info -->
        <div class="col-md-6">
            <div class="panel panel-default">
                <div class="panel-heading panel-heading-custom" style="background:#667eea; color:#fff;">
                    <h3><i class="fa fa-user"></i> 导师基础信息</h3>
                    <button type="button" class="btn btn-sm btn-default" onclick="newTutor()">
                        <i class="fa fa-plus"></i> 新增导师
                    </button>
                </div>
                <div class="panel-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin" onsubmit="return checkPhoto()">
                        <input type="hidden" name="action" value="saveBasic">
                        <input type="hidden" name="tutorId" id="basicTutorId">
                        <div class="form-group">
                            <label>选择导师编辑</label>
                            <select class="form-control" id="tutorSelect" onchange="loadBasicInfo(this.value)">
                                <option value="">-- 选择已有导师 / 或点击「新增导师」--</option>
                                <% List<Tutor> tutors = (List<Tutor>) request.getAttribute("tutors");
                                    if (tutors != null) {
                                        for (Tutor t : tutors) {
                                %>
                                    <option value="<%= t.getId() %>"
                                        data-name="<%= t.getName() != null ? t.getName() : "" %>"
                                        data-gender="<%= t.getGender() != null ? t.getGender() : "" %>"
                                        data-university="<%= t.getUniversity() != null ? t.getUniversity() : "" %>"
                                        data-department="<%= t.getDepartment() != null ? t.getDepartment() : "" %>"
                                        data-fields="<%= t.getResearchFields() != null ? t.getResearchFields() : "" %>"
                                        data-quota="<%= t.getQuota() %>"
                                        data-photo="<%= t.getPhoto() != null ? t.getPhoto() : "" %>"
                                        data-homepage="<%= t.getHomepageUrl() != null ? t.getHomepageUrl() : "" %>"
                                    ><%= t.getName() %> [<%= t.getDepartment() != null ? t.getDepartment() : "" %>]</option>
                                <% }} %>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-sm-6"><div class="form-group"><label>姓名 *</label><input class="form-control" name="name" id="basicName" required></div></div>
                            <div class="col-sm-6"><div class="form-group"><label>性别</label><select class="form-control" name="gender" id="basicGender"><option value="">请选择</option><option value="男">男</option><option value="女">女</option></select></div></div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6"><div class="form-group"><label>院校</label><input class="form-control" name="university" id="basicUniversity"></div></div>
                            <div class="col-sm-6"><div class="form-group"><label>院系</label><input class="form-control" name="department" id="basicDepartment"></div></div>
                        </div>
                        <div class="form-group"><label>研究方向</label><input class="form-control" name="researchFields" id="basicFields"></div>
                        <div class="form-group"><label>招生名额</label><input class="form-control" type="number" name="quota" id="basicQuota" min="0"></div>
                        <div class="form-group"><label>照片URL</label>
                            <div class="input-group">
                                <input class="form-control" name="photo" id="basicPhoto" oninput="previewPhoto()">
                                <span class="input-group-btn"><button type="button" class="btn btn-default" onclick="previewPhoto()"><i class="fa fa-eye"></i></button></span>
                            </div>
                        </div>
                        <div class="form-group" id="photoPreviewWrap" style="display:none;">
                            <img id="photoPreview" class="photo-preview" src="" alt="照片预览">
                        </div>
                        <div class="form-group"><label>主页URL</label><input class="form-control" name="homepageUrl" id="basicHomepage" placeholder="https://..."></div>
                        <button type="submit" class="btn btn-primary btn-block"><i class="fa fa-save"></i> 保存基础信息</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Right Column: Extended Info -->
        <div class="col-md-6">
            <div class="panel panel-default">
                <div class="panel-heading" style="background:#764ba2; color:#fff;">
                    <h3 style="margin:0; font-size:16px; font-weight:600;"><i class="fa fa-file-text"></i> 导师扩展信息</h3>
                </div>
                <div class="panel-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="saveExt">
                        <div class="form-group"><label>选择导师</label><select class="form-control" name="tutorId" id="extTutorSelect" onchange="loadExtInfo(this.value)" required>
                            <option value="">请选择导师</option>
                            <% if (tutors != null) {
                                for (Tutor t : tutors) {
                            %>
                                <option value="<%= t.getId() %>"
                                    data-title="<%= t.getTitle() != null ? t.getTitle() : "" %>"
                                    data-achievement="<%= t.getResearchAchievement() != null ? t.getResearchAchievement() : "" %>"
                                    data-quota="<%= t.getStudentQuota() %>"
                                ><%= t.getName() %> [<%= t.getDepartment() != null ? t.getDepartment() : "" %>]</option>
                            <% }} %>
                        </select></div>
                        <div class="form-group"><label>职称</label><input class="form-control" name="title" id="extTitle"></div>
                        <div class="form-group"><label>研究成果</label><textarea class="form-control" name="researchAchievement" id="extAchievement" rows="4"></textarea></div>
                        <div class="form-group"><label>招生名额</label><input class="form-control" type="number" name="studentQuota" id="extQuota" min="1" value="3"></div>
                        <button type="submit" class="btn btn-primary btn-block" style="background:#764ba2; border-color:#764ba2;"><i class="fa fa-save"></i> 保存扩展信息</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Tutor List Summary -->
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading"><h3 style="margin:0; font-size:16px; font-weight:600;"><i class="fa fa-list"></i> 当前导师列表</h3></div>
                <div class="panel-body" style="max-height:300px; overflow:auto;">
                    <table class="table table-condensed table-hover">
                        <thead><tr><th>ID</th><th>姓名</th><th>院系</th><th>院校</th><th>职称</th><th>招生名额</th><th>照片</th><th>主页</th></tr></thead>
                        <tbody>
                        <% if (tutors != null) {
                            for (Tutor t : tutors) {
                        %>
                        <tr>
                            <td><%= t.getId() %></td>
                            <td><%= t.getName() %></td>
                            <td><%= t.getDepartment() != null ? t.getDepartment() : "-" %></td>
                            <td><%= t.getUniversity() != null ? t.getUniversity() : "-" %></td>
                            <td><%= t.getTitle() != null ? t.getTitle() : "-" %></td>
                            <td><%= t.getStudentQuota() > 0 ? t.getStudentQuota() : t.getQuota() %></td>
                            <td>
                                <% if (t.getPhoto() != null && !t.getPhoto().isEmpty()) { %>
                                    <a href="<%= t.getPhoto() %>" target="_blank">查看</a>
                                <% } else { %>-<% } %>
                            </td>
                            <td>
                                <% if (t.getHomepageUrl() != null && !t.getHomepageUrl().isEmpty()) { %>
                                    <a href="<%= t.getHomepageUrl() %>" target="_blank"><i class="fa fa-external-link"></i></a>
                                <% } else { %>-<% } %>
                            </td>
                        </tr>
                        <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer text-center" style="background:#f7f7f7; padding:12px 0; margin-top:20px;">
    本科生-研究生导师推荐系统
</footer>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
    function newTutor() {
        $('#tutorSelect').val('');
        $('#basicTutorId').val('');
        ['Name','Gender','University','Department','Fields','Quota','Photo','Homepage'].forEach(function(f){
            $('#basic' + f).val('');
        });
        $('#photoPreviewWrap').hide();
        $('#photoPreview').attr('src', '');
    }

    function loadBasicInfo(val) {
        if (!val) { newTutor(); return; }
        var opt = $('#tutorSelect option[value="' + val + '"]');
        $('#basicTutorId').val(val);
        $('#basicName').val(opt.data('name'));
        $('#basicGender').val(opt.data('gender'));
        $('#basicUniversity').val(opt.data('university'));
        $('#basicDepartment').val(opt.data('department'));
        $('#basicFields').val(opt.data('fields'));
        $('#basicQuota').val(opt.data('quota'));
        $('#basicPhoto').val(opt.data('photo'));
        $('#basicHomepage').val(opt.data('homepage'));
        previewPhoto();
    }

    function previewPhoto() {
        var url = $('#basicPhoto').val();
        if (url) {
            $('#photoPreview').attr('src', url);
            $('#photoPreviewWrap').show();
        } else {
            $('#photoPreviewWrap').hide();
        }
    }

    function checkPhoto() {
        previewPhoto();
        return true;
    }

    function loadExtInfo(val) {
        if (!val) {
            $('#extTitle').val('');
            $('#extAchievement').val('');
            $('#extQuota').val('3');
            return;
        }
        var opt = $('#extTutorSelect option[value="' + val + '"]');
        $('#extTitle').val(opt.data('title'));
        $('#extAchievement').val(opt.data('achievement'));
        $('#extQuota').val(opt.data('quota') || 3);
    }

    // On page load, trigger existing selection if any
    $(function(){
        var basicVal = $('#tutorSelect').val();
        if (basicVal) loadBasicInfo(basicVal);
        var extVal = $('#extTutorSelect').val();
        if (extVal) loadExtInfo(extVal);
    });
</script>
</body>
</html>
```

- [ ] **Step 2: Commit**

```bash
git add recommend/src/main/webapp/admin.jsp
git commit -m "feat: rewrite admin page as two-column layout with add tutor and photo preview"
```

---

### Post-Implementation Verification

- [ ] Start Tomcat: `cd recommend && mvn tomcat7:run`
- [ ] Open http://localhost:8080/tutor-recommendation/login.jsp
- [ ] Login as admin (student ID 1)
- [ ] Navigate to admin page
- [ ] Test: Select a tutor from left dropdown → fields populate
- [ ] Test: Click "New Tutor" → fields clear
- [ ] Test: Fill in new tutor info → click Save → new tutor appears in list
- [ ] Test: Edit existing tutor → Save → changes persist
- [ ] Test: Enter photo URL → click eye icon → preview shows
- [ ] Test: Right column → select tutor → fill ext info → Save
- [ ] Test: Verify hot_score is gone from both forms
