SELECT
    employee_id AS �����ȣ,
    last_name   "����̸�"
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

--07�⵵ �Ի��� ����� ����� ����϶�.
--select employee_id, last_name, hire_date from hr.employees where between '07/01/01' and '07/12/31';
--select employee_id, last_name, hire_date from hr.employees where hire_date like '07%';

--last_name �÷��� 'a'�� ���� ����� ����϶�.
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

--�μ����� ����� ���� Ŀ�̼��� �޴� ����� ���� �μ� ���� ������������ ����϶�
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


-- <2���� ����>
SELECT
    'DataBase',
    lower('DataBase')
FROM
    dual;

--����� �ټӳ��� ����϶�. �� 10.5�� employees :hiredate
SELECT
    *
FROM
    employees;

SELECT
    last_name,
    round((sysdate - hire_date) / 365, 1)
    || '��'
FROM
    employees;

SELECT
    sysdate,
    next_day(sysdate, '�����')
FROM
    dual;

SELECT
    to_char(sysdate, 'YYYY-MM-DD'),
    to_char(500000, '$999,999,999')
FROM
    dual;
    
--SELECT
--    to_date(��2024 - 06 - 20��, ��yyyy - mm - dd��),
--    to_date(��20240620��, ��yyyy - mm - dd��)
--FROM
   -- dual;
   
--2007�⵵�� �Ի��� ����� ����� �߷��϶�. to_char() ���  => to_char(hire_date, 'yyyy') = '2007'
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

--���̺� ����
create table emp01 as select * from employees;
--���̺� ������ ����
create table emp02 as select * from employees where 1=0;

--���̺� �÷� �߰�
alter table emp01 add (job varchar(50));
--���̺� �÷� ����
alter table emp01 modify (job varchar2(100));
--���̺� �÷� ����
alter table emp01 drop column job;

-- ������ ����
delete from emp01;
truncate table emp01;
-- ���̺� ����
drop table emp01;
drop table emp02;


create table dept01 as select * from departments;
insert into dept01 values(300, 'Developer', 100, 10);
insert into  dept01 (department_id, department_name) values (400, 'Sales');
update dept01 set department_name = 'IT Service' where department_id = 300;

--employees ���̺��� �����ؼ� emp01 ���̺��� ���� �� salary�� 3000 �̻� ����ڿ��� salary�� 10% �λ�����.
create table emp01 as select * from employees;
update emp01 set salary = salary + (salary*0.1)  where salary >= 3000;
select * from emp01;

--dept01 ���̺��� �μ��̸� 'IT Service' ���� ���� �ο� ����
delete from dept01 where department_name = 'IT Service';

--3���� ����
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

delete from dept01 where department_id = 30;  -- ���� ����� �ȵ�

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
    
--   3�� �̻� ���̺��� �����Ͽ� ����̸�, �̸���, �μ���ȣ, �μ��̸�, ������ȣ, �����̸��� ����� ����.
select e.first_name, e.email, e.department_id, d.deparment_name, d.department_id, j.job_id, j.job_title
from employees e, department d, jobs j
where e.department_id = d.department_id and e.job_id = j.job_id;

select e.first_name, e.email, d.department_id, d.department_name, j.job_id, j.job_title
from employees e inner join department d 
on e.department_id = d.departmetn_id 
inner join jobs j
on e.job_id = j.job_id;

-- 'Seattle' (city)�� �ٹ��ϴ� ����̸�, �μ���ȣ, ������ȣ, �����̸�, �����̸� ����غ���. => (where, ansi)
-- ansi�� join
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
-- where�� join
select e.first_name, e.department_id, j.job_id, j.job_title, l.city
from employees e, job_history j1,  jobs j, departments d,  locations l
where e.department_id = j1.department_id and   j1.job_id = j.job_id and j1.department_id = d.department_id and d.location_id = l.location_id and city = 'Seattle';
--��Kochhar�� ���ӻ���� ���� ����϶�.
select A.last_name || '�� �Ŵ�����' || B.last_name || '�̴�.' "����̸�"
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


--<���ΰ��� 1>
select ename, dname
from employees 
whereename = 'Himuro';

select e.ename, d.dname
from emp e, dept d
where e.dno = d.dno and job = 'Accountant';

