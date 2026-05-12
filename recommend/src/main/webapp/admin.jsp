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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f5f6fa; }
        .body-padding { padding-top: 70px; padding-bottom: 40px; }
        .panel-heading-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .panel-heading-custom h3 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
        }
        .photo-preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #ddd;
            background: #f0f0f0;
        }
        .photo-preview[src=""], .photo-preview:not([src]) {
            display: none;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navMain">
                <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="${pageContext.request.contextPath}/student/home">
                <i class="fa fa-graduation-cap"></i> 导师推荐系统
            </a>
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
    <div class="page-header">
        <h3><i class="fa fa-cog"></i> 管理员：导师信息管理</h3>
    </div>

    <%
        String success = (String) request.getAttribute("success");
        String error = (String) request.getAttribute("error");
        if (success != null) {
    %>
        <div class="alert alert-success"><i class="fa fa-check-circle"></i> <%= success %></div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <%= error %></div>
    <% } %>

    <% List<Tutor> tutors = (List<Tutor>) request.getAttribute("tutors"); %>

    <div class="row">
        <!-- Left Column: Basic Info -->
        <div class="col-md-6">
            <div class="panel panel-default">
                <div class="panel-heading panel-heading-custom" style="background:#667eea; color:#fff;">
                    <h3><i class="fa fa-user"></i> 导师基础信息</h3>
                    <button type="button" class="btn btn-sm btn-default" onclick="newTutor()">
                        <i class="fa fa-plus"></i> 新增导师
                    </button>
                </div>
                <div class="panel-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin" onsubmit="return checkPhoto()">
                        <input type="hidden" name="action" value="saveBasic">
                        <input type="hidden" name="tutorId" id="basicTutorId">
                        <div class="form-group">
                            <label>选择导师编辑</label>
                            <select class="form-control" id="tutorSelect" onchange="loadBasicInfo(this.value)">
                                <option value="">-- 选择已有导师 / 或点击「新增导师」--</option>
                                <% if (tutors != null) {
                                    for (Tutor t : tutors) {
                                %>
                                    <option value="<%= t.getId() %>"
                                        data-name="<%= t.getName() != null ? t.getName().replace("\"", "&quot;") : "" %>"
                                        data-gender="<%= t.getGender() != null ? t.getGender() : "" %>"
                                        data-university="<%= t.getUniversity() != null ? t.getUniversity() : "" %>"
                                        data-department="<%= t.getDepartment() != null ? t.getDepartment() : "" %>"
                                        data-fields="<%= t.getResearchFields() != null ? t.getResearchFields().replace("\"", "&quot;") : "" %>"
                                        data-quota="<%= t.getQuota() %>"
                                        data-photo="<%= t.getPhoto() != null ? t.getPhoto().replace("\"", "&quot;") : "" %>"
                                        data-homepage="<%= t.getHomepageUrl() != null ? t.getHomepageUrl().replace("\"", "&quot;") : "" %>"
                                    ><%= t.getName() %> [<%= t.getDepartment() != null ? t.getDepartment() : "" %>]</option>
                                <% }} %>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-sm-6"><div class="form-group"><label>姓名 *</label><input class="form-control" name="name" id="basicName" required></div></div>
                            <div class="col-sm-6"><div class="form-group"><label>性别</label><select class="form-control" name="gender" id="basicGender"><option value="">请选择</option><option value="男">男</option><option value="女">女</option></select></div></div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6"><div class="form-group"><label>院校</label><input class="form-control" name="university" id="basicUniversity"></div></div>
                            <div class="col-sm-6"><div class="form-group"><label>院系</label><input class="form-control" name="department" id="basicDepartment"></div></div>
                        </div>
                        <div class="form-group"><label>研究方向</label><input class="form-control" name="researchFields" id="basicFields"></div>
                        <div class="form-group"><label>招生名额</label><input class="form-control" type="number" name="quota" id="basicQuota" min="0"></div>
                        <div class="form-group"><label>照片URL</label>
                            <div class="input-group">
                                <input class="form-control" name="photo" id="basicPhoto" oninput="previewPhoto()" placeholder="https://example.com/photo.jpg">
                                <span class="input-group-btn"><button type="button" class="btn btn-default" onclick="previewPhoto()"><i class="fa fa-eye"></i></button></span>
                            </div>
                        </div>
                        <div class="form-group" id="photoPreviewWrap" style="display:none;">
                            <img id="photoPreview" class="photo-preview" src="" alt="照片预览">
                        </div>
                        <div class="form-group"><label>主页URL</label><input class="form-control" name="homepageUrl" id="basicHomepage" placeholder="https://..."></div>
                        <button type="submit" class="btn btn-primary btn-block"><i class="fa fa-save"></i> 保存基础信息</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Right Column: Extended Info -->
        <div class="col-md-6">
            <div class="panel panel-default">
                <div class="panel-heading" style="background:#764ba2; color:#fff;">
                    <h3 style="margin:0; font-size:16px; font-weight:600;"><i class="fa fa-file-text"></i> 导师扩展信息</h3>
                </div>
                <div class="panel-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="saveExt">
                        <div class="form-group"><label>选择导师</label><select class="form-control" name="tutorId" id="extTutorSelect" onchange="loadExtInfo(this.value)" required>
                            <option value="">请选择导师</option>
                            <% if (tutors != null) {
                                for (Tutor t : tutors) {
                            %>
                                <option value="<%= t.getId() %>"
                                    data-title="<%= t.getTitle() != null ? t.getTitle().replace("\"", "&quot;") : "" %>"
                                    data-achievement="<%= t.getResearchAchievement() != null ? t.getResearchAchievement().replace("\"", "&quot;") : "" %>"
                                    data-quota="<%= t.getStudentQuota() %>"
                                ><%= t.getName() %> [<%= t.getDepartment() != null ? t.getDepartment() : "" %>]</option>
                            <% }} %>
                        </select></div>
                        <div class="form-group"><label>职称</label><input class="form-control" name="title" id="extTitle" placeholder="如：教授"></div>
                        <div class="form-group"><label>研究成果</label><textarea class="form-control" name="researchAchievement" id="extAchievement" rows="4"></textarea></div>
                        <div class="form-group"><label>招生名额</label><input class="form-control" type="number" name="studentQuota" id="extQuota" min="1" value="3"></div>
                        <button type="submit" class="btn btn-primary btn-block" style="background:#764ba2; border-color:#764ba2;"><i class="fa fa-save"></i> 保存扩展信息</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Tutor List Summary -->
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading"><h3 style="margin:0; font-size:16px; font-weight:600;"><i class="fa fa-list"></i> 当前导师列表</h3></div>
                <div class="table-responsive" style="max-height:300px; overflow:auto;">
                    <table class="table table-condensed table-hover">
                        <thead><tr><th>ID</th><th>姓名</th><th>院系</th><th>院校</th><th>职称</th><th>招生名额</th><th>照片</th><th>主页</th></tr></thead>
                        <tbody>
                        <% if (tutors != null) {
                            for (Tutor t : tutors) {
                        %>
                        <tr>
                            <td><%= t.getId() %></td>
                            <td><%= t.getName() %></td>
                            <td><%= t.getDepartment() != null ? t.getDepartment() : "-" %></td>
                            <td><%= t.getUniversity() != null ? t.getUniversity() : "-" %></td>
                            <td><%= t.getTitle() != null ? t.getTitle() : "-" %></td>
                            <td><%= t.getStudentQuota() > 0 ? t.getStudentQuota() : t.getQuota() %></td>
                            <td>
                                <% if (t.getPhoto() != null && !t.getPhoto().isEmpty()) { %>
                                    <a href="<%= t.getPhoto() %>" target="_blank">查看</a>
                                <% } else { %>-<% } %>
                            </td>
                            <td>
                                <% if (t.getHomepageUrl() != null && !t.getHomepageUrl().isEmpty()) { %>
                                    <a href="<%= t.getHomepageUrl() %>" target="_blank"><i class="fa fa-external-link"></i></a>
                                <% } else { %>-<% } %>
                            </td>
                        </tr>
                        <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer text-center" style="background:#f7f7f7; padding:12px 0; margin-top:20px;">
    本科生-研究生导师推荐系统
</footer>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
<script>
    function newTutor() {
        $('#tutorSelect').val('');
        $('#basicTutorId').val('');
        $('#basicName').val('').focus();
        $('#basicGender').val('');
        $('#basicUniversity').val('');
        $('#basicDepartment').val('');
        $('#basicFields').val('');
        $('#basicQuota').val('');
        $('#basicPhoto').val('');
        $('#basicHomepage').val('');
        $('#photoPreviewWrap').hide();
        $('#photoPreview').attr('src', '');
    }

    function loadBasicInfo(val) {
        if (!val) { newTutor(); return; }
        var opt = $('#tutorSelect option[value="' + val + '"]');
        $('#basicTutorId').val(val);
        $('#basicName').val(opt.data('name'));
        $('#basicGender').val(opt.data('gender'));
        $('#basicUniversity').val(opt.data('university'));
        $('#basicDepartment').val(opt.data('department'));
        $('#basicFields').val(opt.data('fields'));
        $('#basicQuota').val(opt.data('quota'));
        $('#basicPhoto').val(opt.data('photo'));
        $('#basicHomepage').val(opt.data('homepage'));
        previewPhoto();
    }

    function previewPhoto() {
        var url = $('#basicPhoto').val();
        if (url) {
            $('#photoPreview').attr('src', url);
            $('#photoPreviewWrap').show();
        } else {
            $('#photoPreviewWrap').hide();
        }
    }

    function checkPhoto() {
        previewPhoto();
        return true;
    }

    function loadExtInfo(val) {
        if (!val) {
            $('#extTitle').val('');
            $('#extAchievement').val('');
            $('#extQuota').val('3');
            return;
        }
        var opt = $('#extTutorSelect option[value="' + val + '"]');
        $('#extTitle').val(opt.data('title'));
        $('#extAchievement').val(opt.data('achievement'));
        $('#extQuota').val(opt.data('quota') || 3);
    }

    $(function(){
        var basicVal = $('#tutorSelect').val();
        if (basicVal) loadBasicInfo(basicVal);
        var extVal = $('#extTutorSelect').val();
        if (extVal) loadExtInfo(extVal);
    });
</script>
</body>
</html>
