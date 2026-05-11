# UI视觉升级设计方案

## 目标

改善导师推荐系统的初始页面视觉体验，解决"太寡淡"的问题，在不引入前端工具链的前提下，用最小改动实现显著视觉提升。

## 范围

轻量升级（方案一）：新增全局 `style.css` + 改造 `login.jsp` 和 `studentHome.jsp` 两个核心页面。

## 设计决策

| 决策项 | 选择 |
|--------|------|
| 整体风格 | 现代渐变风 |
| 渐变配色 | 蓝紫渐变 #667eea → #764ba2 |
| 登录页布局 | 整体居中紧凑双栏（max-width限制宽度，左右间距缩小） |
| 主页布局 | 欢迎面板 + 快捷入口卡片 + 信息卡片 |
| 图标库 | Font Awesome CDN |
| 导航栏 | 登录页透明/半透明覆盖渐变背景；主页白色背景+阴影 |

## 技术方案

### 新增文件

**`src/main/webapp/css/style.css`** — 全局样式文件，包含：
- 渐变背景工具类 `.gradient-bg`
- 页面背景色 `.page-bg`（#f5f6fa 浅灰）
- 圆角卡片样式 `.card-white`、`.card-hover`
- 渐变按钮 `.btn-gradient`
- 欢迎横幅 `.welcome-banner`
- 快捷入口卡片 `.quick-entry`
- 信息卡片 `.info-card`
- 导航栏变体 `.navbar-custom`

### 修改文件

**`login.jsp`**：
- 引入 `css/style.css` 和 Font Awesome CDN
- body 应用全屏渐变背景
- 导航栏改为透明背景+白色文字
- 重写登录区域：整体居中容器（max-width: 600px），左侧品牌信息 + 右侧白色圆角卡片表单
- 输入框使用圆角样式，按钮使用渐变圆角
- 页脚去掉固定定位，改为渐变背景下的半透明文字

**`studentHome.jsp`**：
- 引入 `css/style.css`
- 页面背景改为浅灰 #f5f6fa
- 导航栏改为白色背景+品牌色文字+底部阴影
- 顶部：渐变欢迎横幅（学生姓名 + 专业年级）
- 中部：三张功能入口卡片并排，使用不同渐变色编号圆圈
- 底部：两张信息卡片并排（基本信息 + 扩展信息）
- 页脚保持简洁

### 不变内容

- Bootstrap 3.4.1 CDN 保留（依赖其网格和组件）
- 后端逻辑零改动，纯前端视觉升级
- 其他页面（tutors.jsp、tutorBrowse.jsp、recommendResult.jsp 等）暂不改动
- 不抽取 JSP include 模板

## 实施顺序

1. 创建 `style.css`，定义所有工具类和组件样式
2. 改造 `login.jsp`
3. 改造 `studentHome.jsp`
