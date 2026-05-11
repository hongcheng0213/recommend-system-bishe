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
    <style>.body-padding {padding-top:70px; padding-bottom:70px;} .footer{background:#f7f7f7; padding:12px 0;} .info-label{color:#888;font-size:13px;}</style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navMain"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/student/home">导师推荐系统</a>
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
    <div class="page-header"><h3>欢迎，${sessionScope.studentName}</h3></div>
    <% if (student != null) { %>
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-primary">
                <div class="panel-heading">基本信息</div>
                <div class="panel-body">
                    <table class="table table-bordered" style="margin-bottom:0;">
                        <tr><td width="30%"><span class="info-label">姓名</span></td><td><strong><%= student.getName() %></strong></td></tr>
                        <tr><td><span class="info-label">性别</span></td><td><%= student.getGender() != null ? student.getGender() : "-" %></td></tr>
                        <tr><td><span class="info-label">专业</span></td><td><%= student.getMajor() != null ? student.getMajor() : "-" %></td></tr>
                        <tr><td><span class="info-label">年级</span></td><td><%= student.getGrade() != null ? student.getGrade() : (ext != null && ext.getGrade() != null ? ext.getGrade() : "-") %></td></tr>
                        <tr><td><span class="info-label">研究方向</span></td><td><%= student.getInterests() != null ? student.getInterests() : "-" %></td></tr>
                        <tr><td><span class="info-label">考研分数</span></td><td><%= student.getScore() > 0 ? String.format("%.0f", student.getScore()) : "-" %></td></tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-success">
                <div class="panel-heading">扩展信息</div>
                <div class="panel-body">
                    <table class="table table-bordered" style="margin-bottom:0;">
                        <tr><td width="30%"><span class="info-label">GPA</span></td><td><%= ext != null && ext.getGpa() > 0 ? String.format("%.2f", ext.getGpa()) : "未填写" %></td></tr>
                        <tr><td><span class="info-label">电话</span></td><td><%= ext != null && ext.getPhone() != null ? ext.getPhone() : "未填写" %></td></tr>
                        <tr><td><span class="info-label">邮箱</span></td><td><%= ext != null && ext.getEmail() != null ? ext.getEmail() : "未填写" %></td></tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    <div class="row" style="margin-top:20px;">
        <div class="col-md-4"><div class="panel panel-info"><div class="panel-heading">步骤 1</div><div class="panel-body">在导师列表中选择导师并填写意向。</div></div></div>
        <div class="col-md-4"><div class="panel panel-warning"><div class="panel-heading">步骤 2</div><div class="panel-body">系统基于你的偏好和历史打分计算推荐结果。</div></div></div>
        <div class="col-md-4"><div class="panel panel-success"><div class="panel-heading">步骤 3</div><div class="panel-body">查看推荐结果并与导师沟通。</div></div></div>
    </div>
</div>
<footer class="footer text-center">本科生-研究生导师推荐系统</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>

