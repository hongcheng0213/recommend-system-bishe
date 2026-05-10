<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>导师推荐系统 - 登录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <style>body {padding-top: 70px;}</style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#nav-collapse">
                <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/login.jsp">导师推荐系统</a>
        </div>
        <div class="collapse navbar-collapse" id="nav-collapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="${pageContext.request.contextPath}/login.jsp">首页</a></li>
                <li><a href="${pageContext.request.contextPath}/login.jsp">登录</a></li>
                <li><a href="${pageContext.request.contextPath}/admin">管理员入口</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-primary">
                <div class="panel-heading"><h3 class="panel-title">学生登录</h3></div>
                <div class="panel-body">
                    <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
                        <div class="form-group">
                            <label>用户名（学生姓名）</label>
                            <input class="form-control" type="text" name="username" required>
                        </div>
                        <div class="form-group">
                            <label>密码</label>
                            <input class="form-control" type="password" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">登录</button>
                    </form>
                    <hr>
                    <p>还没有账号？<a href="${pageContext.request.contextPath}/index.jsp">立即注册</a></p>
                    <div id="loginError" class="text-danger"></div>
                    <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                    %>
                    <div class="alert alert-danger" style="margin-top:10px;"><%= error %></div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
<footer class="footer text-center" style="padding:15px 0; background:#f7f7f7; position:fixed; width:100%; bottom:0;">
    <div class="container">本科生-研究生导师推荐系统</div>
</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>

