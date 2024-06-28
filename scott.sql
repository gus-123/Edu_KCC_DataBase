select deptno, dname, loc from dept where deptno =10;
select ename, hiredate, empno from emp where empno = 7369;
select * from emp where ename = 'ALLEN';
select * from emp where job != 'MANAGER';
select * from emp where hiredate > '81/04/02';
select ename, sal, deptno from emp where sal >= 800;
select * from emp where deptno > '20';
select * from emp where hiredate < '81/12/09';
select empno, ename from emp where empno <= 7698;
select ename, sal, deptno from emp where hiredate in ('81/04/02', '82/12/09');
select ename, job, sal from emp where sal between 1600 and 3000;
select * from emp where not empno in (7654, 7782);

SELECT *
FROM emp
WHERE ename LIKE 'B%'
UNION
SELECT *
FROM emp
WHERE ename LIKE 'J%';


select * from emp where not hiredate between '81/01/01' and '81/12/31';
select * from emp where job in ('MANAGER', 'SALESMAN');
select ename, empno, deptno from emp where not deptno in (20,30);
select empno, ename, hiredate, deptno from emp where ename like 'S%';
select * from emp where hiredate BETWEEN '81/01/01' and '81/12/31';
select * from emp where ename like '%S%';
select * from emp where ename like '_A%';
select * from emp where comm is null;
select * from emp where comm is not null;
select ename, deptno, sal from emp where deptno = 30 and sal > =1500;
select empno, ename, deptno from emp where ename like 'K%' and deptno =30;

select * from emp where sal >=1500 and deptno = 30
INTERSECT
select * from emp where job = 'MANAGER';

select * from emp where deptno = 30 order by empno;
select ename, sal from emp order by sal desc;


--2일차 수업
select * from emp;

select job, substr(job, 1, 2) from emp;  -- 인덱스 1,2
select job, substr(job, 5) from emp;  -- 인덱스 5 이후
select job, substr(job, -3) from emp;  -- 인덱스 뒤에서 3개

--함수과제
select * from emp;
select empno, substr(empno, 1, 2)  || '**' as MASKING_EMPNO, ename, substr(ename, 1,1) || '****' from emp;
select empno, ename, sal, round((sal / 21.5), 2) as DAY_PAY, round((sal /21.5 / 8) , 1) as TIME_PAY from emp; 
select empno, ename, hiredate, to_char(next_day(add_months(hiredate, 3), '월요일'), 'yyyy-mm-dd') as R_JOB, DECODE(comm, NULL, 'N/A', comm)  from emp; 
select empno, ename, mgr,
    CASE
        WHEN MGR IS NULL THEN '0000'
        WHEN mgr LIKE '75%' THEN '555'
        WHEN mgr LIKE '76%' THEN '6666'
        WHEN mgr LIKE '77%' THEN '7777'
        WHEN mgr LIKE '78%' THEN '8888'
        ELSE to_char(mgr)
        END as chg_mgr 
from emp;  
  
select deptno, TRUNC(AVG(SAL)) as AVG_SAL, max(sal) as MAX_SAL, min(sal) as MIN_SAL, count(*) from emp group by deptno having deptno IN (10, 20, 30); 
select job, count(*) from emp group by job having JOB in ('CLERK', 'SALESMAN', 'MANAGER');
select to_char(hiredate, 'yyyy'), deptno, count(*) from emp group by hiredate,deptno having deptno in ('10', '20');
select nvl2(comm, 'O', 'X'), count(*) as CNT from emp group by nvl2(comm, 'O', 'X');
select deptno, to_char(hiredate, 'yyyy'), count(*), max(sal), sum(sal), avg(sal) from emp group by ROLLUP(deptno, to_char(hiredate, 'yyyy')) order by deptno;

--test
create table test01 as select * from emp;
create table test02 as select * from emp where 1=0;

alter table test01 add(jod varchar(50));
alter table test01 modify(jod varchar2(100));
alter table test01 drop column jod;

delete from test02;
truncate table test01;

drop table test01;

select * from test01;

update test01 set ename = 'SMITH' where job = 'cleark';
delete from test01 where empno = '7499';
drop table test01;

create table test01 as select * from dept;
create table test02 as select * from emp;

drop table test01;
drop table test02;


--3일차 수업

select ename, sal, grade
from emp, salgrade
where sal between losal and hisal order by grade;

--3일차 과제
--<조인과제 2>
select d.deptno, d.dname, e.empno, e.ename, e.sal
from emp e, dept d
where e.deptno = d.deptno and sal > 2000;

select d.deptno, d.dname, avg(sal), max(sal), min(sal), count(*)
from dept d
inner join emp e on d.deptno = e.deptno
group by d.deptno, d.dname;

select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from dept d, emp e
where d.deptno=e.deptno;

SELECT d.deptno, d.dname, e1.empno, e1.ename, e1.mgr, e1.sal, e1.deptno "deptno_1",
       losal, hisal, grade, e2.empno "mgr_empno", e2.ename "mgr_ename"
FROM  emp e1 RIGHT JOIN dept d
ON e1.deptno = d.deptno
LEFT JOIN emp e2
ON e1.mgr = e2.empno
LEFT JOIN salgrade g
ON e1.sal BETWEEN losal AND hisal
ORDER BY d.deptno, e1.empno;

--4일차 수업
--1
select job from emp where ename = 'ALLEN';

select job, e.empno, e.ename, e.sal, e.deptno, d.dname
from emp e
inner join dept d
on e.deptno = d.deptno
where job = (select job from emp where ename = 'ALLEN');
--2
select avg(sal) from emp;

select e.empno, e.ename, d.dname, e.hiredate, d.loc, e.sal, g.grade
from emp e, dept d, salgrade g
where e.deptno = d.deptno and sal > (select avg(sal) from emp) and sal between losal and hisal order by sal desc;
--3
select job from emp where deptno = 30;

SELECT e.empno, e.ename, e.job, e.deptno, d.dname, d.loc
FROM emp e
INNER JOIN dept d
ON e.deptno = d.deptno
where e.deptno = 10 and e.job not in (select job from emp where deptno = 30);
--4
select MAX(SAL) from emp where job= 'SALESMAN';

select e.empno, e.ename, e.sal, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno and sal > (select MAX(SAL) from emp where job= 'SALESMAN') and sal between losal and hisal;  

--5일차
--40번 부서의 부서정보를 rowtype을 이용해서 출력하자. (deptno, dname, loc)
set serveroutput on;
declare
    dept_record dept%rowtype;

begin
    select deptno, dname, loc into emp_record
    from dept
    where deptno = 40;
    
    DBMS_OUTPUT.PUT_LINE(emp_record.deptno ||' ' || emp_record.dname|| ' ' || emp_record.loc);
end;