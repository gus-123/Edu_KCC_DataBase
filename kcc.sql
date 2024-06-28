--jsp용
CREATE TABLE board(
    seq NUMBER,
    title VARCHAR2(50),
    writer VARCHAR2(50),
    contents VARCHAR2(200),
    regdate DATE,
    hitcount NUMBER
)

INSERT INTO board VALUES(1, 'a1', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(2, 'a2', 'a', 'a', sysdate, 1);
INSERT INTO board VALUES(3, 'a3', 'a', 'a', sysdate, 2);
INSERT INTO board VALUES(4, 'a4', 'a', 'a', sysdate, 3);
INSERT INTO board VALUES(5, 'a5', 'a', 'a', sysdate, 4);
INSERT INTO board VALUES(6, 'a6', 'a', 'a', sysdate, 5);
INSERT INTO board VALUES(7, 'a7', 'a', 'a', sysdate, 6);
INSERT INTO board VALUES(8, 'a8', 'a', 'a', sysdate, 7);
INSERT INTO board VALUES(9, 'a9', 'a', 'a', sysdate, 8);
INSERT INTO board VALUES(10, 'a10', 'a', 'a', sysdate, 9);


--<mission kcc>
--1. 각 학생의 평점을 검색하라(학번, 이름 , 학점) : student -> 별칭 사용
SELECT
    sno   AS 학번,
    sname AS 이름,
    avr   "학점"
FROM
    student;
--2. 각 과목의 학점수를 검색하라(과목번호, 과목명, 학점수) : course -> 별칭 사용
SELECT
    cno    AS 과목번호,
    cname  AS 과목명,
    st_num AS 학점수
FROM
    course;
--3. 각 교수의 직위를 검색하라.(교수번호, 교수이름, 직위): professor -> 별칭 사용
SELECT
    pno    AS 교수번호,
    pname  AS 교수이름,
    orders AS 직위
FROM
    professor;
--4. 급여를 10% 인상했을 때 각 직원마다 연간 지급되는 급여를 검색하라. : emp
SELECT
    eno             AS 사번,
    ename           AS 이름,
    sal + sal * 0.9 AS 연봉
FROM
    emp;
--5. 현재 학생의 평점은 4.0 만점이다. 이를 4.5 만점으로 환산해서 검색하라.:student
SELECT
    sno             AS 학번,
    sname           AS 이름,
    avr * 4.5 / 4.0 "환산학점"
FROM
    student;

SELECT
    *
FROM
    emp;

SELECT
    eno,
    ename,
    sal
FROM
    emp
ORDER BY
    sal DESC;

--각 학과명로 교수의 정보를 부임 일자 순으로 검색하자.
SELECT
    section  AS 소속학과,
    orders   AS 교수,
    hiredate AS 부임일
FROM
    professor
ORDER BY
    section,
    hiredate;

--1. 2,3학년 학생 중에서 학점이 2.0에서 3.0 사이의 학생을 검색하라.
SELECT
    sno,
    sname,
    syear
FROM
    student
WHERE
        syear >= 2
    AND syear <= 3
    AND 2.0 <= avr
    AND avr <= 3.0;
--2. 화학, 물리학과 학생중에 1,2 학년 학생을 성적 순으로 검색하라.
SELECT
    sno,
    sname,
    syear
FROM
    student
WHERE
        syear >= 1
    AND syear <= 2
    AND major IN ( '화학', '물리' )
ORDER BY
    avr;
--3. 화학과 정교수를 검새하라.
SELECT
    pno,
    section,
    orders,
    pname
FROM
    professor
WHERE
        orders = '정교수'
    AND section = '화학';

--select * from hr.employees;
--1. 화학과 학생 중에 성이 '관'씨인 학생을 검색하라
SELECT
    *
FROM
    student
WHERE
    major LIKE '화학'
    AND sname LIKE '관%';
--2. 부임일이 1995년 이전의 정교수를 검색하라.
SELECT
    *
FROM
    professor
WHERE
        hirdate < '1995/1/1'
    AND orders = '정교수';
--3. 성과 이름이 각각 1글자인 교수를 검색하라.(이름이 2글자)
SELECT
    *
FROM
    professor
WHERE
    pname LIKE '__';
--4. 화학과 학생 중에 4.5 환산 학전밍 3.5 이상인 학생을 검색하라.
SELECT
    sno             AS 학번,
    sname           AS 이름,
    sex             AS 성별,
    syear           AS 학년,
    major           AS 학과,
    avr * 4.5 / 4.0 "환산학점"
FROM
    student
WHERE
        avr * 4.5 / 4.0 >= 3.5
    AND major = '화학';
--5. 화학과 이외 학과 학생의 평점을 각 학과별 그리고 학년 별 순서로 출력하라.
SELECT
    *
FROM
    student
WHERE
    major <> '화학'
ORDER BY
    major,
    syear;

--SELECT eno,ename,dno FROM emp WHERE dno = 10
--UNION
--SELECT eno,ename,dno FROM emp WHERE dno = 20

--집합연산자를 이용하여 emp 테이블의 내용 중 10번 부서번호의 사원들은 제외한 내용을 출력하라.
--SELECT eno,ename,dno FROM emp 
--MINUS
--SELECT eno,ename,dno FROM emp WHERE dno = 10 

-- 1. emp 테이블을 사용하여 20번, 30번 부서에 근무하고 있는 사원 중 급여가 2000 초과인 사원을 다음 두가지 방식의 select문을 사용하여 사원번호, 급여 , 부서번호를 출력하라.
--1) 집합 연산자를 사용하지 않은 방식
SELECT
    eno,
    ename,
    dno
