<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.example.recommend.model.Tutor" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>导师列表 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <style>.body-padding{padding-top:70px;padding-bottom:70px;}.footer{background:#f7f7f7;padding:12px 0;}</style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#mainNav"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/student/home">导师推荐系统</a>
        </div>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/student/home">首页</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/student/tutors">意向导师</a></li>
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
    <div class="row"><div class="col-md-12"><div class="page-header"><h3>导师列表</h3></div></div></div>
    <div class="row"><div class="col-md-12">
        <%
           List<Tutor> tutors = (List<Tutor>) request.getAttribute("tutors");
           Map ratingMap = (Map) request.getAttribute("ratingMap");
           if (ratingMap == null) { ratingMap = new HashMap(); }
        %>
        <% if (tutors == null || tutors.isEmpty()) { %>
            <div class="alert alert-warning">当前没有导师数据，请先在数据库中插入导师记录。</div>
        <% } else { %>
            <div class="form-group" style="margin-bottom:15px;">
                <div class="input-group">
                    <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
                    <input type="text" id="searchBox" class="form-control" placeholder="搜索导师（姓名/院校/院系/研究方向）" oninput="filterTutors()">
                </div>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/student/rate">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="tutorTable">
                        <thead><tr><th>编号</th><th>姓名</th><th>院校</th><th>学院</th><th>研究方向</th><th>招生名额</th><th>意向程度</th></tr></thead>
                        <tbody>
                        <% for (Tutor t : tutors) {
                               Object r = ratingMap.get(t.getId());
                               double selectedScore = (r instanceof Number) ? ((Number) r).doubleValue() : -1;
                        %>
                            <tr data-search="<%= t.getName().replace("\"", "") %> <%= t.getUniversity() != null ? t.getUniversity().replace("\"", "") : "" %> <%= t.getDepartment() != null ? t.getDepartment().replace("\"", "") : "" %> <%= t.getResearchFields() != null ? t.getResearchFields().replace("\"", "") : "" %>">
                                <td><%= t.getId() %></td>
                                <td class="tutor-name">
                                    <% if (t.getHomepageUrl() != null && !t.getHomepageUrl().isEmpty()) { %>
                                        <a href="<%= t.getHomepageUrl() %>" target="_blank" rel="noopener noreferrer"><%= t.getName() %></a>
                                    <% } else { %>
                                        <%= t.getName() %>
                                    <% } %>
                                </td>
                                <td><%= t.getUniversity() != null ? t.getUniversity() : "-" %></td>
                                <td><%= t.getDepartment() != null ? t.getDepartment() : "-" %></td>
                                <td><%= t.getResearchFields() != null ? t.getResearchFields() : "-" %></td>
                                <td><%= t.getQuota() %></td>
                                <td>
                                    <select name="score_<%= t.getId() %>" class="form-control input-sm" style="width:90px; display:inline-block;">
                                        <option value="">未评分</option>
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <option value="<%= i %>" <%= (int) selectedScore == i ? "selected" : "" %>><%= i %>分</option>
                                    <% } %>
                                    </select>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <button type="submit" class="btn btn-success">保存所有评分</button>
            </form>
        <% } %>
    </div></div>
    <div class="text-right"><a class="btn btn-success" href="${pageContext.request.contextPath}/student/recommend">查看推荐结果</a></div>
</div>
<footer class="footer text-center">本科生-研究生导师推荐系统</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
function isBoundary(ch) {
    return !ch || ch === ' ' || ch === '\t' || ch === '\n' || ch === '\r';
}
var originalRows = [];
$(function(){
    originalRows = $('#tutorTable tbody tr').toArray();
});

function fieldMatch(keyword, text) {
    var idx = text.indexOf(keyword);
    if (idx === -1) return false;
    var next = text.charAt(idx + keyword.length);
    return isBoundary(next);
}

function filterTutors() {
    var keyword = $.trim($('#searchBox').val()).toLowerCase();
    var rows = $('#tutorTable tbody tr').toArray();
    if (!keyword) {
        var tbody = $('#tutorTable tbody');
        for (var i = 0; i < originalRows.length; i++) {
            tbody.append(originalRows[i]);
        }
        return;
    }
    // Split by spaces into tokens; rank by match count (most tokens matched = top)
    var tokens = keyword.split(/\s+/);
    var scored = [];
    for (var i = 0; i < rows.length; i++) {
        var text = $(rows[i]).data('search').toLowerCase();
        var cnt = 0;
        for (var t = 0; t < tokens.length; t++) {
            if (fieldMatch(tokens[t], text)) cnt++;
        }
        scored.push({row: rows[i], score: cnt, orig: i});
    }
    scored.sort(function(a, b) {
        if (a.score !== b.score) return b.score - a.score; // higher score first
        return a.orig - b.orig; // then original order
    });
    var tbody = $('#tutorTable tbody');
    for (var j = 0; j < scored.length; j++) {
        tbody.append(scored[j].row);
    }
}
</script>
</body>
</html>

