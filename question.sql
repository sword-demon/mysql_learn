# 1. 查询学生总人数
select count(1) as num
from student;

# 2. 查询“生物”课程和“物理”课程成绩都及格的学生id和姓名
SELECT a.student_id,
       a.score,
       b.sname
FROM score AS a
         INNER JOIN student AS b ON a.student_id = b.sid
WHERE a.course_id IN (SELECT cid FROM course WHERE cname LIKE '%生物%' OR cname LIKE '%物理%')
  AND a.score >= 60;

# 4. 查询每个年级的班级数，取出班级数最多的前三个年级
select count(1) as num
from class
group by grade_id
order by num desc
limit 3;

# 5. 查询平均成绩最高和最低的学生的id和姓名以及平均成绩
SELECT s.sid,
       sname,
       t1.avg_score
FROM student as s
         INNER JOIN (
    SELECT student_id,
           avg(score) AS avg_score
    FROM score
    GROUP BY student_id
    HAVING avg(score) IN (
                          (SELECT avg(score) FROM score GROUP BY student_id ORDER BY avg(score) DESC LIMIT 1),# 得到最高成绩
                          (SELECT avg(score) FROM score GROUP BY student_id ORDER BY avg(score) ASC LIMIT 1) # 得到最低成绩

        )
) AS t1 ON s.sid = t1.student_id;

# 6.查询每个年级的学生人数
select g.gname, count(s.sid) as num
from class_grade as g
         left join class as c on c.grade_id = g.gid
         left join student as s on c.cid = s.class_id
GROUP BY g.gid;

# 7.查询每位学生的学号，姓名，选课数，平均成绩
SELECT score.student_id,
       GROUP_CONCAT(score.course_id) AS select_courses,
       count(score.course_id)        AS select_course_num,
       avg(score.score)              AS avg_num,
       student.sname
FROM score
         LEFT JOIN student ON score.student_id = student.sid
GROUP BY student_id;

# 8.查询学生编号为“2”的学生的姓名、该学生成绩最高的课程名、成绩最低的课程名及分数
# 将两个最高和最低的结果集合并
(
    SELECT student.sname,
           score.score,
           course.cname
    FROM score
             LEFT JOIN student ON score.student_id = student.sid
             LEFT JOIN course ON score.course_id = course.cid
    WHERE score.student_id = 2
    ORDER BY score.score DESC
    LIMIT 1
)
UNION
(
    SELECT student.sname,
           score.score,
           course.cname
    FROM score
             LEFT JOIN student ON score.student_id = student.sid
             LEFT JOIN course ON score.course_id = course.cid
    WHERE score.student_id = 2
    ORDER BY score.score ASC
    LIMIT 1
)

# 9.查询姓“李”的老师的个数和所带班级数
SELECT count(t.tid) as teacher_nums,
       count(m.cid) AS class_nums
FROM teacher AS t
         LEFT JOIN teach2cls AS m ON t.tid = m.tid
WHERE t.tname LIKE '李%'

# 10.查询班级数小于5的年级id和年级名
SELECT class_grade.gid,
       class_grade.gname,
       count(1) AS num
FROM class
         LEFT JOIN class_grade ON class.grade_id = class_grade.gid
GROUP BY grade_id
HAVING num < 5

# 11.查询班级信息，包括班级id、班级名称、年级、年级级别(12为低年级，34为中年级，56为高年级)
SELECT c.cid     '班级id',
       c.caption '班级名称',
       g.gname   '年级',
       case
           when g.gid < 3 then '低年级'
           when g.gid < 5 and g.gid > 2 then '中年级'
           else '高年级'
           end  '年级级别'
FROM class AS c
         LEFT JOIN class_grade AS g ON c.grade_id = g.gid

# 12.查询学过“张三”老师2门课以上的同学的学号、姓名
# 1. 获取张三老师的id
select tid
from teacher
where tname = '张三';
# 2. 获取张三老师教的课程id
select cid
from course
where teacher_id = (select tid from teacher where tname = '张三');
# 3.
SELECT student_id,
       (select sname from student where sid = score.student_id) as sname
FROM score
WHERE course_id IN (SELECT cid FROM course WHERE teacher_id = (SELECT tid FROM teacher WHERE tname = '张三'))
GROUP BY student_id
HAVING count(course_id) >= 2;


# 13.查询教授课程超过2门的老师的id和姓名
select tname
from teacher
where tid in (select teacher_id from course GROUP BY teacher_id HAVING count(teacher_id) > 2);

# 14.查询学过编号“1”课程和编号“2”课程的同学的学号、姓名
select sname
from student
where sid in (select distinct student_id from score where course_id in (1, 2));

# 15.查询没有带过高年级的老师id和姓名
# 1. 查询除不是高年级的班级id
select cid
from class
where grade_id < 5;

# 2. 查询出老师id
select tid
from teach2cls
where cid in (select cid from class where grade_id < 5);

# 3. 根据老师id查姓名
select tid, tname
from teacher
where tid in (select tid from teach2cls where cid in (select cid from class where grade_id < 5));

