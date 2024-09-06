-- DBMS_OBFUSCATION_TOOLKIT ��ȣȭ ��Ű�� sys�� ���� ���Ѻο� �޾ƾ���
--����
CREATE OR REPLACE PACKAGE CryptIT
IS
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
END CryptIT;

--��ü
CREATE OR REPLACE PACKAGE BODY CryptIT
IS
   s VARCHAR2(2000);

   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
            p NUMBER := ((FLOOR(LENGTH(str)/8+0.9))*8);
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESEncrypt(
               input_string => RPAD(str,p)
                ,key_string => RPAD(HASH,8,'#')
                ,encrypted_string => s
            );
            RETURN s;
        END;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESDecrypt(
               input_string => str
                ,key_string => RPAD(HASH,8,'#')
                ,decrypted_string => s
            );
            RETURN TRIM(s);
        END;

END CryptIT;

CREATE TABLE tbl_member
(
    id VARCHAR2(20) PRIMARY KEY
    , passwd VARCHAR2(20)
); 
INSERT INTO tbl_member ( id, passwd ) VALUES (  'hong',  cryptit.encrypt( '1234', 'test') );
INSERT INTO tbl_member ( id, passwd ) VALUES (  'kenik',  cryptit.encrypt( 'kenik', 'test') );
select * from tbl_member;
ROLLBACK;
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
DROP TABLE O_REVURL;
DROP TABLE O_MEMBERSHIP;
DROP TABLE O_ORDER;
DROP TABLE O_ORDDETAIL;
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
<<<<<<< HEAD
-----------------------------------------------------
-----------------------------------------------------
=======

INSERT INTO O_CART VALUES(1, 1005);
INSERT INTO O_CARTLIST (CLIST_ID, CART_ID, PDT_ID, OPT_ID, CLIST_PDT_COUNT
, CLIST_ADDDATE, CLIST_SELECT)
VALUES(1, 1, 168, 7, 2, SYSDATE, 'Y');
INSERT INTO O_CARTLIST (CLIST_ID, CART_ID, PDT_ID, OPT_ID, CLIST_PDT_COUNT
, CLIST_ADDDATE, CLIST_SELECT)
VALUES(2, 1, 1, NULL, 1, SYSDATE, 'Y');
INSERT INTO O_CARTLIST (CLIST_ID, CART_ID, PDT_ID, OPT_ID, CLIST_PDT_COUNT
, CLIST_ADDDATE, CLIST_SELECT)
VALUES(3, 1, 2, NULL, 1, SYSDATE, 'N');
-- ȸ�� �ֹ�
CREATE SEQUENCE seq_OrderId;

BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || TO_CHAR(seq_OrderId.NEXTVAL, 'FM000000'));
END;

CREATE OR REPLACE PROCEDURE up_SelOrder
(
    puser_id O_ADDRESS.USER_ID%TYPE
    , pcart_id O_ORDER.CART_ID%TYPE
)
IS
    vname O_ADDRESS.ADDR_NAME%TYPE;
    vtel O_ADDRESS.ADDR_TEL%TYPE;
    vzipcode O_ADDRESS.ADDR_ZIPCODE%TYPE;
    vaddress O_ADDRESS.ADDR_ADDRESS%TYPE;
    vpdtname O_PRODUCT.PDT_NAME%TYPE;
    vprice O_PRODUCT.PDT_AMOUNT%TYPE;
    vdcprice O_PRODUCT.PDT_DISCOUNT_RATE%TYPE;
    vpdt_name O_PRODUCT.PDT_NAME%TYPE;
    vpdt_amount NUMBER;
    vpdt_dcamount NUMBER;
    vpdt_count NUMBER;
    vpdt_finalamount NUMBER;
    vopt_name O_PDTOPTION.OPT_NAME%TYPE;
    vopt_amount NUMBER;
    
    vtotal_amount NUMBER := 0;
    vtotal_discount NUMBER := 0;
    vtotal_price NUMBER := 0;
    vdfee NUMBER := 3000;
<<<<<<< HEAD
=======
    
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
    vpoint NUMBER;
