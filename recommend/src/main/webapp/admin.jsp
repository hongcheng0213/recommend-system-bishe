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
                <li class="active"><a href="${pageContext.request.contextPath}/admin">管理员</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container body-padding">
    <div class="page-header"><h3>管理员：导师扩展信息管理</h3></div>
    <div class="row"><div class="col-md-12">
        <div class="alert alert-info">在此输入导师职称、招生名额与研究成果，系统会保存到 tutor_ext 表。</div>
        <%
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            if (success != null) {
        %>
            <div class="alert alert-success"><%= success %></div>
        <% } else if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
    </div></div>
    <div class="row"><div class="col-md-6">
        <form method="post" action="${pageContext.request.contextPath}/admin">
            <div class="form-group"><label>选择导师</label><select class="form-control" name="tutorId" required>
                <option value="">请选择导师</option>
                <% List<Tutor> tutors = (List<Tutor>) request.getAttribute("tutors");
                    if (tutors != null) {
                        for (Tutor t : tutors) {
                %>
                    <option value="<%= t.getId() %>"><%= t.getName() %> [<%= t.getDepartment() %>]</option>
                <% }} %>
            </select></div>
            <div class="form-group"><label>职称</label><input class="form-control" name="title" placeholder="如：教授"></div>
            <div class="form-group"><label>研究成果</label><textarea class="form-control" name="researchAchievement" rows="3"></textarea></div>
            <div class="form-group"><label>招生名额</label><input class="form-control" type="number" name="studentQuota" min="1" value="3"></div>
            <div class="form-group"><label>热度分</label><input class="form-control" type="number" name="hotScore" min="0" value="50"></div>
            <button type="submit" class="btn btn-primary">保存导师扩展信息</button>
        </form>
    </div>
    <div class="col-md-6">
        <div class="panel panel-default"><div class="panel-heading">当前导师数据</div><div class="panel-body" style="max-height:350px; overflow:auto;">
            <table class="table table-condensed"><thead><tr><th>ID</th><th>姓名</th><th>职称</th><th>名额</th></tr></thead><tbody>
            <% if (tutors != null) {
                for (Tutor t : tutors) {
            %>
            <tr><td><%= t.getId() %></td><td><%= t.getName() %></td><td><%= t.getTitle() == null ? "-" : t.getTitle() %></td><td><%= t.getStudentQuota() %></td></tr>
            <% }} %>
            </tbody></table>
        </div></div>
    </div></div>
</div>
<footer class="footer text-center">本科生-研究生导师推荐系统</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>