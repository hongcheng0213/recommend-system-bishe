# UI视觉升级 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 新增全局 style.css，改造 login.jsp 和 studentHome.jsp，实现现代渐变风视觉升级。

**Architecture:** 纯前端改动 — 新增 1 个 CSS 文件定义所有自定义样式，修改 2 个 JSP 页面的 HTML 结构和引用。Bootstrap 3.4.1 网格系统保留不变，后端零改动。

**Tech Stack:** Java Servlet + JSP + Bootstrap 3.4.1 CDN + Font Awesome 4.7 CDN

---

## 文件结构

| 操作 | 文件路径 | 职责 |
|------|---------|------|
| 新建 | `recommend/src/main/webapp/css/style.css` | 全局自定义样式：渐变背景、导航栏、登录卡片、欢迎横幅、快捷入口、信息卡片 |
| 修改 | `recommend/src/main/webapp/login.jsp` | 登录页：全屏渐变背景 + 居中紧凑双栏 |
| 修改 | `recommend/src/main/webapp/studentHome.jsp` | 主页：欢迎横幅 + 快捷入口 + 信息卡片 |

---

### Task 1: 新建全局样式文件 style.css

**Files:**
- Create: `recommend/src/main/webapp/css/style.css`

- [ ] **Step 1: 创建 CSS 目录并写入样式文件**

```css
/* ====== 全局 ====== */
html, body {
    height: 100%;
}
body {
    font-family: "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
}

/* ====== 背景 ====== */
.gradient-bg {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
}
.page-bg {
    background: #f5f6fa;
}

/* ====== 导航栏 ====== */
.navbar-custom {
    border: none;
    margin-bottom: 0;
}
/* 登录页透明导航 */
.navbar-transparent {
    background: transparent;
}
.navbar-transparent .navbar-brand,
.navbar-transparent .navbar-nav > li > a {
    color: rgba(255, 255, 255, 0.9) !important;
}
.navbar-transparent .navbar-nav > li > a:hover,
.navbar-transparent .navbar-nav > li > a:focus {
    color: #fff !important;
    background: rgba(255, 255, 255, 0.15) !important;
}
.navbar-transparent .navbar-toggle {
    border-color: rgba(255, 255, 255, 0.3);
}
.navbar-transparent .navbar-toggle .icon-bar {
    background-color: #fff;
}
/* 主页白色导航 */
.navbar-white {
    background: #fff;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
}
.navbar-white .navbar-brand {
    color: #667eea !important;
    font-weight: 700;
}
.navbar-white .navbar-nav > li > a {
    color: #555 !important;
}
.navbar-white .navbar-nav > li.active > a,
.navbar-white .navbar-nav > li > a:hover {
    color: #667eea !important;
    background: transparent !important;
}

/* ====== 登录页 ====== */
.login-wrapper {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: calc(100vh - 120px);
    padding: 20px 15px;
}
.login-container {
    display: flex;
    max-width: 580px;
    width: 100%;
    align-items: center;
    gap: 28px;
}
.login-brand {
    flex: 1;
    color: #fff;
    text-align: center;
}
.login-brand h2 {
    color: #fff;
    margin: 0 0 6px 0;
    font-size: 24px;
    font-weight: 700;
}
.login-brand .slogan {
    font-size: 13px;
    opacity: 0.85;
    margin-bottom: 14px;
}
.login-brand .features {
    list-style: none;
    padding: 0;
    margin: 0;
    font-size: 12px;
    opacity: 0.75;
}
.login-brand .features li {
    padding: 3px 0;
}
.login-brand .features li i {
    margin-right: 4px;
}
.login-card {
    width: 260px;
    min-width: 260px;
    background: #fff;
    border-radius: 10px;
    padding: 24px 22px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}
.login-card .card-title {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 14px;
    color: #333;
    text-align: center;
}
.login-card .form-control {
    border-radius: 20px;
    height: 40px;
    padding: 6px 18px;
    border: 1px solid #e0e0e0;
    box-shadow: none;
}
.login-card .form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.15);
}
.login-card .btn-login {
    width: 100%;
    border-radius: 20px;
    height: 40px;
    border: none;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: opacity 0.2s;
}
.login-card .btn-login:hover {
    opacity: 0.9;
}
.login-card .register-link {
    text-align: center;
    margin-top: 10px;
    font-size: 13px;
    color: #999;
}
.login-card .register-link a {
    color: #667eea;
}
.login-card .alert {
    margin-bottom: 0;
    margin-top: 10px;
    border-radius: 6px;
}
.login-card hr {
    margin: 12px 0;
}
.login-footer {
    text-align: center;
    color: rgba(255, 255, 255, 0.55);
    font-size: 12px;
    padding-bottom: 18px;
}

/* ====== 主页 ====== */
.body-padding {
    padding-top: 80px;
    padding-bottom: 40px;
}
.welcome-banner {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 12px;
    padding: 26px 30px;
    color: #fff;
    margin-bottom: 22px;
}
.welcome-banner h3 {
    color: #fff;
    margin: 0 0 5px 0;
    font-size: 22px;
    font-weight: 700;
}
.welcome-banner .student-meta {
    font-size: 13px;
    opacity: 0.85;
}
.quick-entries {
    display: flex;
    gap: 14px;
    margin-bottom: 22px;
}
.quick-entry {
    flex: 1;
    background: #fff;
    border-radius: 12px;
    padding: 20px 14px;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    text-decoration: none;
    color: inherit;
    display: block;
    transition: transform 0.2s, box-shadow 0.2s;
}
.quick-entry:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
    text-decoration: none;
    color: inherit;
}
.quick-entry .qe-icon {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    color: #fff;
    margin-bottom: 8px;
}
.qe-icon-purple {
    background: linear-gradient(135deg, #667eea, #764ba2);
}
.qe-icon-pink {
    background: linear-gradient(135deg, #f093fb, #f5576c);
}
.qe-icon-blue {
    background: linear-gradient(135deg, #4facfe, #00f2fe);
}
.quick-entry .qe-title {
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 3px;
}
.quick-entry .qe-desc {
    font-size: 12px;
    color: #999;
}
.info-cards {
    display: flex;
    gap: 14px;
}
.info-card {
    flex: 1;
    background: #fff;
    border-radius: 10px;
    padding: 18px 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}
.info-card .ic-title {
    font-size: 13px;
    color: #999;
    margin-bottom: 10px;
    font-weight: 600;
}
.info-card .ic-table {
    width: 100%;
    font-size: 13px;
}
.info-card .ic-table td {
    padding: 4px 0;
    vertical-align: top;
}
.info-card .ic-table .ic-label {
    color: #aaa;
    width: 75px;
}
.page-header {
    display: none;
}
.footer {
    background: transparent !important;
    padding: 12px 0;
    text-align: center;
    color: #bbb;
    font-size: 12px;
}
```