BEGIN
    -- ��� ����
    SELECT ADDR_NAME, ADDR_TEL, ADDR_ZIPCODE, ADDR_ADDRESS 
    INTO vname, vtel, vzipcode, vaddress 
    FROM O_ADDRESS WHERE user_id = puser_id AND addr_main = 'O';
    DBMS_OUTPUT.PUT_LINE(vname || ' / ' || vtel);
    DBMS_OUTPUT.PUT_LINE('[' || vzipcode || '] ' || vaddress);
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
    -- īƮ �ֹ� ��ǰ ����
    FOR drow IN ( SELECT * FROM O_CARTLIST where cart_id = pcart_id )
    LOOP
    IF drow.clist_select = 'Y' THEN 
        SELECT PDT_NAME, PDT_AMOUNT, PDT_DISCOUNT_RATE, PDT_COUNT
        INTO vpdt_name, vpdt_amount, vpdt_dcamount, vpdt_count
        FROM O_PRODUCT WHERE pdt_id = drow.pdt_id;
<<<<<<< HEAD
        --��� üũ
        IF vpdt_count < drow.CLIST_PDT_COUNT THEN
            RAISE_APPLICATION_ERROR(-20121, '��� �������� �ֹ� ���� �Ұ�');
        END IF;
=======
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
        IF drow.opt_id IS NULL THEN
                vopt_name := NULL;
                vopt_amount := 0;
            ELSE
                SELECT OPT_NAME, OPT_AMOUNT
                INTO vopt_name, vopt_amount
                FROM O_PDTOPTION WHERE opt_id = drow.opt_id;
            END IF;
        vpdt_dcamount := vpdt_amount * vpdt_dcamount / 100;
        vpdt_finalamount := vpdt_amount - vpdt_dcamount;
        
        vpdt_dcamount := vpdt_dcamount * drow.CLIST_PDT_COUNT;
        vpdt_finalamount := (vpdt_finalamount + vopt_amount) * drow.CLIST_PDT_COUNT;
        vpdt_amount := (vpdt_amount + vopt_amount) * drow.CLIST_PDT_COUNT;
        DBMS_OUTPUT.PUT_LINE('*'||vpdt_name||'*');
        IF drow.opt_id IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('[�ɼ�:' || vopt_name||'(+'||TO_CHAR(vopt_amount, 'FM999,999,999')||')]');
        END IF;
<<<<<<< HEAD
        DBMS_OUTPUT.PUT_LINE('����: ' || drow.CLIST_PDT_COUNT || '��' || '    [���:'||vpdt_count||']');
=======
        DBMS_OUTPUT.PUT_LINE('����: ' || drow.CLIST_PDT_COUNT || '��');
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
        DBMS_OUTPUT.PUT_LINE('���� �ݾ� : -' || TO_CHAR(vpdt_dcamount, 'FM999,999,999'));
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vpdt_finalamount, 'FM999,999,999')
        ||' / '||TO_CHAR(vpdt_amount, 'FM999,999,999'));
        vtotal_amount := vtotal_amount + vpdt_amount;
        vtotal_discount := vtotal_discount + vpdt_dcamount;
        vtotal_price := vtotal_price + vpdt_finalamount;
    END IF;
    END LOOP;
    -- ����
    DBMS_OUTPUT.PUT_LINE('---------��밡�� ����------------');
    for drow IN ( 
    SELECT cpn_info
    FROM (SELECT cpn_id FROM O_ISSUEDCOUPON 
    WHERE user_id = puser_id AND ICPN_ISUSED = 'N') a 
    JOIN (SELECT cpn_id, cpn_info FROM O_COUPON 
    WHERE SYSDATE BETWEEN cpn_startdate AND cpn_enddate) b
    ON a.cpn_id = b.cpn_id
    )LOOP
        DBMS_OUTPUT.PUT_LINE(drow.cpn_info);
    END LOOP;
    -- ������
    SELECT USER_POINT INTO vpoint FROM O_USER WHERE user_id = puser_id;
    DBMS_OUTPUT.PUT_LINE('---------�Ϲ�/�ΰ�����------------');
    DBMS_OUTPUT.PUT_LINE('������(' || TO_CHAR(vpoint, 'FM999,999') || '�� ��밡��)');
    IF vpoint >= 3000 THEN
        DBMS_OUTPUT.PUT_LINE('������ ��� ����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�������� 3,000�� �̻��� �� ��� ����');
    END IF;
    -- ���� ���� ����
    IF vtotal_price >= 50000 THEN
    vdfee := 0;
    END IF;
    vtotal_price := vtotal_price + vdfee;
    DBMS_OUTPUT.PUT_LINE('---------���� ���� ����------------');
    DBMS_OUTPUT.PUT_LINE('�ֹ� �ݾ�:     '||TO_CHAR(vtotal_amount, 'FM999,999,999') ||'��');
    DBMS_OUTPUT.PUT_LINE('��ۺ�:        +'||TO_CHAR(vdfee, 'FM999,999') ||'��');
    DBMS_OUTPUT.PUT_LINE('���� �ݾ�:     -'||TO_CHAR(vtotal_discount, 'FM999,999,999') ||'��');
    DBMS_OUTPUT.PUT_LINE('���� ���� �ݾ�: '||TO_CHAR(vtotal_price, 'FM999,999,999') ||'��');
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
END;
-------------------------------------------------------------------------------
--------------------------------------------------------------------------------
EXEC up_SelOrder(1005, 1);

