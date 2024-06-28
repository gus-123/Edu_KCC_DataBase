SELECT
    employee_id AS 사원번호,
    last_name   "사원이름"
FROM
    employees;

SELECT DISTINCT
    job_id
FROM
    employees;

SELECT
    employee_id,
    last_name,
    hire_date
FROM
    employees
WHERE
        hire_date >= '03/01/01'
    AND last_name = 'King';

SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    salary BETWEEN 5000 AND 10000;

--07년도 입사한 사원의 목록을 출력하라.
--select employee_id, last_name, hire_date from hr.employees where between '07/01/01' and '07/12/31';
--select employee_id, last_name, hire_date from hr.employees where hire_date like '07%';

--last_name 컬럼에 'a'가 없는 사원을 출력하라.
SELECT
    last_name
FROM
    employees
WHERE
    NOT last_name LIKE '%a%';

SELECT
    department_id,
    AVG(salary)
FROM
    employees
GROUP BY
    department_id;

--부서별로 사원의 수와 커미션을 받는 사원의 수를 부서 별로 오름차순으로 출력하라
SELECT
    *
FROM
    employees;

SELECT
    department_id,
    COUNT(*),
    COUNT(commission_pct)
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id;


--SELECT department_id, AVG(salary) 
--FROM employees
--GROUP BY department_id;
--HAVING AVG(salary) < 5000;


-- <2일차 수업>
SELECT
    'DataBase',
    lower('DataBase')
FROM
    dual;

--사원의 근속년을 출력하라. 예 10.5년 employees :hiredate
SELECT
    *
FROM
    employees;

SELECT
    last_name,
    round((sysdate - hire_date) / 365, 1)
    || '년'
FROM
    employees;

SELECT
    sysdate,
    next_day(sysdate, '토요일')
FROM
    dual;

SELECT
    to_char(sysdate, 'YYYY-MM-DD'),
    to_char(500000, '$999,999,999')
FROM
    dual;
    
--SELECT
--    to_date(’2024 - 06 - 20’, ‘yyyy - mm - dd’),
--    to_date(’20240620’, ’yyyy - mm - dd’)
--FROM
   -- dual;
   
--2007년도에 입사한 사원의 목록을 추력하라. to_char() 사용  => to_char(hire_date, 'yyyy') = '2007'
SELECT
    last_name, to_char(hire_date, 'yyyy-mm-dd')
FROM
    employees where hire_date like '07%';
    
SELECT employee_id, salary, NVL(commission_pct, 0) FROM employees;

SELECT employee_id, salary, NVL2(commission_pct, 'O','X') FROM employees;

SELECT job_id, DECODE(job_id, 'SA_MAN', 'Sales Dept', ' SH_CLERK', 'Sales Dept', 'Another') FROM employees;

--SELECT job_id,
--    CASE job_id
--        WHEN 'SA_MAN' THEN 'Sales Dept'
--        WHEN 'SA_MAN' THEN 'Sales Dept'
--        ELSE 'Another2'
--       END "CASE" FROM employees;
        
CREATE TABLE emp01  AS SELECT * FROM employees;
CREATE TABLE emp02  AS SELECT * FROM employees WHERE 1=0;
ALTER TABLE emp02 ADD(job VARCHAR(50));
ALTEr TABLE emp02 MODIFY(job VARCHAR2(100));
ALTER TABLE emp02 DROP COLUMN job;
DELETE FROM emp01;
rollback;
TRUNCATE TABLE emp01;
DROP TABLE emp02;

--테이블 복사
create table emp01 as select * from employees;
--테이블 구조만 복사
create table emp02 as select * from employees where 1=0;

--테이블 컬럼 추가
alter table emp01 add (job varchar(50));
--테이블 컬럼 수정
alter table emp01 modify (job varchar2(100));
--테이블 컬럼 삭제
alter table emp01 drop column job;

-- 데이터 삭제
delete from emp01;
truncate table emp01;
-- 테이블 삭제
drop table emp01;
drop table emp02;


create table dept01 as select * from departments;
insert into dept01 values(300, 'Developer', 100, 10);
insert into  dept01 (department_id, department_name) values (400, 'Sales');
update dept01 set department_name = 'IT Service' where department_id = 300;

--employees 테이블을 복사해서 emp01 테이블을 생성 후 salary가 3000 이상 대상자에게 salary를 10% 인상하자.
create table emp01 as select * from employees;
update emp01 set salary = salary + (salary*0.1)  where salary >= 3000;
select * from emp01;

--dept01 테이블에서 부서이름 'IT Service' 값을 가진 로우 삭제
delete from dept01 where department_name = 'IT Service';

--3일차 수업
create table emp01 (
    empno number,
    ename varchar2(20),
    job VARCHAR2(20),
    deptno number
)

insert into emp01 values (null, null, 'IT', 30);

create table emp02 (
    empno number not null,
    ename varchar2(20) not null,
    job VARCHAR2(20),
    deptno number
)

insert into emp02 values (100, 'kim', 'IT', 30);
insert into emp02 values (100, 'park', 'IT', 30);