FROM
    emp
WHERE
    dno IN ( 20, 30 )
    AND sal > 2000;
--2) 집합 연산자를 사용한 방식
SELECT
    eno,
    ename,
    dno
FROM
    emp
WHERE
    dno IN ( 20, 30 )
INTERSECT
SELECT
    eno,
    ename,
    dno
FROM
    emp
WHERE
    sal > 2000;

--1. 화학과 학년별 평균 학점을 검색하라
SELECT
    syear,
    major,
    AVG(avr)
FROM
    student
WHERE
    major = '화학'
GROUP BY
    major,
    syear;
--2.각 학과별 학생수를 검색하라.
SELECT
    major        AS 학과,
    COUNT(major) AS 학생수
FROM
    student
GROUP BY
    major;
--3. 화학과 생물학과 학생을 4.5 환산 학점의 평균을 각각 검색하라
SELECT
    major,
    AVG(avr * 4.5 / 4.0)
FROM
    student
WHERE
    major IN ( '화학', '생물' )
GROUP BY
    major;

SELECT
    *
FROM
    student;

--1. 화학과를 제외한 학생들의 과별 평점평균을 검색하라.
SELECT
    major,
    round(AVG(avr), 2)
FROM
    student
GROUP BY
    major
HAVING
    major != '화학';
--2. 화학과를 제외한 각 학과별 평점 중에 평점이 2.0이상 학과정보를 검색하라.
SELECT
    major,
    round(AVG(avr), 2)
FROM
    student
GROUP BY
    major
HAVING major != '화학'
       AND AVG(avr) > 2.0;
--3. 근무중인 직원 3명 이상인 부서를 검색하라.(emp)
SELECT
    dno,
    COUNT(*)
FROM
    emp
GROUP BY
    dno
HAVING
    COUNT(*) >= 3;

--2일차 수업

SELECT
    cname,
    length(substr(cname, 1, 3))
FROM
    course
WHERE
    cname = substr(cname, 1, 3);

SELECT
    cname,
    substr(cname, 1, length(cname - 1))
FROM
    course;

SELECT
    'Oracle',
    lpad('Oracle', 10, '#')
FROM
    dual;

--3일차 수업
-- 제약 조건 과제1
CREATE TABLE member (
    id      VARCHAR2(20),
    name    VARCHAR2(20),
    regno   VARCHAR2(13),
    hp      VARCHAR2(13),
    address VARCHAR2(100)
)

--ALTER TABLE MEMBER 
--  ADD CONSTRAINT member_id_pk PRIMARY KEY (id),
--  ADD CONSTRAINT rengo_hp_uq UNIQUE (regno, hp), 
--  ALTER COLUMN name SET NOT NULL,
--  ALTER COLUMN address SET NOT NULL;

ALTER TABLE member ADD CONSTRAINT member_id_pk PRIMARY KEY ( id );

ALTER TABLE member ADD CONSTRAINT rengo_hp_uq UNIQUE ( regno,
                                                       hp );

ALTER TABLE member MODIFY
    name
        CONSTRAINT name_nn NOT NULL;

ALTER TABLE member MODIFY
    address
        CONSTRAINT address_nn NOT NULL;

CREATE TABLE book (
    code    NUMBER(4),
    title   VARCHAR2(50),
    count   NUMBER(6),
    price   NUMBER(10),
    publish VARCHAR2(50)
)

ALTER TABLE book ADD CONSTRAINT book_code_pk PRIMARY KEY ( code );

ALTER TABLE book MODIFY
    title
        CONSTRAINT title_nn NOT NULL;

CREATE TABLE order2 (
    no      VARCHAR2(10),
    id      VARCHAR2(20),
    code    NUMBER(4),
    count   NUMBER(6),
    dr_date DATE
)

ALTER TABLE order2 ADD CONSTRAINT order2_no_pk PRIMARY KEY ( no );