SELECT * FROM O_CARTLIST;
------------------------------------------------------------------------
--------------------����,�ֹ�,�ֹ��� INSERT ���ν���-----------------------
CREATE SEQUENCE seq_OrderId;
CREATE SEQUENCE seq_OrderProductId;
CREATE OR REPLACE PROCEDURE up_InsOrder
(
    puser_id O_ORDER.USER_ID%TYPE
    , pcart_id O_ORDER.CART_ID%TYPE
    , picpn_id O_ORDER.ICPN_ID%TYPE
    , pord_name O_ORDER.ORD_NAME%TYPE
    , pord_address O_ORDER.ORD_ADDRESS%TYPE
    , pord_tel O_ORDER.ORD_TEL%TYPE
    , pord_email O_ORDER.ORD_EMAIL%TYPE
    , pord_password O_ORDER.ORD_PASSWORD%TYPE
    , pord_orderdate O_ORDER.ORD_ORDERDATE%TYPE
    , pord_total_amount O_ORDER.ORD_TOTAL_AMOUNT%TYPE
    , pord_cpn_discount O_ORDER.ORD_CPN_DISCOUNT%TYPE
    , pord_pdt_discount O_ORDER.ORD_PDT_DISCOUNT%TYPE
    , pord_usepoint O_ORDER.ORD_USEPOINT%TYPE
    , pord_pay_option O_ORDER.ORD_PAY_OPTION%TYPE
    , pstate O_PAYMENT.PAY_STATE%TYPE
    , ptnumber O_PAYMENT.PAY_TRADE_NUMBER%TYPE
)
IS
    vord_id O_ORDER.ORD_ID%TYPE;
    vfinal_amount NUMBER;
    vdfee O_ORDER.ORD_DELIVERY_FEE%TYPE;
    vpdt_name O_PRODUCT.PDT_NAME%TYPE;
    vpdt_amount NUMBER;
    vpdt_dcamount NUMBER;
    vpdt_count NUMBER;
    vopt_name O_PDTOPTION.OPT_NAME%TYPE;
    vopt_amount NUMBER;
    vtotal_amount NUMBER := 0;
BEGIN
    FOR drow IN ( SELECT * FROM O_CARTLIST where cart_id = pcart_id )
    LOOP
        SELECT PDT_COUNT
        INTO vpdt_count
        FROM O_PRODUCT WHERE pdt_id = drow.pdt_id;
        IF vpdt_count < drow.CLIST_PDT_COUNT THEN
                RAISE_APPLICATION_ERROR(-20122, '��� �������� �ֹ� ���� �Ұ�');
        ELSE
            UPDATE O_PRODUCT
            SET PDT_COUNT = PDT_COUNT - drow.CLIST_PDT_COUNT
            WHERE pdt_id = drow.pdt_id;
        END IF;
    END LOOP;

    vord_id := TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || TO_CHAR(seq_OrderId.NEXTVAL, 'FM000000');
    vfinal_amount := pord_total_amount - pord_cpn_discount - pord_pdt_discount - pord_usepoint;

    -- �ֹ� ���̺� INSERT
    IF vfinal_amount >= 50000 THEN vdfee := 0;
    ELSE
        vdfee := 3000;
    END IF;
<<<<<<< HEAD
=======
    -- �ֹ� ���̺� INSERT
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
    INSERT INTO O_ORDER (ORD_ID, USER_ID, CART_ID, ICPN_ID, ORD_NAME, ORD_ADDRESS, ORD_TEL
    , ORD_EMAIL, ORD_PASSWORD, ORD_ORDERDATE, ORD_TOTAL_AMOUNT, ORD_CPN_DISCOUNT
    , ORD_PDT_DISCOUNT, ORD_USEPOINT, ORD_PAY_OPTION, ORD_DELIVERY_FEE)
    VALUES ( vord_id, puser_id, pcart_id, picpn_id, pord_name, pord_address, pord_tel
    , pord_email, pord_password, pord_orderdate, pord_total_amount, pord_cpn_discount
    , pord_pdt_discount, pord_usepoint, pord_pay_option, vdfee);