create table emp03 (
    empno number unique,
    ename varchar2(20) not null,
    job VARCHAR2(20),
    deptno number
)

insert into emp03 values (100, 'kim', 'IT', 30);
insert into emp03 values (100, 'park', 'IT', 30);

create table emp04 (
    empno number PRIMARY KEY,
    ename varchar2(20) not null,
    job VARCHAR2(20),
    deptno number
)

insert into emp04 values (null, 'kim', 'IT', 30);
insert into emp04 values (200, 'kim', 'IT', 3000);
insert into emp04 values (100, 'park', 'IT', 30);

create table emp05 (
    empno number PRIMARY KEY,
    ename varchar2(20) not null,
    job VARCHAR2(20),
    deptno number REFERENCES departments(department_id) 
                        ON DELETE CASCADE
)

insert into emp05 values (200, 'kim', 'IT', 3000);

create table emp06 (
    empno number,
    ename varchar2(20) not null,
    job VARCHAR2(20),
    deptno number, 
    
    constraint emp06_empno_pk primary key (empno),
    constraint emp06_deptno_fk foreign key(deptno)
    REFERENCES departments(department_id) 
)

create table emp07 (
    empno number,
    ename varchar2(20),
    job VARCHAR2(20),
    deptno number
)

alter table emp07 add CONSTRAINT emp07_empno_pk primary key(empno);
alter table emp07 add constraint emp07_deptno_fk foreign key(deptno)
references departments(department_id);
alter table emp07 modify ename constraint emp07_ename_nn not null;

create table emp08 (
    empno number,
    ename varchar2(20),
    job VARCHAR2(20),
    deptno number
)

ALTER TABLE emp08
  ADD CONSTRAINT emp08_empno_pk PRIMARY KEY (empno),
  ADD CONSTRAINT emp08_deptno_fk FOREIGN KEY (deptno)
    REFERENCES departments(department_id),
  MODIFY ename CONSTRAINT emp08_ename_nn SET NOT NULL;
  
create table emp09 (
    empno number,
    ename varchar2(20),
    job VARCHAR2(20),
    deptno number,
    gender char(1) check (gender in('M','F'))
)

insert into emp09 values (100, 'park', 'IT', 30, 'A');

create table emp10 (
    empno number,
    ename varchar2(20),
    job VARCHAR2(20),
    deptno number,
    loc varchar2(20) default 'Seoul'
)

insert into emp10 (empno, ename, job, deptno) values(100, 'park', 'it', 30);

--1)
--create table emp11(
--empno number,
--deptno number,

--constraint emp11_pk primary key(empno, deptno)
--)

create table emp11(
empno number,
deptno number,
)

alter table emp11
add constraint emp11_empno_ename_pk primary key(empno, deptno);

create table emp12 (
    empno number,
    ename varchar2(20),
    job VARCHAR2(20),
    deptno number
)

alter table dept01
add constraint dept01_department_id_pk primary key (department_id);

ALTER TABLE emp12
  ADD CONSTRAINT emp12_deptno_fk FOREIGN KEY (deptno) REFERENCES dept01(department_id);

insert into emp12 values (100, 'kim', 'IT', 30);

delete from dept01 where department_id = 30;  -- 참조 관계라 안됨

delete from emp12 where deptno = 30;
delete from dept01 where department_id = 30;

create table emp13 (
    empno number,
    ename varchar2(20),
    job VARCHAR2(20),cascade
    deptno number REFERENCES dept01(department_id) on delete
)

INSERT INTO EMP13 VALUES(100, 'kim','it',20);
delete from dept01 where department_id =20;

select employee_id, department_id
    from employees
    where last_name = 'King';
    
select department_id, department_name
    from departments
    where department_id in (80, 90);
    
--   3개 이상 테이블을 조인하여 사원이름, 이메일, 부서번호, 부서이름, 직종번호, 직종이름을 출력해 보자.
select e.first_name, e.email, e.department_id, d.deparment_name, d.department_id, j.job_id, j.job_title
from employees e, department d, jobs j
where e.department_id = d.department_id and e.job_id = j.job_id;

select e.first_name, e.email, d.department_id, d.department_name, j.job_id, j.job_title
from employees e inner join department d 
on e.department_id = d.departmetn_id 
inner join jobs j
on e.job_id = j.job_id;

-- 'Seattle' (city)에 근무하는 사원이름, 부서번호, 직종번호, 직종이름, 도시이름 출력해보자. => (where, ansi)
-- ansi용 join
select e.first_name, e.department_id, j.job_id, j.job_title, l.city
from  employees e inner join job_history j1
on e.department_id = j1.department_id 
inner join jobs j
on j1.job_id = j.job_id
inner join departments d
on j1.department_id = d.department_id 
inner join locations l
on d.location_id = l.location_id
where city = 'Seattle';
-- where용 join
select e.first_name, e.department_id, j.job_id, j.job_title, l.city
from employees e, job_history j1,  jobs j, departments d,  locations l
where e.department_id = j1.department_id and   j1.job_id = j.job_id and j1.department_id = d.department_id and d.location_id = l.location_id and city = 'Seattle';
--’Kochhar’ 직속상사의 정보 출력하라.
select A.last_name || '의 매니저는' || B.last_name || '이다.' "상사이름"
from employees A, employees B
where A.manager_id = B.employee_id
and A.last_name = 'Kochhar';

