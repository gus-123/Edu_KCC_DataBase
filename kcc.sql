--jsp��
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
--1. �� �л��� ������ �˻��϶�(�й�, �̸� , ����) : student -> ��Ī ���
SELECT
    sno   AS �й�,
    sname AS �̸�,
    avr   "����"
FROM
    student;
--2. �� ������ �������� �˻��϶�(�����ȣ, �����, ������) : course -> ��Ī ���
SELECT
    cno    AS �����ȣ,
    cname  AS �����,
    st_num AS ������
FROM
    course;
--3. �� ������ ������ �˻��϶�.(������ȣ, �����̸�, ����): professor -> ��Ī ���
SELECT
    pno    AS ������ȣ,
    pname  AS �����̸�,
    orders AS ����
FROM
    professor;
--4. �޿��� 10% �λ����� �� �� �������� ���� ���޵Ǵ� �޿��� �˻��϶�. : emp
SELECT
    eno             AS ���,
    ename           AS �̸�,
    sal + sal * 0.9 AS ����
FROM
    emp;
--5. ���� �л��� ������ 4.0 �����̴�. �̸� 4.5 �������� ȯ���ؼ� �˻��϶�.:student
SELECT
    sno             AS �й�,
    sname           AS �̸�,
    avr * 4.5 / 4.0 "ȯ������"
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

--�� �а���� ������ ������ ���� ���� ������ �˻�����.
SELECT
    section  AS �Ҽ��а�,
    orders   AS ����,
    hiredate AS ������
FROM
    professor
ORDER BY
    section,
    hiredate;

--1. 2,3�г� �л� �߿��� ������ 2.0���� 3.0 ������ �л��� �˻��϶�.
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
--2. ȭ��, �����а� �л��߿� 1,2 �г� �л��� ���� ������ �˻��϶�.
SELECT
    sno,
    sname,
    syear
FROM
    student
WHERE
        syear >= 1
    AND syear <= 2
    AND major IN ( 'ȭ��', '����' )
ORDER BY
    avr;
--3. ȭ�а� �������� �˻��϶�.
SELECT
    pno,
    section,
    orders,
    pname
FROM
    professor
WHERE
        orders = '������'
    AND section = 'ȭ��';

--select * from hr.employees;
--1. ȭ�а� �л� �߿� ���� '��'���� �л��� �˻��϶�
SELECT
    *
FROM
    student
WHERE
    major LIKE 'ȭ��'
    AND sname LIKE '��%';
--2. �������� 1995�� ������ �������� �˻��϶�.
SELECT
    *
FROM
    professor
WHERE
        hirdate < '1995/1/1'
    AND orders = '������';
--3. ���� �̸��� ���� 1������ ������ �˻��϶�.(�̸��� 2����)
SELECT
    *
FROM
    professor
WHERE
    pname LIKE '__';
--4. ȭ�а� �л� �߿� 4.5 ȯ�� ������ 3.5 �̻��� �л��� �˻��϶�.
SELECT
    sno             AS �й�,
    sname           AS �̸�,
    sex             AS ����,
    syear           AS �г�,
    major           AS �а�,
    avr * 4.5 / 4.0 "ȯ������"
FROM
    student
WHERE
        avr * 4.5 / 4.0 >= 3.5
    AND major = 'ȭ��';
--5. ȭ�а� �̿� �а� �л��� ������ �� �а��� �׸��� �г� �� ������ ����϶�.
SELECT
    *
FROM
    student
WHERE
    major <> 'ȭ��'
ORDER BY
    major,
    syear;

--SELECT eno,ename,dno FROM emp WHERE dno = 10
--UNION
--SELECT eno,ename,dno FROM emp WHERE dno = 20

--���տ����ڸ� �̿��Ͽ� emp ���̺��� ���� �� 10�� �μ���ȣ�� ������� ������ ������ ����϶�.
--SELECT eno,ename,dno FROM emp 
--MINUS
--SELECT eno,ename,dno FROM emp WHERE dno = 10 

-- 1. emp ���̺��� ����Ͽ� 20��, 30�� �μ��� �ٹ��ϰ� �ִ� ��� �� �޿��� 2000 �ʰ��� ����� ���� �ΰ��� ����� select���� ����Ͽ� �����ȣ, �޿� , �μ���ȣ�� ����϶�.
--1) ���� �����ڸ� ������� ���� ���
SELECT
    eno,
    ename,
    dno
