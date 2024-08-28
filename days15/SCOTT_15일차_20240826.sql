-- 트랜잭션 (Transaction)
-- 전체 성공(커밋) or 전체 취소(롤백

CREATE TABLE tbl_dept AS
SELECT * FROM dept;

SELECT * FROM tbl_dept;

-- 1) INSERT

INSERT INTO tbl_dept VALUES(50, 'development', 'COREA');
SAVEPOINT a; -- 특정지점 설정

-- 2) UPDATE

UPDATE tbl_dept
SET loc='ROK' 
WHERE deptno=50;

-- ROLLBACK; INSERT 이전으로 롤백.
ROLLBACK TO SAVEPOINT a;
ROLLBACK TO a;
ROLLBACK;
---- SESSION A
SELECT * FROM tbl_dept;

-- [ 패키지 ]
-- 패키지의 명세서 부분
CREATE OR REPLACE PACKAGE employee_pkg 
AS 
    -- 서브 프로그램( 저장 프로시저, 저장 함수 )
    procedure print_ename(p_empno number); 
    procedure print_sal(p_empno number);
    FUNCTION uf_age
    (
       pssn IN VARCHAR2
       , ptype IN NUMBER
    )
    RETURN NUMBER;
END employee_pkg;
-- 패키지 몸체 부분
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
   
      procedure print_ename(p_empno number) is 
         l_ename emp.ename%type; 
       begin 
         select ename 
           into l_ename 
           from emp 
           where empno = p_empno; 
       dbms_output.put_line(l_ename); 
      exception 
        when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end print_ename; 
   
   procedure print_sal(p_empno number) is 
      l_sal emp.sal%type; 
    begin 
      select sal 
       into l_sal 
        from emp 
        where empno = p_empno; 
     dbms_output.put_line(l_sal); 
    exception 
      when NO_DATA_FOUND then 
        dbms_output.put_line('Invalid employee number'); 
   end print_sal;  
   
   FUNCTION uf_age
(
   pssn IN VARCHAR2 
  ,ptype IN NUMBER --  1(세는 나이)  0(만나이)
)
RETURN NUMBER
IS
   ㄱ NUMBER(4);  -- 올해년도
   ㄴ NUMBER(4);  -- 생일년도
   ㄷ NUMBER(1);  -- 생일 지남 여부    -1 , 0 , 1
   vcounting_age NUMBER(3); -- 세는 나이 
   vamerican_age NUMBER(3); -- 만 나이 
BEGIN
   -- 만나이 = 올해년도 - 생일년도    생일지남여부X  -1 결정.
   --       =  세는나이 -1  
   -- 세는나이 = 올해년도 - 생일년도 +1 ;
   ㄱ := TO_CHAR(SYSDATE, 'YYYY');
   ㄴ := CASE 
          WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(pssn,1,2);
   ㄷ :=  SIGN(TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (생일X)

   vcounting_age := ㄱ - ㄴ +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ㄷ, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ㄷ
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
END employee_pkg;

SELECT name, ssn, EMPLOYEE_PKG.UF_AGE(ssn, 1) age
FROM insa;

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