ALTER TABLE order2
    ADD CONSTRAINT order2_id_fk FOREIGN KEY ( id )
        REFERENCES member ( id );

ALTER TABLE order2 MODIFY
    id
        CONSTRAINT id_nn NOT NULL;

ALTER TABLE order2
    ADD CONSTRAINT order2_code_fk FOREIGN KEY ( code )
        REFERENCES book ( code );

ALTER TABLE order2 MODIFY
    code
        CONSTRAINT code_nn NOT NULL;

-- 제약 조건 과제2
CREATE TABLE dept_const (
    deptno NUMBER(2),
    dname  CHAR(14),
    loc    CHAR(13)
)

ALTER TABLE dept_const ADD CONSTRAINT dept_const_deptno_pk PRIMARY KEY ( deptno );

ALTER TABLE dept_const ADD CONSTRAINT dept_const_dname_uq UNIQUE ( dname );

ALTER TABLE dept_const MODIFY
    loc
        CONSTRAINT loc_nn NOT NULL;

CREATE TABLE emp_const (
    empno    NUMBER(4),
    ename    VARCHAR2(10),
    job      VARCHAR2(9),
    tel      VARCHAR2(20),
    hiredate DATE,
    sal      NUMBER(7),
    comm     NUMBER(7),
    deptno   NUMBER(2)
)

ALTER TABLE emp_const ADD CONSTRAINT emp_const_empno_pk PRIMARY KEY ( empno );

ALTER TABLE emp_const MODIFY
    ename
        CONSTRAINT ename_nn NOT NULL;

ALTER TABLE emp_const ADD CONSTRAINT emp_const_tel_uq UNIQUE ( tel );

ALTER TABLE emp_const
    ADD CONSTRAINT emp_const_sal_ck CHECK ( sal between 1000 and 9999 );

ALTER TABLE emp_const
    ADD CONSTRAINT emp_const_deptno_fk FOREIGN KEY ( deptno )
        REFERENCES dept_const ( deptno );
        
insert into emp_const values (1,'오리', '고니', '010-1234-1234', '1997-12-31', 1000, 12,12);

delete from emp_const WHERE deptno = 12;

select * from emp_const where 1=1;

--'송강' 교수가 강의하는 과목을 검색하라.
select p.pno, c.pno, p.pname, c.cname
from professor p, course c
where c.pno = p.pno and pname = '송강';

--학점이 2학점인 과목과 이를 강의하는 교수를 검색하라.
select c.st_num, c.cname, c.pno, p.pname
from professor p, course c
where c.pno=p.pno and st_num = 2;
--화학과 1학년 학생의 기말고사 성적을 검색하라.
select  s.sno,s.syear,s.major, c.result
from student s, score c
where s.sno =c.sno and syear =1;
-------------------------------------------------
select  s.sno,s.syear,s.major, c.result
from student s
join score c
on s.sno =c.sno and syear =1;
-- 화학과 1학년 학생이 수강하는 과목을 검색하라.(3개 테이블 조인)
select  syear, major, cname
from student s, score t, course c
where s.sno = t.sno and t.cno = c.cno and syear =1 and major like '%화학%';

--학생 중에 동명이인을 검색하라. => distinct
select distinct a.sno,  a.sname "동명이인"
from student a, student b
where a.sname = b.sname and a.sno<>b.sno;

--등록된 과목에 대한 모든 교수를 검색하라. => 등록하지 않은 교수도 출력
select * from professor;

select c.cno, c.cname, p.pname, c.st_num
from course c, professor p
where c.pno = p.pno;

select c.cno, c.cname, p.pname, c.st_num
from course c, professor p
where c.pno(+) = p.pno;

select c.cno, c.cname, p.pname, c.st_num
from course c right join professor p
on c.pno = p.pno;

select c.cno, c.cname, p.pname, c.st_num
from course c full join professor p
on c.pno = p.pno;
-- 비등가 조인
select s.sname, c.cname, s1.result, sc.grade
from student s, score s1, course c, scgrade sc
where s.sno = s1.sno and s1.cno = c.cno;

--4일차 수업
--1.'정의찬'과 부서가 다르지만 동일한 업무을 수행하는 사원 목록을출력하라.
select d.dname
from emp e, dept d
where e.dno = d.dno and ename = '정의찬';

select e.eno, e.dno, e.ename
from emp e,dept d
where e.dno = d.dno and d.dname != (select d.dname
from emp e, dept d
where e.dno = d.dno and ename = '정의찬');

--교수님
select eno,ename,dno, job
from emp
where dno != (select dno from emp where ename = '정의찬')
and job = (select job from emp where ename = '정의찬');
--2. '관우'보다 일반화학과목의 학점이 낮은 학생의 명단을 출력하라.
select g.grade
from student s, course c, score s1, scgrade g
where s.sno = s1.sno and s1.cno = c.cno and c.cname = '일반화학' and s.sname='관우' and result between loscore and hiscore;

