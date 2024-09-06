-- DBMS_OBFUSCATION_TOOLKIT 암호화 패키지 sys로 부터 권한부여 받아야함
--선언
CREATE OR REPLACE PACKAGE CryptIT
IS
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
END CryptIT;

--몸체
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

-- 주문 결제
SELECT * FROM O_AUTH;
SELECT * FROM O_USER;   -- 1005 주윤발
SELECT * FROM O_CATEGORY;
SELECT * FROM O_COUPON;
SELECT * FROM O_ISSUEDCOUPON;

-- 배송지 추가

배송지 등록 쿼리
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
  -- O 여부 찾기
  
  select count(*) into vcount
  from o_address
  where USER_ID = PUSER_ID
  and ADDR_MAIN = 'O';
  
-- 있으면 기존꺼 X로 바꾸기
  if vcount > 0 THEN
    update o_address
    set ADDR_MAIN = 'X'
    where USER_ID = PUSER_ID
      and ADDR_MAIN = 'O';
  end if;
 
  INSERT INTO o_address (
    ADDR_ID,         -- 배송지 ID
    USER_ID,         -- 회원 ID
    ADDR_NICK,       -- 배송지명
    ADDR_NAME,       -- 수령인
    ADDR_HTEL,       -- 휴대전화
    ADDR_TEL,        -- 전화번호
    ADDR_ADDRESS,    -- 배송지 주소
    ADDR_ZIPCODE,    -- 우편번호
    ADDR_MAIN        -- 대표 배송지 여부
  ) VALUES (
    O_ADDRESS_SEQ.NEXTVAL,  -- ADDR_ID는 시퀀스를 통해 자동 생성
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
    PADDR_NICK => '집',
    PADDR_NAME => '주윤발',
    PADDR_HTEL => '02-',
    PADDR_TEL => '010-3497-3698',
    PADDR_ADDRESS => '서울 강남구 개포로 264 개포 래미안 포레스트 101동 908호',
    PADDR_ZIPCODE => '06310',
    PADDR_MAIN => 'O'
  );