--4���� ����
select avg(salary) from employees;

select last_name, salary
from employees
where salary > 6461.831775700934579439252336448598130841

select last_name, salary
from employees
where salary > (select avg(salary) from employees);

-- 'Chen' ������� salary�� ���� �޴� ��� ����� ����϶�.
select last_name,salary
from employees
where salary > (select salary from employees where last_name = 'Chen');

select employee_id, last_name, salary, job_id
from employees
where salary = (select max(salary) from employees group by job_id);  -- salary�� �������ǹ��� ���� ���� �ο쿩�� ������

select employee_id, last_name, salary, job_id
from employees
where salary in (select max(salary) from employees group by job_id);  -- salary�� ���� �÷��̵Ǽ� ������ �� �ʿ�

select employee_id, last_name, salary, job_id
from employees
where (salary,job_id) in (select max(salary), job_id from employees group by job_id);

select employee_id, last_name, hire_date
from employees order by hire_date;

select rownum, alias.*
from(select employee_id, last_name, hire_date  -- ���̺��� ������ ���� �������ֱ����� / rownum�� ����
from employees order by hire_date) alias
where rownum <=5;

--�޿��� ���� �޴� ��� 3���� ����Ͽ���.
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

-- ������ ���
SELECT e.employee_id, e.last_name, d.department_name, l.city, e.salary  
  FROM employees e, departments d, locations l 
  WHERE e.department_id = d.department_id 
  AND d.location_id = l.location_id 
  AND e.job_id NOT IN(SELECT job_id FROM employees WHERE department_id = 30) 
  AND e.department_id = 100;
--5����

--4���� 6�� ���� ��� ����(������ ���� ���� => ���ο� view ���� => ���� ����(view)
create or replace view dept_one as (select e.employee_id , e.first_name, e.department_id, e.hire_date, l.city, e.salary
from employees e
inner join departments d
on e.department_id = d.department_id
inner join locations l
on d.location_id = l.location_id
where salary > (select avg(salary) from employees));

select * from dept_one;
-- employees ���̺��� salary�� ������ view ���� => ���� ����(view)
select employee_id, first_name, last_name, email, phone_number, hire_date, job_id, commission_pct, manager_id, department_id
from employees;

create or replace view no_salary as (select employee_id, first_name, last_name, email, phone_number, hire_date, job_id, commission_pct, manager_id, department_id
from employees);

select * from no_salary;

-- PL/SQL
create table employees2 as select * from employees;  -- PL/SQL��

set serveroutput on;

DECLARE
-- ���� ����
 v_no NUMBER :=10;
 v_hireDate VARCHAR2(30) := TO_CHAR(SYSDATE, 'YYYY/MM/DD');
-- ��� ����
 c_message CONSTANT VARCHAR2(50) := 'HELLO PL/SQL!!!';

BEGIN
 DBMS_OUTPUT.PUT_LINE('PL/SQL ����'); 
 DBMS_OUTPUT.PUT_LINE(c_message); 
 DBMS_OUTPUT.PUT_LINE(v_hireDate); 
END;

DECLARE
-- ���� ����
 v_name VARCHAR2(20);
 v_salary NUMBER;
 v_hireDate VARCHAR2(30);

BEGIN
 SELECT first_name, salary, TO_CHAR(SYSDATE, 'YYYY-MM-DD')
  INTO v_name, v_salary, v_hireDate
  FROM employees
  WHERE first_name ='Ellen';
 DBMS_OUTPUT.PUT_LINE('�˻��� ����� ����');
 DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_salary ||' '|| v_hireDate);
  
END;

--�����ȣ 100���� �ش��ϴ� ����� �̸��� �μ����� ����Ͻÿ�.
DECLARE
    v_name VARCHAR2(20);
    v_department_id VARCHAR2(30);
    
BEGIN
    select first_name, department_id
    INTO v_name, v_department_id
    from employees where employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_department_id);

END;

-- ������ ����

DECLARE
	--�⺻�� ��������
	v_search VARCHAR2(30) := 'Lisa';
	-- ���۷�����
   v_name employees.last_name%TYPE;
   v_salary employees.salary%TYPE;

BEGIN
	SELECT last_name, salary
	INTO v_name, v_salary
	from employees
	WHERE first_name = v_search;
	
	DBMS_OUTPUT.PUT_LINE(v_name ||' ' || v_salary);