- [ ] **Step 2: 验证文件已创建**

```bash
ls -la recommend/src/main/webapp/css/style.css
```

预期：文件存在且非空。

- [ ] **Step 3: 提交**

```bash
git add recommend/src/main/webapp/css/style.css
git commit -m "feat: 新增全局样式文件，定义渐变背景、导航栏、登录卡片、欢迎横幅等组件样式"
```

---

### Task 2: 改造登录页 login.jsp

**Files:**
- Modify: `recommend/src/main/webapp/login.jsp`（几乎全量重写）

- [ ] **Step 1: 重写 login.jsp**

用以下内容完整替换 `recommend/src/main/webapp/login.jsp`：

```jsp
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
```

- [ ] **Step 2: 验证改动**

```bash
wc -l recommend/src/main/webapp/login.jsp
```

预期：约69行，与原来接近但全部是新的HTML结构。

- [ ] **Step 3: 提交**

```bash
git add recommend/src/main/webapp/login.jsp
git commit -m "feat: 登录页视觉升级——全屏蓝紫渐变背景+居中紧凑双栏布局"
```

---

### Task 3: 改造学生主页 studentHome.jsp

**Files:**
- Modify: `recommend/src/main/webapp/studentHome.jsp`

- [ ] **Step 1: 重写 studentHome.jsp**

用以下内容完整替换 `recommend/src/main/webapp/studentHome.jsp`：

