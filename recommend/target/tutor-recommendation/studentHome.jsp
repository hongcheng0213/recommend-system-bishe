<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.example.recommend.model.Student" %>
<%@ page import="com.example.recommend.model.StudentExt" %>
<%
    Student student = (Student) request.getAttribute("student");
    StudentExt ext = (StudentExt) request.getAttribute("studentExt");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>学生主页 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="page-bg">
<nav class="navbar navbar-custom navbar-white navbar-fixed-top">
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
                <li class="active"><a href="${pageContext.request.contextPath}/student/home">首页</a></li>
                <li><a href="${pageContext.request.contextPath}/student/tutors">意向导师</a></li>
                <li><a href="${pageContext.request.contextPath}/student/recommend">推荐结果</a></li>
                <li><a href="${pageContext.request.contextPath}/student/tutorBrowse">导师浏览</a></li>
                <% if (session.getAttribute("isAdmin") != null && (Boolean) session.getAttribute("isAdmin")) { %>
                <li><a href="${pageContext.request.contextPath}/admin">管理员</a></li>
                <% } %>
                <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container body-padding">

    <%-- 欢迎横幅 --%>
    <div class="welcome-banner">
        <h3><i class="fa fa-hand-peace-o"></i> 欢迎回来，${sessionScope.studentName}</h3>
        <% if (student != null) { %>
        <p class="student-meta"><%= student.getMajor() != null ? student.getMajor() : "" %> &nbsp;·&nbsp; <%= student.getGrade() != null ? student.getGrade() : (ext != null && ext.getGrade() != null ? ext.getGrade() : "") %></p>
        <% } %>
    </div>

    <%-- 快捷入口 --%>
    <div class="quick-entries">
        <a href="${pageContext.request.contextPath}/student/tutors" class="quick-entry">
            <div class="qe-icon qe-icon-purple"><i class="fa fa-heart"></i></div>
            <div class="qe-title">意向导师</div>
            <div class="qe-desc">选择心仪导师</div>
        </a>
        <a href="${pageContext.request.contextPath}/student/recommend" class="quick-entry">
            <div class="qe-icon qe-icon-pink"><i class="fa fa-lightbulb-o"></i></div>
            <div class="qe-title">推荐结果</div>
            <div class="qe-desc">查看智能推荐</div>
        </a>
        <a href="${pageContext.request.contextPath}/student/tutorBrowse" class="quick-entry">
            <div class="qe-icon qe-icon-blue"><i class="fa fa-search"></i></div>
            <div class="qe-title">导师浏览</div>
            <div class="qe-desc">浏览全部导师</div>
        </a>
    </div>

    <%-- 信息卡片 --%>
    <% if (student != null) { %>
    <div class="info-cards">
        <div class="info-card">
            <div class="ic-title"><i class="fa fa-id-card"></i> 基本信息</div>
            <table class="ic-table">
                <tr><td class="ic-label">姓名</td><td><strong><%= student.getName() %></strong></td></tr>
                <tr><td class="ic-label">性别</td><td><%= student.getGender() != null ? student.getGender() : "-" %></td></tr>
                <tr><td class="ic-label">专业</td><td><%= student.getMajor() != null ? student.getMajor() : "-" %></td></tr>
                <tr><td class="ic-label">年级</td><td><%= student.getGrade() != null ? student.getGrade() : (ext != null && ext.getGrade() != null ? ext.getGrade() : "-") %></td></tr>
                <tr><td class="ic-label">研究方向</td><td><%= student.getInterests() != null ? student.getInterests() : "-" %></td></tr>
                <tr><td class="ic-label">考研分数</td><td><%= student.getScore() > 0 ? String.format("%.0f", student.getScore()) : "-" %></td></tr>
            </table>
        </div>
        <div class="info-card">
            <div class="ic-title"><i class="fa fa-info-circle"></i> 扩展信息</div>
            <table class="ic-table">
                <tr><td class="ic-label">GPA</td><td><%= ext != null && ext.getGpa() > 0 ? String.format("%.2f", ext.getGpa()) : "未填写" %></td></tr>
                <tr><td class="ic-label">电话</td><td><%= ext != null && ext.getPhone() != null ? ext.getPhone() : "未填写" %></td></tr>
                <tr><td class="ic-label">邮箱</td><td><%= ext != null && ext.getEmail() != null ? ext.getEmail() : "未填写" %></td></tr>
            </table>
        </div>
    </div>
    <% } %>

</div>

<footer class="footer">
    <div class="container">本科生—研究生导师推荐系统</div>
</footer>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>
