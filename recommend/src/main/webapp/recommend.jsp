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
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navBar"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/student/home">导师推荐系统</a>
        </div>
        <div class="collapse navbar-collapse" id="navBar">
            <ul class="nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/student/home">首页</a></li>
                <li><a href="${pageContext.request.contextPath}/student/tutors">导师打分</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/student/recommend">推荐结果</a></li>
                <li><a href="${pageContext.request.contextPath}/login.jsp">退出登录</a></li>
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
        <div class="alert alert-warning">
            当前暂时无法给出推荐结果。请先在“导师列表”中完成至少 3 次打分，然后再查看推荐。<br>
            <a href="${pageContext.request.contextPath}/student/tutors" class="btn btn-primary btn-sm" style="margin-top:10px;">去导师列表打分</a>
        </div>
    <% } else { %>
    <div class="table-responsive">
        <table class="table table-bordered table-striped table-hover">
            <thead><tr><th>排名</th><th>导师姓名</th><th>研究方向</th><th>学院</th><th>匹配分数</th><th>推荐理由</th></tr></thead>
            <tbody>
            <% double maxScore = 0; for (TutorScore ts : recommendations) { if (ts.getScore() > maxScore) maxScore = ts.getScore(); } int rank=1; for (TutorScore ts : recommendations) { double score = ts.getScore(); int percent = maxScore > 0 ? (int) Math.max(5, Math.min(100, (score / maxScore) * 100)) : 50; String reason = ts.getReason(); if (reason == null || reason.trim().isEmpty()) reason = "综合协同与内容匹配"; %>
                <tr>
                    <td><%= rank++ %></td>
                    <td><%= ts.getTutor().getName() %></td>
                    <td><%= ts.getTutor().getResearchFields() %></td>
                    <td><%= ts.getTutor().getDepartment() %></td>
                    <td>
                        <div class="progress" style="margin-bottom: 3px;">
                            <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="<%= percent %>" aria-valuemin="0" aria-valuemax="100" style="width:<%= percent %>%;color:#000;"><%= String.format("%.2f", score) %></div>
                        </div>
                    </td>
                    <td><%= reason %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
    <a class="btn btn-default" href="${pageContext.request.contextPath}/student/home">返回首页</a>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/student/tutors">继续打分</a>
</div>
<footer class="footer text-center">© 2026 本科生-研究生导师推荐系统 | 系统工程优化</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>

