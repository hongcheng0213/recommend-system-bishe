<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.recommend.model.Tutor" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>导师信息浏览 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <style>
        .body-padding{padding-top:70px;padding-bottom:70px;}
        .footer{background:#f7f7f7;padding:12px 0;}
        .tutor-card-row{display:flex;flex-wrap:wrap;}
        .tutor-card-row>[class*='col-']{display:flex;flex-direction:column;margin-bottom:30px;}
        .tutor-card{border:1px solid #ddd;border-radius:8px;overflow:hidden;transition:all 0.3s ease;flex:1;display:flex;flex-direction:column;}
        .tutor-card:hover{box-shadow:0 4px 12px rgba(0,0,0,0.15);transform:translateY(-2px);}
        .tutor-photo{height:200px;object-fit:cover;width:100%;}
        .tutor-info{padding:15px;flex:1;}
        .search-filter{background:#f8f9fa;padding:20px;border-radius:8px;margin-bottom:30px;}
        .loading{text-align:center;padding:50px;}
    </style>
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
                <li><a href="${pageContext.request.contextPath}/student/tutors">导师打分</a></li>
                <li><a href="${pageContext.request.contextPath}/student/recommend">推荐结果</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/student/tutorBrowse">导师浏览</a></li>
                <% if (session.getAttribute("isAdmin") != null && (Boolean) session.getAttribute("isAdmin")) { %>
                <li><a href="${pageContext.request.contextPath}/admin">管理员</a></li>
                <% } %>
                <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container body-padding">
    <div class="row"><div class="col-md-12"><div class="page-header"><h3>导师信息浏览</h3></div></div></div>
    
    <!-- 搜索和筛选区域 -->
    <div class="search-filter">
        <form method="get" action="${pageContext.request.contextPath}/student/tutorBrowse" class="form-horizontal">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="control-label">学校</label>
                        <select name="university" class="form-control" onchange="this.form.submit()">
                            <option value="">全部学校</option>
                            <% 
                                List<String> universities = (List<String>) request.getAttribute("universities");
                                String selectedUniversity = null;
                                try {
                                    if (request.getParameter("university") != null) {
                                        selectedUniversity = new String(request.getParameter("university").getBytes("ISO-8859-1"), "UTF-8");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                if (universities != null) {
                                    for (String uni : universities) {
                            %>
                            <option value="<%= uni %>" <%= selectedUniversity != null && uni.equals(selectedUniversity) ? "selected" : "" %>>
                                <%= uni %>
                            </option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="control-label">院系</label>
                        <select name="department" class="form-control">
                            <option value="">全部院系</option>
                            <% 
                                List<String> departments = (List<String>) request.getAttribute("departments");
                                String selectedDepartment = null;
                                try {
                                    if (request.getParameter("department") != null) {
                                        selectedDepartment = new String(request.getParameter("department").getBytes("ISO-8859-1"), "UTF-8");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                if (departments != null) {
                                    for (String dept : departments) {
                            %>
                            <option value="<%= dept %>" <%= selectedDepartment != null && dept.equals(selectedDepartment) ? "selected" : "" %>>
                                <%= dept %>
                            </option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="control-label">关键词搜索</label>
                        <div class="input-group">
                            <% 
                                String keyword = null;
                                try {
                                    if (request.getParameter("keyword") != null) {
                                        keyword = new String(request.getParameter("keyword").getBytes("ISO-8859-1"), "UTF-8");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                            <input type="text" name="keyword" class="form-control" placeholder="姓名、研究方向" value="<%= keyword != null ? keyword : "" %>">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="submit">搜索</button>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="control-label">&nbsp;</label>
                        <button type="button" class="btn btn-default btn-block" onclick="resetForm()">重置筛选</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
    
    <!-- 导师卡片列表 -->
    <div class="row tutor-card-row">
        <% 
            List<Tutor> tutors = (List<Tutor>) request.getAttribute("tutors");
            if (tutors == null || tutors.isEmpty()) {
        %>
            <div class="col-md-12">
                <div class="alert alert-warning">未找到符合条件的导师</div>
            </div>
        <% } else {
            for (Tutor tutor : tutors) {
        %>
            <div class="col-md-4 col-sm-6 col-xs-12">
                <div class="tutor-card">
                    <% if (tutor.getPhoto() != null && !tutor.getPhoto().isEmpty()) { %>
                        <img src="<%= tutor.getPhoto() %>" alt="<%= tutor.getName() %>" class="tutor-photo">
                    <% } else { %>
                        <img src="https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=professional%20academic%20portrait%20of%20a%20university%20professor&image_size=square" alt="<%= tutor.getName() %>" class="tutor-photo">
                    <% } %>
                    <div class="tutor-info">
                        <h4><%= tutor.getName() %></h4>
                        <p class="text-muted"><%= tutor.getTitle() %></p>
                        <p><strong>学校：</strong><%= tutor.getUniversity() %></p>
                        <p><strong>院系：</strong><%= tutor.getDepartment() %></p>
                        <p><strong>研究方向：</strong><%= tutor.getResearchFields() %></p>
                        <% if (tutor.getHomepageUrl() != null && !tutor.getHomepageUrl().isEmpty()) { %>
                            <a href="<%= tutor.getHomepageUrl() %>" target="_blank" class="btn btn-primary btn-sm">访问官网</a>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } } %>
    </div>

    <%-- 分页控件 --%>
    <%
        int currentPage = (Integer) request.getAttribute("currentPage");
        int totalPages = (Integer) request.getAttribute("totalPages");
        int totalTutors = (Integer) request.getAttribute("totalTutors");
        if (totalPages > 1) {
            String queryStr = "";
            if (request.getParameter("university") != null)
                queryStr += "&university=" + java.net.URLEncoder.encode(request.getParameter("university"), "UTF-8");
            if (request.getParameter("department") != null)
                queryStr += "&department=" + java.net.URLEncoder.encode(request.getParameter("department"), "UTF-8");
            if (request.getParameter("keyword") != null)
                queryStr += "&keyword=" + java.net.URLEncoder.encode(request.getParameter("keyword"), "UTF-8");
    %>
    <div class="text-center">
        <ul class="pagination">
            <li class="<%= currentPage <= 1 ? "disabled" : "" %>">
                <a href="?page=<%= currentPage - 1 %><%= queryStr %>">&laquo;</a>
            </li>
            <% for (int p = 1; p <= totalPages; p++) { %>
            <li class="<%= p == currentPage ? "active" : "" %>">
                <a href="?page=<%= p %><%= queryStr %>"><%= p %></a>
            </li>
            <% } %>
            <li class="<%= currentPage >= totalPages ? "disabled" : "" %>">
                <a href="?page=<%= currentPage + 1 %><%= queryStr %>">&raquo;</a>
            </li>
        </ul>
        <small class="text-muted">共 <%= totalTutors %> 位导师</small>
    </div>
    <% } %>
</div>
<footer class="footer text-center">本科生-研究生导师推荐系统</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
    function resetForm() {
        window.location.href = '${pageContext.request.contextPath}/student/tutorBrowse';
    }
</script>
</body>
</html>