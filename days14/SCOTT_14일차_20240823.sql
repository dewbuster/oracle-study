-- TRIGGER
상품테이블
PK          재고수량
1 냉장고       10
2 TV          35
3 자전거       20
입고테이블
입고번호PK  입고날짜    입고상품번호(FK)  입고수량
1000                    2             30
판매테이블
판매번호PK  판매날짜    판매상품번호(FK)  판매수량
1000                    2             15
--
-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명        VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격     NUMBER
  ,재고수량       NUMBER DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;

SELECT * FROM 상품;
-- 문제1) 입고 테이블에 상품이 입고가 되면 자동으로 상품 테이블의 재고수량이  update 되는 트리거 생성 + 확인
-- 입고 테이블에 데이터 입력  
 --  ut_insIpgo
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
INSERT ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
--EXCEPTION
END;
 
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);
COMMIT;
---------------
SELECT * FROM 입고;
SELECT * FROM 상품;
-----------
UPDATE 입고 
SET 입고수량 = 30 
WHERE 입고번호 = 5;
COMMIT;
-- 문제2) 입고 테이블에서 입고가 수정되는 경우    상품테이블의 재고수량 수정. 
CREATE OR REPLACE TRIGGER ut_updIpgo
AFTER
UPDATE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량 - :OLD.입고수량
    WHERE 상품코드 = :NEW.상품코드;
--EXCEPTION
END;

-- 입고 테이블에서 입고가 취소되어서 입고 삭제.    상품테이블의 재고수량 수정. 
CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER
DELETE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량
    WHERE 상품코드 = :OLD.상품코드;
--EXCEPTION
END;

DELETE FROM 입고 
WHERE 입고번호 = 5;
COMMIT;

SELECT * FROM 판매;
SELECT * FROM 상품;

-- 문제4) 판매테이블에 판매가 되면 (INSERT) 
--       상품테이블의 재고수량이 수정
--      ut_insPan

CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
INSERT ON 판매
FOR EACH ROW
DECLARE
    vcount NUMBER;
BEGIN
    SELECT 재고수량 INTO vcount FROM 상품 WHERE 상품코드 = :NEW.상품코드;
    IF vcount < :NEW.판매수량 THEN
        RAISE_APPLICATION_ERROR(-20001, '재고수량 부족');
    ELSE
        UPDATE 상품
        SET 재고수량 = 재고수량 - :NEW.판매수량
        WHERE 상품코드 = :NEW.상품코드;
    END IF;
--EXCEPTION
END;

INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2023-11-10', 5, 1000000);

INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (2, 'AAAAAA', '2023-11-12', 50, 1000000);
COMMIT;
ROLLBACK;
SELECT * FROM 판매;
SELECT * FROM 상품;

-- 문제5) 판매번호 1  20     판매수량 5 -> 10
CREATE OR REPLACE TRIGGER ut_updPan
BEFORE
UPDATE ON 판매
FOR EACH ROW
DECLARE
    vqty NUMBER;
BEGIN
    SELECT 재고수량 INTO vqty FROM 상품 WHERE 상품코드 = :NEW.상품코드;
    vqty := vqty + :OLD.판매수량;
    IF vqty < :NEW.판매수량 THEN
        RAISE_APPLICATION_ERROR(-20001, '재고수량 부족 업데이트X');
    ELSE
        UPDATE 상품
        SET 재고수량 = 재고수량 + :OLD.판매수량 - :NEW.판매수량
        WHERE 상품코드 = :NEW.상품코드;
    END IF;
--EXCEPTION
END;

UPDATE 판매
SET 판매수량 = 10
WHERE 판매번호 = 1;

SELECT * FROM 판매;
SELECT * FROM 상품;

CREATE OR REPLACE TRIGGER ut_delPan
AFTER
DELETE ON 판매
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 + :OLD.판매수량
    WHERE 상품코드 = :OLD.상품코드;
--EXCEPTION
END;

DELETE FROM 판매 
WHERE 판매번호 = 1;

-- [ 예외처리 블럭 ]
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'admin', 90);
--ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found

CREATE OR REPLACE PROCEDURE up_exceptiontest
(
    psal IN emp.sal%TYPE    
)
IS
    vename emp.ename%TYPE;
BEGIN
    SELECT ename INTO vename FROM emp WHERE sal = psal;
    DBMS_OUTPUT.PUT_LINE('> vename = ' || vename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        RAISE_APPLICATION_ERROR(-20001, 'QUERY NO DATA FOUND');
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR(-20002, 'QUERY DATA TOO_MANY_ROWS FOUND');
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20003, 'QUERY OTHERS EXCEPTION FOUND');
END;
EXEC up_exceptiontest(800);
EXEC up_exceptiontest(9000);
01403-"no data found"  -- NO_DATA_FOUND
EXEC up_exceptiontest(2850);
01422-"exact fetch returns more than requested number of rows" -- TOO_MANY_ROWS

SELECT * FROM emp;

INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'admin', 90);
--ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found

CREATE OR REPLACE PROCEDURE up_insertemp
(
    pempno emp.empno%TYPE
    , pename emp.ename%TYPE
    , pdeptno emp.deptno%TYPE
)
IS
    PARENT_KEY_NOT_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT(PARENT_KEY_NOT_FOUND, -02291);
BEGIN
    INSERT INTO emp (empno, ename, deptno)
    VALUES (pempno, pename, pdeptno);
    COMMIT;
EXCEPTION
    WHEN PARENT_KEY_NOT_FOUND THEN 
        RAISE_APPLICATION_ERROR(-20011, 'QUERY FK 위배....');
    WHEN NO_DATA_FOUND THEN 
        RAISE_APPLICATION_ERROR(-20001, 'QUERY NO DATA FOUND');
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR(-20002, 'QUERY DATA TOO_MANY_ROWS FOUND');
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20003, 'QUERY OTHERS EXCEPTION FOUND');
END;

EXEC up_insertemp(9999, 'admin', 90);
-- [ 사용자가 정의한 에러처리 방법 ]
-- sal 범위가 A~B 사원수 카운팅
--                      0 내가 선언한 예외 강제로 발생..
CREATE OR REPLACE PROCEDURE up_myexception
(
    plosal NUMBER
    , phisal NUMBER
)
IS
    vcount NUMBER;
    -- 1) 사용자 정의 예외 객체(변수) 선언
    ZERO_EMP_COUNT EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO vcount
    FROM emp 
    WHERE sal BETWEEN plosal AND phisal;
    IF vcount = 0 THEN
    -- 2) 강제로 사용자가 정의한 에러를 발생
        RAISE ZERO_EMP_COUNT;
    ELSE
        DBMS_OUTPUT.PUT_LINE( '> 사원수 : ' || vcount );
    END IF;
EXCEPTION
    WHEN ZERO_EMP_COUNT THEN
        RAISE_APPLICATION_ERROR(-20022, 'QUERY 사원수가 0이다');
    WHEN NO_DATA_FOUND THEN 
        RAISE_APPLICATION_ERROR(-20001, 'QUERY NO DATA FOUND');
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR(-20002, 'QUERY DATA TOO_MANY_ROWS FOUND');
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20003, 'QUERY OTHERS EXCEPTION FOUND');
END;

EXEC up_myexception(800,1200);
EXEC up_myexception(6000,7200);