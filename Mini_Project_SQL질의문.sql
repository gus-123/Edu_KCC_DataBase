CREATE TABLE Supplier (  -- ���޾�ü
   supplier_id   number   primary key,
   supplier_name   varchar(200)   NULL,
   business_no   varchar(200)   NULL,
   tel_no   varchar(200)   NULL,
   address   varchar(200)   NULL,
   location   varchar(200)   NULL,
   zipcode   varchar(200)   NULL
);

CREATE TABLE contract_supplier (  -- ������ó
   contract_supplier_id   number   primary key,
   supplier_id number references Supplier(supplier_id) on delete cascade,
   contract_name   varchar(200)   NULL,
   contract_date   Date   NULL,
   content   varchar(200)   NULL
);

CREATE TABLE item (  -- ���޹�ǰ
   item_id   number primary key,
   commodity_classification_code number not null,
   item_name   varchar(200)   not NULL,
   item_price   number   NULL,
   manufacturer   varchar(200)   NULL,
   contract_supplier_id number references contract_supplier(contract_supplier_id) on delete cascade
);

CREATE TABLE department (  -- �μ�
   department_no   number   primary key,
   department_name   varchar(200)   NULL,
   department_manager   varchar(200)   NULL,
   department_location   varchar(200)   NULL,
   department_tel   varchar(200)   NULL
);

CREATE TABLE department_frequent_item ( --�μ�����ǰ��
  department_no number,
  item_id number,

  PRIMARY KEY (department_no, item_id),  
  FOREIGN KEY (department_no) REFERENCES department(department_no),  
  FOREIGN KEY (item_id) REFERENCES item(item_id)  
);

alter table department_frequent_item add division varchar2(200);

CREATE TABLE charge_item (  -- û����ǰ
   charge_item_id number,
   department_no number,
   item_id number,
   charge_amount   number   NULL,
   charge_date   Date   NULL,
   charger_item_state   varchar(200)   NULL,
   
   PRIMARY KEY (department_no, item_id, charge_item_id),  
   FOREIGN KEY (department_no) REFERENCES department(department_no),  
   FOREIGN KEY (item_id) REFERENCES item(item_id)
);

CREATE TABLE order_form (  -- ���ּ�
   order_form_id   number primary key,
   supplier_name   varchar(200)   NULL,
   total_price   number   NULL,
   order_form_name   varchar(200)   NULL
);

CREATE TABLE order_item ( --���ֹ�ǰ
   order_form_id   number,
   item_id   number,
   department_no   number,
   order_item_price   number   NULL,
   incoming_amount   number   NULL,
   incoming_date   Date   NULL,
   incoming_state   varchar(200)   NULL,
   PRIMARY KEY (order_form_id, item_id, department_no),  
   FOREIGN KEY (department_no) REFERENCES department(department_no),  
   FOREIGN KEY (item_id) REFERENCES item(item_id),
   FOREIGN KEY (order_form_id) REFERENCES order_form(order_form_id)
);

CREATE TABLE trigonometry (  -- �󰢹��
   grade   varchar(200)   primary key,
   max_year   DATE   NULL,
   min_year   DATE   NULL,
   discount_cost   number   NULL
);

CREATE TABLE stock_item (  --���ǰ
   stock_item_id   number primary key,
   item_id   number references item(item_id) on delete cascade,
   department_no   number references department(department_no) on delete cascade,
   safe_stock   number  NULL,
   optimal_stock   number   NULL,
   current_stock   number   NULL
);

CREATE TABLE item_usage_history (  -- ��ǰ ����̷�
   item_usage_history_id   number  primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   usage_date   Date   NULL,
   usage_amount   number   NULL
);

CREATE TABLE inspection_detail (  -- ���˸�ϻ�
   inspection_detail_id   number primary key,
   inspection_detail_name   varchar(200)   NULL
);

CREATE TABLE manager (  -- ������
   manager_id   number  primary key,
   manager_name   varchar(200)   NULL,
   manager_tel   varchar(200)   NULL,
   department_no   number references department(department_no) on delete cascade
);

CREATE TABLE device_inspection_list ( --�Ƿ������˸��
   device_inspection_list_id   number,
   stock_item_id number,
   device_inspection_list_name   varchar(200)   NULL,
   device_inspection_list_period   varchar(200)   NULL,
   PRIMARY KEY (device_inspection_list_id, stock_item_id),  
   FOREIGN KEY (stock_item_id) REFERENCES stock_item(stock_item_id)
);

CREATE TABLE device_inspection (  -- �Ƿ�������
   inspection_detail_id   number,
   device_inspection_list_id   number,
   stock_item_id   number,
   device_inspection_date date null,
   device_inspection_state varchar(200) null,
   manager_id   number references manager(manager_id) on delete cascade,
   PRIMARY KEY (inspection_detail_id, device_inspection_list_id, stock_item_id),
   FOREIGN KEY (inspection_detail_id) REFERENCES inspection_detail(inspection_detail_id),
   FOREIGN KEY (stock_item_id) REFERENCES stock_item(stock_item_id)
);

ALTER TABLE device_inspection
ADD CONSTRAINT device_inspection_fk
FOREIGN KEY (device_inspection_list_id, stock_item_id) 
REFERENCES device_inspection_list(device_inspection_list_id, stock_item_id);

CREATE TABLE disposal (  -- ���
   disposal_id   number  primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   manager_id   number references manager(manager_id) on delete cascade,
   request_date   Date   NULL,
   disposal_date   Date   NULL,
   content   varchar(200)   NULL,
   disposal_amount   number   NULL
);

CREATE TABLE device_repair_request (  --������û�Ƿ���
   device_repair_request_id   number   primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   manager_id   number references manager(manager_id) on delete cascade,
   device_repair_request_date   Date   NULL,
   device_repair_failure_date   Date   NULL,
   device_repair_failure_symptom   varchar(200)   NULL,
   device_repair_request_state   varchar(200)   NULL
);

CREATE TABLE device_repiar_company (  -- ������ü
   device_repiar_company_id   number   primary key,
   device_repair_company_name   VARCHAR(200)   NULL,
   business_num   VARCHAR(200)   NULL,
   device_repiar_company_manager   VARCHAR(200)   NULL,
   device_repair_company_tel   VARCHAR(200)   NULL
);

CREATE TABLE device_repair_check ( --������ü �������� �Ƿ���
   device_repair_request_id number,
   device_repiar_company_id number,
   
   PRIMARY KEY (device_repair_request_id, device_repiar_company_id),
   FOREIGN KEY (device_repair_request_id) REFERENCES device_repair_request(device_repair_request_id),
   FOREIGN KEY (device_repiar_company_id) REFERENCES device_repiar_company(device_repiar_company_id)
);

alter table device_repair_check add device_repair_state   varchar(200);

CREATE TABLE device_repair ( --�Ƿ������
   device_repiar_id   number,
   device_repair_request_id number,
   device_repiar_company_id number,
   device_repair_complete_date   DATE   NULL,
   device_repair_price   number   NULL,
   device_repair_content   VARCHAR(200)   NULL,
   PRIMARY KEY (device_repiar_id, device_repair_request_id, device_repiar_company_id),
   FOREIGN KEY (device_repair_request_id) REFERENCES device_repair_request(device_repair_request_id),
   FOREIGN KEY (device_repiar_company_id) REFERENCES device_repiar_company(device_repiar_company_id)
);

CREATE TABLE device_transfer_request (  -- �Ƿ����̵���û��
   device_transfer_request_id   number   primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   transfer_department_no   number references department(department_no) on delete cascade,
   manager_id   number references manager(manager_id) on delete cascade,
   previous_department_no   number NOT NULL,
   device_tranfer_request_reason   varchar(200)  NULL,
   device_tranfer_request_date   Date   NULL,
   device_tranfer_request_state   varchar(200)   NULL
);

CREATE TABLE device_transfer_history (  --�Ƿ����̵�����
   stock_item_id   number,
   device_transfer_request_id number,
   privious_department_no   number   NULL,
   transfer_department_no   number   NULL,
   device_transfer_date   Date   NULL,
   PRIMARY KEY (privious_department_no, stock_item_id),
   FOREIGN KEY (stock_item_id) REFERENCES stock_item(stock_item_id),
   FOREIGN KEY (device_transfer_request_id) REFERENCES device_transfer_request(device_transfer_request_id)
);

create table medical_device ( -- �Ƿ���
    stock_item_id number,
    medical_device_no number,
    standard varchar2(200),
    lease_period date,
    lease_amount number,
    english_name varchar2(200),
    PRIMARY KEY (stock_item_id, medical_device_no),
    FOREIGN KEY (stock_item_id) REFERENCES stock_item(stock_item_id)
);



-- ��ü ���̺� DROP ��ɾ�

BEGIN
    FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'HOSPITAL') LOOP
        EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
    END LOOP;
END;



-- ������ ���� ��ϵ�

-- ��ü ��ǰ�ڵ� ���  => 0��

select b.item_id as ��ǰ�ڵ�, b.item_name as ��ǰ��, c.english_name as ��������, c.standard as �԰�, a.safe_stock as ������� ,  a.optimal_stock as �������, a.current_stock as �����, a.department_no as �μ���ȣ, e.manager_name as ������
from stock_item a, item b, medical_device c, department d, manager e
where a.item_id = b.item_id and a.stock_item_id = c.stock_item_id and a.department_no = d.department_no and e.department_no = d.department_no;

create or replace view inventory_list as (
select b.item_id as ��ǰ�ڵ�, b.item_name as ��ǰ��, c.english_name as ��������, c.standard as �԰�, a.safe_stock as ������� , 
    a.optimal_stock as �������, a.current_stock as �����, a.department_no as �μ���ȣ, e.manager_name as ������
from stock_item a, item b, medical_device c, department d, manager e
where a.item_id = b.item_id and a.stock_item_id = c.stock_item_id and a.department_no = d.department_no and e.department_no = d.department_no);

