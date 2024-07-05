CREATE TABLE Supplier (  -- 공급업체
   supplier_id   number   primary key,
   supplier_name   varchar(200)   NULL,
   business_no   varchar(200)   NULL,
   tel_no   varchar(200)   NULL,
   address   varchar(200)   NULL,
   location   varchar(200)   NULL,
   zipcode   varchar(200)   NULL
);

CREATE TABLE contract_supplier (  -- 계약공급처
   contract_supplier_id   number   primary key,
   supplier_id number references Supplier(supplier_id) on delete cascade,
   contract_name   varchar(200)   NULL,
   contract_date   Date   NULL,
   content   varchar(200)   NULL
);

CREATE TABLE item (  -- 공급물품
   item_id   number primary key,
   commodity_classification_code number not null,
   item_name   varchar(200)   not NULL,
   item_price   number   NULL,
   manufacturer   varchar(200)   NULL,
   contract_supplier_id number references contract_supplier(contract_supplier_id) on delete cascade
);

CREATE TABLE department (  -- 부서
   department_no   number   primary key,
   department_name   varchar(200)   NULL,
   department_manager   varchar(200)   NULL,
   department_location   varchar(200)   NULL,
   department_tel   varchar(200)   NULL
);

CREATE TABLE department_frequent_item ( --부서정기품목
  department_no number,
  item_id number,

  PRIMARY KEY (department_no, item_id),  
  FOREIGN KEY (department_no) REFERENCES department(department_no),  
  FOREIGN KEY (item_id) REFERENCES item(item_id)  
);

alter table department_frequent_item add division varchar2(200);