select * from employees;

select * from employees e, departments d
where e.department_id =d. department_id;

select e.employes_id, d.department_id, d.department_name from employees e, departments d
where e.department_id = d.department_id(+);

select e.employee_id, d.department_id, d.department_name
from employees e left join departments d
on e.department_id = d.department_id;


--<조인과제 1>
select ename, dname
from employees 
whereename = 'Himuro';

select e.ename, d.dname
from emp e, dept d
where e.dno = d.dno and job = 'Accountant';

--4일차 수업
select avg(salary) from employees;

select last_name, salary
from employees
where salary > 6461.831775700934579439252336448598130841

select last_name, salary
from employees
where salary > (select avg(salary) from employees);

-- 'Chen' 사원보다 salary를 많이 받는 사원 목록을 출력하라.
select last_name,salary
from employees
where salary > (select salary from employees where last_name = 'Chen');

select employee_id, last_name, salary, job_id
from employees
where salary = (select max(salary) from employees group by job_id);  -- salary에 하위질의문의 값이 다중 로우여서 문제남

select employee_id, last_name, salary, job_id
from employees
where salary in (select max(salary) from employees group by job_id);  -- salary에 다중 컬럼이되서 기준이 더 필요

select employee_id, last_name, salary, job_id
from employees
where (salary,job_id) in (select max(salary), job_id from employees group by job_id);

select employee_id, last_name, hire_date
from employees order by hire_date;

select rownum, alias.*
from(select employee_id, last_name, hire_date  -- 테이블의 데이터 값을 가공해주기위해 / rownum은 순서
from employees order by hire_date) alias
where rownum <=5;

--급여를 많이 받는 사원 3명을 출력하여라.
select rownum, alias.*
from(select * from employees order by salary desc) alias
where rownum <=3;
--1
select employee_id, first_name, hire_date, salary from employees where last_name = 'Patel';
--2
select job_id from employees where last_name = 'Austin';

select first_name, department_id, salary, job_id
from employees
where job_id = (select job_id from employees where last_name = 'Austin');
--3
select salary from employees where last_name = 'Seo';

select employee_id, first_name, salary
from employees
where salary = (select salary from employees where last_name = 'Seo');
--4
select max(salary) from employees where department_id = 30;

select employee_id , first_name, salary
from employees
where salary > (select max(salary) from employees where department_id = 30);

select employee_id , first_name, salary
from employees
where salary > all(select salary from employees where department_id = 30);
--5
select min(salary) from employees where department_id = 30;

select employee_id , first_name, salary
from employees
where salary > (select min(salary) from employees where department_id = 30);

select employee_id , first_name, salary
from employees
where salary > any(select salary from employees where department_id = 30);
--6
select avg(salary) from employees;

select e.employee_id , e.first_name, e.department_id, e.hire_date, l.city, e.salary
from employees e
inner join departments d
on e.department_id = d.department_id
inner join locations l
on d.location_id = l.location_id
where salary > (select avg(salary) from employees);
--7
select distinct job_id from employees where department_id = 100;

select e.employee_id, e.first_name, e.department_id, e.hire_date, l.location_id
from employees e
inner join departments d
on e.department_id = d.department_id
inner join locations l
on d.location_id = l.location_id
where e.department_id = 30 and e.department_id <> 100;

-- 교수님 방식
SELECT e.employee_id, e.last_name, d.department_name, l.city, e.salary  
  FROM employees e, departments d, locations l 
  WHERE e.department_id = d.department_id 
  AND d.location_id = l.location_id 
  AND e.job_id NOT IN(SELECT job_id FROM employees WHERE department_id = 30) 
  AND e.department_id = 100;
--5일차

--4일차 6번 문제 뷰로 생성(과도한 조인 예제 => 새로운 view 생성 => 쿼리 질의(view)
create or replace view dept_one as (select e.employee_id , e.first_name, e.department_id, e.hire_date, l.city, e.salary
from employees e
inner join departments d
on e.department_id = d.department_id
inner join locations l
on d.location_id = l.location_id
where salary > (select avg(salary) from employees));

select * from dept_one;
-- employees 테이블에서 salary를 제외한 view 생성 => 쿼리 질의(view)
select employee_id, first_name, last_name, email, phone_number, hire_date, job_id, commission_pct, manager_id, department_id
from employees;

create or replace view no_salary as (select employee_id, first_name, last_name, email, phone_number, hire_date, job_id, commission_pct, manager_id, department_id
from employees);

select * from no_salary;

-- PL/SQL
create table employees2 as select * from employees;  -- PL/SQL용

set serveroutput on;

DECLARE
-- 변수 선언
 v_no NUMBER :=10;
 v_hireDate VARCHAR2(30) := TO_CHAR(SYSDATE, 'YYYY/MM/DD');
-- 상수 선언
 c_message CONSTANT VARCHAR2(50) := 'HELLO PL/SQL!!!';

BEGIN
 DBMS_OUTPUT.PUT_LINE('PL/SQL 수업'); 
 DBMS_OUTPUT.PUT_LINE(c_message); 
 DBMS_OUTPUT.PUT_LINE(v_hireDate); 
END;

DECLARE
-- 변수 선언
 v_name VARCHAR2(20);
 v_salary NUMBER;
 v_hireDate VARCHAR2(30);

BEGIN
 SELECT first_name, salary, TO_CHAR(SYSDATE, 'YYYY-MM-DD')
  INTO v_name, v_salary, v_hireDate
  FROM employees
  WHERE first_name ='Ellen';
 DBMS_OUTPUT.PUT_LINE('검색된 사원의 정보');
 DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_salary ||' '|| v_hireDate);
  