select * from inventory_list;

-- '�������̹߻���' ��ġ ���� ��û�� ���� �ڼ��� ������ ��ȸ => 1��

select * from device_repair_request;

select b.device_repair_request_id as ������û����ȣ, b.device_repair_request_date as ��û����, b.device_repair_failure_date as �����Ͻ�, a.stock_item_id as ���ǰ��ȣ,
    e.item_name as ��ǰ��, c.department_name as �μ���, d.manager_name as ��û��, b.device_repair_failure_symptom as ��������, b.device_repair_request_state as ��ġ��Ȳ
from stock_item a, device_repair_request b, department c, manager d, item e
where a.stock_item_id = b.stock_item_id and a.department_no = c.department_no and c.department_no = d.department_no and  e.item_name = '�������̹߻���' and a.item_id = e.item_id;

-- ������û����ȣ 1���� ���� ���� �Ƿڼ� (���ν���) => 2��

select a.DEVICE_REPAIR_REQUEST_ID AS "������û����ȣ", a.STOCK_ITEM_ID as "���ǰ��ȣ", g.item_name as "��ǰ��", e.manager_name as " �������̸�", a.DEVICE_REPAIR_REQUEST_DATE as "��û����", a.DEVICE_REPAIR_FAILURE_DATE as "�����Ͻ�", a.DEVICE_REPAIR_FAILURE_SYMPTOM as "��������", a.DEVICE_REPAIR_REQUEST_STATE as "��û����", b.DEVICE_REPIAR_COMPANY_ID as ������ü��ȣ, b.DEVICE_REPAIR_STATE as ��������, c.DEVICE_REPAIR_COMPANY_NAME as ������ü��, c.BUSINESS_NUM as "����ڹ�ȣ", c.DEVICE_REPIAR_COMPANY_MANAGER as ���������, c.DEVICE_REPAIR_COMPANY_TEL as "���� ����ó", d.DEVICE_REPIAR_ID as "�Ƿ������������ȣ", d.DEVICE_REPAIR_COMPLETE_DATE as "���� ������", d.DEVICE_REPAIR_PRICE as "���� �ݾ�", d.DEVICE_REPAIR_CONTENT as "ó�� ����"
from device_repair_request a, device_repair_check b, device_repiar_company c, DEVICE_REPAIR d, manager e, stock_item f, item g
where a.DEVICE_REPAIR_REQUEST_ID = b.DEVICE_REPAIR_REQUEST_ID and b.DEVICE_REPIAR_COMPANY_ID = c.DEVICE_REPIAR_COMPANY_ID and a.MANAGER_ID = e.MANAGER_ID and f.STOCK_ITEM_ID = a.STOCK_ITEM_ID and f.item_id = g.item_id and a.DEVICE_REPAIR_REQUEST_ID = 1;

set serveroutput on;

CREATE OR REPLACE PROCEDURE Request_for_maintenance(p_device_repiar_id in device_repair.device_repiar_id%type)

is
    cursor device_repair_cursors is
        select a.DEVICE_REPAIR_REQUEST_ID AS "������û����ȣ", a.STOCK_ITEM_ID as "���ǰ��ȣ", k.supplier_name as "���޾�ü��", g.item_id as "��ǰ �ڵ�", g.item_name as "��ǰ��",
            i.english_name as "������" ,e.manager_name as "�������̸�", h.department_name as "�μ���", a.DEVICE_REPAIR_REQUEST_DATE as "��û����", a.DEVICE_REPAIR_FAILURE_DATE as "�����Ͻ�",
            a.DEVICE_REPAIR_FAILURE_SYMPTOM as "��������", a.DEVICE_REPAIR_REQUEST_STATE as "��û����", b.DEVICE_REPIAR_COMPANY_ID as ������ü��ȣ,
            b.DEVICE_REPAIR_STATE as ��������, c.DEVICE_REPAIR_COMPANY_NAME as ������ü��, c.BUSINESS_NUM as "����ڹ�ȣ", c.DEVICE_REPIAR_COMPANY_MANAGER as ���������,
            c.DEVICE_REPAIR_COMPANY_TEL as "���� ����ó", d.DEVICE_REPIAR_ID as "�Ƿ������������ȣ", d.DEVICE_REPAIR_COMPLETE_DATE as "���� ������",
            d.DEVICE_REPAIR_PRICE as "���� �ݾ�", d.DEVICE_REPAIR_CONTENT as "ó�� ����"
        from device_repair_request a, device_repair_check b, device_repiar_company c, DEVICE_REPAIR d, manager e,
            stock_item f, item g, department h,medical_device i, contract_supplier j, supplier k
        where a.DEVICE_REPAIR_REQUEST_ID = b.DEVICE_REPAIR_REQUEST_ID and b.DEVICE_REPIAR_COMPANY_ID = c.DEVICE_REPIAR_COMPANY_ID
            and a.MANAGER_ID = e.MANAGER_ID and f.STOCK_ITEM_ID = a.STOCK_ITEM_ID and f.item_id = g.item_id and h.department_no = f.department_no
            and g.contract_supplier_id = j.contract_supplier_id and j.supplier_id = k.supplier_id and a.DEVICE_REPAIR_REQUEST_ID = 1;
    
    device_repair_record device_repair_cursors%rowtype;

begin
    
    for device_repair_record in device_repair_cursors loop
        dbms_output.put_line('======================= �����Ƿڼ� =======================');
        dbms_output.put_line('�������� ' ||'| '|| device_repair_record."��û����" ||' |'|| ' ���� ' ||' |'|| ' ��� ' ||'| '|| ' �븮 ' ||'| '|| ' ���� ');
        dbms_output.put_line(' �� �� �� ' ||'| '|| device_repair_record."�������̸�" ||' '|| '  ' ||' '|| '  ' ||' '|| '  ' ||' '|| '  ');
        dbms_output.put_line('������ȣ ' ||'| '|| p_device_repiar_id ||' '|| '  ' ||' '|| '  ' ||' '|| '  ' ||' '|| '  ');
        dbms_output.put_line('�Ƿںμ� ' ||'| '|| device_repair_record."�μ���" ||' '|| '  ' ||' '|| '  ' ||' '|| '  ' ||' '|| '  ');
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('������ȣ : ' || device_repair_record."�Ƿ������������ȣ"  ||' |'|| ' ���ǰ��ȣ : ' ||' '|| device_repair_record."���ǰ��ȣ" ||' |'|| ' S/N : ' ||' '|| device_repair_record."��ǰ �ڵ�" ||' |'|| ' ���������� : ' || device_repair_record."���� ������");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('��ǰ�� : ' || device_repair_record."��ǰ��" ||' |'|| ' ������ : ' || device_repair_record."������");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('����ó : ' || device_repair_record."���޾�ü��");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('�������(�����) : ' || device_repair_record."��������");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('�߻��Ͻ� : ' || device_repair_record."�����Ͻ�" ||' |' || ' �������� : ' || device_repair_record."���� ������" ||' | '|| '�������̸� : ' || device_repair_record."�������̸�");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('������û���� : ' || device_repair_record."��û����" || ' | '|| '�������� : ' || device_repair_record."��������" );
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('���񳻿� : ' || device_repair_record."ó�� ����");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('�������� : ' || device_repair_record."���� �ݾ�");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('�� �� å���� : ' || device_repair_record."���������"||' |' || ' ���� ����ó : ' || device_repair_record."���� ����ó");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('����� ��ȣ : ' || device_repair_record."����ڹ�ȣ" || ' | ' || '������ü�� : ' || device_repair_record."������ü��" || ' |' || ' ������ü��ȣ : ' || device_repair_record."������ü��ȣ");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('');
    end loop;
end;

execute Request_for_maintenance(1);

-- ���� �󰨱ݾ� ���� => 3��

select * from medical_device;
select * from contract_supplier;

CREATE TABLE item_name (  -- ��ǰ��
  commodity_classification_code number primary key,
  classification_name varchar2(200) not null
);

insert into item_name values(101, '��ǰ');
insert into item_name values(102, '�Ǿ�ǰ');
insert into item_name values(103, '�Ƿ���');

select a.supplier_id as "���޾�ü��ȣ", d.supplier_name as "���޾�ü��", a.contract_name as "����", a.contract_date as "�������", a.content as "��೻��", a.contract_supplier_id as "����ó ��ȣ",  b.item_id as "��ǰ�ڵ�", b.commodity_classification_code as "��ǰ�з��ڵ�", f.classification_name as "��ǰ�з���", b.item_name as "��ǰ��", b.item_price as "�ܰ�", b.manufacturer as "������", c.grade as "�󰨵��" ,b.item_price- (b.item_price * c.discount_cost) AS �󰨱ݾ�
from contract_supplier a inner join item b
on a.contract_supplier_id = b.contract_supplier_id
left join trigonometry c on a.contract_date between c.min_year and c.max_year
inner join supplier d on a.supplier_id = d.supplier_id
left join item_name f on b.commodity_classification_code = f.commodity_classification_code;

create or replace view amortization as (select a.supplier_id as "���޾�ü��ȣ", d.supplier_name as "���޾�ü��", a.contract_name as "����", a.contract_date as "�������", a.content as "��೻��",
    a.contract_supplier_id as "����ó ��ȣ", b.item_id as "��ǰ�ڵ�", b.commodity_classification_code as "��ǰ�з��ڵ�", f.classification_name as "��ǰ�з���",
    b.item_name as "��ǰ��", b.item_price as "�ܰ�", b.manufacturer as "������", c.grade as "�󰨵��" ,b.item_price- (b.item_price * c.discount_cost) AS �󰨱ݾ�
from contract_supplier a inner join item b
on a.contract_supplier_id = b.contract_supplier_id
left join trigonometry c on a.contract_date between c.min_year and c.max_year
inner join supplier d on a.supplier_id = d.supplier_id
left join item_name f on b.commodity_classification_code = f.commodity_classification_code);