<<<<<<< HEAD
    
    -- ���� ���̺� INSERT ���ν���
    up_InsPayment(vord_id, puser_id, vfinal_amount, pord_orderdate,  pstate, ptnumber);
    
=======
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
    -- �ֹ��� ���̺� INSERT
    FOR drow IN ( SELECT * FROM O_CARTLIST where cart_id = pcart_id )
    LOOP
        IF drow.clist_select = 'Y' THEN 
            SELECT PDT_NAME, PDT_AMOUNT, PDT_DISCOUNT_RATE
            INTO vpdt_name, vpdt_amount, vpdt_dcamount
            FROM O_PRODUCT WHERE pdt_id = drow.pdt_id;
            vpdt_dcamount := vpdt_amount - (vpdt_amount * vpdt_dcamount / 100);
            
            IF drow.opt_id IS NULL THEN
                vopt_name := NULL;
                vopt_amount := 0;
            ELSE
                SELECT OPT_NAME, OPT_AMOUNT
                INTO vopt_name, vopt_amount
                FROM O_PDTOPTION WHERE opt_id = drow.opt_id;
            END IF;
            vpdt_amount := vpdt_amount * drow.clist_pdt_count;
            vpdt_dcamount := vpdt_dcamount * drow.clist_pdt_count;
            vopt_amount:= vopt_amount * drow.clist_pdt_count;
