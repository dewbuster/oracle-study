-- 작업스케줄러
-- 일정 시간에 자동 실행되는 프로시저 함수
-- ** 1) DBMS_JOB 패키지
-- 2) DBMS_SCHEDULER 패키지 (Oracle 10g 이후 추가)

-- 프로시저, 함수 준비
-- 스키줄 설정
-- 잡 생성/삭제/중지 기능 체크
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

-- 잡 등록 ( DBMS_JOB.SUBMIT 프로시저 )
SELECT *
FROM user_jobs;  -- 등록된 job 조회
--
DECLARE
  vjob_no NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(
         job => vjob_no
       , what => 'UP_JOB;'
       , next_date => SYSDATE
       -- , interval => 'SYSDATE + 1'  하루에 한 번  문자열 설정
       -- , interval => 'SYSDATE + 1/24'
       -- , interval => 'NEXT_DAY(TRUNC(SYSDATE),'일요일') + 15/24'
       --    매주 일요일 오후3시 마다.
       -- , interval => 'LAST_DAY(TRUNC(SYSDATE)) + 18/24 + 30/60/24'
       --    매월 마지막 일의   6시 30분 마다..
       , interval => 'SYSDATE + 1/24/60' -- 매 분 마다       
    );
    COMMIT;
     DBMS_OUTPUT.PUT_LINE( '잡 등록된 번호 : ' || vjob_no );
END;

SELECT seq, TO_CHAR( insert_date, 'DL TS')
FROM tbl_job;
-- 잡 중지 : DBMS_JOB.BROKEN

BEGIN
    DBMS_JOB.BROKEN(1, true);  -- 재시작 할때는 false
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
-- 잡 속성 변경 : DBMS_JOB.CHANGE 프로시저 사용..


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

-- 회원 주문
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
    DBMS_OUTPUT.PUT_LINE( '주문상품' );
    DBMS_OUTPUT.PUT_LINE( vpdtname );
    DBMS_OUTPUT.PUT_LINE( '할인금액: ' || vdcprice );
    DBMS_OUTPUT.PUT_LINE( vprice  || ' ' || (vprice - vdcprice));
--EXCEPTION
END;

EXEC up_SelOrder(1005, 1, 2);