END;

--사원번호 100번에 해당하는 사원의 이름과 부서명을 출력하시오.
DECLARE
    v_name VARCHAR2(20);
    v_department_id VARCHAR2(30);
    
BEGIN
    select first_name, department_id
    INTO v_name, v_department_id
    from employees where employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_department_id);

END;

-- 데이터 유형

DECLARE
	--기본형 데이터형
	v_search VARCHAR2(30) := 'Lisa';
	-- 래퍼러스형
   v_name employees.last_name%TYPE;
   v_salary employees.salary%TYPE;

BEGIN
	SELECT last_name, salary
	INTO v_name, v_salary
	from employees
	WHERE first_name = v_search;
	
	DBMS_OUTPUT.PUT_LINE(v_name ||' ' || v_salary);
END;

--1. 사원테이블에서 201번 사원의 이름과 이메일을 출력하라(레퍼런스형)
declare
    v_name employees.first_name%type;
    v_email employees.email%type;
    
begin
    select first_name, email
    into v_name, v_email
    from employees
    where employee_id = 201;
    
    DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_email);
end;

--2.employees => employees2 복사
-- 사원테이블에서 사원번호가 가장 큰 사원을 찾은 후 사원번호 + 1번으로 아래의 사원을추가하라.
create table employees2 as select * from employees;

declare
    v_max_id employees2.employee_id%type;
    
begin
    select max(employee_id)
    into v_max_id
    from employees2;
    
    insert into employees2(employee_id, last_name, email, hire_date, job_id) values
    (v_max_id+1, 'Hon gil dong', 'aa@aa.com', sysdate, 'AD_VP');

    COMMIT;
end;

DECLARE
	 employee_record employees%rowtype;

BEGIN
	SELECT * INTO employee_record
	FROM employees
	WHERE first_name = 'Lisa';
	
	DBMS_OUTPUT.PUT_LINE(employee_record.employee_id ||' '|| employee_record.first_name ||' ' || employee_record.salary);

END;

declare
	v_no number :=7;

begin
	--단수
	if v_no = 7 then
		DBMS_OUTPUT.PUT_LINE('7이다');
	end if;
end;


declare
	v_no number :=7;

begin
	--단수
	if v_no = 5 then
		DBMS_OUTPUT.PUT_LINE('5이다.');
	else
		DBMS_OUTPUT.PUT_LINE('5가 아니다.');
	end if;
end;

declare
	v_no number :=7;
	v_score number := 80;

begin
	--단수
	if v_score >= 90 then
		DBMS_OUTPUT.PUT_LINE('A학점');
	elsif v_score >= 80 then
		DBMS_OUTPUT.PUT_LINE('B학점');
	elsif v_score >= 70 then
		DBMS_OUTPUT.PUT_LINE('B학점');
	elsif v_score >= 60 then
		DBMS_OUTPUT.PUT_LINE('B학점');
	else
		DBMS_OUTPUT.PUT_LINE('F학점');
	end if;
end;

declare
	v_deptno number := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);

begin
--    select avg(salary) into v_deptno
--    from employees where department_id = v_deptno;
--
--	if v_deptno >= 6000 then
--		DBMS_OUTPUT.PUT_LINE('높음');
--	elsif v_deptno between 3000 and 6000 then
--		DBMS_OUTPUT.PUT_LINE('보통');
--	else
--		DBMS_OUTPUT.PUT_LINE('낮음');
--	end if;

    case when v_deptno between 1 and 3000 then
        dbms_output.put_line('낮음');
    when v_deptno between 3000 and 6000 then
        dbms_output.put_line('보통');
    else
        dbms_output.put_line('높음');
    end case;
end;
---------LOOP
DECLARE
	i NUMBER :=0;
	total NUMBER :=0;

BEGIN
	LOOP
        i:=i+1;
        total := total +i;
        --조건
        EXIT WHEN i >= 10;
    END LOOP;
	
	DBMS_OUTPUT.PUT_LINE(total);
END;
---------WHILE
DECLARE
	i NUMBER :=0;
	total NUMBER :=0;