END;
BEGIN
  Inso_address(
    PUSER_ID => 1003,
    PADDR_NICK => '사무실',
    PADDR_NAME => '김영희',
    PADDR_HTEL => '010-1234-5678', 
    PADDR_TEL => '02-1234-5678',
    PADDR_ADDRESS => '쌍용교육센터 5강의실',
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
-- 회원 주문
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
    -- 배송 정보
    SELECT ADDR_NAME, ADDR_TEL, ADDR_ZIPCODE, ADDR_ADDRESS 
    INTO vname, vtel, vzipcode, vaddress 
    FROM O_ADDRESS WHERE user_id = puser_id AND addr_main = 'O';
    DBMS_OUTPUT.PUT_LINE(vname || ' / ' || vtel);
    DBMS_OUTPUT.PUT_LINE('[' || vzipcode || '] ' || vaddress);
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
    -- 카트 주문 상품 정보
    FOR drow IN ( SELECT * FROM O_CARTLIST where cart_id = pcart_id )
    LOOP
    IF drow.clist_select = 'Y' THEN 
        SELECT PDT_NAME, PDT_AMOUNT, PDT_DISCOUNT_RATE, PDT_COUNT
        INTO vpdt_name, vpdt_amount, vpdt_dcamount, vpdt_count
        FROM O_PRODUCT WHERE pdt_id = drow.pdt_id;
<<<<<<< HEAD
        --재고 체크
        IF vpdt_count < drow.CLIST_PDT_COUNT THEN
            RAISE_APPLICATION_ERROR(-20121, '재고 부족으로 주문 진행 불가');
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
            DBMS_OUTPUT.PUT_LINE('[옵션:' || vopt_name||'(+'||TO_CHAR(vopt_amount, 'FM999,999,999')||')]');
        END IF;
<<<<<<< HEAD
        DBMS_OUTPUT.PUT_LINE('수량: ' || drow.CLIST_PDT_COUNT || '개' || '    [재고:'||vpdt_count||']');
=======
        DBMS_OUTPUT.PUT_LINE('수량: ' || drow.CLIST_PDT_COUNT || '개');
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
        DBMS_OUTPUT.PUT_LINE('할인 금액 : -' || TO_CHAR(vpdt_dcamount, 'FM999,999,999'));
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vpdt_finalamount, 'FM999,999,999')
        ||' / '||TO_CHAR(vpdt_amount, 'FM999,999,999'));
        vtotal_amount := vtotal_amount + vpdt_amount;
        vtotal_discount := vtotal_discount + vpdt_dcamount;
        vtotal_price := vtotal_price + vpdt_finalamount;
    END IF;
    END LOOP;
    -- 쿠폰
    DBMS_OUTPUT.PUT_LINE('---------사용가능 쿠폰------------');
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
    -- 적립금
    SELECT USER_POINT INTO vpoint FROM O_USER WHERE user_id = puser_id;
    DBMS_OUTPUT.PUT_LINE('---------일반/부가결제------------');
    DBMS_OUTPUT.PUT_LINE('적립금(' || TO_CHAR(vpoint, 'FM999,999') || '원 사용가능)');
    IF vpoint >= 3000 THEN
        DBMS_OUTPUT.PUT_LINE('적립금 사용 가능');
    ELSE
        DBMS_OUTPUT.PUT_LINE('적립금은 3,000원 이상일 때 사용 가능');
    END IF;
    -- 최종 결제 정보
    IF vtotal_price >= 50000 THEN
    vdfee := 0;
    END IF;
    vtotal_price := vtotal_price + vdfee;
    DBMS_OUTPUT.PUT_LINE('---------최종 결제 정보------------');
    DBMS_OUTPUT.PUT_LINE('주문 금액:     '||TO_CHAR(vtotal_amount, 'FM999,999,999') ||'원');
    DBMS_OUTPUT.PUT_LINE('배송비:        +'||TO_CHAR(vdfee, 'FM999,999') ||'원');
    DBMS_OUTPUT.PUT_LINE('할인 금액:     -'||TO_CHAR(vtotal_discount, 'FM999,999,999') ||'원');
    DBMS_OUTPUT.PUT_LINE('최종 결제 금액: '||TO_CHAR(vtotal_price, 'FM999,999,999') ||'원');
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
END;
-------------------------------------------------------------------------------
--------------------------------------------------------------------------------
EXEC up_SelOrder(1005, 1);

SELECT * FROM O_CARTLIST;
------------------------------------------------------------------------
--------------------결제,주문,주문상세 INSERT 프로시저-----------------------
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
                RAISE_APPLICATION_ERROR(-20122, '재고 부족으로 주문 진행 불가');
        ELSE
            UPDATE O_PRODUCT
            SET PDT_COUNT = PDT_COUNT - drow.CLIST_PDT_COUNT
            WHERE pdt_id = drow.pdt_id;
        END IF;
    END LOOP;

    vord_id := TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || TO_CHAR(seq_OrderId.NEXTVAL, 'FM000000');
    vfinal_amount := pord_total_amount - pord_cpn_discount - pord_pdt_discount - pord_usepoint;

    -- 주문 테이블 INSERT
    IF vfinal_amount >= 50000 THEN vdfee := 0;
    ELSE
        vdfee := 3000;
    END IF;
<<<<<<< HEAD
=======
    -- 주문 테이블 INSERT
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
    INSERT INTO O_ORDER (ORD_ID, USER_ID, CART_ID, ICPN_ID, ORD_NAME, ORD_ADDRESS, ORD_TEL
    , ORD_EMAIL, ORD_PASSWORD, ORD_ORDERDATE, ORD_TOTAL_AMOUNT, ORD_CPN_DISCOUNT
    , ORD_PDT_DISCOUNT, ORD_USEPOINT, ORD_PAY_OPTION, ORD_DELIVERY_FEE)
    VALUES ( vord_id, puser_id, pcart_id, picpn_id, pord_name, pord_address, pord_tel
    , pord_email, pord_password, pord_orderdate, pord_total_amount, pord_cpn_discount
    , pord_pdt_discount, pord_usepoint, pord_pay_option, vdfee);
