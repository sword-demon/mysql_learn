# 创建 test数据库
create DATABASE if not exists `test`
default CHARACTER SET utf8
default COLLATE utf8_general_ci;

DROP TABLE IF EXISTS `class`;
CREATE TABLE `class`  (
  `cid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `caption` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '班级名称',
  `grade_id` int(11) UNSIGNED NOT NULL COMMENT '所属年级id',
  PRIMARY KEY (`cid`) USING BTREE,
  INDEX `cid`(`cid`, `caption`, `grade_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '班级表' ROW_FORMAT = Dynamic;

INSERT INTO `class` VALUES (1, '一年一班', 1);
INSERT INTO `class` VALUES (2, '一年二班', 1);
INSERT INTO `class` VALUES (3, '二年一班', 2);
INSERT INTO `class` VALUES (4, '二年二班', 2);
INSERT INTO `class` VALUES (5, '三年一班', 3);
INSERT INTO `class` VALUES (6, '三年二班', 3);
INSERT INTO `class` VALUES (7, '四年一班', 4);
INSERT INTO `class` VALUES (8, '四年二班', 4);
INSERT INTO `class` VALUES (9, '五年一班', 5);
INSERT INTO `class` VALUES (10, '五年二班', 5);
INSERT INTO `class` VALUES (11, '六年一班', 6);
INSERT INTO `class` VALUES (12, '六年二班', 6);
INSERT INTO `class` VALUES (13, '六年三班', 6);


DROP TABLE IF EXISTS `class_grade`;
CREATE TABLE `class_grade`  (
  `gid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `gname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '年级名称',
  PRIMARY KEY (`gid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '年级表' ROW_FORMAT = Dynamic;


INSERT INTO `class_grade` VALUES (1, '一年级');
INSERT INTO `class_grade` VALUES (2, '二年级');
INSERT INTO `class_grade` VALUES (3, '三年级');
INSERT INTO `class_grade` VALUES (4, '四年级');
INSERT INTO `class_grade` VALUES (5, '五年级');
INSERT INTO `class_grade` VALUES (6, '六年级');


DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `cid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '课程名称',
  `teacher_id` int(11) NOT NULL COMMENT '关联教师id',
  PRIMARY KEY (`cid`) USING BTREE,
  INDEX `cname`(`cname`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;


INSERT INTO `course` VALUES (1, '语文', 1);
INSERT INTO `course` VALUES (2, '数学', 2);
INSERT INTO `course` VALUES (3, '英语', 3);
INSERT INTO `course` VALUES (4, '化学', 4);
INSERT INTO `course` VALUES (5, '物理', 5);
INSERT INTO `course` VALUES (6, '生物', 6);
INSERT INTO `course` VALUES (7, '化学实验课', 4);
INSERT INTO `course` VALUES (8, '化学会考课', 4);


DROP TABLE IF EXISTS `score`;
CREATE TABLE `score`  (
  `sid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL COMMENT '学生id',
  `course_id` int(11) NOT NULL COMMENT '对应课程id',
  `score` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '得分',
  PRIMARY KEY (`sid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '得分表' ROW_FORMAT = Dynamic;


INSERT INTO `score` VALUES (1, 1, 1, 95.00);
INSERT INTO `score` VALUES (2, 2, 2, 95.00);
INSERT INTO `score` VALUES (3, 3, 3, 75.00);
INSERT INTO `score` VALUES (4, 1, 2, 93.00);
INSERT INTO `score` VALUES (5, 1, 3, 55.00);
INSERT INTO `score` VALUES (6, 2, 1, 59.50);
INSERT INTO `score` VALUES (7, 2, 3, 89.00);
INSERT INTO `score` VALUES (8, 3, 1, 84.00);
INSERT INTO `score` VALUES (9, 3, 2, 99.00);
INSERT INTO `score` VALUES (10, 1, 5, 59.00);
INSERT INTO `score` VALUES (11, 2, 5, 99.00);
INSERT INTO `score` VALUES (12, 3, 5, 88.00);
INSERT INTO `score` VALUES (13, 1, 4, 84.00);
INSERT INTO `score` VALUES (14, 2, 4, 86.00);
INSERT INTO `score` VALUES (15, 3, 4, 85.00);
INSERT INTO `score` VALUES (16, 1, 7, 99.00);


DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `sid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sname` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '学生姓名',
  `gender` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '性别 1男 2女 3保密',
  `class_id` int(11) UNSIGNED NOT NULL COMMENT '所属的班级id',
  PRIMARY KEY (`sid`) USING BTREE,
  INDEX `sname`(`sname`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '学生表' ROW_FORMAT = Dynamic;


INSERT INTO `student` VALUES (1, '学生1', 1, 1);
INSERT INTO `student` VALUES (2, '学生2', 1, 1);
INSERT INTO `student` VALUES (3, '张学生', 1, 2);
INSERT INTO `student` VALUES (4, '张学生', 2, 3);


DROP TABLE IF EXISTS `teach2cls`;
CREATE TABLE `teach2cls`  (
  `tcid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tid` int(11) NOT NULL COMMENT '教师id',
  `cid` int(11) NOT NULL COMMENT '班级id',
  PRIMARY KEY (`tcid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '班级任职表' ROW_FORMAT = Dynamic;


INSERT INTO `teach2cls` VALUES (1, 1, 1);
INSERT INTO `teach2cls` VALUES (2, 2, 2);
INSERT INTO `teach2cls` VALUES (3, 3, 3);
INSERT INTO `teach2cls` VALUES (4, 4, 3);
INSERT INTO `teach2cls` VALUES (5, 1, 2);
INSERT INTO `teach2cls` VALUES (6, 1, 4);
INSERT INTO `teach2cls` VALUES (7, 2, 5);
INSERT INTO `teach2cls` VALUES (8, 2, 6);


DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
  `tid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '教师名',
  PRIMARY KEY (`tid`) USING BTREE,
  INDEX `tname`(`tname`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;


INSERT INTO `teacher` VALUES (4, '张三');
INSERT INTO `teacher` VALUES (2, '李大钊');
INSERT INTO `teacher` VALUES (1, '李淳风');
INSERT INTO `teacher` VALUES (3, '李白');
INSERT INTO `teacher` VALUES (5, '王五');
INSERT INTO `teacher` VALUES (6, '老师6');

