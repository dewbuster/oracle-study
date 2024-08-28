-- �۾������ٷ�
-- ���� �ð��� �ڵ� ����Ǵ� ���ν��� �Լ�
-- ** 1) DBMS_JOB ��Ű��
-- 2) DBMS_SCHEDULER ��Ű�� (Oracle 10g ���� �߰�)

-- ���ν���, �Լ� �غ�
-- ��Ű�� ����
-- �� ����/����/���� ��� üũ
CREATE TABLE tbl_job
(
    seq NUMBER
    , insert_date DATE
);
--
CREATE OR REPLACE PROCEDURE up_job
IS
    vseq NUMBER;
BEGIN
    SELECT NVL(MAX(seq),0)+1 INTO vseq
    FROM tbl_job;
    
    INSERT INTO tbl_job VALUES ( vseq, SYSDATE );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE( SQLERRM );
END;

-- �� ��� ( DBMS_JOB.SUBMIT ���ν��� )
SELECT *
FROM user_jobs;  -- ��ϵ� job ��ȸ
--
DECLARE
  vjob_no NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(
         job => vjob_no
       , what => 'UP_JOB;'
       , next_date => SYSDATE
       -- , interval => 'SYSDATE + 1'  �Ϸ翡 �� ��  ���ڿ� ����
       -- , interval => 'SYSDATE + 1/24'
       -- , interval => 'NEXT_DAY(TRUNC(SYSDATE),'�Ͽ���') + 15/24'
       --    ���� �Ͽ��� ����3�� ����.
       -- , interval => 'LAST_DAY(TRUNC(SYSDATE)) + 18/24 + 30/60/24'
       --    �ſ� ������ ����   6�� 30�� ����..
       , interval => 'SYSDATE + 1/24/60' -- �� �� ����       
    );
    COMMIT;
     DBMS_OUTPUT.PUT_LINE( '�� ��ϵ� ��ȣ : ' || vjob_no );
END;

SELECT seq, TO_CHAR( insert_date, 'DL TS')
FROM tbl_job;
-- �� ���� : DBMS_JOB.BROKEN

BEGIN
    DBMS_JOB.BROKEN(1, true);  -- ����� �Ҷ��� false
    COMMIT;
END;

BEGIN
    DBMS_JOB.RUN(1);
    COMMIT;
END;

BEGIN
    DBMS_JOB.REMOVE(1);
    COMMIT;
END;
-- �� �Ӽ� ���� : DBMS_JOB.CHANGE ���ν��� ���..


UPDATE O_PRODUCT
SET SCAT_ID = 1
WHERE SCAT_ID = 3;

ALTER TABLE O_SUBCATEGORY
DROP COLUMN CAT_ID;

DELETE FROM O_SUBCATEGORY
WHERE SCAT_ID = 3;

COMMIT;

-- 

DROP TABLE O_USER;
DROP TABLE O_ADDRESS;
DROP TABLE O_CART;
DROP TABLE O_CARTLIST;
DROP TABLE O_CATEGORY;
DROP TABLE O_COLOR;
DROP TABLE O_COMMENT;
DROP TABLE O_COUPON;
DROP TABLE O_DELIVERY;
DROP TABLE O_DESIGN;
DROP TABLE O_EVENT;
DROP TABLE O_ISSUEDCOUPON;
DROP TABLE O_LINEUP;
DROP TABLE O_MEMBERSHIP;
DROP TABLE O_ORDER;
DROP TABLE O_ORDPRODUCT;
DROP TABLE O_PAYMENT;
DROP TABLE O_PDTOPTION;
DROP TABLE O_PRODUCT;
DROP TABLE O_REVIEW;
DROP TABLE O_SUBCATEGORY;
DROP TABLE O_PDTCOLOR;
DROP TABLE O_PDTDESIGN;
DROP TABLE O_PDTLINEUP;
DROP TABLE O_ORDERSTATE;
DROP TABLE O_AUTH;
DROP TABLE O_NOTICE;
DROP TABLE O_FAQ;
DROP TABLE O_FAQCATEGORY;
DROP TABLE O_ASK;

-- �ֹ� ����
SELECT * FROM O_AUTH;
SELECT * FROM O_USER;   -- 1005 ������
SELECT * FROM O_CATEGORY;
SELECT * FROM O_COUPON;
SELECT * FROM O_ISSUEDCOUPON;

-- ����� �߰�

����� ��� ����
create sequence O_ADDRESS_SEQ;
create or replace procedure Inso_address(
  PUSER_ID       o_address.USER_ID%TYPE, 
  PADDR_NICK     o_address.ADDR_NICK%TYPE,
  PADDR_NAME     o_address.ADDR_NAME%TYPE,
  PADDR_HTEL     o_address.ADDR_HTEL%TYPE,
  PADDR_TEL      o_address.ADDR_TEL%TYPE,
  PADDR_ADDRESS  o_address.ADDR_ADDRESS%TYPE,
  PADDR_ZIPCODE  o_address.ADDR_ZIPCODE%TYPE,
  PADDR_MAIN     o_address.ADDR_MAIN%TYPE
) IS
  vcount number;