# 16.查询学过“张三”老师所教的所有课的同学的学号、姓名
select sid, sname
from student
where sid in (select distinct student_id
              from score
              where course_id in
                    (select cid from course where teacher_id in (select tid from teacher where tname = '张三')));


# 17.查询带过超过2个班级的老师的id和姓名
select tid, tname
from teacher
where tid in (select tid from teach2cls GROUP BY tid HAVING count(tid) > 2);

# 18.查询课程编号“2”的成绩比课程编号“1”课程低的所有同学的学号、姓名
SELECT a.student_id
FROM score a,
     score b
WHERE a.student_id = b.student_id
  AND a.course_id = 2
  AND b.course_id = 1
  AND a.score < b.score;

# 19.查询所带班级数最多的老师id和姓名
select a.tid, max(a.num) as num, t.tname
from (select tid, count(cid) as num from teach2cls group by tid) as a
         left join teacher as t on a.tid = t.tid;

# 20.查询有课程成绩小于60分的同学的学号、姓名
select sid, sname
from student
where sid in (select distinct student_id from score where score < 60);

# 21.查询没有学全所有课的同学的学号、姓名
# 先查询总课程数,然后对比每个学生的学的课程数,小于总的就代表没学全
SELECT stu.sid,
       stu.sname
FROM student as stu,
     (SELECT COUNT(cid) AS num FROM course) AS t1,
     (SELECT student_id, COUNT(course_id) AS num FROM score GROUP BY student_id) AS t2
WHERE t1.num > t2.num
  AND t2.student_id = stu.sid;

# 22.查询至少有一门课与学号为“1”的同学所学相同的同学的学号和姓名
SELECT a.sid, a.sname
FROM student as a
         INNER JOIN
     (
         SELECT distinct student_id
         FROM score
         WHERE course_id in
               (
                   SELECT course_id
                   FROM score
                   WHERE student_id = 1
               )
           AND student_id != 1
     ) AS b
     on a.sid = b.student_id;

# 23.查询至少学过学号为“1”同学所选课程中任意一门课的其他同学学号和姓名
select sid, sname
from student
where sid in (select distinct student_id
              from score
              where course_id in (select course_id from score where student_id = 1)
                and student_id != 1);

# 24.查询和“2”号同学学习的课程完全相同的其他同学的学号和姓名
select sid, sname
from student
where sid in (select DISTINCT s2.student_id
              from score as s1
                       inner join score as s2 on s1.course_id = s2.course_id
              where s1.student_id = 2
                and s2.student_id != 2);

# 25.删除学习“张三”老师课的score表记录
delete
from score
where course_id in
      (select cid from course where teacher_id = (select tid from teacher where tname = '张三'));


# 26.向score表中插入一些记录，这些记录要求符合以下条件：①没有上过编号“2”课程的同学学号；②插入“2”号课程的平均成绩
# 查询没有上过编号2课程的同学的id
select sid
from student as a
         left join (select student_id from score where course_id = 2) as b
                   on a.sid = b.student_id
where b.student_id is null;
# 将查询出来的学生id插入score表
insert into score (student_id, course_id, score)
select 4 as student_id, 2 as course_id, AVG(score) as score
from score
where course_id = 2;

# 27.按平均成绩从低到高显示所有学生的“语文”、“数学”、“英语”三门的课程成绩，按如下形式显示： 学生ID,语文,数学,英语,课程数和平均分
# 1. 查询三门课的id
select cid
from course
where cname in ('语文', '数学', '英语');

# 2. 查询每个学生的三门课的平均分
select student_id, AVG(score) as avg_score
from score
where course_id in (select cid from course where cname in ('语文', '数学', '英语'))
group by student_id;

# 最终结果
select b.student_id                                           '学生ID',
       max(case when b.course_id = 1 then b.score else 0 end) '语文',
       max(case when b.course_id = 2 then b.score else 0 end) '数学',
       max(case when b.course_id = 3 then b.score else 0 end) '英语',
       avg(b.score)                                           '平均分'
from (
         select student_id, course_id, score, AVG(score) as avg_score
         from score
         where course_id in (select cid from course where cname in ('语文', '数学', '英语'))
         group by student_id, course_id) as b
group by student_id;


# 28.查询各科成绩最高和最低的分：以如下形式显示：课程ID，最高分，最低分
select course_id, max(score), min(score)
from score
where course_id in (select cid from course)
group by course_id;


# 29.按各科平均成绩从低到高和及格率的百分数从高到低顺序
SELECT course_id                                                                  AS 课程id,
       avg(score)                                                                 AS 平均成绩,
       concat(100 * sum(CASE WHEN score >= 60 THEN 1 ELSE 0 END) / count(1), '%') AS 及格率
FROM score
GROUP BY course_id
ORDER BY avg(score),
         100 * sum(CASE WHEN score >= 60 THEN 1 ELSE 0 END) / count(1) DESC;


# 30.课程平均分从高到低显示（现实任课老师）
select s.course_id, avg(s.score), t.tname as avg_score
from score as s
         inner join course as c on s.course_id = c.cid
         left join teacher as t on c.teacher_id = t.tid