select * from amortization;

SELECT
    "��ǰ��",
    "�ܰ�",
    "�󰨵��",
    SUM(�ܰ� - �󰨱ݾ�) AS ���ıݾ�,
    SUM(�󰨱ݾ�) AS �󰨵ȱݾ�
FROM amortization
GROUP BY ROLLUP ("��ǰ��", "�ܰ�", "�󰨵��")  
ORDER BY "��ǰ��", "�ܰ�", "�󰨵��", ���ıݾ� DESC;



--- ���� ������

-- �󰢹�� 
INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('4', TO_DATE('YYYY-MM-DD', '2009-12-31'), TO_DATE('YYYY-MM-DD', '2005-01-01'), 0.4);

INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('3', TO_DATE('YYYY-MM-DD', '2014-12-31'), TO_DATE('YYYY-MM-DD', '2010-01-01'), 0.3);

INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('2', TO_DATE('YYYY-MM-DD', '2019-12-31'), TO_DATE('YYYY-MM-DD', '2015-01-01'), 0.2);

INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('1', TO_DATE('YYYY-MM-DD', '2024-12-31'), TO_DATE('YYYY-MM-DD', '2020-01-01'), 0.0);


-- ���޾�ü ������ 15�� ����
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (1, '���޾�ü1', '123-45-6789', '010-1234-5678', '����� ������ ������� 1�� 1', '����', '12345');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (2, '���޾�ü2', '223-45-6789', '010-2234-5678', '����� ������ ������� 2�� 2', '����', '12346');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (3, '���޾�ü3', '323-45-6789', '010-3234-5678', '����� ������ ������� 3�� 3', '����', '12347');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (4, '���޾�ü4', '423-45-6789', '010-4234-5678', '����� ������ ������� 4�� 4', '����', '12348');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (5, '���޾�ü5', '523-45-6789', '010-5234-5678', '����� ������ ������� 5�� 5', '����', '12349');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (6, '���޾�ü6', '623-45-6789', '010-6234-5678', '����� ������ ������� 6�� 6', '����', '12350');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (7, '���޾�ü7', '723-45-6789', '010-7234-5678', '����� ������ ������� 7�� 7', '����', '12351');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (8, '���޾�ü8', '823-45-6789', '010-8234-5678', '����� ������ ������� 8�� 8', '����', '12352');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (9, '���޾�ü9', '923-45-6789', '010-9234-5678', '����� ������ ������� 9�� 9', '����', '12353');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (10, '���޾�ü10', '1023-45-6789', '010-1023-5678', '����� ������ ������� 10�� 10', '����', '12354');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (11, '���޾�ü11', '1123-45-6789', '010-1123-5678', '����� ������ ������� 11�� 11', '����', '12355');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (12, '���޾�ü12', '1223-45-6789', '010-1223-5678', '����� ������ ������� 12�� 12', '����', '12356');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (13, '���޾�ü13', '1323-45-6789', '010-1323-5678', '����� ������ ������� 13�� 13', '����', '12357');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (14, '���޾�ü14', '1423-45-6789', '010-1423-5678', '����� ������ ������� 14�� 14', '����', '12358');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (15, '���޾�ü15', '1523-45-6789', '010-1523-5678', '����� ������ ������� 15�� 15', '����', '12359');