begin
  -- O ���� ã��
  
  select count(*) into vcount
  from o_address
  where USER_ID = PUSER_ID
  and ADDR_MAIN = 'O';
  
-- ������ ������ X�� �ٲٱ�
  if vcount > 0 THEN
    update o_address
    set ADDR_MAIN = 'X'
    where USER_ID = PUSER_ID
      and ADDR_MAIN = 'O';
  end if;
 
  INSERT INTO o_address (
    ADDR_ID,         -- ����� ID
    USER_ID,         -- ȸ�� ID
    ADDR_NICK,       -- �������
    ADDR_NAME,       -- ������
    ADDR_HTEL,       -- �޴���ȭ
    ADDR_TEL,        -- ��ȭ��ȣ
    ADDR_ADDRESS,    -- ����� �ּ�
    ADDR_ZIPCODE,    -- �����ȣ
    ADDR_MAIN        -- ��ǥ ����� ����
  ) VALUES (
    O_ADDRESS_SEQ.NEXTVAL,  -- ADDR_ID�� �������� ���� �ڵ� ����
    PUSER_ID,
    PADDR_NICK,
    PADDR_NAME,
    PADDR_HTEL,
    PADDR_TEL,
    PADDR_ADDRESS,
    PADDR_ZIPCODE,
    PADDR_MAIN
  );
  COMMIT;  
  EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
select * from o_user;
select * from o_address;
BEGIN
  Inso_address(
    PUSER_ID => 1005,
    PADDR_NICK => '��',
    PADDR_NAME => '������',
    PADDR_HTEL => '02-',
    PADDR_TEL => '010-3497-3698',
    PADDR_ADDRESS => '���� ������ ������ 264 ���� ���̾� ������Ʈ 101�� 908ȣ',
    PADDR_ZIPCODE => '06310',
    PADDR_MAIN => 'O'
  );
END;

BEGIN
  Inso_address(
    PUSER_ID => 1003,
    PADDR_NICK => '�繫��',
    PADDR_NAME => '�迵��',
    PADDR_HTEL => '010-1234-5678', 
    PADDR_TEL => '02-1234-5678',
    PADDR_ADDRESS => '�ֿ뱳������ 5���ǽ�',
    PADDR_ZIPCODE => '06310',
    PADDR_MAIN => 'O'
  );
END;

select * from o_address;

delete from o_address;

-- ȸ�� �ֹ�
CREATE SEQUENCE seq_OrderId;

BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || TO_CHAR(seq_OrderId.NEXTVAL, '000000'));
END;

CREATE OR REPLACE PROCEDURE up_SelOrder
(
    puser_id O_ADDRESS.USER_ID%TYPE
    , ppdt_id O_PRODUCT.pdt_id%TYPE
    , pcount NUMBER := 1
)
IS
    vname O_ADDRESS.ADDR_NAME%TYPE;
    vtel O_ADDRESS.ADDR_TEL%TYPE;
    vzipcode O_ADDRESS.ADDR_ZIPCODE%TYPE;
    vaddress O_ADDRESS.ADDR_ADDRESS%TYPE;
    vpdtname O_PRODUCT.PDT_NAME%TYPE;
    vprice O_PRODUCT.PDT_AMOUNT%TYPE;
    vdcprice O_PRODUCT.PDT_DISCOUNT_RATE%TYPE;
BEGIN
    SELECT ADDR_NAME, ADDR_TEL, ADDR_ZIPCODE, ADDR_ADDRESS 
    INTO vname, vtel, vzipcode, vaddress 
    FROM O_ADDRESS WHERE user_id = puser_id;
    
    SELECT PDT_NAME, PDT_AMOUNT, NVL(PDT_DISCOUNT_RATE, 0)
    INTO vpdtname, vprice, vdcprice
    FROM O_PRODUCT WHERE pdt_id = ppdt_id; 
    vdcprice := (vprice * vdcprice / 100) * pcount;
    vprice := vprice * pcount;
    DBMS_OUTPUT.PUT_LINE( vname || ' / ' || vtel );
    DBMS_OUTPUT.PUT_LINE( '[' || vzipcode || '] ' || vaddress );
    DBMS_OUTPUT.PUT_LINE( '�ֹ���ǰ' );
    DBMS_OUTPUT.PUT_LINE( vpdtname );
    DBMS_OUTPUT.PUT_LINE( '���αݾ�: ' || vdcprice );
    DBMS_OUTPUT.PUT_LINE( vprice  || ' ' || (vprice - vdcprice));
--EXCEPTION
END;

EXEC up_SelOrder(1005, 1, 2);