<<<<<<< HEAD
            INSERT INTO O_ORDDETAIL (OPDT_ID, ORD_ID, OPDT_NAME, OPDT_AMOUNT
=======
            INSERT INTO O_ORDDETAIL (OPDT_ID, ORD_ID, CLIST_ID, OPDT_NAME, OPDT_AMOUNT
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
            , OPDT_DCAMOUNT, OPDT_OPNAME, OPDT_OPAMOUNT, OPDT_COUNT, OPDT_STATE, OPDT_REFUND
            , OPDT_DELCOMPANY, OPDT_DELNUMBER, OPDT_CONFIRM) 
            VALUES ( seq_OrderProductId.NEXTVAL, vord_id, vpdt_name
            , vpdt_amount, vpdt_dcamount, vopt_name, vopt_amount, drow.clist_pdt_count
            , '�ֹ��Ϸ�', NULL, NULL, NULL, 'N');
        END IF;
    END LOOP;
    -- ���� �������� ����
    UPDATE O_ISSUEDCOUPON
    SET icpn_isused = 'Y'
    WHERE icpn_id = picpn_id;
    -- �ֹ��� ��ǰ ��ٱ��� ����
    DELETE FROM O_CARTLIST
    WHERE cart_id = pcart_id AND CLIST_SELECT = 'Y';

    SelOrdComplete(vord_id, pord_orderdate);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
END;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
CREATE SEQUENCE seq_PaymentId;
CREATE OR REPLACE PROCEDURE up_InsPayment
(
    pord_id O_PAYMENT.ORD_ID%TYPE
    , puser_id O_PAYMENT.USER_ID%TYPE
    , pamount NUMBER
    , poption O_PAYMENT.PAY_OPTION%TYPE
    , pstate O_PAYMENT.PAY_STATE%TYPE
    , ptnumber O_PAYMENT.PAY_TRADE_NUMBER%TYPE
)
IS
    vmem_id NUMBER;
    vmem_benefit NUMBER;
BEGIN
    INSERT INTO O_PAYMENT (PAY_ID, ORD_ID, USER_ID, PAY_AMOUNT, PAY_DATE
    , PAY_OPTION, PAY_STATE, PAY_TRADE_NUMBER)
    VALUES (seq_PaymentId.NEXTVAL, pord_id, puser_id, pamount, SYSDATE
    , poption, pstate, ptnumber);
    
    -- ������ �߰�
    IF pstate = 'success' THEN
        SELECT mem_id INTO vmem_id FROM O_USER WHERE user_id = puser_id;
        SELECT mem_benefit INTO vmem_benefit FROM O_MEMBERSHIP WHERE mem_id = vmem_id;
        
        UPDATE O_USER
        SET USER_POINT = USER_POINT + ROUND(pamount * vmem_benefit)
        WHERE user_id = puser_id;
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
END;
---------------------------------------------------------------------------
-------------------------------------------------------------------------
SELECT * FROM O_CART;
SELECT * FROM O_CARTLIST;
SELECT * FROM O_COUPON;
SELECT * FROM O_ISSUEDCOUPON;
SELECT * FROM O_USER;
SELECT * FROM O_ADDRESS;
SELECT * FROM O_ORDER;
SELECT * FROM O_ORDDETAIL;
SELECT * FROM O_PAYMENT;

<<<<<<< HEAD
EXEC up_InsOrder(1005, 1, 1, '������', '���� ������ ������ 264 ���� ���̾� ������Ʈ 101�� 908ȣ', '010-3497-3698', 'ssit0005@naver.com', NULL, SYSDATE, 68800, 5000, 5770, 0, 'īī������', 'success', '240012-1120442');
---------------------------------------------------------------
---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SelOrdComplete
(
    pord_id O_PAYMENT.ORD_ID%TYPE
    , pord_orderdate O_ORDER.ORD_ORDERDATE%TYPE
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE( '�ֹ��� �Ϸ� �Ǿ����ϴ�.' );
    DBMS_OUTPUT.PUT_LINE( '�ֹ���ȣ  ' ||  pord_id);
    DBMS_OUTPUT.PUT_LINE( '�ֹ�����  ' || TO_CHAR(pord_orderdate, 'YYYY-MM-DD HH:MI:SS'));
END;

CREATE OR REPLACE PROCEDURE SelOrdDetail
(
    pord_id O_PAYMENT.ORD_ID%TYPE
)
IS
    drow O_ORDER%ROWTYPE;
    vdcamount NUMBER;
    vfinalamount NUMBER;
BEGIN
    SELECT * INTO drow FROM O_ORDER WHERE ORD_ID = pord_id;
    vdcamount := drow.ORD_PDT_DISCOUNT - drow.ORD_CPN_DISCOUNT;
    vfinalamount := drow.ORD_TOTAL_AMOUNT - vdcamount;
    DBMS_OUTPUT.PUT_LINE('----�ֹ�����----');
    DBMS_OUTPUT.PUT_LINE('�ֹ���ȣ  '||drow.ORD_ID);
    DBMS_OUTPUT.PUT_LINE('�ֹ�����  '||TO_CHAR(drow.ORD_ORDERDATE, 'YYYY-MM-DD HH:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('�ֹ���   '||drow.ORD_NAME); 
    DBMS_OUTPUT.PUT_LINE('----��������----');
    DBMS_OUTPUT.PUT_LINE('�� �ֹ��ݾ�  '||TO_CHAR(drow.ORD_TOTAL_AMOUNT,'FM999,999,999'));
    DBMS_OUTPUT.PUT_LINE('�� ���αݾ�  '||TO_CHAR(vdcamount,'FM999,999,999'));
    DBMS_OUTPUT.PUT_LINE('�� �����ݾ�  '||TO_CHAR(vfinalamount,'FM999,999,999'));
    DBMS_OUTPUT.PUT_LINE('��������    '||drow.ORD_PAY_OPTION);
    DBMS_OUTPUT.PUT_LINE('----�ֹ���ǰ����----');
    FOR ddrow IN (SELECT * FROM O_ORDDETAIL WHERE ORD_ID = pord_id)
    LOOP
        DBMS_OUTPUT.PUT_LINE(ddrow.OPDT_NAME ||' '|| ddrow.OPDT_AMOUNT 
        ||' '|| ddrow.OPDT_COUNT ||' '|| ddrow.OPDT_STATE||' '|| NVL(ddrow.OPDT_REFUND, '-'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----�������----');
    DBMS_OUTPUT.PUT_LINE('�����ôº� '||drow.ORD_NAME); 
    DBMS_OUTPUT.PUT_LINE('�ּ� '||drow.ORD_ADDRESS);
    DBMS_OUTPUT.PUT_LINE('��ȭ��ȣ '||drow.ORD_TEL);
END;
SELECT * FROM O_ORDER;
EXEC selOrdDetail('20240830-000019');
=======
EXEC up_InsOrder(1005, 1, 1,  '������', '���� ������ ������ 264 ���� ���̾� ������Ʈ 101�� 908ȣ', '010-3497-3698', 'ssit0005@naver.com', NULL, SYSDATE, 63040, 0, 5760, 0, 'īī�� ����');
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