BEGIN
	WHILE I <= 10 LOOP
        total := total +i;
         i:=i+1;
    END LOOP;
	
	DBMS_OUTPUT.PUT_LINE(total);
END;
--FOR
DECLARE
	i NUMBER :=0;
	total NUMBER :=0;

BEGIN
	FOR i in 1..10 LOOP
        total := total + i;
    END LOOP;
	
	DBMS_OUTPUT.PUT_LINE(total);
END;

--과제 > LOOP => 구구단 3단 => 3*1=3;
DECLARE
    i number := 3;
    j number := 1;
begin
    loop
        i := i*j
        exit when j <10;
    end loop
    
    dbms_output.put_line(i || * || 'j' || '=' || i*j);
end;
--FOR => 구구단 전체  ->?
declare
    i number :=2;
    j number :=1;
    total number :=1;

begin
    for j in 1...10 loop
        i := i * j;
    end loop;
    
    dbms.output.put_line(i);
end;

----예외
DECLARE
    employee_record employees%ROWTYPE;
BEGIN
    SELECT employee_id, last_name, department_id
    INTO employee_record.employee_id,
    employee_record.last_name,
    employee_record.department_id
    FROM employees
    WHERE department_id = 50;

EXCEPTION
    --UNIQUE : 제약조건을 갖는 컬럼에 중복된 데이터 insert하는 경우
    WHEN DUP_VAL_ON_INDEX THEN
    dbms_output.put_line('이미 존재하는 사원입니다');
    --select문 결과 2개 이상의 row를 반환
    WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line('검색된 row가 많습니다.');
    --데이터가 없을 떄
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('검색된 사원이 없습니다.');
    WHEN OTHERS THEN
    dbms_output.put_line('기타 예외.');
END;

DECLARE
	e_user_exception EXCEPTION;  -- 사용자 예외 정의
	cnt NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO cnt
	FROM employees
	WHERE department_id = 40;

IF cnt < 5 THEN
	RAISE e_user_exception; -- 인원적으로 예외 발생
END IF;

EXCEPTION
	WHEN e_user_exception THEN
	dbms_output.put_line('5명 이하 부서금지');
	
END;


--신입사원을 입력시  잘못된 부서번호에 대해서 사용자 예외 처리 하세요. => employees2 테이블 활용
--declare
--    e_user_exception EXCEPTION;
--    cnt number := count(lat_name);
--    dept_id number := 50000;
--    v_max_id employees2.employee_id%type;
--    
--begin 
----    SELECT COUNT(last_name) INTO cnt
----    FROM employees2;
--
--    for i in 1..cnt loop
--        if employees2.employee_id = dept_id then
--            select max(employee_id)
--            into v_max_id
--            from employees2;
--    
--            insert into employees2(employee_id, last_name, email, hire_date, job_id) values
--            (v_max_id+1, 'Hon gil dong', 'aa@aa.com', sysdate, 'AD_VP');
--        else
--            RAISE e_user_exception;
--        end if;
--    end loop;
--  
-- EXCEPTION
--     WHEN e_user_exception THEN
--        dbms_output.put_line('해당 부서 번호 ('|| dept_id ||')는 존재하지 않습니다.');
--end;

declare
    p_department_id number := 50000;
    ex_invaild_deptid EXCEPTION;
    v_cnt number := 0;
    v_employee_id employees2.employee_id%type;

begin
    select count(*) into v_cnt
    from employees2
    where department_id = p_department_id;
    
    if v_cnt = 0 then
        raise ex_invaild_deptid;
    end if;
    
    select max(employee_id) + 1
    into v_employee_id
    from employees2;
    
    insert into employees2(employee_id, last_name, email, hire_date, job_id, department_id) values (v_employee_id+1, 'Hon gil dong', 'aa@aa.com', sysdate, 'AD_VP', p_department_id);
    
    exception
        when ex_invaild_deptid then
            dbms_output.put_line('해당 부서가 없습니다.');
        when others then
            dbms_output.put_line('기타 예외');
        
end;
---------------커서
DECLARE
	--커서 선언
	CURSOR department_cursors IS
		SELECT department_id, department_name, location_id
		FROM departments;
	
	department_record department_cursors%ROWTYPE;

BEGIN
	--커서 열기
	OPEN department_cursors;
	
	LOOP
		FETCH department_cursors
			into department_record.department_id,
					 department_record.department_name,
					 department_record.location_id;
		EXIT WHEN department_cursors%NOTFOUND;
		
		DBMS_OUTPUT.PUT_LINE(department_record.department_id ||' '|| department_record.department_name ||' ' || department_record.location_id);
	END LOOP;
	CLOSE department_cursors;
END;

DECLARE
	--커서 선언
	CURSOR department_cursors IS
		SELECT department_id, department_name, location_id
		FROM departments;
	
	department_record department_cursors%ROWTYPE;

BEGIN	
	FOR department_record IN department_cursors LOOP
		DBMS_OUTPUT.PUT_LINE(department_record.department_id ||' '|| department_record.department_name ||' ' || department_record.location_id);
	END LOOP;
END;