-- ��� ����ó 20�� ������ ����
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (1, '������ó1', TO_DATE('2023-01-01', 'YYYY-MM-DD'), '��� ���� 1', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (2, '������ó2', TO_DATE('2023-02-01', 'YYYY-MM-DD'), '��� ���� 2', 2);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (3, '������ó3', TO_DATE('2023-03-01', 'YYYY-MM-DD'), '��� ���� 3', 3);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (4, '������ó4', TO_DATE('2023-04-01', 'YYYY-MM-DD'), '��� ���� 4', 4);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (5, '������ó5', TO_DATE('2023-05-01', 'YYYY-MM-DD'), '��� ���� 5', 5);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (6, '������ó6', TO_DATE('2023-06-01', 'YYYY-MM-DD'), '��� ���� 6', 6);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (7, '������ó7', TO_DATE('2023-07-01', 'YYYY-MM-DD'), '��� ���� 7', 7);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (8, '������ó8', TO_DATE('2023-08-01', 'YYYY-MM-DD'), '��� ���� 8', 8);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (9, '������ó9', TO_DATE('2023-09-01', 'YYYY-MM-DD'), '��� ���� 9', 9);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (10, '������ó10', TO_DATE('2023-10-01', 'YYYY-MM-DD'), '��� ���� 10', 10);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (11, '������ó11', TO_DATE('2023-11-01', 'YYYY-MM-DD'), '��� ���� 11', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (12, '������ó12', TO_DATE('2023-12-01', 'YYYY-MM-DD'), '��� ���� 12', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (13, '������ó13', TO_DATE('2024-01-01', 'YYYY-MM-DD'), '��� ���� 13', 13);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (14, '������ó14', TO_DATE('2024-02-01', 'YYYY-MM-DD'), '��� ���� 14', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (15, '������ó15', TO_DATE('2024-03-01', 'YYYY-MM-DD'), '��� ���� 15', 15);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (16, '������ó16', TO_DATE('2024-04-01', 'YYYY-MM-DD'), '��� ���� 16', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (17, '������ó17', TO_DATE('2024-05-01', 'YYYY-MM-DD'), '��� ���� 17', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (18, '������ó18', TO_DATE('2024-06-01', 'YYYY-MM-DD'), '��� ���� 18', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (19, '������ó19', TO_DATE('2024-07-01', 'YYYY-MM-DD'), '��� ���� 19', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (20, '������ó20', TO_DATE('2024-08-01', 'YYYY-MM-DD'), '��� ���� 20', 2);

-- ���� ��ǰ 20�� ������ ����
INSERT INTO item (item_id, commodity_classification_code, contract_supplier_id, item_name, item_price, manufacturer) VALUES (1, 1, '��ǰ1', 1000, '������1', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (2, 1,'��ǰ2', 2000, '������2', 2);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (3, 1,'��ǰ3', 3000, '������3', 3);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (4, 1,'��ǰ4', 4000, '������4', 4);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (5, 1,'��ǰ5', 5000, '������5', 5);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (6, 2,'��ǰ6', 6000, '������6', 6);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (7, 2,'��ǰ7', 7000, '������7', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (8, 2,'��ǰ8', 8000, '������8', 8);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (9, 2,'��ǰ9', 9000, '������9', 9);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (10, 2,'��ǰ10', 10000, '������10', 10);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (11, 3,'��ǰ11', 11000, '������11', 11);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (12, 3,'��ǰ12', 12000, '������12', 12);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (13, 3,'��ǰ13', 13000, '������13', 13);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (14, 3,'��ǰ14', 14000, '������14', 14);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (15, 3,'��ǰ15', 15000, '������15', 15);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (16, 3,'��ǰ16', 16000, '������16', 16);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (17, 3,'��ǰ17', 17000, '������17', 17);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (18, 3,'��ǰ18', 18000, '������18', 18);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (19, 3,'��ǰ19', 19000, '������19', 19);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (20, 3,'��ǰ20', 20000, '������20', 20);



-- �μ� 20�� ������ ���� 
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (1, '����', 'ȫ�浿', '2��', '02-1234-5678');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (2, '�ܰ�', '�̼���', '3��', '02-2345-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (3, '�Ҿư�', '������', '4��', '02-3456-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (4, '����ΰ�', '������', '5��', '02-4567-8901');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (5, '�����ܰ�', '�庸��', '6��', '02-5678-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (6, '�Ű��', '���߱�', '7��', '02-6789-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (7, '�Ǻΰ�', '�豸', '8��', '02-7890-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (8, '�񴢱��', '������', '9��', '02-8901-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (9, '�Ȱ�', '��âȣ', '10��', '02-9012-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (10, 'ġ��', '������', '11��', '02-0123-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (11, '�̺����İ�', '������', '12��', '02-1234-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (12, '��Ȱ���а�', '������', '13��', '02-2345-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (14, '�������а�', '�����', '1��', '02-4567-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (15, '�������а�', '��ȫ��', '15��', '02-5678-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (16, '���峻��', '������', '16��', '02-6789-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (17, '�������系��', '�̽¸�', '17��', '02-7890-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (18, '��ȭ�⳻��', '������', '18��', '02-8901-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (19, 'ȣ��⳻��', '�����', '19��', '02-9012-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (20, '���к񳻰�', '�빫��', '20��', '02-0123-5678');

--�μ�����ǰ��
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (1, 1);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (2, 2);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (3, 3);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (4, 4);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (5, 5);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (6, 6);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (7, 7);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (8, 8);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (9, 9);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (10, 10);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (11, 11);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (12, 12);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (14, 14);

-- û����ǰ ������ 20�� ����
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (1, 1, 1, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (2, 1, 2, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (3, 2, 3, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (4, 2, 4, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (5, 3, 5, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (6, 3, 6, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (7, 4, 7, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (8, 4, 8, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (9, 5, 9, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (10, 5, 10, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (11, 6, 11, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (12, 6, 12, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (13, 7, 13, 45, TO_DATE('2024-07-13', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (14, 7, 14, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (15, 8, 15, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (16, 8, 16, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (17, 9, 17, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (18, 9, 18, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (19, 10, 19, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (20,10, 20, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '����');


-- ���ּ� ������ 20�� ����
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (1, '���޾�üA', 50000, '���ּ�1');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (2, '���޾�üB', 120000, '���ּ�2');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (3, '���޾�üC', 75000, '���ּ�3');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (4, '���޾�üD', 200000, '���ּ�4');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (5, '���޾�üE', 95000, '���ּ�5');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (6, '���޾�üF', 130000, '���ּ�6');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (7, '���޾�üG', 110000, '���ּ�7');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (8, '���޾�üH', 89000, '���ּ�8');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (9, '���޾�üI', 67000, '���ּ�9');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (10, '���޾�üJ', 150000, '���ּ�10');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (11, '���޾�üK', 53000, '���ּ�11');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (12, '���޾�üL', 47000, '���ּ�12');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (13, '���޾�üM', 92000, '���ּ�13');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (14, '���޾�üN', 81000, '���ּ�14');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (15, '���޾�üO', 160000, '���ּ�15');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (16, '���޾�üP', 140000, '���ּ�16');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (17, '���޾�üQ', 103000, '���ּ�17');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (18, '���޾�üR', 75000, '���ּ�18');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (19, '���޾�üS', 125000, '���ּ�19');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (20, '���޾�üT', 68000, '���ּ�20');

-- ���ֹ�ǰ ������ 20�� ����
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (1, 1, 1, 1000, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (2, 2, 2, 2000, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (3, 3, 3, 3000, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (4, 4, 4, 4000, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (5, 5, 5, 5000, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (6, 6, 6, 6000, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (7, 7, 7, 7000, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (8, 8, 8, 8000, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (9, 9, 9, 9000, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (10, 10, 10, 10000, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (11, 11, 11, 11000, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (12, 12, 12, 12000, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (13, 13, 13, 13000, 45, TO_DATE('2024-07-13', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (14, 14, 14, 14000, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (15, 15, 15, 15000, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (16, 16, 16, 16000, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (17, 17, 17, 17000, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (18, 18, 18, 18000, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (19, 19, 19, 19000, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (20, 20, 20, 20000, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '�԰�');

-- ���ǰ 20�� ������ ���
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (1, 1, 1, 50, 100, 75);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (2, 2, 2, 30, 80, 60);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (3, 3, 3, 20, 60, 40);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (4, 4, 4, 40, 90, 70);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (5, 5, 5, 25, 75, 50);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (6, 6, 6, 35, 85, 65);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (7, 7, 7, 45, 95, 80);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (8, 8, 8, 55, 105, 85);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (9, 9, 9, 65, 115, 90);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (10, 10, 10, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (11, 11, 11, 50, 100, 75);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (12, 12, 12, 30, 80, 60);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (14, 14, 14, 40, 90, 70);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (15, 15, 15, 25, 75, 50);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (16, 16, 16, 35, 85, 65);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (17, 17, 17, 45, 95, 80);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (18, 18, 18, 55, 105, 85);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (19, 19, 19, 65, 115, 90);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (20, 20, 20, 75, 125, 100);

-- ��ǰ����̷� ������ 20��
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 50);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (2, 2, TO_DATE('2024-01-02', 'YYYY-MM-DD'), 30);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (3, 3, TO_DATE('2024-01-03', 'YYYY-MM-DD'), 20);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (4, 4, TO_DATE('2024-01-04', 'YYYY-MM-DD'), 40);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (5, 5, TO_DATE('2024-01-05', 'YYYY-MM-DD'), 25);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (6, 6, TO_DATE('2024-01-06', 'YYYY-MM-DD'), 35);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (7, 7, TO_DATE('2024-01-07', 'YYYY-MM-DD'), 45);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (8, 8, TO_DATE('2024-01-08', 'YYYY-MM-DD'), 15);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (9, 9, TO_DATE('2024-01-09', 'YYYY-MM-DD'), 50);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (10,10, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 20);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (11, 11, TO_DATE('2024-01-11', 'YYYY-MM-DD'), 30);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (12, 12, TO_DATE('2024-01-12', 'YYYY-MM-DD'), 60);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (13, 13, TO_DATE('2024-01-13', 'YYYY-MM-DD'), 25);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (14, 14, TO_DATE('2024-01-14', 'YYYY-MM-DD'), 35);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (15, 15, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 45);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (16, 16, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 55);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (17, 17, TO_DATE('2024-01-17', 'YYYY-MM-DD'), 20);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (18, 18, TO_DATE('2024-01-18', 'YYYY-MM-DD'), 50);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (19, 19, TO_DATE('2024-01-19', 'YYYY-MM-DD'), 40);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (20, 20, TO_DATE('2024-01-20', 'YYYY-MM-DD'), 30);

-- ���˸�� �� ������ 20�� ����
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (1, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (2, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (3, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (4, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (5, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (6, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (7, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (8, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (9, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (10, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (11, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (12, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (13, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (14, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (15, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (16, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (17, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (18, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (19, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (20, '�۵�Ȯ��');

-- MANAGER ���̺� 30�� ���
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (1, '��ö��', '010-1111-1111', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (2, '�̿���', '010-2222-2222', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (3, '�ڹμ�', '010-3333-3333', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (4, '������', '010-4444-4444', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (5, '������', '010-5555-5555', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (6, '�����', '010-6666-6666', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (7, '�̼���', '010-7777-7777', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (8, '������', '010-8888-8888', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (9, '�ּ���', '010-9999-9999', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (10, '����ȣ', '010-1010-1010', 10);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (11, '��ҿ�', '010-1111-0000', 11);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (12, '����ȣ', '010-2222-1111', 12);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (14, '�ֿ���', '010-4444-3333', 14);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (15, '���켺', '010-5555-4444', 15);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (16, '������', '010-6666-5555', 16);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (17, '�̹�ȣ', '010-7777-6666', 17);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (18, '�ں���', '010-8888-7777', 18);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (19, '������', '010-9999-8888', 19);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (20, '������', '010-1010-9999', 20);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (21, '�����', '010-1212-1212', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (22, '�̵���', '010-2323-2323', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (23, '�ڽ���', '010-3434-3434', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (24, '�ּ���', '010-4545-4545', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (25, '��ä��', '010-5656-5656', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (26, '������', '010-6767-6767', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (27, '������', '010-7878-7878', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (28, '������', '010-8989-8989', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (29, '�ֿ���', '010-9090-9090', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (30, '���ҹ�', '010-0000-0000', 10);

-- �Ƿ������˸�� ������ 20�� ����
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (1, 01, '���˸��1', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (2, 02, '���˸��2', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (3, 03, '���˸��3', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (4, 04, '���˸��4', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (5, 05, '���˸��5', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (6, 06, '���˸��6', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (7, 07, '���˸��7', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (8, 08, '���˸��8', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (9, 09, '���˸��9', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (10, 10, '���˸��10', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (11, 11, '���˸��11', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (12, 12, '���˸��12', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (14, 14, '���˸��14', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (15, 15, '���˸��15', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (16, 16, '���˸��16', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (17, 17, '���˸��17', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (18, 18, '���˸��18', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (19, 19, '���˸��19', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (20, 20, '���˸��20', '����');


-- �Ƿ������� ������ 10�� ����
INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (1, 1, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '����', 3);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (2, 2, 2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '����', 5);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (3, 5, 5, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '����', 7);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (4, 6, 6, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '����', 9);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (5, 7, 7, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '����', 11);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (6, 8, 8, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '����', 12);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (7, 9, 9, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '����', 15);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (8, 10, 10, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '����', 16);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (9, 11, 11, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '����', 17);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (10, 12, 12, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '����', 18);

-- ��� ���̺� ������ 18�� ����
INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (1, 1, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), '����1', 10);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (2, 2, 2, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-06-16', 'YYYY-MM-DD'), '����2', 20);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (3, 3, 3, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-06-17', 'YYYY-MM-DD'), '����3', 30);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (4, 4, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-06-18', 'YYYY-MM-DD'), '����4', 40);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (5, 5, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-19', 'YYYY-MM-DD'), '����5', 50);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (6, 6, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), '����6', 60);
INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (7, 7, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-06-21', 'YYYY-MM-DD'), '����7', 70);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (8, 8, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-06-22', 'YYYY-MM-DD'), '����8', 80);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (9, 9, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-06-23', 'YYYY-MM-DD'), '����9', 90);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (10, 10, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-06-24', 'YYYY-MM-DD'), '����10', 100);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (11, 11, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), '����11', 110);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (12, 12, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-06-26', 'YYYY-MM-DD'), '����12', 120);


INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (14, 14, 14, TO_DATE('2024-06-14', 'YYYY-MM-DD'), TO_DATE('2024-06-28', 'YYYY-MM-DD'), '����14', 140);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (15, 15, 15, TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-29', 'YYYY-MM-DD'), '����15', 150);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (16, 16, 16, TO_DATE('2024-06-16', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), '����16', 160);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (17, 17, 17, TO_DATE('2024-06-17', 'YYYY-MM-DD'), TO_DATE('2024-07-01', 'YYYY-MM-DD'), '����17', 170);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (18, 18, 18, TO_DATE('2024-06-18', 'YYYY-MM-DD'), TO_DATE('2024-07-02', 'YYYY-MM-DD'), '����18', 180);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (19, 19, 19, TO_DATE('2024-06-19', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), '����19', 190);


-- �Ƿ��� ������û 11�� ������ ����
INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (1, 2, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-05-30', 'YYYY-MM-DD'), '���� �� ����', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (2, 5, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-05-29', 'YYYY-MM-DD'), 'ȭ�� ������', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (3, 4, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-05-28', 'YYYY-MM-DD'), '���͸� ����', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (4, 6, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-05-27', 'YYYY-MM-DD'), '�Ҹ� �� ��', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (5, 7, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-05-26', 'YYYY-MM-DD'), '��ġ �� ��', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (6, 8, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), '���� �� ��', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (7, 9, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-05-24', 'YYYY-MM-DD'), 'ī�޶� ����', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (8, 10, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-05-23', 'YYYY-MM-DD'), '�� ���� �� ��', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (9, 11, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'), '���� ����', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (10, 12, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-05-21', 'YYYY-MM-DD'), '������', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (11, 14, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'ȭ�� ����', '��û', '���� ��');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (12, 15, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-05-19', 'YYYY-MM-DD'), '��Ʈ��ũ ����', '��û', '���� ��');

-- �Ƿ��� ���� ��ü ������ 10�� ����
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (1, 'RepairCo', '123-45-6789', 'John Doe', '010-1234-5678');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (2, 'FixItAll', '987-65-4321', 'Jane Smith', '010-8765-4321');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (3, 'DeviceMenders', '456-78-9012', 'Alice Brown', '010-2345-6789');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (4, 'TechRepair', '321-54-9876', 'Bob Johnson', '010-3456-7890');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (5, 'GadgetFixers', '654-32-1098', 'Charlie Davis', '010-4567-8901');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (6, 'QuickFix', '789-01-2345', 'David Wilson', '010-5678-9012');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (7, 'RepairMasters', '234-56-7890', 'Eve White', '010-6789-0123');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (8, 'DeviceDoctors', '890-12-3456', 'Frank Green', '010-7890-1234');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (9, 'GadgetCare', '567-89-0123', 'Grace Black', '010-8901-2345');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (10, 'FixPro', '098-76-5432', 'Hank Gray', '010-9012-3456');

-- �Ƿ��� ���� ������ 10�� ����
INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), 100.00, 'Screen replacement', 1, 1);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), 150.00, 'Battery replacement', 2, 2);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (3, TO_DATE('2024-07-03', 'YYYY-MM-DD'), 200.00, 'Motherboard repair', 3, 3);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (4, TO_DATE('2024-07-04', 'YYYY-MM-DD'), 120.00, 'Software update', 4, 4);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (5, TO_DATE('2024-07-05', 'YYYY-MM-DD'), 80.00, 'Charging port repair', 5, 5);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (6, TO_DATE('2024-07-06', 'YYYY-MM-DD'), 50.00, 'Speaker repair', 6, 6);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (7, TO_DATE('2024-07-07', 'YYYY-MM-DD'), 90.00, 'Camera repair', 7, 7);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (8, TO_DATE('2024-07-08', 'YYYY-MM-DD'), 110.00, 'Keyboard repair', 8, 8);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (9, TO_DATE('2024-07-09', 'YYYY-MM-DD'), 130.00, 'Touchscreen repair', 9, 9);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (10, TO_DATE('2024-07-10', 'YYYY-MM-DD'), 140.00, 'Microphone repair', 10, 10);


-- �Ƿ��� �̵���û�� ������ 15�� ����
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (2, 2, 3, 12, 2, 'Reason 2', TO_DATE('2024-07-02', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (4, 4, 5, 14, 4, 'Reason 4', TO_DATE('2024-07-04', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (5, 5, 6, 15, 5, 'Reason 5', TO_DATE('2024-07-05', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (6, 6, 7, 16, 6, 'Reason 6', TO_DATE('2024-07-06', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (7, 7, 8, 17, 7, 'Reason 7', TO_DATE('2024-07-07', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (8, 8, 9, 18, 8, 'Reason 8', TO_DATE('2024-07-08', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (9, 9, 10, 9, 9, 'Reason 9', TO_DATE('2024-07-09', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (10, 10, 11, 10, 10, 'Reason 10', TO_DATE('2024-07-10', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (11, 11, 12, 21, 11, 'Reason 11', TO_DATE('2024-07-11', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (14, 14, 15, 24, 14, 'Reason 14', TO_DATE('2024-07-14', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (15, 15, 16, 25, 15, 'Reason 15', TO_DATE('2024-07-15', 'YYYY-MM-DD'), '����');

-- �Ƿ����̵����� ������
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date)
SELECT 2, 2, 1, 4, TO_DATE('2024-07-01', 'YYYY-MM-DD')
FROM DUAL
WHERE EXISTS (SELECT 1 FROM stock_item WHERE stock_item_id = 2)
  AND EXISTS (SELECT 1 FROM device_transfer_request WHERE device_transfer_request_id = 2);
  
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date)
SELECT 4, 4, 1, 5, TO_DATE('2024-07-01', 'YYYY-MM-DD')
FROM DUAL
WHERE EXISTS (SELECT 1 FROM stock_item WHERE stock_item_id = 5)
  AND EXISTS (SELECT 1 FROM device_transfer_request WHERE device_transfer_request_id = 5);

select * from stock_item;
select * from item;
--- �Ƿ���
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 2,  2, '�������߻���ġ_Precision x-ray_US/X-RAD_320_320kV_45mA', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 3060000, 'X-ray generator');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 3,  3, 'Ź�������ɺи���  Kubota  JP/4000  5800rpm', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 5940000, 'tabletop centrifuge');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 4,  4, '�Ϲݰ����������  �ѹ����  HB-101L', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 2376000, 'mechanical convection type universal culture machine');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 5,  5, '��ü���̰�  Olympus optical  JP/CH-2', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 1650000, 'stereoscopic microscope');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 6,  6, '�������̰�  Olympus  JP/BX51T', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 22000000, 'fluorescence microscope');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 7,  7, '�Ƿ��и�����ӻ�ȭ���ڵ��м���ġ  Beckman Coulter  JP/AU480  ', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 73828000, 'Automatic Clinical Chemistry Analysis Unit for Medical Separation');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 8,  8, '�Ƿ��б�������  Cholestech  US/LDX', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 6000000, 'medical spectrophotometer');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 9,  9, '�Ƿ��鿪����������ġ  bioMerieux Italia s.p.a  IT/VIDAS PC BLUE  ', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 70532900, 'Medical Immunofluorescence Measurement Device');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 10,  10, '�ڵ������ⱸ  �ٰ�����  AT-2000Z  �����ڵ�������', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 20672000, 'automatic dyeing device');

--������û�Ƿ���
insert into device_repair_request(device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state)
values (1, 2, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), '���� ����', '���δ��');
insert into device_repair_request(device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state)
values (2, 3, 1, TO_DATE('2024-07-03', 'YYYY-MM-DD'), TO_DATE('2024-07-04', 'YYYY-MM-DD'), '�������', '���οϷ�');
insert into device_repair_request(device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state)
values (3, 2, 1, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-07-04', 'YYYY-MM-DD'), '���� ���� �Ҿ�', '������');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (1, 2, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-05-30', 'YYYY-MM-DD'), '���� �� ����', '��û' );

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (2, 5, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-05-29', 'YYYY-MM-DD'), 'ȭ�� ������', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (3, 4, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-05-28', 'YYYY-MM-DD'), '���͸� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (4, 6, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-05-27', 'YYYY-MM-DD'), '�Ҹ� �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (5, 7, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-05-26', 'YYYY-MM-DD'), '��ġ �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (6, 8, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), '���� �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (7, 9, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-05-24', 'YYYY-MM-DD'), 'ī�޶� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (8, 10, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-05-23', 'YYYY-MM-DD'), '�� ���� �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (9, 11, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'), '���� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (10, 12, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-05-21', 'YYYY-MM-DD'), '������', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (11, 14, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'ȭ�� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (12, 15, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-05-19', 'YYYY-MM-DD'), '��Ʈ��ũ ����', '��û');

-- �Ƿ��� ���� ��ü ������ 10�� ����
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (1, 'RepairCo', '123-45-6789', 'John Doe', '010-1234-5678');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (2, 'FixItAll', '987-65-4321', 'Jane Smith', '010-8765-4321');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (3, 'DeviceMenders', '456-78-9012', 'Alice Brown', '010-2345-6789');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (4, 'TechRepair', '321-54-9876', 'Bob Johnson', '010-3456-7890');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (5, 'GadgetFixers', '654-32-1098', 'Charlie Davis', '010-4567-8901');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (6, 'QuickFix', '789-01-2345', 'David Wilson', '010-5678-9012');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (7, 'RepairMasters', '234-56-7890', 'Eve White', '010-6789-0123');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (8, 'DeviceDoctors', '890-12-3456', 'Frank Green', '010-7890-1234');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (9, 'GadgetCare', '567-89-0123', 'Grace Black', '010-8901-2345');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (10, 'FixPro', '098-76-5432', 'Hank Gray', '010-9012-3456');


-- �Ƿ��� ����
INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), 100.00, 'Screen replacement', 1, 1);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), 150.00, 'Battery replacement', 2, 2);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (3, TO_DATE('2024-07-03', 'YYYY-MM-DD'), 200.00, 'Motherboard repair', 3, 3);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (4, TO_DATE('2024-07-04', 'YYYY-MM-DD'), 120.00, 'Software update', 4, 4);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (5, TO_DATE('2024-07-05', 'YYYY-MM-DD'), 80.00, 'Charging port repair', 5, 5);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (6, TO_DATE('2024-07-06', 'YYYY-MM-DD'), 50.00, 'Speaker repair', 6, 6);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (7, TO_DATE('2024-07-07', 'YYYY-MM-DD'), 90.00, 'Camera repair', 7, 7);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (8, TO_DATE('2024-07-08', 'YYYY-MM-DD'), 110.00, 'Keyboard repair', 8, 8);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (9, TO_DATE('2024-07-09', 'YYYY-MM-DD'), 130.00, 'Touchscreen repair', 9, 9);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (10, TO_DATE('2024-07-10', 'YYYY-MM-DD'), 140.00, 'Microphone repair', 10, 10);



--- ���� ������2

-- ���޾�ü ������ 15�� ����
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (1, '��������', '101-23-4567', '010-1111-2222', '����� ������ ����� 123', '����', '06212');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (2, '��������', '202-34-5678', '010-2222-3333', '����� ���ʱ� ���ʴ�� 456', '����', '06542');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (3, '�߾�����', '303-45-6789', '010-3333-4444', '����� ���α� ���� 789', '����', '03154');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (4, '�Ｚ����', '404-56-7890', '010-4444-5555', '����� ������ ������� 101', '����', '04174');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (5, 'LG����', '505-67-8901', '010-5555-6666', '����� �������� ���Ǵ�� 202', '����', '07223');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (6, '��������', '606-78-9012', '010-6666-7777', '����� ������ ȭ��� 303', '����', '07789');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (7, 'SK����', '707-89-0123', '010-7777-8888', '����� ���ı� ���Ĵ�� 404', '����', '05556');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (8, '�Ե�����', '808-90-1234', '010-8888-9999', '����� ������ õȣ��� 505', '����', '05337');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (9, '��ȭ����', '909-01-2345', '010-9999-0000', '����� ����� ����� 606', '����', '01765');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (10, '����������', '010-12-3456', '010-0000-1111', '����� ���빮�� �ջ�� 707', '����', '02534');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (11, 'GS����', '111-23-4567', '010-1111-2222', '����� �߱� ������� 808', '����', '04516');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (12, '�λ�����', '212-34-5678', '010-2222-3333', '����� ���� ����� 909', '����', '03378');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (13, '�����ȭ������', '313-45-6789', '010-3333-4444', '����� ���빮�� ���Ϸ� 1010', '����', '03748');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (14, '�ż�������', '414-56-7890', '010-4444-5555', '����� ���α� ���ε��� 1111', '����', '08378');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (15, '�̸�Ʈ����', '515-67-8901', '010-5555-6666', '����� ���Ǳ� ���Ƿ� 1212', '����', '08734');


-- ��� ����ó 20�� ������ ����
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (1, '�����Ƿ�� �Ƿ� ��� ���� ��� 2023', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'MRI �� CT ��� ���� ���', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (2, '�������б� �Ƿ�� �Ƿ� �Ҹ�ǰ ���� ��� 2023', TO_DATE('2023-02-01', 'YYYY-MM-DD'), '�ֻ�� �� �Ҹ�ǰ ���� ���', 2);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (3, '�Ｚ���ﺴ�� �Ƿ� ��ǰ ���� ��� 2023', TO_DATE('2023-03-01', 'YYYY-MM-DD'), '�׻��� �� ������ ���� ���', 3);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (4, '����ƻ꺴�� �Ƿ� ��� �������� ��� 2023', TO_DATE('2023-04-01', 'YYYY-MM-DD'), 'MRI �� CT ��� �������� ���', 4);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (5, '���Ｚ�𺴿� �Ƿ� ������ ���� ��� 2023', TO_DATE('2023-05-01', 'YYYY-MM-DD'), 'ȯ�� ������ ���� �ý��� ���', 5);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (6, '�Ѿ���б����� �Ƿ� �Ҹ�ǰ ���� ��� 2023', TO_DATE('2023-06-01', 'YYYY-MM-DD'), '������ �Ҹ�ǰ ���� ���', 6);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (7, '������б����� �Ƿ� ��� ���� ��� 2023', TO_DATE('2023-07-01', 'YYYY-MM-DD'), '������ �� �������� ��� ���� ���', 7);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (8, '�д缭����б����� �Ƿ� �Ҹ�ǰ ���� ��� 2023', TO_DATE('2023-08-01', 'YYYY-MM-DD'), '��ȸ�� �Ƿ� �Ҹ�ǰ ���� ���', 8);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (9, '������б��Ƿ�� �Ƿ� ��ǰ ���� ��� 2023', TO_DATE('2023-09-01', 'YYYY-MM-DD'), '�׾��� �� �鿪������ ���� ���', 9);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (10, '�̴�񵿺��� �Ƿ� ��� �������� ��� 2023', TO_DATE('2023-10-01', 'YYYY-MM-DD'), '�Ƿ� ��� �������� �� ���� ���', 10);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (11, '�߾Ӵ��б����� �Ƿ� ������ ���� ��� 2023', TO_DATE('2023-11-01', 'YYYY-MM-DD'), '�Ƿ� ���� �ý��� ���� ���', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (12, '���縯���б� �����μ��𺴿� �Ƿ� �Ҹ�ǰ ���� ��� 2023', TO_DATE('2023-12-01', 'YYYY-MM-DD'), '������ �Ҹ�ǰ ���� ���', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (13, '��õ����б� ��õ���� �Ƿ� ��� ���� ��� 2024', TO_DATE('2024-01-01', 'YYYY-MM-DD'), '������ �� MRI ��� ���� ���', 13);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (14, '���ϴ��б����� �Ƿ� �Ҹ�ǰ ���� ��� 2024', TO_DATE('2024-02-01', 'YYYY-MM-DD'), '������ �Ҹ�ǰ ���� ���', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (15, '��������������� �Ƿ� ��ǰ ���� ��� 2024', TO_DATE('2024-03-01', 'YYYY-MM-DD'), '�׻��� �� ������ ���� ���', 15);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (16, '�Ǳ����б����� �Ƿ� ��� �������� ��� 2024', TO_DATE('2024-04-01', 'YYYY-MM-DD'), '�Ƿ� ��� �������� �� ��ü ���', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (17, '������б����� �Ƿ� ������ ���� ��� 2024', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'ȯ�� ������ ���� �ý��� ���', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (18, '�Ѹ����б� ���ɺ��� �Ƿ� �Ҹ�ǰ ���� ��� 2024', TO_DATE('2024-06-01', 'YYYY-MM-DD'), '������ �Ҹ�ǰ ���� ���', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (19, '����Ư���� ����ź��� �Ƿ� ��� ���� ��� 2024', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 'MRI �� CT ��� ���� ���', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (20, '�λ���б����� �Ƿ� �Ҹ�ǰ ���� ��� 2024', TO_DATE('2024-08-01', 'YYYY-MM-DD'), '������ �Ҹ�ǰ ���� ���', 2);

select * from contract_supplier;
-- ���� ��ǰ 20�� ������ ����
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (1, 102, '�׶��÷糪��ƮŸ��', 6750, 'GSK', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (2, 102,'���ݿ���������', 2760, '��ȭ��ǰ(��)', 2);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (3, 101,'����긮�� KF94 �̼����� ����ũ', 19800, '����������ũ', 3);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (4, 103,'�������̹߻���', 3060000, '��� �Ƿ���', 4);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (5, 102,'���Ǹ�ť��', 2860, '��������(��)', 5);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (6, 102,'���ͺ�������', 2800, '�������', 6);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (7, 102,'����ġ��������', 1000, '��������(��)', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (8, 102,'����ī���ɾ��', 5560, '��������(��)', 8);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (9, 102,'�������ö�Ÿ', 11600, '���������', 9);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (10, 102,'�λ絹�÷�����', 33500, '��������(��)', 10);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (11, 101,'PRIMO �̼����� ����ũ KF94', 13900, '������ ����ũ', 11);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (12, 101,'����긮�� KF94 �̼����� ����ũ', 10000, '����������ũ', 12);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (13, 101,'���ζ������� ���� �ʹ̼����� Ȳ�� �濪����ũ KF94', 3700, '�濪Ȳ�縶��ũ ������', 13);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (14, 103,'�������̰�', 22000000, '�Ѻ������Ƿ��(��ϵ�)', 14);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (15, 103,'��Ƽ�̵������̰�', 1038000, '����Ƿ��', 15);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (16, 103,'�ȸ�����', 1998000, '��� �Ƿ���', 16);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (17, 101,'�Ĵ��� KF94 TPE ����ũ ', 7000, '�Ĵ���', 17);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (18, 103,'�����йڼ�ȯ��ġ', 1384000, '���ȸ޵��ɾ�', 18);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (19, 103,'�Ƴ׷��̵����а�', 132000, '�¿��޵�Į', 19);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (21, 103,'Ź�������ɺи���', 5940000, 'SK �޵�Į', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (22, 103,'������ȯ�ĶǴ±�����Ĺ������', 2376000, 'SK �޵�Į', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (23, 103,'��ü���̰�', 1650000, '�¿��޵�Į', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (24, 103,'�Ƿ��и�����ӻ�ȭ���ڵ��м���ġ', 73828000, 'SK �޵�Į', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (25, 103,'�ɹ�ġ���뱤���ձ�Ǵ¾׼�����', 400000, '�Ѻ������Ƿ��(��ϵ�)', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (26, 103,'ü���км���', 12500000, 'SK �޵�Į', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (27, 103,'�����뷹�����Ǵ¾׼�����', 8370000, 'SK �޵�Į', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (28, 103,'�������ڱر�', 2735000, 'SK �޵�Į', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (29, 103,'���ο�¿���', 1089000, 'SK �޵�Į', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (30, 103,'���ο������ڱر�(��Ÿ����)', 700000, 'SK �޵�Į', 7);


-- �μ� 20�� ������ ���� 
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (1, '����', 'ȫ�浿', '2��', '02-1234-5678');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (2, '�ܰ�', '�̼���', '3��', '02-2345-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (3, '�Ҿư�', '������', '4��', '02-3456-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (4, '����ΰ�', '������', '5��', '02-4567-8901');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (5, '�����ܰ�', '�庸��', '6��', '02-5678-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (6, '�Ű��', '���߱�', '7��', '02-6789-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (7, '�Ǻΰ�', '�豸', '8��', '02-7890-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (8, '�񴢱��', '������', '9��', '02-8901-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (9, '�Ȱ�', '��âȣ', '10��', '02-9012-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (10, 'ġ��', '������', '11��', '02-0123-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (11, '�̺����İ�', '������', '12��', '02-1234-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (12, '��Ȱ���а�', '������', '13��', '02-2345-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (14, '�������а�', '�����', '1��', '02-4567-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (15, '�������а�', '��ȫ��', '15��', '02-5678-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (16, '���峻��', '������', '16��', '02-6789-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (17, '�������系��', '�̽¸�', '17��', '02-7890-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (18, '��ȭ�⳻��', '������', '18��', '02-8901-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (19, 'ȣ��⳻��', '�����', '19��', '02-9012-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (20, '���к񳻰�', '�빫��', '20��', '02-0123-5678');

--�μ�����ǰ��
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (1, 1);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (2, 2);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (3, 3);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (4, 4);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (5, 5);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (6, 6);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (7, 7);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (8, 8);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (9, 9);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (10, 10);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (11, 11);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (12, 12);
insert into department_frequent_item (DEPARTMENT_NO, item_id) values (14, 14);

-- û����ǰ ������ 20�� ����
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (1, 1, 1, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (2, 1, 2, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (3, 2, 3, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (4, 2, 4, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (5, 3, 5, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (6, 3, 6, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (7, 4, 7, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (8, 4, 8, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (9, 5, 9, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (10, 5, 10, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (11, 6, 11, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (12, 6, 12, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (13, 7, 13, 45, TO_DATE('2024-07-13', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (14, 7, 14, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (15, 8, 15, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (16, 8, 16, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (17, 9, 17, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (18, 9, 18, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '�ջ�');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (19, 10, 19, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '����');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (20,10, 20, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '����');


-- ���ּ� ������ 20�� ����
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (1, '���޾�üA', 50000, '���ּ�1');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (2, '���޾�üB', 120000, '���ּ�2');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (3, '���޾�üC', 75000, '���ּ�3');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (4, '���޾�üD', 200000, '���ּ�4');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (5, '���޾�üE', 95000, '���ּ�5');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (6, '���޾�üF', 130000, '���ּ�6');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (7, '���޾�üG', 110000, '���ּ�7');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (8, '���޾�üH', 89000, '���ּ�8');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (9, '���޾�üI', 67000, '���ּ�9');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (10, '���޾�üJ', 150000, '���ּ�10');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (11, '���޾�üK', 53000, '���ּ�11');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (12, '���޾�üL', 47000, '���ּ�12');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (13, '���޾�üM', 92000, '���ּ�13');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (14, '���޾�üN', 81000, '���ּ�14');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (15, '���޾�üO', 160000, '���ּ�15');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (16, '���޾�üP', 140000, '���ּ�16');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (17, '���޾�üQ', 103000, '���ּ�17');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (18, '���޾�üR', 75000, '���ּ�18');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (19, '���޾�üS', 125000, '���ּ�19');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (20, '���޾�üT', 68000, '���ּ�20');

-- ���ֹ�ǰ ������ 20�� ����
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (1, 1, 1, 1000, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (2, 2, 2, 2000, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (3, 3, 3, 3000, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (4, 4, 4, 4000, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (5, 5, 5, 5000, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (6, 6, 6, 6000, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (7, 7, 7, 7000, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (8, 8, 8, 8000, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (9, 9, 9, 9000, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (10, 10, 10, 10000, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (11, 11, 11, 11000, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (12, 12, 12, 12000, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (14, 14, 14, 14000, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (15, 15, 15, 15000, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (16, 16, 16, 16000, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (17, 17, 17, 17000, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (18, 18, 18, 18000, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '�ҷ�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (19, 19, 19, 19000, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '�԰�');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (20, 20, 20, 20000, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '�԰�');

-- ���ǰ 20�� ������ ���
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (1, 1, 1, 50, 100, 75);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (2, 2, 2, 30, 80, 60);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (3, 3, 3, 20, 60, 40);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (4, 4, 4, 40, 90, 70);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (5, 5, 5, 25, 75, 50);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (6, 6, 6, 35, 85, 65);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (7, 7, 7, 45, 95, 80);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (8, 8, 8, 55, 105, 85);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (9, 9, 9, 65, 115, 90);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (10, 10, 10, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (11, 11, 11, 50, 100, 75);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (12, 12, 12, 30, 80, 60);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (14, 14, 14, 40, 90, 70);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (15, 15, 15, 25, 75, 50);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (16, 16, 16, 35, 85, 65);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (17, 17, 17, 45, 95, 80);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (18, 18, 18, 55, 105, 85);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (19, 19, 19, 65, 115, 90);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (20, 20, 20, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (21, 21, 10, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (22, 22, 12, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (23, 23, 14, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (24, 24, 11, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (25, 25, 9, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (26, 26, 1, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (27, 27, 4, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (28, 28, 11, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (29, 29, 12, 75, 125, 100);
INSERT INTO STOCK_ITEM (STOCK_ITEM_ID, ITEM_ID, DEPARTMENT_NO, SAFE_STOCK, OPTIMAL_STOCK, CURRENT_STOCK) VALUES (30, 30, 15, 75, 125, 100);


-- �Ƿ��� ���̺� ����
INSERT INTO medical_device VALUES (4,  1, '�������߻���ġ_Precision x-ray_US/X-RAD_320_320kV_45mA', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 306000, 'X-ray generator');
INSERT INTO medical_device VALUES (14, 2, '�������̰�  Olympus  JP/BX51T', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 2200000, 'fluorescence microscope');
INSERT INTO medical_device VALUES (15, 3, '��Ƽ�̵������̰�  Boyalok visiontech  CN/SmokerView', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 103800, 'Multimedia Imaging Microscope');
INSERT INTO medical_device VALUES (16, 4, 'CN/EP1280 K', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 187000, 'massage chair');
INSERT INTO medical_device VALUES (18, 5, 'Mark �� plus(MK-300)', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 138400, 'quadriplegic compression circulation system');
INSERT INTO medical_device VALUES (19, 6, '�Ƴ׷��̵�����а� ALP-K2 JP/500V �ȶ���', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 13200, 'aneroid blood pressure gauge');
INSERT INTO medical_device VALUES (20, 7, 'MX50+Xplorer900-1', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 15000, 'X-ray');
INSERT INTO medical_device VALUES (21, 8, 'Ź�������ɺи���  Kubota  JP/4000  5800rpm', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 594000, 'tabletop centrifuge');
INSERT INTO medical_device VALUES (22, 9, '�Ϲݰ����������  �ѹ����  HB-101L', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 237600, 'mechanical convection type universal culture machine');
INSERT INTO medical_device VALUES (23, 10, '��ü���̰�  Olympus optical  JP/CH-2', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 165000, 'stereoscopic microscope');
INSERT INTO medical_device VALUES (24, 11, '�Ƿ��и�����ӻ�ȭ���ڵ��м���ġ  Beckman Coulter  JP/AU480  400test/h', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 738280, 'Automatic Clinical Chemistry Analysis Unit for Medical Separation');
INSERT INTO medical_device VALUES (25, 12, 'ġ���밡�ñ������ձ�', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 40000, 'Aesthetic Dental Melt Polymer');
INSERT INTO medical_device VALUES (26, 13, 'ü����������  �Ĵн�  FA-600  ADC����ȸ�ιױ��м���', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 1250000, 'body composition analyzer');
INSERT INTO medical_device VALUES (27, 14, '�Ƿ�뷹���������  ������ũ���  SALUS-TALENT  Diode', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 837000, 'surgical laser');
INSERT INTO medical_device VALUES (28, 15, 'Homer ion  JP/TENS 21  19mA', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 273500, 'low-frequency stimulator');
INSERT INTO medical_device VALUES (29, 16, '������', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 108900, 'personal heater');
INSERT INTO medical_device VALUES (30, 17, 'HS700-C', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 70000, 'Personal Combination Stimulator');


-- ��ǰ����̷� ������ 20��
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 50);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (2, 2, TO_DATE('2024-01-02', 'YYYY-MM-DD'), 30);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (3, 3, TO_DATE('2024-01-03', 'YYYY-MM-DD'), 20);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (4, 4, TO_DATE('2024-01-04', 'YYYY-MM-DD'), 40);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (5, 5, TO_DATE('2024-01-05', 'YYYY-MM-DD'), 25);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (6, 6, TO_DATE('2024-01-06', 'YYYY-MM-DD'), 35);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (7, 7, TO_DATE('2024-01-07', 'YYYY-MM-DD'), 45);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (8, 8, TO_DATE('2024-01-08', 'YYYY-MM-DD'), 15);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (9, 9, TO_DATE('2024-01-09', 'YYYY-MM-DD'), 50);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (10,10, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 20);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (11, 11, TO_DATE('2024-01-11', 'YYYY-MM-DD'), 30);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (12, 12, TO_DATE('2024-01-12', 'YYYY-MM-DD'), 60);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (13, 13, TO_DATE('2024-01-13', 'YYYY-MM-DD'), 25);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (14, 14, TO_DATE('2024-01-14', 'YYYY-MM-DD'), 35);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (15, 15, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 45);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (16, 16, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 55);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (17, 17, TO_DATE('2024-01-17', 'YYYY-MM-DD'), 20);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (18, 18, TO_DATE('2024-01-18', 'YYYY-MM-DD'), 50);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (19, 19, TO_DATE('2024-01-19', 'YYYY-MM-DD'), 40);
INSERT INTO item_usage_history (item_usage_history_id, stock_item_id, usage_date, usage_amount) VALUES (20, 20, TO_DATE('2024-01-20', 'YYYY-MM-DD'), 30);

-- ���˸�� �� ������ 20�� ����
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (1, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (2, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (3, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (4, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (5, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (6, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (7, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (8, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (9, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (10, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (11, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (12, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (13, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (14, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (15, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (16, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (17, '�۵�Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (18, 'û��Ȯ��');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (19, '���� ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (20, '�۵�Ȯ��');

-- MANAGER ���̺� 30�� ���
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (1, '��ö��', '010-1111-1111', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (2, '�̿���', '010-2222-2222', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (3, '�ڹμ�', '010-3333-3333', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (4, '������', '010-4444-4444', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (5, '������', '010-5555-5555', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (6, '�����', '010-6666-6666', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (7, '�̼���', '010-7777-7777', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (8, '������', '010-8888-8888', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (9, '�ּ���', '010-9999-9999', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (10, '����ȣ', '010-1010-1010', 10);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (11, '��ҿ�', '010-1111-0000', 11);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (12, '����ȣ', '010-2222-1111', 12);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (14, '�ֿ���', '010-4444-3333', 14);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (15, '���켺', '010-5555-4444', 15);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (16, '������', '010-6666-5555', 16);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (17, '�̹�ȣ', '010-7777-6666', 17);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (18, '�ں���', '010-8888-7777', 18);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (19, '������', '010-9999-8888', 19);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (20, '������', '010-1010-9999', 20);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (21, '�����', '010-1212-1212', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (22, '�̵���', '010-2323-2323', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (23, '�ڽ���', '010-3434-3434', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (24, '�ּ���', '010-4545-4545', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (25, '��ä��', '010-5656-5656', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (26, '������', '010-6767-6767', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (27, '������', '010-7878-7878', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (28, '������', '010-8989-8989', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (29, '�ֿ���', '010-9090-9090', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (30, '���ҹ�', '010-0000-0000', 10);

-- �Ƿ������˸�� ������ 20�� ����
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (1, 01, '���˸��1', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (2, 02, '���˸��2', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (3, 03, '���˸��3', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (4, 04, '���˸��4', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (5, 05, '���˸��5', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (6, 06, '���˸��6', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (7, 07, '���˸��7', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (8, 08, '���˸��8', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (9, 09, '���˸��9', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (10, 10, '���˸��10', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (11, 11, '���˸��11', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (12, 12, '���˸��12', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (14, 14, '���˸��14', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (15, 15, '���˸��15', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (16, 16, '���˸��16', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (17, 17, '���˸��17', '����');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (18, 18, '���˸��18', '�б⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (19, 19, '���˸��19', '�ݱ⺰');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (20, 20, '���˸��20', '����');


-- �Ƿ������� ������ 10�� ����
INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (1, 1, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '����', 3);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (2, 2, 2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '����', 5);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (3, 5, 5, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '����', 7);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (4, 6, 6, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '����', 9);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (5, 7, 7, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '����', 11);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (6, 8, 8, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '����', 12);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (7, 9, 9, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '����', 15);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (8, 10, 10, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '����', 16);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (9, 11, 11, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '����', 17);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (10, 12, 12, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '����', 18);

-- ��� ���̺� ������ 18�� ����
INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (1, 1, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), '��� �ջ�', 10);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (2, 2, 2, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-06-16', 'YYYY-MM-DD'), '��� ���� ����', 20);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (3, 3, 3, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-06-17', 'YYYY-MM-DD'), '����� ����', 30);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (4, 4, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-06-18', 'YYYY-MM-DD'), '��� ���۵�', 40);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (5, 5, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-19', 'YYYY-MM-DD'), '������ ��', 50);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (6, 6, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), '��ǰ ����', 60);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (7, 7, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-06-21', 'YYYY-MM-DD'), '����� ������ ���� ��ü', 70);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (8, 8, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-06-22', 'YYYY-MM-DD'), '��� ���� ����', 80);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (9, 9, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-06-23', 'YYYY-MM-DD'), '��� ���׷��̵� �ʿ�', 90);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (10, 10, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-06-24', 'YYYY-MM-DD'), '��� ��� �� ����', 100);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (11, 11, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), '��� �������� ��� ����', 110);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (12, 12, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-06-26', 'YYYY-MM-DD'), '��� ��� �ߴ�', 120);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (14, 14, 14, TO_DATE('2024-06-14', 'YYYY-MM-DD'), TO_DATE('2024-06-28', 'YYYY-MM-DD'), '��� ���� ����', 140);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (15, 15, 15, TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-29', 'YYYY-MM-DD'), '��� ����', 150);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (16, 16, 16, TO_DATE('2024-06-16', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), '��� ��ü �ʿ�', 160);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (17, 17, 17, TO_DATE('2024-06-17', 'YYYY-MM-DD'), TO_DATE('2024-07-01', 'YYYY-MM-DD'), '��� �ļ�', 170);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (18, 18, 18, TO_DATE('2024-06-18', 'YYYY-MM-DD'), TO_DATE('2024-07-02', 'YYYY-MM-DD'), '��� ������', 180);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (19, 19, 19, TO_DATE('2024-06-19', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), '��� ����ȭ', 190);


-- �Ƿ��� ������û 11�� ������ ����
INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (1, 2, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-05-30', 'YYYY-MM-DD'), '���� �� ����', '��û' );

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (2, 5, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-05-29', 'YYYY-MM-DD'), 'ȭ�� ������', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (3, 4, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-05-28', 'YYYY-MM-DD'), '���͸� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (4, 6, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-05-27', 'YYYY-MM-DD'), '�Ҹ� �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (5, 7, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-05-26', 'YYYY-MM-DD'), '��ġ �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (6, 8, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), '���� �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (7, 9, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-05-24', 'YYYY-MM-DD'), 'ī�޶� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (8, 10, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-05-23', 'YYYY-MM-DD'), '�� ���� �� ��', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (9, 11, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'), '���� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (10, 12, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-05-21', 'YYYY-MM-DD'), '������', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (11, 14, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'ȭ�� ����', '��û');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (12, 15, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-05-19', 'YYYY-MM-DD'), '��Ʈ��ũ ����', '��û');

-- �Ƿ��� ���� ��ü ������ 10�� ����
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (1, 'RepairCo', '123-45-6789', 'John Doe', '010-1234-5678');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (2, 'FixItAll', '987-65-4321', 'Jane Smith', '010-8765-4321');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (3, 'DeviceMenders', '456-78-9012', 'Alice Brown', '010-2345-6789');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (4, 'TechRepair', '321-54-9876', 'Bob Johnson', '010-3456-7890');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (5, 'GadgetFixers', '654-32-1098', 'Charlie Davis', '010-4567-8901');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (6, 'QuickFix', '789-01-2345', 'David Wilson', '010-5678-9012');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (7, 'RepairMasters', '234-56-7890', 'Eve White', '010-6789-0123');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (8, 'DeviceDoctors', '890-12-3456', 'Frank Green', '010-7890-1234');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (9, 'GadgetCare', '567-89-0123', 'Grace Black', '010-8901-2345');
INSERT INTO device_repiar_company (device_repiar_company_id, device_repair_company_name, business_num, device_repiar_company_manager, device_repair_company_tel) VALUES (10, 'FixPro', '098-76-5432', 'Hank Gray', '010-9012-3456');

-- �Ƿ��� ���� ������ 10�� ����
INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), 100.00, 'Screen replacement', 1, 1);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), 150.00, 'Battery replacement', 2, 2);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (3, TO_DATE('2024-07-03', 'YYYY-MM-DD'), 200.00, 'Motherboard repair', 3, 3);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (4, TO_DATE('2024-07-04', 'YYYY-MM-DD'), 120.00, 'Software update', 4, 4);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (5, TO_DATE('2024-07-05', 'YYYY-MM-DD'), 80.00, 'Charging port repair', 5, 5);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (6, TO_DATE('2024-07-06', 'YYYY-MM-DD'), 50.00, 'Speaker repair', 6, 6);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (7, TO_DATE('2024-07-07', 'YYYY-MM-DD'), 90.00, 'Camera repair', 7, 7);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (8, TO_DATE('2024-07-08', 'YYYY-MM-DD'), 110.00, 'Keyboard repair', 8, 8);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (9, TO_DATE('2024-07-09', 'YYYY-MM-DD'), 130.00, 'Touchscreen repair', 9, 9);

INSERT INTO device_repair (device_repiar_id, device_repair_complete_date, device_repair_price, device_repair_content, device_repair_request_id, device_repiar_company_id)
VALUES (10, TO_DATE('2024-07-10', 'YYYY-MM-DD'), 140.00, 'Microphone repair', 10, 10);


-- �Ƿ��� �̵���û�� ������ 15�� ����
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (2, 2, 3, 12, 2, '�μ� �� �Ƿ��� �������� ���� �̵� ��û', TO_DATE('2024-07-02', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (4, 4, 5, 14, 4, '��� �������� ���� ��ü ��� ��û', TO_DATE('2024-07-04', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (5, 5, 6, 15, 5, '�ű� ������Ʈ �������� ���� �߰� ��� �ʿ�', TO_DATE('2024-07-05', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (6, 6, 7, 16, 6, '���� ����� ���� ���Ϸ� ���� ��ü ��û', TO_DATE('2024-07-06', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (7, 7, 8, 17, 7, '�μ� �̵����� ���� ��� �Բ� �̵� ��û', TO_DATE('2024-07-07', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (8, 8, 9, 18, 8, '��� �������� �ʿ�� ���� �̵� ��û', TO_DATE('2024-07-08', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (9, 9, 10, 9, 9, '��� ȿ���� ������ ���� �̵� ��û', TO_DATE('2024-07-09', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (10, 10, 11, 10, 10, '��� Ȱ�뵵 ������ ���� �̵� ��û', TO_DATE('2024-07-10', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (11, 11, 12, 21, 11, '�μ� �� ��� ���ġ�� ���� �̵� ��û', TO_DATE('2024-07-11', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (14, 14, 15, 24, 14, '�μ� �� ��� �������� ���� ��� ��û', TO_DATE('2024-07-14', 'YYYY-MM-DD'), '����');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (15, 15, 16, 25, 15, '��� ���� ���Ϸ� ���� ��ü ��û', TO_DATE('2024-07-15', 'YYYY-MM-DD'), '����');

ALTER table device_transfer_request modify device_tranfer_request_state DEFAULT '���� ��';

-- �Ƿ����̵����� ������ 10�� ����
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (1, 10, 10, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (2, 2, 11, 2, TO_DATE('2024-07-02', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (3, 4, 12, 17, TO_DATE('2024-07-03', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (4, 5, 3, 13, TO_DATE('2024-07-04', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (5, 6, 14, 4, TO_DATE('2024-07-05', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (6, 7, 15, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'));