FROM
    emp
WHERE
    dno IN ( 20, 30 )
    AND sal > 2000;
--2) ���� �����ڸ� ����� ���
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

--1. ȭ�а� �г⺰ ��� ������ �˻��϶�
SELECT
    syear,
    major,
    AVG(avr)
FROM
    student
WHERE
    major = 'ȭ��'
GROUP BY
    major,
    syear;
--2.�� �а��� �л����� �˻��϶�.
SELECT
    major        AS �а�,
    COUNT(major) AS �л���
FROM
    student
GROUP BY
    major;
--3. ȭ�а� �����а� �л��� 4.5 ȯ�� ������ ����� ���� �˻��϶�
SELECT
    major,
    AVG(avr * 4.5 / 4.0)
FROM
    student
WHERE
    major IN ( 'ȭ��', '����' )
GROUP BY
    major;

SELECT
    *
FROM
    student;

--1. ȭ�а��� ������ �л����� ���� ��������� �˻��϶�.
SELECT
    major,
    round(AVG(avr), 2)
FROM
    student
GROUP BY
    major
HAVING
    major != 'ȭ��';
--2. ȭ�а��� ������ �� �а��� ���� �߿� ������ 2.0�̻� �а������� �˻��϶�.
SELECT
    major,
    round(AVG(avr), 2)
FROM
    student
GROUP BY
    major
HAVING major != 'ȭ��'
       AND AVG(avr) > 2.0;
--3. �ٹ����� ���� 3�� �̻��� �μ��� �˻��϶�.(emp)
SELECT
    dno,
    COUNT(*)
FROM
    emp
GROUP BY
    dno
HAVING
    COUNT(*) >= 3;

--2���� ����

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

--3���� ����
-- ���� ���� ����1
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

-- ���� ���� ����2
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
        
insert into emp_const values (1,'����', '���', '010-1234-1234', '1997-12-31', 1000, 12,12);

delete from emp_const WHERE deptno = 12;

select * from emp_const where 1=1;

--'�۰�' ������ �����ϴ� ������ �˻��϶�.
select p.pno, c.pno, p.pname, c.cname
from professor p, course c
where c.pno = p.pno and pname = '�۰�';

--������ 2������ ����� �̸� �����ϴ� ������ �˻��϶�.
select c.st_num, c.cname, c.pno, p.pname
from professor p, course c
where c.pno=p.pno and st_num = 2;
--ȭ�а� 1�г� �л��� �⸻��� ������ �˻��϶�.
select  s.sno,s.syear,s.major, c.result
from student s, score c
where s.sno =c.sno and syear =1;
-------------------------------------------------
select  s.sno,s.syear,s.major, c.result
from student s
join score c
on s.sno =c.sno and syear =1;
-- ȭ�а� 1�г� �л��� �����ϴ� ������ �˻��϶�.(3�� ���̺� ����)
select  syear, major, cname
from student s, score t, course c
where s.sno = t.sno and t.cno = c.cno and syear =1 and major like '%ȭ��%';

--�л� �߿� ���������� �˻��϶�. => distinct
select distinct a.sno,  a.sname "��������"
from student a, student b
where a.sname = b.sname and a.sno<>b.sno;

--��ϵ� ���� ���� ��� ������ �˻��϶�. => ������� ���� ������ ���
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
-- �� ����
select s.sname, c.cname, s1.result, sc.grade
from student s, score s1, course c, scgrade sc
where s.sno = s1.sno and s1.cno = c.cno;

--4���� ����
--1.'������'�� �μ��� �ٸ����� ������ ������ �����ϴ� ��� ���������϶�.
select d.dname
from emp e, dept d
where e.dno = d.dno and ename = '������';

select e.eno, e.dno, e.ename
from emp e,dept d
where e.dno = d.dno and d.dname != (select d.dname
from emp e, dept d
where e.dno = d.dno and ename = '������');

--������
select eno,ename,dno, job
from emp
where dno != (select dno from emp where ename = '������')
and job = (select job from emp where ename = '������');
--2. '����'���� �Ϲ�ȭ�а����� ������ ���� �л��� ����� ����϶�.
select g.grade
from student s, course c, score s1, scgrade g
where s.sno = s1.sno and s1.cno = c.cno and c.cname = '�Ϲ�ȭ��' and s.sname='����' and result between loscore and hiscore;