--커서를 이용하여 사원의정보를 출력하라. (사원번호, 사원이름(first_name), 급여, 급여누계)
declare
    cursor employees_cursors IS
        select employee_id, first_name, salary
        from employees;
    
    employee_record employees_cursors%ROWTYPE;
    
    saltotal number := 0;

begin
    DBMS_OUTPUT.PUT_LINE('Employee ID, First Name, Salary');
    for employee_record in employees_cursors loop
        saltotal := saltotal + employee_record.salary;
        DBMS_OUTPUT.PUT_LINE(employee_record.employee_id || ',' ||
                         employee_record.first_name || ',' ||
                         to_char(employee_record.salary, 'FM999,999') || chr(10));
    end loop;
    DBMS_OUTPUT.PUT_LINE('Total Salary: ' || to_char(saltotal, 'FM999,999'));
end;

-- 6일차
set serveroutput on;

CREATE OR REPLACE PROCEDURE listByDeptno(p_deptno 
                                                                IN employees.department_id%TYPE)
IS
    CURSOR employee_cursors IS
        SELECT * FROM employees
            WHERE department_id = p_deptno;  --=> 값을 찾아올때만 가져옴
    
    employee_record employee_cursors%ROWTYPE;
    
BEGIN
    dbms_output.put_line('========= 사원 리스트 =========');
    
    FOR employee_record IN employee_cursors LOOP
        dbms_output.put_line(p_deptno ||' '|| employee_record.employee_id ||' '|| employee_record.last_name);
    END LOOP;
END;
        

EXECUTE listByDeptno(30);