group by s.course_id
order by avg(s.score) desc;

# 31.查询各科成绩前三名的记录(不考虑成绩并列情况)
SELECT sc1.`student_id`,
       sc1.`course_id`,
       sc1.`score`,
       (SELECT COUNT(*)
        FROM score sc3
        WHERE sc3.`course_id` = sc1.`course_id`
          AND sc3.`score` > sc1.`score`
       ) + 1 as rank
FROM
    score as sc1
    LEFT JOIN
    score as sc2
ON
    sc1.`course_id` = sc2.`course_id`
    AND sc1.`score` < sc2.`score`
GROUP BY
    sc1.`course_id`,
    sc1.`student_id`,
    sc1.`score`
HAVING
    COUNT (sc2.`student_id`) <= 2;

# 32.查询每门课程被选修的学生数
select student_id, course_id, count(student_id) as num
from score
group by course_id;

# 33.查询选修了2门以上课程的全部学生的学号和姓名
select sid, sname
from student
where sid in (select student_id from score group by student_id HAVING count(course_id) >= 2);

# 34.查询男生、女生的人数，按倒序排列
# 查询男生、女生的人数，按倒序排列
select (case when gender = 1 then '男' else '女' end) '性别',
       count(gender) as                             '人数'
from student
group by gender
order by count(gender) desc;

# 35.查询姓“张”的学生名单
select *
from student
where sname like '张%';

# 36.查询同名同姓学生名单，并统计同名人数
select sname, count(sname) as num
from student
group by sname
HAVING count(sname) > 1;

# 37.查询每门课程的平均成绩，结果按平均成绩升序排列，平均成绩相同时，按课程号降序排列
select avg(score)
from score
group by course_id
order by avg(score) asc, course_id desc;

# 38.查询课程名称为“数学”，且分数低于60的学生姓名和分数
SELECT stu.sname,
       s.score
FROM score as s
         left join student as stu on s.student_id = stu.sid
WHERE course_id = (SELECT cid FROM course WHERE cname = '数学')
  AND score < 60;

# 39.查询课程编号为“3”且课程成绩在80分以上的学生的学号和姓名
SELECT s.student_id,
       stu.sname
FROM score as s
         left join student as stu on s.student_id = stu.sid
WHERE s.score >= 80
  AND s.course_id = 3;

# 40.求选修了课程的学生人数
select count(distinct sid)
from student
where sid in (select distinct student_id from score);

# 41.查询选修“王五”老师所授课程的学生中，成绩最高和最低的学生姓名及其成绩
(
    SELECT stu.sname,
           s.student_id,
           s.score
    FROM score as s
             left join student as stu on s.student_id = stu.sid
    WHERE s.course_id = (SELECT cid FROM course WHERE teacher_id = (SELECT tid FROM teacher WHERE tname = '王五'))
    ORDER BY s.score DESC
    LIMIT 1)
union
(
    SELECT stu.sname,
           s.student_id,
           s.score
    FROM score as s
             left join student as stu on s.student_id = stu.sid
    WHERE s.course_id = (SELECT cid FROM course WHERE teacher_id = (SELECT tid FROM teacher WHERE tname = '王五'))
    ORDER BY s.score asc
    LIMIT 1
);

# 42.查询各个课程及相应的选修人数
select count(student_id) as num, course_id
from score
group by course_id;

# 43.查询不同课程但成绩相同的学生的学号、课程号、学生成绩
select *
from score a
where exists(select 1 from score where course_id <> a.course_id and score = a.score)

# 44.查询每门课程成绩最好的前两名学生id和姓名
SELECT student_id,
       stu.sname
FROM score
         left join student as stu on score.student_id = stu.sid
WHERE (SELECT count(1) FROM score AS sc WHERE score.course_id = sc.course_id AND score.score < sc.score) < 2
ORDER BY course_id,
         score DESC;

# 45.检索至少选修两门课程的学生学号
select student_id
from score
group by student_id
HAVING count(course_id) >= 2;

# 46、查询没有学生选修的课程的课程号和课程名
select c.*
from course as c
         left join score as s on c.cid = s.course_id
where s.student_id is null;

# 47、查询没带过任何班级的老师id和姓名
select t.*
from teacher as t
         left join teach2cls as tc on t.tid = tc.tid
where tc.cid is null;

# 48、查询有两门以上课程超过80分的学生id及其平均成绩
select student_id, avg(score) as avg_score
from score
where score > 80
group by student_id
HAVING count(course_id) >= 2;

# 49、检索“3”课程分数小于60，按分数降序排列的同学学号
select student_id
from score
where score < 60
  and course_id = 3
order by score desc;

# 50、删除编号为“2”的同学的“1”课程的成绩
delete
from score
where student_id = 2
  and course_id = 1;

# 51、查询同时选修了物理课和生物课的学生id和姓名
select sid, sname
from student
where sid in (select student_id from score where course_id in (select cid from course where cname in ('生物', '物理')));