select s1.cno, sname,g.grade
from student s, course c, score s1, scgrade g
where s.sno = s1.sno and s1.cno = c.cno and c.cname = '�Ϲ�ȭ��' and  result between loscore and hiscore and grade >
(select g.grade
from student s, course c, score s1, scgrade g
where s.sno = s1.sno and s1.cno = c.cno and c.cname = '�Ϲ�ȭ��' and s.sname='����' and result between loscore and hiscore);

select dno from emp group by dno
having avg(sal) = (select max(avg(sal)) from emp group by dno);

--�л� �ο����� ���� ���� �а��� ����϶�.
select max(count(major)) from student group by major;

select major from student group by major
having count(major) = (select max(count(major)) from student group by major);

--�л� �� �⸻��� ��ռ����� ���� ���� �л��� ������ �˻��϶�.
select min(avg(result)) from student s, score s1
group by sname;

SELECT s.sno, s.sname
FROM student s
INNER JOIN score s1 ON s.sno = s1.sno
GROUP BY s.sno, s.sname
HAVING AVG(s1.result) < (SELECT MIN(AVG(result)) FROM student s, score s1
                          GROUP BY sname);
-- ������
select s.sno, sname
from student s, score r
where s.sno = r.sno
group by s.sno, sname
having avg(result) = (select min(avg(result)) from score group by sno);
                          
--ȭ�а� 1�г� �л��߿� ������ ��������� �л��� �˻��϶�.
select avg(avr) from student where syear = 1 and major = 'ȭ��';

select sname, avr from student
group by avr, sname
having avg(avr) < (select avg(avr) from student where syear = 1 and major = 'ȭ��');

--������
select * from student
where major = 'ȭ��' and syear = 1 and avr < (select avg(avr) from student where syear = 1 and major = 'ȭ��');

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
ename = '���ϴ�';

select eno, ename, mgr, job
from emp
where (mgr, job) in (select mgr, job from emp where 
ename = '���ϴ�');
---
select avr, major from student where major = 'ȭ��';

select * from student
where avr in (select avr from student where major = 'ȭ��')and major != 'ȭ��';
----
select * from student
where (avr,syear) in (select avr, syear from student where major = 'ȭ��') and major != 'ȭ��';
-- 
SELECT AVG(result) FROM course c, score s WHERE c.cno = s.cno and c.cname = '��ȭ��';

select c.cno, c.cname, c.pno, p.pname
from course c
inner join professor p
on c.pno = p.pno
inner join score s
on c.cno = s.cno
group by c.cno, c.cname, c.pno, p.pname
having avg(s.result) > (SELECT AVG(result) FROM course c, score s WHERE c.cno = s.cno and c.cname = '��ȭ��');

--����
select c.cno, c.cname, p.pname, avg(result)
from score r, professor p, course c
where r.cno=c.cno
and p.pno = c.pno
group by c.cno, c.cname, p.pname
having  avg(result) > ( select avg(result) from score where cno = (select cno from course where cname = '��ȭ��'));

-- ����¡ ó���� ����
select * from (
    select rownum as row_num, alias.*
    from (select * from board order by seq desc) alias
    )
    where row_num between 6 and 10;  --=> �̰� ���ĸ� �����.

--����Ŭ �ε��� ����    
CREATE SEQUENCE board_seq;
INSERT INTO board values(board_seq.NEXTVAL,'a1', 'a', 'a', sysdate, 0);

INSERT INTO board(seq, title, writer, contents, regdate, hitcount)
(select board_seq.nextval, title, writer, contents, regdate, hitcount from board);

select * from board where seq = 9999;

ALTER TABLE board ADD CONSTRAINT board_seq_pk PRIMARY KEY(seq);

--ex) board ���̺� 'title' �÷��� ���� �۹�ȣ(seq) 100000���� ���ؼ� 'title' ���� 'a100000' �����ϰ� 'a100000' �˻� �� ���� ��ȹ�� Ȯ�� => full scan
--      �ε��� �����ϰ� �ٽ� �˻� �� => index scan

select * from board;

update board set title = 'a256' where seq =256;

select seq from board where seq = 256;
select seq from board where title = 'a256';

create index board_title_idx on board(title);

--5����