END;

--1. ������̺��� 201�� ����� �̸��� �̸����� ����϶�(���۷�����)
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

--2.employees => employees2 ����
-- ������̺��� �����ȣ�� ���� ū ����� ã�� �� �����ȣ + 1������ �Ʒ��� ������߰��϶�.
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
	--�ܼ�
	if v_no = 7 then
		DBMS_OUTPUT.PUT_LINE('7�̴�');
	end if;
end;


declare
	v_no number :=7;

begin
	--�ܼ�
	if v_no = 5 then
		DBMS_OUTPUT.PUT_LINE('5�̴�.');
	else
		DBMS_OUTPUT.PUT_LINE('5�� �ƴϴ�.');
	end if;
end;

declare
	v_no number :=7;
	v_score number := 80;

begin
	--�ܼ�
	if v_score >= 90 then
		DBMS_OUTPUT.PUT_LINE('A����');
	elsif v_score >= 80 then
		DBMS_OUTPUT.PUT_LINE('B����');
	elsif v_score >= 70 then
		DBMS_OUTPUT.PUT_LINE('B����');
	elsif v_score >= 60 then
		DBMS_OUTPUT.PUT_LINE('B����');
	else
		DBMS_OUTPUT.PUT_LINE('F����');
	end if;
end;

declare
	v_deptno number := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);

begin
--    select avg(salary) into v_deptno
--    from employees where department_id = v_deptno;
--
--	if v_deptno >= 6000 then
--		DBMS_OUTPUT.PUT_LINE('����');
--	elsif v_deptno between 3000 and 6000 then
--		DBMS_OUTPUT.PUT_LINE('����');
--	else
--		DBMS_OUTPUT.PUT_LINE('����');
--	end if;

    case when v_deptno between 1 and 3000 then
        dbms_output.put_line('����');
    when v_deptno between 3000 and 6000 then
        dbms_output.put_line('����');
    else
        dbms_output.put_line('����');
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
        --����
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

--���� > LOOP => ������ 3�� => 3*1=3;
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
--FOR => ������ ��ü  ->?
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

----����
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
    --UNIQUE : ���������� ���� �÷��� �ߺ��� ������ insert�ϴ� ���
    WHEN DUP_VAL_ON_INDEX THEN
    dbms_output.put_line('�̹� �����ϴ� ����Դϴ�');
    --select�� ��� 2�� �̻��� row�� ��ȯ
    WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line('�˻��� row�� �����ϴ�.');
    --�����Ͱ� ���� ��
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('�˻��� ����� �����ϴ�.');
    WHEN OTHERS THEN
    dbms_output.put_line('��Ÿ ����.');
END;

DECLARE
	e_user_exception EXCEPTION;  -- ����� ���� ����
	cnt NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO cnt
	FROM employees
	WHERE department_id = 40;

IF cnt < 5 THEN
	RAISE e_user_exception; -- �ο������� ���� �߻�
END IF;

EXCEPTION
	WHEN e_user_exception THEN
	dbms_output.put_line('5�� ���� �μ�����');
	
END;


--���Ի���� �Է½�  �߸��� �μ���ȣ�� ���ؼ� ����� ���� ó�� �ϼ���. => employees2 ���̺� Ȱ��
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
--        dbms_output.put_line('�ش� �μ� ��ȣ ('|| dept_id ||')�� �������� �ʽ��ϴ�.');
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
            dbms_output.put_line('�ش� �μ��� �����ϴ�.');
        when others then
            dbms_output.put_line('��Ÿ ����');
        
end;
---------------Ŀ��
DECLARE
	--Ŀ�� ����
	CURSOR department_cursors IS
		SELECT department_id, department_name, location_id
		FROM departments;
	
	department_record department_cursors%ROWTYPE;

BEGIN
	--Ŀ�� ����
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
	--Ŀ�� ����
	CURSOR department_cursors IS
		SELECT department_id, department_name, location_id
		FROM departments;
	
	department_record department_cursors%ROWTYPE;

BEGIN	
	FOR department_record IN department_cursors LOOP
		DBMS_OUTPUT.PUT_LINE(department_record.department_id ||' '|| department_record.department_name ||' ' || department_record.location_id);
	END LOOP;