-- 기존 jobs => jobs2 복사
--프로시저를 이용하여 job_id, job_title, min_salary, max_salary
--입력받아 테이블에 새로운 row를 추가해 보자
--('a','IT", 100, 1000)
create table jobs2 as select * from jobs;

create or replace procedure listByJobs2(
    p_job_id IN jobs2.job_id%type,
    p_job_title in jobs2.job_title%type,
    p_min_salary in jobs2.min_salary%type,  --=>  같은 타입을 가지게 해주세요
    p_max_salary in jobs2.max_salary%type
)

is 
    
begin
    insert into jobs2(job_id, job_title, min_salary, max_salary) values (p_job_id, p_job_title, p_min_salary, p_max_salary);
    
    commit;
end;

EXECUTE listByJobs2('a','IT', 100, 1000);

--<과제 hr> jobs2테이블 job_id 제약조건(pk) 추가 프로시저를 이용하여 동일한 job_id를 체크
-- no => insert 실행  / yes => update 실행
drop table jobs2;
create table jobs2 as select * from jobs;
alter table jobs2 add constraint jobs2_pk primary key(job_id);

--create or place procedure new_table1(
--    p_job_id jobs2.job_id%type := 'AD_VP';
--    p_job_title in jobs2.job_title%type,
--    p_min_salary in jobs2.min_salary%type,  --=>  같은 타입을 가지게 해주세요
--    p_max_salary in jobs2.max_salary%type
--)
--
--is
--    cursor jobs2_cursors is
--        select job_id from jobs2 where job_id = p_job_id;
--
--begin       
--    if job_id != p_job_id then
--        update jobs2 set job_id =  p_job_id from job_id = 'a';
--    end if;
--    
--     insert into jobs2(job_id, job_title, min_salary, max_salary) values (p_job_id, p_job_title, p_min_salary, p_max_salary);
--     
--     commit;
--end;

CREATE OR REPLACE PROCEDURE new_table1 (
  p_job_id jobs2.job_id%type,
  p_job_title IN jobs2.job_title%type,
  p_min_salary IN jobs2.min_salary%TYPE,
  p_max_salary IN jobs2.max_salary%TYPE
)
IS
  v_cnt NUMBER := 0;
  v_result NUMBER := 0;  -- Flag to indicate successful insert/update
BEGIN
  SELECT COUNT(*) INTO v_cnt
  FROM jobs2
  WHERE job_id = p_job_id;

  IF v_cnt = 0 THEN
    INSERT INTO jobs2 (job_id, job_title, min_salary, max_salary)
    VALUES (p_job_id, p_job_title, p_min_salary, p_max_salary);
  ELSE
    UPDATE jobs2
    SET job_title = p_job_title,
        min_salary = p_min_salary,
        max_salary = p_max_salary
    WHERE job_id = p_job_id;
  END IF;

  COMMIT;
END;

execute new_table1 ('b','b', 100, 1000);
execute new_table1 ('a','b', 100, 1000);

-- 기본 값을 넣은 버전
CREATE OR REPLACE PROCEDURE new_table2 (
  p_job_id jobs2.job_id%type,
  p_job_title IN jobs2.job_title%type,
  p_min_salary IN jobs2.min_salary%TYPE := 100,
  p_max_salary IN jobs2.max_salary%TYPE := 1000
)
IS
  v_cnt NUMBER := 0;
  v_result NUMBER := 0;  -- Flag to indicate successful insert/update
BEGIN
  SELECT COUNT(*) INTO v_cnt
  FROM jobs2
  WHERE job_id = p_job_id;

  IF v_cnt = 0 THEN
    INSERT INTO jobs2 (job_id, job_title, min_salary, max_salary)
    VALUES (p_job_id, p_job_title, p_min_salary, p_max_salary);
  ELSE
    UPDATE jobs2
    SET job_title = p_job_title,
        min_salary = p_min_salary,
        max_salary = p_max_salary
    WHERE job_id = p_job_id;
  END IF;

  COMMIT;
END;

EXECUTE new_table2 ('c','c');

-- out, in 매개변수 설정
CREATE OR REPLACE PROCEDURE new_table3 (
  p_job_id jobs2.job_id%type,
  p_job_title IN jobs2.job_title%type,
  p_min_salary IN jobs2.min_salary%TYPE := 100,
  p_max_salary IN jobs2.max_salary%TYPE := 1000,
   p_result out number
)
IS
  v_cnt NUMBER := 0;
  v_result NUMBER := 0;  -- Flag to indicate successful insert/update
BEGIN
  SELECT COUNT(*) INTO v_cnt
  FROM jobs2
  WHERE job_id = p_job_id;

  IF v_cnt = 0 THEN
    INSERT INTO jobs2 (job_id, job_title, min_salary, max_salary)
    VALUES (p_job_id, p_job_title, p_min_salary, p_max_salary);
    v_result := 1;
  ELSE
    UPDATE jobs2
    SET job_title = p_job_title,
        min_salary = p_min_salary,
        max_salary = p_max_salary
    WHERE job_id = p_job_id;
    v_result := 1;
  END IF;

  COMMIT;
END;

declare
    p_result number;
    
begin  
    new_table3('d', 'd1', 200, 2000, p_result);
    
    if p_result = 1 then
        dbms_output.put_line('추가 되었습니다.');
    else
        dbms_output.put_line('추가 되었습니다.');
    end if;
end;

--- 함수
CREATE OR REPLACE function getSalary(p_no employees.employee_id%TYPE)
    return NUMBER
IS
    v_salary NUMBER;

BEGIN
    select salary into v_salary
    from employees
    where employee_id = p_no;
    
    return v_salary;
end;

select getSalary(100) from  dual;

-- 사원번호를 입력 받아 이름을 반환하는 함수를 구현 하라. 없으면 => 없으면 => 해당 사원 없음
CREATE OR REPLACE function isId(p_no employees.employee_id%type)
    return number
is
    v_employee_id number;
    v_cnt number;
    ex_invaild_employee_id exception;
    
begin
    select count(employee_id) into v_cnt
    from employees
    where employee_id = p_no;
    
    if v_cnt = 0 then
        raise ex_invaild_employee_id;
    end if;
    
    exception
        when ex_invaild_employee_id then
             dbms_output.put_line('해당 사원이 없습니다.');
             return v_employee_id;
        when others then
            dbms_output.put_line('해당 사원이 있습니다.');
end;

select isId(6000) from  dual;

-- 교수님 방식
create or replace function get_emp_name(
  p_employee_id employees.employee_id%type)
  return varchar2
IS
  result VARCHAR2(50) := null;
BEGIN
    --사원검색
    SELECT last_name INTO result
  FROM employees
  WHERE employee_id = p_employee_id;
  
  RETURN result;
EXCEPTION
  WHEN NO_DATA_FOUND  THEN  
    RETURN '해당 사원 없음';
END;

select get_emp_name(100) from dual;
    
 -- package
--패키지 선언
 CREATE OR REPLACE PACKAGE my_package
 IS
   PROCEDURE getEmployee(in_id IN employees.employee_id%TYPE,
                    out_id OUT employees.employee_id%TYPE,
                    out_name OUT employees.first_name%TYPE,
                    out_salary OUT employees.salary%TYPE);

   FUNCTION getSalary(p_no employees.employee_id%TYPE)
      RETURN NUMBER;

 END;

-- 패키지 본문
CREATE OR REPLACE PACKAGE BODY my_package
 IS
   PROCEDURE getEmployee(in_id IN employees.employee_id%TYPE,
                    out_id OUT employees.employee_id%TYPE,
                    out_name OUT employees.first_name%TYPE,
                    out_salary OUT employees.salary%TYPE)

     IS
     BEGIN
        SELECT employee_id, first_name, salary
           INTO out_id, out_name, out_salary
           FROM employees
           WHERE employee_id = in_id;
     END; --프로시저 종료

   FUNCTION getSalary(p_no employees.employee_id%TYPE)
      RETURN NUMBER

   IS
     v_salary NUMBER;
   BEGIN
     SELECT salary INTO v_salary
       FROM employees
       WHERE employee_id = p_no;
   
    RETURN v_salary;
   END; --함수종료

 END;--패키지 종료


--함수 실행
 SELECT my_package.getSalary(100) FROM dual;

--프로시저 실행
 DECLARE
   p_id NUMBER;
   p_name VARCHAR2(50);
   p_salary NUMBER;

 BEGIN
   my_package.getEmployee(100, p_id, p_name, p_salary);
   dbms_output.put_line(p_id ||'  '|| p_name ||'   '|| p_salary);
 END;
 
--Trigger
CREATE TABLE emp14(
    empno NUMBER PRIMARY KEY,
    ename VARCHAR2(20),
    job VARCHAR2(20)
)

CREATE OR REPLACE TRIGGER trg_01
    AFTER INSERT 
    ON emp14
    BEGIN
        dbms_output.put_line('신입 사원이 추가 되었습니다.');
END;

INSERT INTO emp14 VALUES(1, '홍길동', '개발');
    
CREATE TABLE sal01 (
	salno NUMBER PRIMARY KEY,
	sal NUMBER,
	empno NUMBER REFERENCES emp14(empno)
)

CREATE SEQUENCE sal01_salno_seq;

CREATE TABLE sal01 (
	salno NUMBER PRIMARY KEY,
	sal NUMBER,
	empno NUMBER REFERENCES emp14(empno)
)

CREATE SEQUENCE sal01_salno_seq;

CREATE OR REPLACE TRIGGER trg02
	AFTER INSERT
	ON emp14
	FOR EACH ROW
	BEGIN
		INSERT INTO sal01 VALUES(sal01_salno_seq.NEXTVAL, 4000, :NEW.empno);
    END;
    
INSERT INTO emp14 values(2, '박길동', '영업');

-- 사원이 삭제되면 그 사원의 급여정보(sal01) 테이블의 해당 로우도 함꼐 삭제 되도록 트리거를 구현해 보자.
CREATE OR REPLACE TRIGGER trg03 
AFTER DELETE ON emp14
FOR EACH ROW
BEGIN
  DELETE FROM sal01
  WHERE empno = :OLD.empno;
END;


--<mission hr> employees2에서 retire_date 컬럼을 추가하자.
--  ALTER TABLE employees2 ADD(retire_date date);
--  그리고 아래의 내용에 맞는 package,  procedure 만들어 보자.

--패키지 선언부
CREATE OR REPLACE PACKAGE hr_pkg IS
    --신규 사원 입력
    --신규사원 사번 => 마지막(최대)사번 + 1
    --신규사원 등록
    PROCEDURE new_emp_proc(ps_emp_name IN VARCHAR2,
	pe_email IN VARCHAR2,
	pj_job_id IN VARCHAR2,
	pd_hire_date IN VARCHAR2);
    -- TO_DATE(pdhire_date, 'YYYY-MM-DD');

   -- 퇴사 사원 처리
   --퇴사한 사원은 사원테이블에서 삭제하지 않고 퇴사일자(retire_date)를 NULL에서 갱신
   PROCEDURE retire_emp_proc(pn_employee_id IN NUMBER);

END hr_pkg;

CREATE OR REPLACE PACKAGE BODY hr_pkg IS
 -- 신규 사원 입력
  PROCEDURE new_emp_proc(ps_emp_name IN VARCHAR2,
	pe_email IN VARCHAR2,
	pj_job_id IN VARCHAR2,
	pd_hire_date IN VARCHAR2)
  IS
    vn_emp_id employees2.employee_id%TYPE; 
    vd_hire_date DATE := TO_DATE(pd_hire_date, 'YYYY-MM-DD');

  BEGIN
        --신규사원 사번 => 마지막(최대)사번 + 1
        SELECT  NVL(MAX(employee_id), 0) + 1
	INTO vn_emp_id
	FROM employees2;

      --신규사원 등록
       INSERT INTO employees2(employee_id, last_name, hire_date, email, job_id)
	VALUES(vn_emp_id, ps_emp_name, vd_hire_date, pe_email, pj_job_id);

       COMMIT;

       EXCEPTION WHEN OTHERS THEN
	dbms_output.put_line('insert error');
	ROLLBACK;

  END new_emp_proc;

  --퇴사처리
  --퇴사한 사원은 사원테이블에서 삭제하지 않고 퇴사일자(retire_date)를 NULL에서 갱신
  PROCEDURE retire_emp_proc(pn_employee_id IN NUMBER)
  IS
    vn_cnt NUMBER := 0;
    e_no_data EXCEPTION;
  BEGIN
      UPDATE employees2
	SET retire_date = SYSDATE
	WHERE employee_id = pn_employee_id
	AND retire_date IS NULL;

      --UPDATE된 건수를 가져오기
      vn_cnt := SQL%ROWCOUNT;

     --갱신된 건수가 0이면 사용자 예외처리
     IF vn_cnt = 0 THEN
        RAISE e_no_data; --인위적으로 사용자 예외 발생
     END IF;

     COMMIT;

     EXCEPTION WHEN e_no_data THEN
	dbms_output.put_line(pn_employee_id ||'는 퇴사대상이 아닙니다.');
	ROLLBACK;

   END retire_emp_proc;

END hr_pkg;


EXECUTE hr_pkg.new_emp_proc('홍길동', 'aaa@aa.com', 'AD_VP', '2021-02-24');

EXECUTE hr_pkg.retire_emp_proc(100);

---------------------------------------- 연습
set serveroutput on;
