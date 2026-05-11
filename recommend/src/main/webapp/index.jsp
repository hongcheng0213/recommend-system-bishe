<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>学生信息录入 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <style>.body-padding{padding-top:70px;padding-bottom:70px;}.footer{background:#f7f7f7;padding:12px 0;margin-top:20px;}</style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#mainNav"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">导师推荐系统</a>
        </div>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="nav navbar-nav">
                <li class="active"><a href="${pageContext.request.contextPath}/index.jsp">首页</a></li>
                <li><a href="${pageContext.request.contextPath}/login.jsp">登录</a></li>
                <li><a href="${pageContext.request.contextPath}/admin">管理员入口</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container body-padding">
    <div class="row">
        <div class="col-md-10 col-md-offset-1">
            <div class="page-header"><h3>学生信息录入</h3></div>
            <form id="studentForm" method="post" action="${pageContext.request.contextPath}/register">
                <div class="row">
                    <div class="col-md-6">
                        <div class="panel panel-primary">
                            <div class="panel-heading">学生基本信息</div>
                            <div class="panel-body">
                                <div class="form-group"><label>姓名</label><input class="form-control" name="name" required></div>
                                <div class="form-group"><label>密码</label><input type="password" class="form-control" name="password" required></div>
                                <div class="form-group"><label>性别</label><select class="form-control" name="gender"><option value="">请选择</option><option>男</option><option>女</option></select></div>
                                <div class="form-group"><label>专业</label><input class="form-control" name="major" placeholder="请输入专业"></div>
                                <div class="form-group"><label>年级</label><input class="form-control" name="grade" required></div>
                                <div class="form-group"><label>绩点 (GPA)</label><input class="form-control" type="number" step="0.01" min="0" max="4" name="gpa" required></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="panel panel-success">
                            <div class="panel-heading">偏好与联系信息</div>
                            <div class="panel-body">
                                <div class="form-group"><label>考研成绩（0-500）</label><input class="form-control" type="number" min="0" max="500" name="score" placeholder="如：385" required></div>
                                <div class="form-group"><label>联系电话</label><input class="form-control" name="phone" required></div>
                                <div class="form-group"><label>邮箱</label><input class="form-control" type="email" name="email"></div>
                                <div class="form-group"><label>感兴趣的研究方向</label><textarea class="form-control" name="interests" id="interests" rows="4" placeholder="请描述你感兴趣的研究方向，系统将据此进行导师匹配" required></textarea></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="text-center">
                    <button id="submitBtn" type="submit" class="btn btn-primary">提交信息</button>
                </div>
            </form>
            <div id="errorMsg" class="text-danger text-center" style="margin-top:10px;"></div>
        </div>
    </div>
</div>
<footer class="footer text-center">本科生-研究生导师推荐系统</footer>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
$('#studentForm').submit(function(e){
    var grade = $('input[name="grade"]').val().trim();
    var gpa = parseFloat($('input[name="gpa"]').val());
    var phone = $('input[name="phone"]').val().trim();
    var interests = $('#interests').val().trim();
    if (!grade){ e.preventDefault(); $('#errorMsg').text('年级不能为空'); return; }
    if (isNaN(gpa) || gpa < 0 || gpa > 4){ e.preventDefault(); $('#errorMsg').text('绩点必须在0-4之间'); return; }
    if (!phone){ e.preventDefault(); $('#errorMsg').text('联系电话不能为空'); return; }
    if (!interests){ e.preventDefault(); $('#errorMsg').text('请填写感兴趣的研究方向'); return; }
    $('#submitBtn').prop('disabled', true).text('提交中...');
});
</script>
</body>
</html>