<<<<<<< HEAD
    
    -- 결제 테이블 INSERT 프로시저
    up_InsPayment(vord_id, puser_id, vfinal_amount, pord_orderdate,  pstate, ptnumber);
    
=======
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
    -- 주문상세 테이블 INSERT
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
            , '주문완료', NULL, NULL, NULL, 'N');
        END IF;
    END LOOP;
    -- 사용된 쿠폰으로 변경
    UPDATE O_ISSUEDCOUPON
    SET icpn_isused = 'Y'
    WHERE icpn_id = picpn_id;
    -- 주문한 제품 장바구니 비우기
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
    
    -- 적립금 추가
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
EXEC up_InsOrder(1005, 1, 1, '주윤발', '서울 강남구 개포로 264 개포 래미안 포레스트 101동 908호', '010-3497-3698', 'ssit0005@naver.com', NULL, SYSDATE, 68800, 5000, 5770, 0, '카카오페이', 'success', '240012-1120442');
---------------------------------------------------------------
---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SelOrdComplete
(
    pord_id O_PAYMENT.ORD_ID%TYPE
    , pord_orderdate O_ORDER.ORD_ORDERDATE%TYPE
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE( '주문이 완료 되었습니다.' );
    DBMS_OUTPUT.PUT_LINE( '주문번호  ' ||  pord_id);
    DBMS_OUTPUT.PUT_LINE( '주문일자  ' || TO_CHAR(pord_orderdate, 'YYYY-MM-DD HH:MI:SS'));
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
    DBMS_OUTPUT.PUT_LINE('----주문정보----');
    DBMS_OUTPUT.PUT_LINE('주문번호  '||drow.ORD_ID);
    DBMS_OUTPUT.PUT_LINE('주문일자  '||TO_CHAR(drow.ORD_ORDERDATE, 'YYYY-MM-DD HH:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('주문자   '||drow.ORD_NAME); 
    DBMS_OUTPUT.PUT_LINE('----결제정보----');
    DBMS_OUTPUT.PUT_LINE('총 주문금액  '||TO_CHAR(drow.ORD_TOTAL_AMOUNT,'FM999,999,999'));
    DBMS_OUTPUT.PUT_LINE('총 할인금액  '||TO_CHAR(vdcamount,'FM999,999,999'));
    DBMS_OUTPUT.PUT_LINE('총 결제금액  '||TO_CHAR(vfinalamount,'FM999,999,999'));
    DBMS_OUTPUT.PUT_LINE('결제수단    '||drow.ORD_PAY_OPTION);
    DBMS_OUTPUT.PUT_LINE('----주문상품정보----');
    FOR ddrow IN (SELECT * FROM O_ORDDETAIL WHERE ORD_ID = pord_id)
    LOOP
        DBMS_OUTPUT.PUT_LINE(ddrow.OPDT_NAME ||' '|| ddrow.OPDT_AMOUNT 
        ||' '|| ddrow.OPDT_COUNT ||' '|| ddrow.OPDT_STATE||' '|| NVL(ddrow.OPDT_REFUND, '-'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----배송정보----');
    DBMS_OUTPUT.PUT_LINE('받으시는분 '||drow.ORD_NAME); 
    DBMS_OUTPUT.PUT_LINE('주소 '||drow.ORD_ADDRESS);
    DBMS_OUTPUT.PUT_LINE('전화번호 '||drow.ORD_TEL);
END;
SELECT * FROM O_ORDER;
EXEC selOrdDetail('20240830-000019');
=======
EXEC up_InsOrder(1005, 1, 1,  '주윤발', '서울 강남구 개포로 264 개포 래미안 포레스트 101동 908호', '010-3497-3698', 'ssit0005@naver.com', NULL, SYSDATE, 63040, 0, 5760, 0, '카카오 페이');
>>>>>>> 6f104a9e49c0f2b5dce522fdc05e46d8129585aa
