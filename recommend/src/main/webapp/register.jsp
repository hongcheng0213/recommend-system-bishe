<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>导师推荐系统 - 学生注册</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <style>.body-padding {padding-top:70px; padding-bottom:60px;} .footer {background:#f7f7f7; padding:12px 0; margin-top:30px;}</style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main-nav">
                <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/login.jsp">导师推荐系统</a>
        </div>
        <div class="collapse navbar-collapse" id="main-nav">
            <ul class="nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/login.jsp">首页</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/register">注册</a></li>
                <li><a href="${pageContext.request.contextPath}/student/home">学生主页</a></li>
                <li><a href="${pageContext.request.contextPath}/student/recommend">推荐结果</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container body-padding">
    <div class="row">
        <div class="col-md-10 col-md-offset-1">
            <div class="page-header"><h2>学生信息录入</h2></div>
            <form id="registerForm" method="post" action="${pageContext.request.contextPath}/register">
                <div class="row">
                    <div class="col-md-6">
                        <div class="panel panel-primary">
                            <div class="panel-heading">学生基本信息</div>
                            <div class="panel-body">
                                <div class="form-group">
                                    <label>学号<span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="student_no" id="studentNo" placeholder="请输入学号">
                                </div>
                                <div class="form-group">
                                    <label>姓名</label>
                                    <input type="text" class="form-control" name="name" placeholder="请输入姓名">
                                </div>
                                <div class="form-group">
                                    <label>密码</label>
                                    <input type="password" class="form-control" name="password" placeholder="请输入密码">
                                </div>
                                <div class="form-group">
                                    <label>性别</label>
                                    <select class="form-control" name="gender">
                                        <option value="">请选择</option>
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                        <option value="其他">其他</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>专业</label>
                                    <select class="form-control" name="major" id="major">
                                        <option value="">请选择专业</option>
                                        <option>计算机科学与技术</option>
                                        <option>软件工程</option>
                                        <option>电子信息工程</option>
                                        <option>自动化</option>
                                        <option>数据科学与大数据技术</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="panel panel-success">
                            <div class="panel-heading">学生偏好信息</div>
                            <div class="panel-body">
                                <div class="form-group">
                                    <label>年级</label>
                                    <select class="form-control" name="grade">
                                        <option value="">请选择年级</option>
                                        <option>大一</option>
                                        <option>大二</option>
                                        <option>大三</option>
                                        <option>大四</option>
                                        <option>研一</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>研究方向<span class="text-danger">*</span></label>
                                    <select class="form-control" name="interests" id="researchDirection">
                                        <option value="">请选择研究方向</option>
                                        <option>推荐系统</option>
                                        <option>机器学习</option>
                                        <option>大数据</option>
                                        <option>计算机视觉</option>
                                        <option>自然语言处理</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>兴趣关键词</label>
                                    <input class="form-control" type="text" name="interests" placeholder="如：推荐系统, 大数据">
                                </div>
                                <div class="form-group">
                                    <label>成绩（0-100）</label>
                                    <input class="form-control" type="number" name="score" min="0" max="100" placeholder="如：85">
                                </div>
                                <div class="form-group">
                                    <label>自我描述</label>
                                    <textarea class="form-control" name="description" rows="3" placeholder="简要描述你的兴趣和目标"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="text-center">
                    <button id="submitBtn" type="submit" class="btn btn-primary btn-lg">提交注册 <span id="spinner" class="glyphicon glyphicon-refresh glyphicon-spin" style="display:none"></span></button>
                    <a class="btn btn-default" href="${pageContext.request.contextPath}/login.jsp">返回登录</a>
                </div>
            </form>
            <div id="registerMsg" class="text-center" style="margin-top:10px;"></div>
            <div style="margin-top:16px;">
                <div class="alert alert-info"><strong>提示：</strong>注册后请登录，并在“导师列表”页面给导师打分，才能生成个性化推荐结果。</div>
            </div>
            <div>
                <div class="text-danger">
                    <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                    %>
                    <%= error %>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
<footer class="footer text-center">© 2026 本科生-研究生导师推荐系统 | 系统工程优化</footer>
<div id="alertModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="alertModalTitle">
    <div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title" id="alertModalTitle">提示</h4></div><div class="modal-body"><p id="alertModalBody"></p></div><div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div></div></div>
</div>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
$(function(){
    $('#registerForm').submit(function(e){
        var studentNo = $('#studentNo').val().trim();
        var direction = $('#researchDirection').val();
        if (studentNo === '') { e.preventDefault(); showModal('注册错误', '学号不能为空'); return; }
        if (direction === '') { e.preventDefault(); showModal('注册错误', '请选择研究方向'); return; }
        var score = $('input[name="score"]').val();
        if (score !== '' && (isNaN(score) || score < 0 || score > 100)) { e.preventDefault(); showModal('注册错误', '成绩请输入0-100的数值'); return; }
        $('#submitBtn').prop('disabled', true);
        $('#spinner').show();
    });
});
function showModal(title, message){ $('#alertModalTitle').text(title); $('#alertModalBody').text(message); $('#alertModal').modal('show'); }
</script>
</body>
</html>

