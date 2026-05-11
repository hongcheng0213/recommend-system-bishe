<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>导师推荐系统 - 登录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="gradient-bg">
<nav class="navbar navbar-custom navbar-transparent navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#nav-collapse">
                <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/login.jsp">
                <i class="fa fa-graduation-cap"></i> 导师推荐系统
            </a>
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

<div class="login-wrapper">
    <div class="login-container">
        <div class="login-brand">
            <h2><i class="fa fa-graduation-cap"></i> 导师推荐系统</h2>
            <p class="slogan">智能匹配 · 精准推荐 · 成就未来</p>
            <ul class="features">
                <li><i class="fa fa-check-circle"></i> 协同过滤智能推荐算法</li>
                <li><i class="fa fa-check-circle"></i> 多维度导师信息浏览</li>
                <li><i class="fa fa-check-circle"></i> 个性化意向导师选择</li>
            </ul>
        </div>
        <div class="login-card">
            <div class="card-title"><i class="fa fa-user"></i> 学生登录</div>
            <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
                <div class="form-group">
                    <label>用户名（学生姓名）</label>
                    <input class="form-control" type="text" name="username" placeholder="请输入姓名" required>
                </div>
                <div class="form-group">
                    <label>密码</label>
                    <input class="form-control" type="password" name="password" placeholder="请输入密码" required>
                </div>
                <button type="submit" class="btn-login">登 录</button>
            </form>
            <p class="register-link">还没有账号？<a href="${pageContext.request.contextPath}/index.jsp">立即注册 <i class="fa fa-arrow-right"></i></a></p>
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="alert alert-danger"><%= error %></div>
            <%
                }
            %>
        </div>
    </div>
</div>

<footer class="login-footer">
    <div>本科生—研究生导师推荐系统</div>
</footer>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>