select s1.cno, sname,g.grade
from student s, course c, score s1, scgrade g
where s.sno = s1.sno and s1.cno = c.cno and c.cname = '일반화학' and  result between loscore and hiscore and grade >
(select g.grade
from student s, course c, score s1, scgrade g
where s.sno = s1.sno and s1.cno = c.cno and c.cname = '일반화학' and s.sname='관우' and result between loscore and hiscore);

select dno from emp group by dno
having avg(sal) = (select max(avg(sal)) from emp group by dno);

--학생 인원수가 가장 많은 학과를 출력하라.
select max(count(major)) from student group by major;

select major from student group by major
having count(major) = (select max(count(major)) from student group by major);

--학생 중 기말고사 평균성적이 가장 낮은 학생의 정보를 검색하라.
select min(avg(result)) from student s, score s1
group by sname;

SELECT s.sno, s.sname
FROM student s
INNER JOIN score s1 ON s.sno = s1.sno
GROUP BY s.sno, s.sname
HAVING AVG(s1.result) < (SELECT MIN(AVG(result)) FROM student s, score s1
                          GROUP BY sname);
-- 교수님
select s.sno, sname
from student s, score r
where s.sno = r.sno
group by s.sno, sname
having avg(result) = (select min(avg(result)) from score group by sno);
                          
--화학과 1학년 학생중에 평점이 평균이하인 학생을 검색하라.
select avg(avr) from student where syear = 1 and major = '화학';

select sname, avr from student
group by avr, sname
having avg(avr) < (select avg(avr) from student where syear = 1 and major = '화학');

--교수님
select * from student
where major = '화학' and syear = 1 and avr < (select avg(avr) from student where syear = 1 and major = '화학');

select eno, ename, sal, dno
from emp
where sal < (select min(sal) from emp where dno = 10);

select eno, ename, sal, dno
from emp
where sal < all(select sal from emp where dno = 10);

-- all any
select dno  from emp where dno = 30;

select * from emp
where sal > all(select dno  from emp where dno = 30);

select * from emp
where sal > (select max(dno) from emp where dno =30);

--2
select * from emp
where sal < any(select dno  from emp where dno = 30);

select * from emp
where sal < (select max(dno)  from emp where dno = 30);

--
select mgr, job from emp where 
ename = '손하늘';

select eno, ename, mgr, job
from emp
where (mgr, job) in (select mgr, job from emp where 
ename = '손하늘');
---
select avr, major from student where major = '화학';

select * from student
where avr in (select avr from student where major = '화학')and major != '화학';
----
select * from student
where (avr,syear) in (select avr, syear from student where major = '화학') and major != '화학';
-- 
SELECT AVG(result) FROM course c, score s WHERE c.cno = s.cno and c.cname = '핵화학';

select c.cno, c.cname, c.pno, p.pname
from course c
inner join professor p
on c.pno = p.pno
inner join score s
on c.cno = s.cno
group by c.cno, c.cname, c.pno, p.pname
having avg(s.result) > (SELECT AVG(result) FROM course c, score s WHERE c.cno = s.cno and c.cname = '핵화학');

--교수
select c.cno, c.cname, p.pname, avg(result)
from score r, professor p, course c
where r.cno=c.cno
and p.pno = c.pno
group by c.cno, c.cname, p.pname
having  avg(result) > ( select avg(result) from score where cno = (select cno from course where cname = '핵화학'));

-- 페이징 처리에 쓰임
select * from (
    select rownum as row_num, alias.*
    from (select * from board order by seq desc) alias
    )
    where row_num between 6 and 10;  --=> 이거 수식만 변경됨.

--오라클 인덱스 생성    
CREATE SEQUENCE board_seq;
INSERT INTO board values(board_seq.NEXTVAL,'a1', 'a', 'a', sysdate, 0);

INSERT INTO board(seq, title, writer, contents, regdate, hitcount)
(select board_seq.nextval, title, writer, contents, regdate, hitcount from board);

select * from board where seq = 9999;

ALTER TABLE board ADD CONSTRAINT board_seq_pk PRIMARY KEY(seq);

--ex) board 테이블 'title' 컬럼에 대한 글번호(seq) 100000번에 대해서 'title' 값을 'a100000' 수정하고 'a100000' 검색 후 실행 계획을 확인 => full scan
--      인덱스 생성하고 다시 검색 후 => index scan

select * from board;

update board set title = 'a256' where seq =256;

select seq from board where seq = 256;
select seq from board where title = 'a256';

create index board_title_idx on board(title);
