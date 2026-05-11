<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>学生主页 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <style>.body-padding {padding-top:70px; padding-bottom:70px;} .footer{background:#f7f7f7; padding:12px 0;}</style>
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
                <li><a href="${pageContext.request.contextPath}/admin">管理员</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container body-padding">
    <div class="jumbotron">
        <h2>欢迎，${sessionScope.studentName}</h2>
        <p>这是你的个人主页。你可以先填写意向导师，然后查看推荐结果。</p>
        <p>
            <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/student/tutors">意向导师</a>
            <a class="btn btn-success btn-lg" href="${pageContext.request.contextPath}/student/recommend">查看推荐结果</a>
        </p>
    </div>
    <div class="row">
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

