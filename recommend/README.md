## 本科生-研究生导师推荐系统（基于协同过滤）

### 1. 项目简介

本项目使用 **Java + Servlet + JSP + MySQL** 实现一个简单的本科生-研究生导师推荐系统，核心是：
- 学生可以给导师打分；
- 系统基于学生协同过滤（余弦相似度）和内容匹配（专业、兴趣、成绩）给学生推荐导师。

### 2. 技术栈

- Java 8
- Maven
- Servlet / JSP（Tomcat 等容器）
- MySQL

### 3. 数据库建表示例（MySQL）

```sql
CREATE DATABASE IF NOT EXISTS tutor_recommendation DEFAULT CHARSET utf8mb4;
USE tutor_recommendation;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  password VARCHAR(100) NOT NULL,
  gender VARCHAR(10),
  major VARCHAR(100),
  grade VARCHAR(20),
  interests VARCHAR(255),
  score DOUBLE
);

CREATE TABLE tutors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  gender VARCHAR(10),
  department VARCHAR(100),
  research_fields VARCHAR(255),
  quota INT
);

CREATE TABLE student_preferences (
  student_id INT NOT NULL,
  tutor_id INT NOT NULL,
  preference_score DOUBLE NOT NULL,
  PRIMARY KEY (student_id, tutor_id),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (tutor_id) REFERENCES tutors(id)
);
```

可以手动插入一些导师和学生数据，方便测试：

```sql
INSERT INTO tutors(name, gender, department, research_fields, quota) VALUES
('张老师', '男', '计算机学院', '人工智能,推荐系统', 5),
('李老师', '女', '计算机学院', '大数据,数据挖掘', 3),
('王老师', '男', '信息工程学院', '通信,信号处理', 2);
```

### 4. 配置数据库连接

编辑 `src/main/resources/db.properties`，根据你本地 MySQL 修改：

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/tutor_recommendation?useSSL=false&useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
db.username=你的数据库用户名
db.password=你的数据库密码
```

### 5. 编译与运行

1. 在项目根目录执行：

```bash
mvn clean package
```

2. 将生成的 `target/tutor-recommendation.war` 部署到 Tomcat（或在 IDE 中直接以 Tomcat 运行该 Maven Web 项目）。
3. 访问：`http://localhost:8080/tutor-recommendation/`（根据你的上下文路径调整）。

### 6. 主要使用流程

1. 学生注册账号并登录；
2. 在“导师列表”页面给多位导师打分；
3. 点击“查看推荐导师”，系统基于协同过滤和内容匹配生成推荐列表。

### 7. 新增扩展表与功能说明

本项目已扩展 MySQL 表以支持更完整功能：

- `student_ext`：学生扩展信息（年级、绩点、联系电话、邮箱），在注册时写入。
- `tutor_ext`：导师扩展信息（职称、研究成果、招生名额、热度值），管理员页面可维护。
- `recommend_log`：推荐记录日志（学生、导师、推荐分、时间），每次生成推荐时自动记录。

#### 7.1 新增表 SQL（可直接在数据库执行）

```sql
CREATE TABLE student_ext (
  student_id INT NOT NULL,
  grade VARCHAR(20) NOT NULL COMMENT '年级',
  gpa DECIMAL(4,2) NOT NULL COMMENT '绩点',
  phone VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY (student_id),
  FOREIGN KEY (student_id) REFERENCES students(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tutor_ext (
  tutor_id INT NOT NULL,
  title VARCHAR(50) DEFAULT NULL COMMENT '职称',
  research_achievement TEXT COMMENT '研究成果',
  student_quota INT NOT NULL DEFAULT 3 COMMENT '招生名额',
  hot_score INT NOT NULL DEFAULT 50 COMMENT '热度值',
  PRIMARY KEY (tutor_id),
  FOREIGN KEY (tutor_id) REFERENCES tutors(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE recommend_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
  student_id INT NOT NULL,
  tutor_id INT NOT NULL,
  recommend_score DOUBLE NOT NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (tutor_id) REFERENCES tutors(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### 7.2 新增页面说明

- `index.jsp`：学生注册首页，新增年级、绩点、联系电话字段。
- `recommendResult.jsp`：推荐结果页显示导师职称、招生名额、研究成果、匹配进度条。
- `admin.jsp`：管理员页面，可录入/修改导师职称、招生名额、研究成果、热度值。

#### 7.3 快速使用（补充）

1. 访问：`http://localhost:8080/tutor-recommendation/index.jsp`，输入学生信息并注册；
2. 登录后进入“导师列表”打分；
3. 查看推荐结果页面检验扩展字段展示；
4. 访问：`http://localhost:8080/tutor-recommendation/admin`，维护导师扩展信息。