```jsp
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.example.recommend.model.Student" %>
<%@ page import="com.example.recommend.model.StudentExt" %>
<%
    Student student = (Student) request.getAttribute("student");
    StudentExt ext = (StudentExt) request.getAttribute("studentExt");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>学生主页 - 导师推荐系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="page-bg">
<nav class="navbar navbar-custom navbar-white navbar-fixed-top">
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
                <li class="active"><a href="${pageContext.request.contextPath}/student/home">首页</a></li>
                <li><a href="${pageContext.request.contextPath}/student/tutors">意向导师</a></li>
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

    <%-- 欢迎横幅 --%>
    <div class="welcome-banner">
        <h3><i class="fa fa-hand-peace-o"></i> 欢迎回来，${sessionScope.studentName}</h3>
        <% if (student != null) { %>
        <p class="student-meta"><%= student.getMajor() != null ? student.getMajor() : "" %> &nbsp;·&nbsp; <%= student.getGrade() != null ? student.getGrade() : (ext != null && ext.getGrade() != null ? ext.getGrade() : "") %></p>
        <% } %>
    </div>

    <%-- 快捷入口 --%>
    <div class="quick-entries">
        <a href="${pageContext.request.contextPath}/student/tutors" class="quick-entry">
            <div class="qe-icon qe-icon-purple"><i class="fa fa-heart"></i></div>
            <div class="qe-title">意向导师</div>
            <div class="qe-desc">选择心仪导师</div>
        </a>
        <a href="${pageContext.request.contextPath}/student/recommend" class="quick-entry">
            <div class="qe-icon qe-icon-pink"><i class="fa fa-lightbulb-o"></i></div>
            <div class="qe-title">推荐结果</div>
            <div class="qe-desc">查看智能推荐</div>
        </a>
        <a href="${pageContext.request.contextPath}/student/tutorBrowse" class="quick-entry">
            <div class="qe-icon qe-icon-blue"><i class="fa fa-search"></i></div>
            <div class="qe-title">导师浏览</div>
            <div class="qe-desc">浏览全部导师</div>
        </a>
    </div>

    <%-- 信息卡片 --%>
    <% if (student != null) { %>
    <div class="info-cards">
        <div class="info-card">
            <div class="ic-title"><i class="fa fa-id-card"></i> 基本信息</div>
            <table class="ic-table">
                <tr><td class="ic-label">姓名</td><td><strong><%= student.getName() %></strong></td></tr>
                <tr><td class="ic-label">性别</td><td><%= student.getGender() != null ? student.getGender() : "-" %></td></tr>
                <tr><td class="ic-label">专业</td><td><%= student.getMajor() != null ? student.getMajor() : "-" %></td></tr>
                <tr><td class="ic-label">年级</td><td><%= student.getGrade() != null ? student.getGrade() : (ext != null && ext.getGrade() != null ? ext.getGrade() : "-") %></td></tr>
                <tr><td class="ic-label">研究方向</td><td><%= student.getInterests() != null ? student.getInterests() : "-" %></td></tr>
                <tr><td class="ic-label">考研分数</td><td><%= student.getScore() > 0 ? String.format("%.0f", student.getScore()) : "-" %></td></tr>
            </table>
        </div>
        <div class="info-card">
            <div class="ic-title"><i class="fa fa-info-circle"></i> 扩展信息</div>
            <table class="ic-table">
                <tr><td class="ic-label">GPA</td><td><%= ext != null && ext.getGpa() > 0 ? String.format("%.2f", ext.getGpa()) : "未填写" %></td></tr>
                <tr><td class="ic-label">电话</td><td><%= ext != null && ext.getPhone() != null ? ext.getPhone() : "未填写" %></td></tr>
                <tr><td class="ic-label">邮箱</td><td><%= ext != null && ext.getEmail() != null ? ext.getEmail() : "未填写" %></td></tr>
            </table>
        </div>
    </div>
    <% } %>

</div>

<footer class="footer">
    <div class="container">本科生—研究生导师推荐系统</div>
</footer>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>
</body>
</html>
```

- [ ] **Step 2: 验证改动**

```bash
wc -l recommend/src/main/webapp/studentHome.jsp
```

预期：约105行。

- [ ] **Step 3: 提交**

```bash
git add recommend/src/main/webapp/studentHome.jsp
git commit -m "feat: 主页视觉升级——欢迎横幅+快捷入口卡片+信息卡片布局"
```

---

### Task 4: 构建验证

**Files:** 无新建或修改

- [ ] **Step 1: Maven 构建**

```bash
cd recommend && mvn compile -q
```

预期：BUILD SUCCESS，无编译错误。

- [ ] **Step 2: 确认 style.css 被复制到 target 目录**

```bash
ls recommend/target/tutor-recommendation/css/style.css
```

预期：文件存在。

- [ ] **Step 3: 确认修改的 JSP 被复制到 target 目录**

```bash
head -5 recommend/target/tutor-recommendation/login.jsp
head -5 recommend/target/tutor-recommendation/studentHome.jsp
```

预期：两个文件都以 `<%@ page contentType="text/html; charset=UTF-8" language="java" %>` 开头。

- [ ] **Step 4: 提交**

```bash
git add -A
git commit -m "chore: Maven构建验证通过"
```