CREATE TABLE charge_item (  -- 청구물품
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

CREATE TABLE order_form (  -- 발주서
   order_form_id   number primary key,
   supplier_name   varchar(200)   NULL,
   total_price   number   NULL,
   order_form_name   varchar(200)   NULL
);

CREATE TABLE order_item ( --발주물품
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

CREATE TABLE trigonometry (  -- 상각방법
   grade   varchar(200)   primary key,
   max_year   DATE   NULL,
   min_year   DATE   NULL,
   discount_cost   number   NULL
);

CREATE TABLE stock_item (  --재고물품
   stock_item_id   number primary key,
   item_id   number references item(item_id) on delete cascade,
   department_no   number references department(department_no) on delete cascade,
   safe_stock   number  NULL,
   optimal_stock   number   NULL,
   current_stock   number   NULL
);

CREATE TABLE item_usage_history (  -- 물품 사용이력
   item_usage_history_id   number  primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   usage_date   Date   NULL,
   usage_amount   number   NULL
);

CREATE TABLE inspection_detail (  -- 점검목록상세
   inspection_detail_id   number primary key,
   inspection_detail_name   varchar(200)   NULL
);

CREATE TABLE manager (  -- 관리자
   manager_id   number  primary key,
   manager_name   varchar(200)   NULL,
   manager_tel   varchar(200)   NULL,
   department_no   number references department(department_no) on delete cascade
);

CREATE TABLE device_inspection_list ( --의료기기점검목록
   device_inspection_list_id   number,
   stock_item_id number,
   device_inspection_list_name   varchar(200)   NULL,
   device_inspection_list_period   varchar(200)   NULL,
   PRIMARY KEY (device_inspection_list_id, stock_item_id),  
   FOREIGN KEY (stock_item_id) REFERENCES stock_item(stock_item_id)
);

CREATE TABLE device_inspection (  -- 의료기기점검
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

CREATE TABLE disposal (  -- 폐기
   disposal_id   number  primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   manager_id   number references manager(manager_id) on delete cascade,
   request_date   Date   NULL,
   disposal_date   Date   NULL,
   content   varchar(200)   NULL,
   disposal_amount   number   NULL
);

CREATE TABLE device_repair_request (  --수리요청의료기기
   device_repair_request_id   number   primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   manager_id   number references manager(manager_id) on delete cascade,
   device_repair_request_date   Date   NULL,
   device_repair_failure_date   Date   NULL,
   device_repair_failure_symptom   varchar(200)   NULL,
   device_repair_request_state   varchar(200)   NULL
);

CREATE TABLE device_repiar_company (  -- 수리업체
   device_repiar_company_id   number   primary key,
   device_repair_company_name   VARCHAR(200)   NULL,
   business_num   VARCHAR(200)   NULL,
   device_repiar_company_manager   VARCHAR(200)   NULL,
   device_repair_company_tel   VARCHAR(200)   NULL
);

CREATE TABLE device_repair_check ( --수리업체 수리가능 의료기기
   device_repair_request_id number,
   device_repiar_company_id number,
   
   PRIMARY KEY (device_repair_request_id, device_repiar_company_id),
   FOREIGN KEY (device_repair_request_id) REFERENCES device_repair_request(device_repair_request_id),
   FOREIGN KEY (device_repiar_company_id) REFERENCES device_repiar_company(device_repiar_company_id)
);

alter table device_repair_check add device_repair_state   varchar(200);

CREATE TABLE device_repair ( --의료기기수리
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

CREATE TABLE device_transfer_request (  -- 의료기기이동신청서
   device_transfer_request_id   number   primary key,
   stock_item_id   number references stock_item(stock_item_id) on delete cascade,
   transfer_department_no   number references department(department_no) on delete cascade,
   manager_id   number references manager(manager_id) on delete cascade,
   previous_department_no   number NOT NULL,
   device_tranfer_request_reason   varchar(200)  NULL,
   device_tranfer_request_date   Date   NULL,
   device_tranfer_request_state   varchar(200)   NULL
);

CREATE TABLE device_transfer_history (  --의료기기이동내역
   stock_item_id   number,
   device_transfer_request_id number,
   privious_department_no   number   NULL,
   transfer_department_no   number   NULL,
   device_transfer_date   Date   NULL,
   PRIMARY KEY (privious_department_no, stock_item_id),
   FOREIGN KEY (stock_item_id) REFERENCES stock_item(stock_item_id),
   FOREIGN KEY (device_transfer_request_id) REFERENCES device_transfer_request(device_transfer_request_id)
);

create table medical_device ( -- 의료기기
    stock_item_id number,
    medical_device_no number,
    standard varchar2(200),
    lease_period date,
    lease_amount number,
    english_name varchar2(200),
    PRIMARY KEY (stock_item_id, medical_device_no),
    FOREIGN KEY (stock_item_id) REFERENCES stock_item(stock_item_id)
);



-- 전체 테이블 DROP 명령어

BEGIN
    FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'HOSPITAL') LOOP
        EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
    END LOOP;
END;



-- 실행할 쿼리 목록들

-- 전체 물품코드 목록  => 0번

select b.item_id as 물품코드, b.item_name as 물품명, c.english_name as 영문장비명, c.standard as 규격, a.safe_stock as 안전재고 ,  a.optimal_stock as 적정재고, a.current_stock as 현재고, a.department_no as 부서번호, e.manager_name as 관리자
from stock_item a, item b, medical_device c, department d, manager e
where a.item_id = b.item_id and a.stock_item_id = c.stock_item_id and a.department_no = d.department_no and e.department_no = d.department_no;

create or replace view inventory_list as (
select b.item_id as 물품코드, b.item_name as 물품명, c.english_name as 영문장비명, c.standard as 규격, a.safe_stock as 안전재고 , 
    a.optimal_stock as 적정재고, a.current_stock as 현재고, a.department_no as 부서번호, e.manager_name as 관리자
from stock_item a, item b, medical_device c, department d, manager e
where a.item_id = b.item_id and a.stock_item_id = c.stock_item_id and a.department_no = d.department_no and e.department_no = d.department_no);

select * from inventory_list;

-- '엑스레이발생기' 장치 수리 요청에 대한 자세한 정보를 조회 => 1번

select * from device_repair_request;

select b.device_repair_request_id as 수리요청서번호, b.device_repair_request_date as 요청일자, b.device_repair_failure_date as 고장일시, a.stock_item_id as 재고물품번호,
    e.item_name as 물품명, c.department_name as 부서명, d.manager_name as 요청자, b.device_repair_failure_symptom as 고장증상, b.device_repair_request_state as 조치상황
from stock_item a, device_repair_request b, department c, manager d, item e
where a.stock_item_id = b.stock_item_id and a.department_no = c.department_no and c.department_no = d.department_no and  e.item_name = '엑스레이발생기' and a.item_id = e.item_id;

-- 수리요청서번호 1번에 대한 정비 의뢰서 (프로시저) => 2번

select a.DEVICE_REPAIR_REQUEST_ID AS "수리요청서번호", a.STOCK_ITEM_ID as "재고물품번호", g.item_name as "물품명", e.manager_name as " 관리자이름", a.DEVICE_REPAIR_REQUEST_DATE as "요청일자", a.DEVICE_REPAIR_FAILURE_DATE as "고장일시", a.DEVICE_REPAIR_FAILURE_SYMPTOM as "고장증상", a.DEVICE_REPAIR_REQUEST_STATE as "요청상태", b.DEVICE_REPIAR_COMPANY_ID as 수리업체번호, b.DEVICE_REPAIR_STATE as 수리상태, c.DEVICE_REPAIR_COMPANY_NAME as 수리업체명, c.BUSINESS_NUM as "사업자번호", c.DEVICE_REPIAR_COMPANY_MANAGER as 수리담당자, c.DEVICE_REPAIR_COMPANY_TEL as "수리 연락처", d.DEVICE_REPIAR_ID as "의료기기수리내역번호", d.DEVICE_REPAIR_COMPLETE_DATE as "수리 종료일", d.DEVICE_REPAIR_PRICE as "수리 금액", d.DEVICE_REPAIR_CONTENT as "처리 내용"
from device_repair_request a, device_repair_check b, device_repiar_company c, DEVICE_REPAIR d, manager e, stock_item f, item g
where a.DEVICE_REPAIR_REQUEST_ID = b.DEVICE_REPAIR_REQUEST_ID and b.DEVICE_REPIAR_COMPANY_ID = c.DEVICE_REPIAR_COMPANY_ID and a.MANAGER_ID = e.MANAGER_ID and f.STOCK_ITEM_ID = a.STOCK_ITEM_ID and f.item_id = g.item_id and a.DEVICE_REPAIR_REQUEST_ID = 1;

set serveroutput on;

CREATE OR REPLACE PROCEDURE Request_for_maintenance(p_device_repiar_id in device_repair.device_repiar_id%type)

is
    cursor device_repair_cursors is
        select a.DEVICE_REPAIR_REQUEST_ID AS "수리요청서번호", a.STOCK_ITEM_ID as "재고물품번호", k.supplier_name as "공급업체명", g.item_id as "물품 코드", g.item_name as "물품명",
            i.english_name as "영문명" ,e.manager_name as "관리자이름", h.department_name as "부서명", a.DEVICE_REPAIR_REQUEST_DATE as "요청일자", a.DEVICE_REPAIR_FAILURE_DATE as "고장일시",
            a.DEVICE_REPAIR_FAILURE_SYMPTOM as "고장증상", a.DEVICE_REPAIR_REQUEST_STATE as "요청상태", b.DEVICE_REPIAR_COMPANY_ID as 수리업체번호,
            b.DEVICE_REPAIR_STATE as 수리상태, c.DEVICE_REPAIR_COMPANY_NAME as 수리업체명, c.BUSINESS_NUM as "사업자번호", c.DEVICE_REPIAR_COMPANY_MANAGER as 수리담당자,
            c.DEVICE_REPAIR_COMPANY_TEL as "수리 연락처", d.DEVICE_REPIAR_ID as "의료기기수리내역번호", d.DEVICE_REPAIR_COMPLETE_DATE as "수리 종료일",
            d.DEVICE_REPAIR_PRICE as "수리 금액", d.DEVICE_REPAIR_CONTENT as "처리 내용"
        from device_repair_request a, device_repair_check b, device_repiar_company c, DEVICE_REPAIR d, manager e,
            stock_item f, item g, department h,medical_device i, contract_supplier j, supplier k
        where a.DEVICE_REPAIR_REQUEST_ID = b.DEVICE_REPAIR_REQUEST_ID and b.DEVICE_REPIAR_COMPANY_ID = c.DEVICE_REPIAR_COMPANY_ID
            and a.MANAGER_ID = e.MANAGER_ID and f.STOCK_ITEM_ID = a.STOCK_ITEM_ID and f.item_id = g.item_id and h.department_no = f.department_no
            and g.contract_supplier_id = j.contract_supplier_id and j.supplier_id = k.supplier_id and a.DEVICE_REPAIR_REQUEST_ID = 1;
    
    device_repair_record device_repair_cursors%rowtype;

begin
    
    for device_repair_record in device_repair_cursors loop
        dbms_output.put_line('======================= 정비의뢰서 =======================');
        dbms_output.put_line('접수일자 ' ||'| '|| device_repair_record."요청일자" ||' |'|| ' 결제 ' ||' |'|| ' 사원 ' ||'| '|| ' 대리 ' ||'| '|| ' 과장 ');
        dbms_output.put_line(' 접 수 자 ' ||'| '|| device_repair_record."관리자이름" ||' '|| '  ' ||' '|| '  ' ||' '|| '  ' ||' '|| '  ');
        dbms_output.put_line('접수번호 ' ||'| '|| p_device_repiar_id ||' '|| '  ' ||' '|| '  ' ||' '|| '  ' ||' '|| '  ');
        dbms_output.put_line('의뢰부서 ' ||'| '|| device_repair_record."부서명" ||' '|| '  ' ||' '|| '  ' ||' '|| '  ' ||' '|| '  ');
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('관리번호 : ' || device_repair_record."의료기기수리내역번호"  ||' |'|| ' 재고물품번호 : ' ||' '|| device_repair_record."재고물품번호" ||' |'|| ' S/N : ' ||' '|| device_repair_record."물품 코드" ||' |'|| ' 수리종료일 : ' || device_repair_record."수리 종료일");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('물품명 : ' || device_repair_record."물품명" ||' |'|| ' 영문명 : ' || device_repair_record."영문명");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('구입처 : ' || device_repair_record."공급업체명");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('고장상태(사용자) : ' || device_repair_record."고장증상");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('발생일시 : ' || device_repair_record."고장일시" ||' |' || ' 보고일자 : ' || device_repair_record."수리 종료일" ||' | '|| '관리자이름 : ' || device_repair_record."관리자이름");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('수리요청상태 : ' || device_repair_record."요청상태" || ' | '|| '수리상태 : ' || device_repair_record."수리상태" );
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('정비내역 : ' || device_repair_record."처리 내용");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('추정예산 : ' || device_repair_record."수리 금액");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('관 리 책임자 : ' || device_repair_record."수리담당자"||' |' || ' 수리 연락처 : ' || device_repair_record."수리 연락처");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('사업자 번호 : ' || device_repair_record."사업자번호" || ' | ' || '수리업체명 : ' || device_repair_record."수리업체명" || ' |' || ' 수리업체번호 : ' || device_repair_record."수리업체번호");
        dbms_output.put_line('--------------------------------------------------------');
        dbms_output.put_line('');
    end loop;
end;

execute Request_for_maintenance(1);

-- 누적 상감금액 집계 => 3번

select * from medical_device;
select * from contract_supplier;

CREATE TABLE item_name (  -- 물품명
  commodity_classification_code number primary key,
  classification_name varchar2(200) not null
);

insert into item_name values(101, '비품');
insert into item_name values(102, '의약품');
insert into item_name values(103, '의료기기');

select a.supplier_id as "공급업체번호", d.supplier_name as "공급업체명", a.contract_name as "계약명", a.contract_date as "계약일자", a.content as "계약내용", a.contract_supplier_id as "공급처 번호",  b.item_id as "물품코드", b.commodity_classification_code as "물품분류코드", f.classification_name as "물품분류명", b.item_name as "물품명", b.item_price as "단가", b.manufacturer as "제조사", c.grade as "상감등급" ,b.item_price- (b.item_price * c.discount_cost) AS 상감금액
from contract_supplier a inner join item b
on a.contract_supplier_id = b.contract_supplier_id
left join trigonometry c on a.contract_date between c.min_year and c.max_year
inner join supplier d on a.supplier_id = d.supplier_id
left join item_name f on b.commodity_classification_code = f.commodity_classification_code;

create or replace view amortization as (select a.supplier_id as "공급업체번호", d.supplier_name as "공급업체명", a.contract_name as "계약명", a.contract_date as "계약일자", a.content as "계약내용",
    a.contract_supplier_id as "공급처 번호", b.item_id as "물품코드", b.commodity_classification_code as "물품분류코드", f.classification_name as "물품분류명",
    b.item_name as "물품명", b.item_price as "단가", b.manufacturer as "제조사", c.grade as "상감등급" ,b.item_price- (b.item_price * c.discount_cost) AS 상감금액
from contract_supplier a inner join item b
on a.contract_supplier_id = b.contract_supplier_id
left join trigonometry c on a.contract_date between c.min_year and c.max_year
inner join supplier d on a.supplier_id = d.supplier_id
left join item_name f on b.commodity_classification_code = f.commodity_classification_code);

select * from amortization;

SELECT
    "물품명",
    "단가",
    "상감등급",
    SUM(단가 - 상감금액) AS 상감후금액,
    SUM(상감금액) AS 상감된금액
FROM amortization
GROUP BY ROLLUP ("물품명", "단가", "상감등급")  
ORDER BY "물품명", "단가", "상감등급", 상감후금액 DESC;



--- 더미 데이터

-- 상각방법 
INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('4', TO_DATE('YYYY-MM-DD', '2009-12-31'), TO_DATE('YYYY-MM-DD', '2005-01-01'), 0.4);

INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('3', TO_DATE('YYYY-MM-DD', '2014-12-31'), TO_DATE('YYYY-MM-DD', '2010-01-01'), 0.3);

INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('2', TO_DATE('YYYY-MM-DD', '2019-12-31'), TO_DATE('YYYY-MM-DD', '2015-01-01'), 0.2);

INSERT INTO trigonometry (grade, max_year, min_year, discount_cost)
VALUES ('1', TO_DATE('YYYY-MM-DD', '2024-12-31'), TO_DATE('YYYY-MM-DD', '2020-01-01'), 0.0);


-- 공급업체 데이터 15개 삽입
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (1, '공급업체1', '123-45-6789', '010-1234-5678', '서울시 강남구 테헤란로 1길 1', '서울', '12345');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (2, '공급업체2', '223-45-6789', '010-2234-5678', '서울시 강남구 테헤란로 2길 2', '서울', '12346');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (3, '공급업체3', '323-45-6789', '010-3234-5678', '서울시 강남구 테헤란로 3길 3', '서울', '12347');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (4, '공급업체4', '423-45-6789', '010-4234-5678', '서울시 강남구 테헤란로 4길 4', '서울', '12348');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (5, '공급업체5', '523-45-6789', '010-5234-5678', '서울시 강남구 테헤란로 5길 5', '서울', '12349');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (6, '공급업체6', '623-45-6789', '010-6234-5678', '서울시 강남구 테헤란로 6길 6', '서울', '12350');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (7, '공급업체7', '723-45-6789', '010-7234-5678', '서울시 강남구 테헤란로 7길 7', '서울', '12351');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (8, '공급업체8', '823-45-6789', '010-8234-5678', '서울시 강남구 테헤란로 8길 8', '서울', '12352');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (9, '공급업체9', '923-45-6789', '010-9234-5678', '서울시 강남구 테헤란로 9길 9', '서울', '12353');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (10, '공급업체10', '1023-45-6789', '010-1023-5678', '서울시 강남구 테헤란로 10길 10', '서울', '12354');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (11, '공급업체11', '1123-45-6789', '010-1123-5678', '서울시 강남구 테헤란로 11길 11', '서울', '12355');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (12, '공급업체12', '1223-45-6789', '010-1223-5678', '서울시 강남구 테헤란로 12길 12', '서울', '12356');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (13, '공급업체13', '1323-45-6789', '010-1323-5678', '서울시 강남구 테헤란로 13길 13', '서울', '12357');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (14, '공급업체14', '1423-45-6789', '010-1423-5678', '서울시 강남구 테헤란로 14길 14', '서울', '12358');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (15, '공급업체15', '1523-45-6789', '010-1523-5678', '서울시 강남구 테헤란로 15길 15', '서울', '12359');

-- 계약 공급처 20개 데이터 삽입
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (1, '계약공급처1', TO_DATE('2023-01-01', 'YYYY-MM-DD'), '계약 내용 1', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (2, '계약공급처2', TO_DATE('2023-02-01', 'YYYY-MM-DD'), '계약 내용 2', 2);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (3, '계약공급처3', TO_DATE('2023-03-01', 'YYYY-MM-DD'), '계약 내용 3', 3);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (4, '계약공급처4', TO_DATE('2023-04-01', 'YYYY-MM-DD'), '계약 내용 4', 4);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (5, '계약공급처5', TO_DATE('2023-05-01', 'YYYY-MM-DD'), '계약 내용 5', 5);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (6, '계약공급처6', TO_DATE('2023-06-01', 'YYYY-MM-DD'), '계약 내용 6', 6);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (7, '계약공급처7', TO_DATE('2023-07-01', 'YYYY-MM-DD'), '계약 내용 7', 7);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (8, '계약공급처8', TO_DATE('2023-08-01', 'YYYY-MM-DD'), '계약 내용 8', 8);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (9, '계약공급처9', TO_DATE('2023-09-01', 'YYYY-MM-DD'), '계약 내용 9', 9);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (10, '계약공급처10', TO_DATE('2023-10-01', 'YYYY-MM-DD'), '계약 내용 10', 10);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (11, '계약공급처11', TO_DATE('2023-11-01', 'YYYY-MM-DD'), '계약 내용 11', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (12, '계약공급처12', TO_DATE('2023-12-01', 'YYYY-MM-DD'), '계약 내용 12', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (13, '계약공급처13', TO_DATE('2024-01-01', 'YYYY-MM-DD'), '계약 내용 13', 13);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (14, '계약공급처14', TO_DATE('2024-02-01', 'YYYY-MM-DD'), '계약 내용 14', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (15, '계약공급처15', TO_DATE('2024-03-01', 'YYYY-MM-DD'), '계약 내용 15', 15);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (16, '계약공급처16', TO_DATE('2024-04-01', 'YYYY-MM-DD'), '계약 내용 16', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (17, '계약공급처17', TO_DATE('2024-05-01', 'YYYY-MM-DD'), '계약 내용 17', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (18, '계약공급처18', TO_DATE('2024-06-01', 'YYYY-MM-DD'), '계약 내용 18', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (19, '계약공급처19', TO_DATE('2024-07-01', 'YYYY-MM-DD'), '계약 내용 19', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (20, '계약공급처20', TO_DATE('2024-08-01', 'YYYY-MM-DD'), '계약 내용 20', 2);

-- 공급 물품 20개 데이터 삽입
INSERT INTO item (item_id, commodity_classification_code, contract_supplier_id, item_name, item_price, manufacturer) VALUES (1, 1, '물품1', 1000, '제조사1', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (2, 1,'물품2', 2000, '제조사2', 2);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (3, 1,'물품3', 3000, '제조사3', 3);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (4, 1,'물품4', 4000, '제조사4', 4);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (5, 1,'물품5', 5000, '제조사5', 5);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (6, 2,'물품6', 6000, '제조사6', 6);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (7, 2,'물품7', 7000, '제조사7', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (8, 2,'물품8', 8000, '제조사8', 8);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (9, 2,'물품9', 9000, '제조사9', 9);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (10, 2,'물품10', 10000, '제조사10', 10);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (11, 3,'물품11', 11000, '제조사11', 11);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (12, 3,'물품12', 12000, '제조사12', 12);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (13, 3,'물품13', 13000, '제조사13', 13);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (14, 3,'물품14', 14000, '제조사14', 14);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (15, 3,'물품15', 15000, '제조사15', 15);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (16, 3,'물품16', 16000, '제조사16', 16);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (17, 3,'물품17', 17000, '제조사17', 17);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (18, 3,'물품18', 18000, '제조사18', 18);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (19, 3,'물품19', 19000, '제조사19', 19);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (20, 3,'물품20', 20000, '제조사20', 20);



-- 부서 20개 데이터 삽입 
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (1, '내과', '홍길동', '2층', '02-1234-5678');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (2, '외과', '이순신', '3층', '02-2345-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (3, '소아과', '강감찬', '4층', '02-3456-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (4, '산부인과', '유관순', '5층', '02-4567-8901');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (5, '정형외과', '장보고', '6층', '02-5678-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (6, '신경과', '안중근', '7층', '02-6789-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (7, '피부과', '김구', '8층', '02-7890-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (8, '비뇨기과', '윤봉길', '9층', '02-8901-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (9, '안과', '안창호', '10층', '02-9012-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (10, '치과', '김좌진', '11층', '02-0123-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (11, '이비인후과', '유진오', '12층', '02-1234-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (12, '재활의학과', '최재형', '13층', '02-2345-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (14, '응급의학과', '김원봉', '1층', '02-4567-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (15, '가정의학과', '김홍집', '15층', '02-5678-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (16, '심장내과', '서재필', '16층', '02-6789-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (17, '혈액종양내과', '이승만', '17층', '02-7890-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (18, '소화기내과', '박정희', '18층', '02-8901-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (19, '호흡기내과', '김대중', '19층', '02-9012-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (20, '내분비내과', '노무현', '20층', '02-0123-5678');

--부서정기품목
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

-- 청구물품 데이터 20개 삽입
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (1, 1, 1, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (2, 1, 2, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (3, 2, 3, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (4, 2, 4, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (5, 3, 5, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (6, 3, 6, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (7, 4, 7, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (8, 4, 8, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (9, 5, 9, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (10, 5, 10, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (11, 6, 11, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (12, 6, 12, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (13, 7, 13, 45, TO_DATE('2024-07-13', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (14, 7, 14, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (15, 8, 15, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (16, 8, 16, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (17, 9, 17, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (18, 9, 18, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (19, 10, 19, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (20,10, 20, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '정상');


-- 발주서 데이터 20개 삽입
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (1, '공급업체A', 50000, '발주서1');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (2, '공급업체B', 120000, '발주서2');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (3, '공급업체C', 75000, '발주서3');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (4, '공급업체D', 200000, '발주서4');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (5, '공급업체E', 95000, '발주서5');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (6, '공급업체F', 130000, '발주서6');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (7, '공급업체G', 110000, '발주서7');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (8, '공급업체H', 89000, '발주서8');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (9, '공급업체I', 67000, '발주서9');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (10, '공급업체J', 150000, '발주서10');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (11, '공급업체K', 53000, '발주서11');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (12, '공급업체L', 47000, '발주서12');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (13, '공급업체M', 92000, '발주서13');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (14, '공급업체N', 81000, '발주서14');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (15, '공급업체O', 160000, '발주서15');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (16, '공급업체P', 140000, '발주서16');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (17, '공급업체Q', 103000, '발주서17');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (18, '공급업체R', 75000, '발주서18');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (19, '공급업체S', 125000, '발주서19');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (20, '공급업체T', 68000, '발주서20');

-- 발주물품 데이터 20개 삽입
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (1, 1, 1, 1000, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (2, 2, 2, 2000, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (3, 3, 3, 3000, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (4, 4, 4, 4000, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (5, 5, 5, 5000, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (6, 6, 6, 6000, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (7, 7, 7, 7000, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (8, 8, 8, 8000, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (9, 9, 9, 9000, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (10, 10, 10, 10000, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (11, 11, 11, 11000, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (12, 12, 12, 12000, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (13, 13, 13, 13000, 45, TO_DATE('2024-07-13', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (14, 14, 14, 14000, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (15, 15, 15, 15000, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (16, 16, 16, 16000, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (17, 17, 17, 17000, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (18, 18, 18, 18000, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (19, 19, 19, 19000, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (20, 20, 20, 20000, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '입고');

-- 재고물품 20개 데이터 등록
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

-- 물품사용이력 데이터 20개
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

-- 점검목록 상세 데이터 20개 삽입
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (1, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (2, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (3, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (4, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (5, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (6, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (7, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (8, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (9, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (10, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (11, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (12, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (13, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (14, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (15, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (16, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (17, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (18, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (19, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (20, '작동확인');

-- MANAGER 테이블 30개 등록
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (1, '김철수', '010-1111-1111', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (2, '이영희', '010-2222-2222', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (3, '박민수', '010-3333-3333', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (4, '최지현', '010-4444-4444', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (5, '정다은', '010-5555-5555', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (6, '김민재', '010-6666-6666', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (7, '이서연', '010-7777-7777', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (8, '박지훈', '010-8888-8888', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (9, '최수민', '010-9999-9999', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (10, '정민호', '010-1010-1010', 10);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (11, '김소연', '010-1111-0000', 11);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (12, '이준호', '010-2222-1111', 12);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (14, '최예린', '010-4444-3333', 14);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (15, '정우성', '010-5555-4444', 15);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (16, '김태희', '010-6666-5555', 16);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (17, '이민호', '010-7777-6666', 17);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (18, '박보영', '010-8888-7777', 18);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (19, '최진혁', '010-9999-8888', 19);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (20, '정해인', '010-1010-9999', 20);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (21, '김고은', '010-1212-1212', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (22, '이동욱', '010-2323-2323', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (23, '박신혜', '010-3434-3434', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (24, '최수진', '010-4545-4545', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (25, '정채연', '010-5656-5656', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (26, '김유정', '010-6767-6767', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (27, '이종석', '010-7878-7878', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (28, '박현진', '010-8989-8989', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (29, '최영수', '010-9090-9090', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (30, '정소민', '010-0000-0000', 10);

-- 의료기기점검목록 데이터 20개 삽입
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (1, 01, '점검목록1', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (2, 02, '점검목록2', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (3, 03, '점검목록3', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (4, 04, '점검목록4', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (5, 05, '점검목록5', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (6, 06, '점검목록6', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (7, 07, '점검목록7', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (8, 08, '점검목록8', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (9, 09, '점검목록9', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (10, 10, '점검목록10', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (11, 11, '점검목록11', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (12, 12, '점검목록12', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (14, 14, '점검목록14', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (15, 15, '점검목록15', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (16, 16, '점검목록16', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (17, 17, '점검목록17', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (18, 18, '점검목록18', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (19, 19, '점검목록19', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (20, 20, '점검목록20', '연간');


-- 의료기기점검 데이터 10개 삽입
INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (1, 1, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '정상', 3);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (2, 2, 2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '정상', 5);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (3, 5, 5, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '정상', 7);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (4, 6, 6, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '정상', 9);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (5, 7, 7, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '정상', 11);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (6, 8, 8, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '정상', 12);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (7, 9, 9, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '정상', 15);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (8, 10, 10, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '정상', 16);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (9, 11, 11, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '정상', 17);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (10, 12, 12, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '정상', 18);

-- 폐기 테이블 데이터 18개 삽입
INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (1, 1, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), '내용1', 10);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (2, 2, 2, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-06-16', 'YYYY-MM-DD'), '내용2', 20);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (3, 3, 3, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-06-17', 'YYYY-MM-DD'), '내용3', 30);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (4, 4, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-06-18', 'YYYY-MM-DD'), '내용4', 40);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (5, 5, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-19', 'YYYY-MM-DD'), '내용5', 50);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (6, 6, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), '내용6', 60);
INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (7, 7, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-06-21', 'YYYY-MM-DD'), '내용7', 70);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (8, 8, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-06-22', 'YYYY-MM-DD'), '내용8', 80);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (9, 9, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-06-23', 'YYYY-MM-DD'), '내용9', 90);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (10, 10, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-06-24', 'YYYY-MM-DD'), '내용10', 100);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (11, 11, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), '내용11', 110);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (12, 12, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-06-26', 'YYYY-MM-DD'), '내용12', 120);


INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (14, 14, 14, TO_DATE('2024-06-14', 'YYYY-MM-DD'), TO_DATE('2024-06-28', 'YYYY-MM-DD'), '내용14', 140);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (15, 15, 15, TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-29', 'YYYY-MM-DD'), '내용15', 150);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (16, 16, 16, TO_DATE('2024-06-16', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), '내용16', 160);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (17, 17, 17, TO_DATE('2024-06-17', 'YYYY-MM-DD'), TO_DATE('2024-07-01', 'YYYY-MM-DD'), '내용17', 170);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (18, 18, 18, TO_DATE('2024-06-18', 'YYYY-MM-DD'), TO_DATE('2024-07-02', 'YYYY-MM-DD'), '내용18', 180);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (19, 19, 19, TO_DATE('2024-06-19', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), '내용19', 190);


-- 의료기기 수리요청 11개 데이터 삽입
INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (1, 2, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-05-30', 'YYYY-MM-DD'), '전원 안 켜짐', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (2, 5, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-05-29', 'YYYY-MM-DD'), '화면 깜빡임', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (3, 4, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-05-28', 'YYYY-MM-DD'), '배터리 문제', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (4, 6, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-05-27', 'YYYY-MM-DD'), '소리 안 남', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (5, 7, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-05-26', 'YYYY-MM-DD'), '터치 안 됨', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (6, 8, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), '충전 안 됨', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (7, 9, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-05-24', 'YYYY-MM-DD'), '카메라 문제', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (8, 10, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-05-23', 'YYYY-MM-DD'), '앱 실행 안 됨', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (9, 11, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'), '과열 문제', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (10, 12, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-05-21', 'YYYY-MM-DD'), '느려짐', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (11, 14, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), '화면 깨짐', '요청', '진행 중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state, device_repair_state) VALUES (12, 15, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-05-19', 'YYYY-MM-DD'), '네트워크 문제', '요청', '진행 중');

-- 의료기기 수리 업체 데이터 10개 삽입
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

-- 의료기기 수리 데이터 10개 삽입
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


-- 의료기기 이동신청서 데이터 15개 삽입
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (2, 2, 3, 12, 2, 'Reason 2', TO_DATE('2024-07-02', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (4, 4, 5, 14, 4, 'Reason 4', TO_DATE('2024-07-04', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (5, 5, 6, 15, 5, 'Reason 5', TO_DATE('2024-07-05', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (6, 6, 7, 16, 6, 'Reason 6', TO_DATE('2024-07-06', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (7, 7, 8, 17, 7, 'Reason 7', TO_DATE('2024-07-07', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (8, 8, 9, 18, 8, 'Reason 8', TO_DATE('2024-07-08', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (9, 9, 10, 9, 9, 'Reason 9', TO_DATE('2024-07-09', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (10, 10, 11, 10, 10, 'Reason 10', TO_DATE('2024-07-10', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (11, 11, 12, 21, 11, 'Reason 11', TO_DATE('2024-07-11', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (14, 14, 15, 24, 14, 'Reason 14', TO_DATE('2024-07-14', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) VALUES (15, 15, 16, 25, 15, 'Reason 15', TO_DATE('2024-07-15', 'YYYY-MM-DD'), '거절');

-- 의료기기이동내역 데이터
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
--- 의료기기
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 2,  2, '엑스선발생장치_Precision x-ray_US/X-RAD_320_320kV_45mA', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 3060000, 'X-ray generator');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 3,  3, '탁상형원심분리기  Kubota  JP/4000  5800rpm', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 5940000, 'tabletop centrifuge');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 4,  4, '일반강제대류배양기  한백과학  HB-101L', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 2376000, 'mechanical convection type universal culture machine');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 5,  5, '실체현미경  Olympus optical  JP/CH-2', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 1650000, 'stereoscopic microscope');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 6,  6, '형광현미경  Olympus  JP/BX51T', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 22000000, 'fluorescence microscope');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 7,  7, '의료용분리방식임상화학자동분석장치  Beckman Coulter  JP/AU480  ', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 73828000, 'Automatic Clinical Chemistry Analysis Unit for Medical Separation');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 8,  8, '의료용분광광도계  Cholestech  US/LDX', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 6000000, 'medical spectrophotometer');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 9,  9, '의료용면역형광측정장치  bioMerieux Italia s.p.a  IT/VIDAS PC BLUE  ', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 70532900, 'Medical Immunofluorescence Measurement Device');
INSERT INTO medical_device ( stock_item_id,  medical_device_no,  standard,  lease_period,  lease_amount,   english_name)
VALUES ( 10,  10, '자동염색기구  다가전자  AT-2000Z  세균자동염색기', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 20672000, 'automatic dyeing device');

--수리요청의료기기
insert into device_repair_request(device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state)
values (1, 2, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), '진공 누출', '승인대기');
insert into device_repair_request(device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state)
values (2, 3, 1, TO_DATE('2024-07-03', 'YYYY-MM-DD'), TO_DATE('2024-07-04', 'YYYY-MM-DD'), '베어링문제', '승인완료');
insert into device_repair_request(device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state)
values (3, 2, 1, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-07-04', 'YYYY-MM-DD'), '전원 공급 불안', '승인중');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (1, 2, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-05-30', 'YYYY-MM-DD'), '전원 안 켜짐', '요청' );

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (2, 5, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-05-29', 'YYYY-MM-DD'), '화면 깜빡임', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (3, 4, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-05-28', 'YYYY-MM-DD'), '배터리 문제', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (4, 6, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-05-27', 'YYYY-MM-DD'), '소리 안 남', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (5, 7, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-05-26', 'YYYY-MM-DD'), '터치 안 됨', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (6, 8, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), '충전 안 됨', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (7, 9, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-05-24', 'YYYY-MM-DD'), '카메라 문제', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (8, 10, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-05-23', 'YYYY-MM-DD'), '앱 실행 안 됨', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (9, 11, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'), '과열 문제', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (10, 12, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-05-21', 'YYYY-MM-DD'), '느려짐', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (11, 14, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), '화면 깨짐', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (12, 15, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-05-19', 'YYYY-MM-DD'), '네트워크 문제', '요청');

-- 의료기기 수리 업체 데이터 10개 삽입
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


-- 의료기기 수리
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



--- 더미 데이터2

-- 공급업체 데이터 15개 삽입
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (1, '서울제약', '101-23-4567', '010-1111-2222', '서울시 강남구 역삼로 123', '서울', '06212');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (2, '강북제약', '202-34-5678', '010-2222-3333', '서울시 서초구 서초대로 456', '서울', '06542');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (3, '중앙제약', '303-45-6789', '010-3333-4444', '서울시 종로구 종로 789', '서울', '03154');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (4, '삼성제약', '404-56-7890', '010-4444-5555', '서울시 마포구 마포대로 101', '서울', '04174');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (5, 'LG제약', '505-67-8901', '010-5555-6666', '서울시 영등포구 여의대로 202', '서울', '07223');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (6, '현대제약', '606-78-9012', '010-6666-7777', '서울시 강서구 화곡로 303', '서울', '07789');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (7, 'SK제약', '707-89-0123', '010-7777-8888', '서울시 송파구 송파대로 404', '서울', '05556');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (8, '롯데제약', '808-90-1234', '010-8888-9999', '서울시 강동구 천호대로 505', '서울', '05337');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (9, '한화제약', '909-01-2345', '010-9999-0000', '서울시 노원구 노원로 606', '서울', '01765');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (10, '포스코제약', '010-12-3456', '010-0000-1111', '서울시 동대문구 왕산로 707', '서울', '02534');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (11, 'GS제약', '111-23-4567', '010-1111-2222', '서울시 중구 세종대로 808', '서울', '04516');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (12, '두산제약', '212-34-5678', '010-2222-3333', '서울시 은평구 진흥로 909', '서울', '03378');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (13, '현대백화점제약', '313-45-6789', '010-3333-4444', '서울시 서대문구 통일로 1010', '서울', '03748');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (14, '신세계제약', '414-56-7890', '010-4444-5555', '서울시 구로구 구로동로 1111', '서울', '08378');
INSERT INTO SUPPLIER (supplier_id, supplier_name, business_no, tel_no, address, location, zipcode) VALUES (15, '이마트제약', '515-67-8901', '010-5555-6666', '서울시 관악구 관악로 1212', '서울', '08734');


-- 계약 공급처 20개 데이터 삽입
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (1, '서울의료원 의료 장비 공급 계약 2023', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'MRI 및 CT 장비 공급 계약', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (2, '연세대학교 의료원 의료 소모품 공급 계약 2023', TO_DATE('2023-02-01', 'YYYY-MM-DD'), '주사기 및 소모품 공급 계약', 2);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (3, '삼성서울병원 의료 약품 공급 계약 2023', TO_DATE('2023-03-01', 'YYYY-MM-DD'), '항생제 및 진통제 공급 계약', 3);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (4, '서울아산병원 의료 기기 유지보수 계약 2023', TO_DATE('2023-04-01', 'YYYY-MM-DD'), 'MRI 및 CT 기기 유지보수 계약', 4);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (5, '서울성모병원 의료 데이터 관리 계약 2023', TO_DATE('2023-05-01', 'YYYY-MM-DD'), '환자 데이터 관리 시스템 계약', 5);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (6, '한양대학교병원 의료 소모품 공급 계약 2023', TO_DATE('2023-06-01', 'YYYY-MM-DD'), '수술용 소모품 공급 계약', 6);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (7, '서울대학교병원 의료 장비 공급 계약 2023', TO_DATE('2023-07-01', 'YYYY-MM-DD'), '초음파 및 엑스레이 장비 공급 계약', 7);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (8, '분당서울대학교병원 의료 소모품 공급 계약 2023', TO_DATE('2023-08-01', 'YYYY-MM-DD'), '일회용 의료 소모품 공급 계약', 8);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (9, '고려대학교의료원 의료 약품 공급 계약 2023', TO_DATE('2023-09-01', 'YYYY-MM-DD'), '항암제 및 면역억제제 공급 계약', 9);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (10, '이대목동병원 의료 기기 유지보수 계약 2023', TO_DATE('2023-10-01', 'YYYY-MM-DD'), '의료 기기 유지보수 및 점검 계약', 10);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (11, '중앙대학교병원 의료 데이터 관리 계약 2023', TO_DATE('2023-11-01', 'YYYY-MM-DD'), '의료 정보 시스템 관리 계약', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (12, '가톨릭대학교 의정부성모병원 의료 소모품 공급 계약 2023', TO_DATE('2023-12-01', 'YYYY-MM-DD'), '진찰용 소모품 공급 계약', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (13, '순천향대학교 부천병원 의료 장비 공급 계약 2024', TO_DATE('2024-01-01', 'YYYY-MM-DD'), '초음파 및 MRI 장비 공급 계약', 13);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (14, '인하대학교병원 의료 소모품 공급 계약 2024', TO_DATE('2024-02-01', 'YYYY-MM-DD'), '수술용 소모품 공급 계약', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (15, '강남세브란스병원 의료 약품 공급 계약 2024', TO_DATE('2024-03-01', 'YYYY-MM-DD'), '항생제 및 진통제 공급 계약', 15);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (16, '건국대학교병원 의료 기기 유지보수 계약 2024', TO_DATE('2024-04-01', 'YYYY-MM-DD'), '의료 기기 유지보수 및 교체 계약', 12);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (17, '경희대학교병원 의료 데이터 관리 계약 2024', TO_DATE('2024-05-01', 'YYYY-MM-DD'), '환자 데이터 관리 시스템 계약', 11);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (18, '한림대학교 성심병원 의료 소모품 공급 계약 2024', TO_DATE('2024-06-01', 'YYYY-MM-DD'), '진찰용 소모품 공급 계약', 14);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (19, '서울특별시 보라매병원 의료 장비 공급 계약 2024', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 'MRI 및 CT 장비 공급 계약', 1);
INSERT INTO contract_supplier (contract_supplier_id, contract_name, contract_date, content, supplier_id) VALUES (20, '부산대학교병원 의료 소모품 공급 계약 2024', TO_DATE('2024-08-01', 'YYYY-MM-DD'), '수술용 소모품 공급 계약', 2);

select * from contract_supplier;
-- 공급 물품 20개 데이터 삽입
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (1, 102, '테라플루나이트타임', 6750, 'GSK', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (2, 102,'판콜에스내복액', 2760, '동화약품(주)', 2);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (3, 101,'에어브리스 KF94 미세먼지 마스크', 19800, '셀렉더마스크', 3);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (4, 103,'엑스레이발생기', 3060000, '사랑 의료기기', 4);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (5, 102,'판피린큐액', 2860, '동아제약(주)', 5);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (6, 102,'닥터베아제정', 2800, '대웅제약', 6);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (7, 102,'베나치오에프액', 1000, '동아제약(주)', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (8, 102,'마데카솔케어연고', 5560, '동국제약(주)', 8);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (9, 102,'케토톱플라스타', 11600, '태평양제약', 9);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (10, 102,'인사돌플러스정', 33500, '동국제약(주)', 10);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (11, 101,'PRIMO 미세먼지 마스크 KF94', 13900, '프리모 마스크', 11);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (12, 101,'에어브리스 KF94 미세먼지 마스크', 10000, '셀렉더마스크', 12);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (13, 101,'도부라이프텍 도부 초미세먼지 황사 방역마스크 KF94', 3700, '방역황사마스크 전문점', 13);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (14, 103,'형광현미경', 22000000, '한빛나노의료기(운암동)', 14);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (15, 103,'멀티미디어영상현미경', 1038000, '대민의료기', 15);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (16, 103,'안마의자', 1998000, '사랑 의료기기', 16);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (17, 101,'파더랩 KF94 TPE 마스크 ', 7000, '파더랩', 17);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (18, 103,'사지압박순환장치', 1384000, '지안메디케어', 18);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (19, 103,'아네로이드혈압계', 132000, '태원메디칼', 19);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (21, 103,'탁상형원심분리기', 5940000, 'SK 메디칼', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (22, 103,'강제순환식또는기계대류식범용배양기', 2376000, 'SK 메디칼', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (23, 103,'실체현미경', 1650000, '태원메디칼', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (24, 103,'의료용분리방식임상화학자동분석장치', 73828000, 'SK 메디칼', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (25, 103,'심미치과용광중합기또는액세서리', 400000, '한빛나노의료기(운암동)', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (26, 103,'체성분분석기', 12500000, 'SK 메디칼', 1);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (27, 103,'수술용레이저또는액세서리', 8370000, 'SK 메디칼', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (28, 103,'저주파자극기', 2735000, 'SK 메디칼', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (29, 103,'개인용온열기', 1089000, 'SK 메디칼', 7);
INSERT INTO item (item_id, commodity_classification_code, item_name, item_price, manufacturer, contract_supplier_id) VALUES (30, 103,'개인용조합자극기(두타베드)', 700000, 'SK 메디칼', 7);


-- 부서 20개 데이터 삽입 
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (1, '내과', '홍길동', '2층', '02-1234-5678');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (2, '외과', '이순신', '3층', '02-2345-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (3, '소아과', '강감찬', '4층', '02-3456-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (4, '산부인과', '유관순', '5층', '02-4567-8901');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (5, '정형외과', '장보고', '6층', '02-5678-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (6, '신경과', '안중근', '7층', '02-6789-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (7, '피부과', '김구', '8층', '02-7890-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (8, '비뇨기과', '윤봉길', '9층', '02-8901-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (9, '안과', '안창호', '10층', '02-9012-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (10, '치과', '김좌진', '11층', '02-0123-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (11, '이비인후과', '유진오', '12층', '02-1234-6789');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (12, '재활의학과', '최재형', '13층', '02-2345-7890');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (14, '응급의학과', '김원봉', '1층', '02-4567-9012');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (15, '가정의학과', '김홍집', '15층', '02-5678-0123');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (16, '심장내과', '서재필', '16층', '02-6789-1234');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (17, '혈액종양내과', '이승만', '17층', '02-7890-2345');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (18, '소화기내과', '박정희', '18층', '02-8901-3456');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (19, '호흡기내과', '김대중', '19층', '02-9012-4567');
INSERT INTO DEPARTMENT (DEPARTMENT_NO, DEPARTMENT_NAME, DEPARTMENT_MANAGER, DEPARTMENT_LOCATION, DEPARTMENT_TEL) VALUES (20, '내분비내과', '노무현', '20층', '02-0123-5678');

--부서정기품목
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

-- 청구물품 데이터 20개 삽입
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (1, 1, 1, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (2, 1, 2, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (3, 2, 3, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (4, 2, 4, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (5, 3, 5, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (6, 3, 6, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (7, 4, 7, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (8, 4, 8, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (9, 5, 9, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (10, 5, 10, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (11, 6, 11, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (12, 6, 12, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (13, 7, 13, 45, TO_DATE('2024-07-13', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (14, 7, 14, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (15, 8, 15, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (16, 8, 16, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (17, 9, 17, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (18, 9, 18, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '손상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (19, 10, 19, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '정상');
INSERT INTO charge_item (charge_item_id, department_no, item_id, charge_amount, charge_date, charger_item_state) VALUES (20,10, 20, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '정상');


-- 발주서 데이터 20개 삽입
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (1, '공급업체A', 50000, '발주서1');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (2, '공급업체B', 120000, '발주서2');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (3, '공급업체C', 75000, '발주서3');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (4, '공급업체D', 200000, '발주서4');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (5, '공급업체E', 95000, '발주서5');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (6, '공급업체F', 130000, '발주서6');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (7, '공급업체G', 110000, '발주서7');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (8, '공급업체H', 89000, '발주서8');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (9, '공급업체I', 67000, '발주서9');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (10, '공급업체J', 150000, '발주서10');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (11, '공급업체K', 53000, '발주서11');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (12, '공급업체L', 47000, '발주서12');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (13, '공급업체M', 92000, '발주서13');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (14, '공급업체N', 81000, '발주서14');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (15, '공급업체O', 160000, '발주서15');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (16, '공급업체P', 140000, '발주서16');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (17, '공급업체Q', 103000, '발주서17');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (18, '공급업체R', 75000, '발주서18');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (19, '공급업체S', 125000, '발주서19');
INSERT INTO order_form (order_form_id, supplier_name, total_price, order_form_name) VALUES (20, '공급업체T', 68000, '발주서20');

-- 발주물품 데이터 20개 삽입
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (1, 1, 1, 1000, 10, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (2, 2, 2, 2000, 20, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (3, 3, 3, 3000, 15, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (4, 4, 4, 4000, 25, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (5, 5, 5, 5000, 30, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (6, 6, 6, 6000, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (7, 7, 7, 7000, 12, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (8, 8, 8, 8000, 18, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (9, 9, 9, 9000, 22, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (10, 10, 10, 10000, 28, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (11, 11, 11, 11000, 35, TO_DATE('2024-07-11', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (12, 12, 12, 12000, 40, TO_DATE('2024-07-12', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (14, 14, 14, 14000, 50, TO_DATE('2024-07-14', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (15, 15, 15, 15000, 55, TO_DATE('2024-07-15', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (16, 16, 16, 16000, 60, TO_DATE('2024-07-16', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (17, 17, 17, 17000, 65, TO_DATE('2024-07-17', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (18, 18, 18, 18000, 70, TO_DATE('2024-07-18', 'YYYY-MM-DD'), '불량');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (19, 19, 19, 19000, 75, TO_DATE('2024-07-19', 'YYYY-MM-DD'), '입고');
INSERT INTO order_item (order_form_id, item_id, department_no, order_item_price, incoming_amount, incoming_date, incoming_state) VALUES (20, 20, 20, 20000, 80, TO_DATE('2024-07-20', 'YYYY-MM-DD'), '입고');

-- 재고물품 20개 데이터 등록
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


-- 의료기기 테이블 삽입
INSERT INTO medical_device VALUES (4,  1, '엑스선발생장치_Precision x-ray_US/X-RAD_320_320kV_45mA', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 306000, 'X-ray generator');
INSERT INTO medical_device VALUES (14, 2, '형광현미경  Olympus  JP/BX51T', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 2200000, 'fluorescence microscope');
INSERT INTO medical_device VALUES (15, 3, '멀티미디어영상현미경  Boyalok visiontech  CN/SmokerView', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 103800, 'Multimedia Imaging Microscope');
INSERT INTO medical_device VALUES (16, 4, 'CN/EP1280 K', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 187000, 'massage chair');
INSERT INTO medical_device VALUES (18, 5, 'Mark Ⅲ plus(MK-300)', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 138400, 'quadriplegic compression circulation system');
INSERT INTO medical_device VALUES (19, 6, '아네로이드식혈압계 ALP-K2 JP/500V 팔뚝형', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 13200, 'aneroid blood pressure gauge');
INSERT INTO medical_device VALUES (20, 7, 'MX50+Xplorer900-1', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 15000, 'X-ray');
INSERT INTO medical_device VALUES (21, 8, '탁상형원심분리기  Kubota  JP/4000  5800rpm', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 594000, 'tabletop centrifuge');
INSERT INTO medical_device VALUES (22, 9, '일반강제대류배양기  한백과학  HB-101L', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 237600, 'mechanical convection type universal culture machine');
INSERT INTO medical_device VALUES (23, 10, '실체현미경  Olympus optical  JP/CH-2', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 165000, 'stereoscopic microscope');
INSERT INTO medical_device VALUES (24, 11, '의료용분리방식임상화학자동분석장치  Beckman Coulter  JP/AU480  400test/h', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 738280, 'Automatic Clinical Chemistry Analysis Unit for Medical Separation');
INSERT INTO medical_device VALUES (25, 12, '치과용가시광선중합기', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 40000, 'Aesthetic Dental Melt Polymer');
INSERT INTO medical_device VALUES (26, 13, '체지방측정기  파닉스  FA-600  ADC측정회로및광학센서', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 1250000, 'body composition analyzer');
INSERT INTO medical_device VALUES (27, 14, '의료용레이저조사기  씨알테크놀러지  SALUS-TALENT  Diode', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 837000, 'surgical laser');
INSERT INTO medical_device VALUES (28, 15, 'Homer ion  JP/TENS 21  19mA', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 273500, 'low-frequency stimulator');
INSERT INTO medical_device VALUES (29, 16, '의자형', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 108900, 'personal heater');
INSERT INTO medical_device VALUES (30, 17, 'HS700-C', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 70000, 'Personal Combination Stimulator');


-- 물품사용이력 데이터 20개
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

-- 점검목록 상세 데이터 20개 삽입
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (1, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (2, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (3, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (4, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (5, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (6, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (7, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (8, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (9, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (10, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (11, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (12, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (13, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (14, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (15, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (16, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (17, '작동확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (18, '청결확인');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (19, '전원 ON/OFF');
INSERT INTO INSPECTION_DETAIL (inspection_detail_id, inspection_detail_NAME) VALUES (20, '작동확인');

-- MANAGER 테이블 30개 등록
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (1, '김철수', '010-1111-1111', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (2, '이영희', '010-2222-2222', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (3, '박민수', '010-3333-3333', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (4, '최지현', '010-4444-4444', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (5, '정다은', '010-5555-5555', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (6, '김민재', '010-6666-6666', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (7, '이서연', '010-7777-7777', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (8, '박지훈', '010-8888-8888', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (9, '최수민', '010-9999-9999', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (10, '정민호', '010-1010-1010', 10);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (11, '김소연', '010-1111-0000', 11);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (12, '이준호', '010-2222-1111', 12);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (14, '최예린', '010-4444-3333', 14);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (15, '정우성', '010-5555-4444', 15);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (16, '김태희', '010-6666-5555', 16);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (17, '이민호', '010-7777-6666', 17);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (18, '박보영', '010-8888-7777', 18);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (19, '최진혁', '010-9999-8888', 19);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (20, '정해인', '010-1010-9999', 20);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (21, '김고은', '010-1212-1212', 1);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (22, '이동욱', '010-2323-2323', 2);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (23, '박신혜', '010-3434-3434', 3);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (24, '최수진', '010-4545-4545', 4);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (25, '정채연', '010-5656-5656', 5);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (26, '김유정', '010-6767-6767', 6);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (27, '이종석', '010-7878-7878', 7);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (28, '박현진', '010-8989-8989', 8);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (29, '최영수', '010-9090-9090', 9);
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, MANAGER_TEL, DEPARTMENT_NO) VALUES (30, '정소민', '010-0000-0000', 10);

-- 의료기기점검목록 데이터 20개 삽입
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (1, 01, '점검목록1', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (2, 02, '점검목록2', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (3, 03, '점검목록3', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (4, 04, '점검목록4', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (5, 05, '점검목록5', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (6, 06, '점검목록6', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (7, 07, '점검목록7', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (8, 08, '점검목록8', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (9, 09, '점검목록9', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (10, 10, '점검목록10', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (11, 11, '점검목록11', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (12, 12, '점검목록12', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (14, 14, '점검목록14', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (15, 15, '점검목록15', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (16, 16, '점검목록16', '연간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (17, 17, '점검목록17', '월간');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (18, 18, '점검목록18', '분기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (19, 19, '점검목록19', '반기별');
INSERT INTO device_inspection_list (device_inspection_list_id, stock_item_id, device_inspection_list_name, device_inspection_list_period) VALUES (20, 20, '점검목록20', '연간');


-- 의료기기점검 데이터 10개 삽입
INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (1, 1, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), '정상', 3);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (2, 2, 2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), '정상', 5);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (3, 5, 5, TO_DATE('2024-07-03', 'YYYY-MM-DD'), '정상', 7);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (4, 6, 6, TO_DATE('2024-07-04', 'YYYY-MM-DD'), '정상', 9);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (5, 7, 7, TO_DATE('2024-07-05', 'YYYY-MM-DD'), '정상', 11);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (6, 8, 8, TO_DATE('2024-07-06', 'YYYY-MM-DD'), '정상', 12);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (7, 9, 9, TO_DATE('2024-07-07', 'YYYY-MM-DD'), '정상', 15);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (8, 10, 10, TO_DATE('2024-07-08', 'YYYY-MM-DD'), '정상', 16);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (9, 11, 11, TO_DATE('2024-07-09', 'YYYY-MM-DD'), '정상', 17);

INSERT INTO device_inspection (inspection_detail_id, device_inspection_list_id, stock_item_id, device_inspection_date, device_inspection_state, manager_id)
VALUES (10, 12, 12, TO_DATE('2024-07-10', 'YYYY-MM-DD'), '정상', 18);

-- 폐기 테이블 데이터 18개 삽입
INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (1, 1, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), '기기 손상', 10);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (2, 2, 2, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-06-16', 'YYYY-MM-DD'), '기기 수명 만료', 20);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (3, 3, 3, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-06-17', 'YYYY-MM-DD'), '기술적 결함', 30);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (4, 4, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-06-18', 'YYYY-MM-DD'), '기기 오작동', 40);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (5, 5, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-19', 'YYYY-MM-DD'), '오래된 모델', 50);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (6, 6, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), '부품 부족', 60);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (7, 7, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-06-21', 'YYYY-MM-DD'), '기술적 진보로 인한 교체', 70);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (8, 8, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-06-22', 'YYYY-MM-DD'), '기기 안전 문제', 80);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (9, 9, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-06-23', 'YYYY-MM-DD'), '기기 업그레이드 필요', 90);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (10, 10, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-06-24', 'YYYY-MM-DD'), '기기 사용 빈도 낮음', 100);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (11, 11, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), '기기 유지보수 비용 과다', 110);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (12, 12, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-06-26', 'YYYY-MM-DD'), '기기 사용 중단', 120);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (14, 14, 14, TO_DATE('2024-06-14', 'YYYY-MM-DD'), TO_DATE('2024-06-28', 'YYYY-MM-DD'), '기기 성능 저하', 140);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (15, 15, 15, TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-29', 'YYYY-MM-DD'), '기기 고장', 150);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (16, 16, 16, TO_DATE('2024-06-16', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), '기기 교체 필요', 160);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (17, 17, 17, TO_DATE('2024-06-17', 'YYYY-MM-DD'), TO_DATE('2024-07-01', 'YYYY-MM-DD'), '기기 파손', 170);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (18, 18, 18, TO_DATE('2024-06-18', 'YYYY-MM-DD'), TO_DATE('2024-07-02', 'YYYY-MM-DD'), '기기 감가상각', 180);

INSERT INTO disposal (disposal_id, stock_item_id, manager_id, request_date, disposal_date, content, disposal_amount)
VALUES (19, 19, 19, TO_DATE('2024-06-19', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), '기기 노후화', 190);


-- 의료기기 수리요청 11개 데이터 삽입
INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (1, 2, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-05-30', 'YYYY-MM-DD'), '전원 안 켜짐', '요청' );

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (2, 5, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-05-29', 'YYYY-MM-DD'), '화면 깜빡임', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (3, 4, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-05-28', 'YYYY-MM-DD'), '배터리 문제', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (4, 6, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-05-27', 'YYYY-MM-DD'), '소리 안 남', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (5, 7, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-05-26', 'YYYY-MM-DD'), '터치 안 됨', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (6, 8, 6, TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), '충전 안 됨', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (7, 9, 7, TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-05-24', 'YYYY-MM-DD'), '카메라 문제', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (8, 10, 8, TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-05-23', 'YYYY-MM-DD'), '앱 실행 안 됨', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (9, 11, 9, TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'), '과열 문제', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (10, 12, 10, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-05-21', 'YYYY-MM-DD'), '느려짐', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (11, 14, 11, TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), '화면 깨짐', '요청');

INSERT INTO device_repair_request (device_repair_request_id, stock_item_id, manager_id, device_repair_request_date, device_repair_failure_date, device_repair_failure_symptom, device_repair_request_state ) VALUES (12, 15, 12, TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-05-19', 'YYYY-MM-DD'), '네트워크 문제', '요청');

-- 의료기기 수리 업체 데이터 10개 삽입
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

-- 의료기기 수리 데이터 10개 삽입
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


-- 의료기기 이동신청서 데이터 15개 삽입
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (2, 2, 3, 12, 2, '부서 내 의료기기 부족으로 인한 이동 요청', TO_DATE('2024-07-02', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (4, 4, 5, 14, 4, '기기 고장으로 인한 대체 기기 요청', TO_DATE('2024-07-04', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (5, 5, 6, 15, 5, '신규 프로젝트 시작으로 인한 추가 기기 필요', TO_DATE('2024-07-05', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (6, 6, 7, 16, 6, '기존 기기의 성능 저하로 인한 교체 요청', TO_DATE('2024-07-06', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (7, 7, 8, 17, 7, '부서 이동으로 인한 기기 함께 이동 요청', TO_DATE('2024-07-07', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (8, 8, 9, 18, 8, '기기 유지보수 필요로 인한 이동 요청', TO_DATE('2024-07-08', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (9, 9, 10, 9, 9, '기기 효율성 증가를 위한 이동 요청', TO_DATE('2024-07-09', 'YYYY-MM-DD'), '거절');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (10, 10, 11, 10, 10, '기기 활용도 증가를 위한 이동 요청', TO_DATE('2024-07-10', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (11, 11, 12, 21, 11, '부서 내 기기 재배치로 인한 이동 요청', TO_DATE('2024-07-11', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (14, 14, 15, 24, 14, '부서 내 기기 부족으로 인한 긴급 요청', TO_DATE('2024-07-14', 'YYYY-MM-DD'), '승인');
INSERT INTO device_transfer_request (device_transfer_request_id, stock_item_id, transfer_department_no, manager_id, previous_department_no, device_tranfer_request_reason, device_tranfer_request_date, device_tranfer_request_state) 
    VALUES (15, 15, 16, 25, 15, '기기 성능 저하로 인한 교체 요청', TO_DATE('2024-07-15', 'YYYY-MM-DD'), '거절');

ALTER table device_transfer_request modify device_tranfer_request_state DEFAULT '승인 전';

-- 의료기기이동내역 데이터 10개 삽입
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (1, 10, 10, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (2, 2, 11, 2, TO_DATE('2024-07-02', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (3, 4, 12, 17, TO_DATE('2024-07-03', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (4, 5, 3, 13, TO_DATE('2024-07-04', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (5, 6, 14, 4, TO_DATE('2024-07-05', 'YYYY-MM-DD'));
INSERT INTO device_transfer_history (stock_item_id, device_transfer_request_id, privious_department_no, transfer_department_no, device_transfer_date) VALUES (6, 7, 15, 5, TO_DATE('2024-07-06', 'YYYY-MM-DD'));