END;

--Ŀ���� �̿��Ͽ� ����������� ����϶�. (�����ȣ, ����̸�(first_name), �޿�, �޿�����)
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

-- 6����
set serveroutput on;

CREATE OR REPLACE PROCEDURE listByDeptno(p_deptno 
                                                                IN employees.department_id%TYPE)
IS
    CURSOR employee_cursors IS
        SELECT * FROM employees
            WHERE department_id = p_deptno;  --=> ���� ã�ƿö��� ������
    
    employee_record employee_cursors%ROWTYPE;
    
BEGIN
    dbms_output.put_line('========= ��� ����Ʈ =========');
    
    FOR employee_record IN employee_cursors LOOP
        dbms_output.put_line(p_deptno ||' '|| employee_record.employee_id ||' '|| employee_record.last_name);
    END LOOP;
END;
        

EXECUTE listByDeptno(30);

-- ���� jobs => jobs2 ����
--���ν����� �̿��Ͽ� job_id, job_title, min_salary, max_salary
--�Է¹޾� ���̺� ���ο� row�� �߰��� ����
--('a','IT", 100, 1000)
create table jobs2 as select * from jobs;

create or replace procedure listByJobs2(
    p_job_id IN jobs2.job_id%type,
    p_job_title in jobs2.job_title%type,
    p_min_salary in jobs2.min_salary%type,  --=>  ���� Ÿ���� ������ ���ּ���
    p_max_salary in jobs2.max_salary%type
)

is 
    
begin
    insert into jobs2(job_id, job_title, min_salary, max_salary) values (p_job_id, p_job_title, p_min_salary, p_max_salary);
    
    commit;
end;

EXECUTE listByJobs2('a','IT', 100, 1000);

--<���� hr> jobs2���̺� job_id ��������(pk) �߰� ���ν����� �̿��Ͽ� ������ job_id�� üũ
-- no => insert ����  / yes => update ����
drop table jobs2;
create table jobs2 as select * from jobs;
alter table jobs2 add constraint jobs2_pk primary key(job_id);

--create or place procedure new_table1(
--    p_job_id jobs2.job_id%type := 'AD_VP';
--    p_job_title in jobs2.job_title%type,
--    p_min_salary in jobs2.min_salary%type,  --=>  ���� Ÿ���� ������ ���ּ���
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

-- �⺻ ���� ���� ����
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

-- out, in �Ű����� ����
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
        dbms_output.put_line('�߰� �Ǿ����ϴ�.');
    else
        dbms_output.put_line('�߰� �Ǿ����ϴ�.');
    end if;
end;

--- �Լ�
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

-- �����ȣ�� �Է� �޾� �̸��� ��ȯ�ϴ� �Լ��� ���� �϶�. ������ => ������ => �ش� ��� ����
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
             dbms_output.put_line('�ش� ����� �����ϴ�.');
             return v_employee_id;
        when others then
            dbms_output.put_line('�ش� ����� �ֽ��ϴ�.');
end;

select isId(6000) from  dual;

-- ������ ���
create or replace function get_emp_name(
  p_employee_id employees.employee_id%type)
  return varchar2
IS
  result VARCHAR2(50) := null;
BEGIN
    --����˻�
    SELECT last_name INTO result
  FROM employees
  WHERE employee_id = p_employee_id;
  
  RETURN result;
EXCEPTION
  WHEN NO_DATA_FOUND  THEN  
    RETURN '�ش� ��� ����';
END;

select get_emp_name(100) from dual;
    
 -- package
--��Ű�� ����
 CREATE OR REPLACE PACKAGE my_package
 IS
   PROCEDURE getEmployee(in_id IN employees.employee_id%TYPE,
                    out_id OUT employees.employee_id%TYPE,
                    out_name OUT employees.first_name%TYPE,
                    out_salary OUT employees.salary%TYPE);

   FUNCTION getSalary(p_no employees.employee_id%TYPE)
      RETURN NUMBER;

 END;

-- ��Ű�� ����
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
     END; --���ν��� ����

   FUNCTION getSalary(p_no employees.employee_id%TYPE)
      RETURN NUMBER

   IS
     v_salary NUMBER;
   BEGIN
     SELECT salary INTO v_salary
       FROM employees
       WHERE employee_id = p_no;
   
    RETURN v_salary;
   END; --�Լ�����

 END;--��Ű�� ����


--�Լ� ����
 SELECT my_package.getSalary(100) FROM dual;

--���ν��� ����
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
        dbms_output.put_line('���� ����� �߰� �Ǿ����ϴ�.');
END;

INSERT INTO emp14 VALUES(1, 'ȫ�浿', '����');
    
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
    
INSERT INTO emp14 values(2, '�ڱ浿', '����');

-- ����� �����Ǹ� �� ����� �޿�����(sal01) ���̺��� �ش� �ο쵵 �Բ� ���� �ǵ��� Ʈ���Ÿ� ������ ����.
CREATE OR REPLACE TRIGGER trg03 
AFTER DELETE ON emp14
FOR EACH ROW
BEGIN
  DELETE FROM sal01
  WHERE empno = :OLD.empno;
END;


--<mission hr> employees2���� retire_date �÷��� �߰�����.
--  ALTER TABLE employees2 ADD(retire_date date);
--  �׸��� �Ʒ��� ���뿡 �´� package,  procedure ����� ����.

--��Ű�� �����
CREATE OR REPLACE PACKAGE hr_pkg IS
    --�ű� ��� �Է�
    --�űԻ�� ��� => ������(�ִ�)��� + 1
    --�űԻ�� ���
    PROCEDURE new_emp_proc(ps_emp_name IN VARCHAR2,
	pe_email IN VARCHAR2,
	pj_job_id IN VARCHAR2,
	pd_hire_date IN VARCHAR2);
    -- TO_DATE(pdhire_date, 'YYYY-MM-DD');

   -- ��� ��� ó��
   --����� ����� ������̺��� �������� �ʰ� �������(retire_date)�� NULL���� ����
   PROCEDURE retire_emp_proc(pn_employee_id IN NUMBER);

END hr_pkg;

CREATE OR REPLACE PACKAGE BODY hr_pkg IS
 -- �ű� ��� �Է�
  PROCEDURE new_emp_proc(ps_emp_name IN VARCHAR2,
	pe_email IN VARCHAR2,
	pj_job_id IN VARCHAR2,
	pd_hire_date IN VARCHAR2)
  IS
    vn_emp_id employees2.employee_id%TYPE; 
    vd_hire_date DATE := TO_DATE(pd_hire_date, 'YYYY-MM-DD');

  BEGIN
        --�űԻ�� ��� => ������(�ִ�)��� + 1
        SELECT  NVL(MAX(employee_id), 0) + 1
	INTO vn_emp_id
	FROM employees2;

      --�űԻ�� ���
       INSERT INTO employees2(employee_id, last_name, hire_date, email, job_id)
	VALUES(vn_emp_id, ps_emp_name, vd_hire_date, pe_email, pj_job_id);

       COMMIT;

       EXCEPTION WHEN OTHERS THEN
	dbms_output.put_line('insert error');
	ROLLBACK;

  END new_emp_proc;

  --���ó��
  --����� ����� ������̺��� �������� �ʰ� �������(retire_date)�� NULL���� ����
  PROCEDURE retire_emp_proc(pn_employee_id IN NUMBER)
  IS
    vn_cnt NUMBER := 0;
    e_no_data EXCEPTION;
  BEGIN
      UPDATE employees2
	SET retire_date = SYSDATE
	WHERE employee_id = pn_employee_id
	AND retire_date IS NULL;

      --UPDATE�� �Ǽ��� ��������
      vn_cnt := SQL%ROWCOUNT;

     --���ŵ� �Ǽ��� 0�̸� ����� ����ó��
     IF vn_cnt = 0 THEN
        RAISE e_no_data; --���������� ����� ���� �߻�
     END IF;

     COMMIT;

     EXCEPTION WHEN e_no_data THEN
	dbms_output.put_line(pn_employee_id ||'�� ������� �ƴմϴ�.');
	ROLLBACK;

   END retire_emp_proc;

END hr_pkg;


EXECUTE hr_pkg.new_emp_proc('ȫ�浿', 'aaa@aa.com', 'AD_VP', '2021-02-24');

EXECUTE hr_pkg.retire_emp_proc(100);

---------------------------------------- ����
set serveroutput on;
