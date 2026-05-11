<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.recommend.model.TutorScore" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>推荐结果 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <style>.body-padding{padding-top:70px;padding-bottom:70px;}.footer{background:#f7f7f7;padding:12px 0;}</style>
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
                <li><a href="${pageContext.request.contextPath}/student/home">首页</a></li>
                <li><a href="${pageContext.request.contextPath}/student/tutors">导师打分</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/student/recommend">推荐结果</a></li>
                <li><a href="${pageContext.request.contextPath}/student/tutorBrowse">导师浏览</a></li>
                <li><a href="${pageContext.request.contextPath}/admin">管理员</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container body-padding">
    <div class="page-header"><h3>推荐结果</h3></div>
    <%
        List<TutorScore> recommendations = (List<TutorScore>) request.getAttribute("recommendations");
        if (recommendations == null || recommendations.isEmpty()) {
    %>
        <div class="alert alert-warning">当前暂无推荐结果，请先给导师评分后再查看推荐。</div>
    <%
        } else {
    %>
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                <tr><th>排名</th><th>导师</th><th>职称</th><th>学院</th><th>研究方向</th><th>招生名额</th><th>研究成果</th><th>匹配分</th><th>推荐理由</th></tr>
                </thead>
                <tbody>
                <% int rank = 1; for (TutorScore ts : recommendations) {
                    double score = ts.getScore();
                    int percent = (int) Math.max(0, Math.min(100, score * 10));
                    String reason = ts.getReason(); if (reason == null || reason.trim().isEmpty()) reason = "综合协同与内容匹配";
                %>
                <tr>
                    <td><%= rank++ %></td>
                    <td><%= ts.getTutor().getName() %></td>
                    <td><%= ts.getTutor().getTitle() == null ? "无" : ts.getTutor().getTitle() %></td>
                    <td><%= ts.getTutor().getDepartment() %></td>
                    <td><%= ts.getTutor().getResearchFields() %></td>
                    <td><%= ts.getTutor().getStudentQuota() %></td>
                    <td><%= ts.getTutor().getResearchAchievement() == null ? "无" : ts.getTutor().getResearchAchievement() %></td>
                    <td><div class="progress"><div class="progress-bar progress-bar-success" style="width:<%= percent %>%"><%= String.format("%.2f", score) %></div></div></td>
                    <td><%= reason %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
    <a class="btn btn-default" href="${pageContext.request.contextPath}/student/home">返回首页</a>
</div>
<footer class="footer text-center">本科生-研究生导师推荐系统</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>