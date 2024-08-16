SELECT * FROM tbl_bonus;
SELECT * FROM tbl_emp;

MERGE INTO tbl_emp e
USING ( SELECT id, bonus FROM tbl_bonus ) b
ON (e.id = b.id)
WHEN MATCHED THEN
UPDATE SET e.bonus = b.bonus
WHEN NOT MATCHED THEN
INSERT (e.id, e.name, e.bonus) VALUES (b.id, 'new' , b.bonus)
;
ROLLBACK;
-- 제약조건(Constraint)
SELECT *
FROM user_constraints -- 뷰(view)
WHERE table_name = 'EMP';

-- 제약조건 사용 이유?
-- 1) 제약조건은 data integrity(데이터 무결성)을 위하여 주로 테이블에 행(row)을 입력, 수정, 삭제할 때 적용되는 규칙으로 사용되며 
-- 2) 테이블에 의해 참조되고 있는 경우 테이블의 삭제 방지를 위해서도 사용된다. 

-- (참고) 무결성 (integrity)
-- 데이터의 정확성과 일관성을 유지하고, 데이터에 결손과 부정합이 없음을 보증하는 것

-- 제약조건을 생성하는 방법 
-- (1) 테이블을 생성과 동시에 제약조건을 생성 (2가지 방법)
       -- IN-LINE 제약조건 설정 방법 (컬럼 레벨)
--          예) SEQ NUMBER PRIMARY KEY
--       -- OUT-OF-LINE 제약조건 설정 방법 (테이블 레벨)
--          CREATE TABLE XX
--          (
--            컬럼1 -- 컬럼레벨 (NOT NULL 제약 조건은 컬럼레벨만 설정가능)
--           ,컬럼2
--           
--           ,제약조건 설정 -- 테이블 레벨 (복합키 설정)
--           ,제약조건 설정
--           ,제약조건 설정
--           ,제약조건 설정
--          )
--          
--          예) 복합키 설정 이유?
--          [사원의 급여 지금 테이블]
--          PK (급여지급날짜 + 사원번호) 복합키        [역정규화]
--순번       급여지급날짜 사원번호 급여액
--1         2024.7.15  1111   3,000,000
--2         2024.7.15  1112   3,000,000
--3         2024.7.15  1113   3,000,000
--          :
--4         2024.8.15  1111   3,000,000
--          2024.8.15  1112   3,000,000
--          2024.8.15  1113   3,000,000

-- 컬럼 레벨 방식 제약조건
DROP TABLE tbl_constraint1;
DROP TABLE tbl_emp;
CREATE TABLE tbl_constraint1
(
    --empno NUMBER(4) NOT NULL PRIMARY KEY
    empno NUMBER(4) NOT NULL CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) CONSTRAINT fk_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT uk_tblconstraint1_email UNIQUE
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK( city IN ('서울','부산','대구') )
);

SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_C%';
-- ck_tblconstraint1_city 체크제약조건 비활성화 disable/enable
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT ck_tblconstraint1_city [CASCADE]; -- 비활성화
ENABLE CONSTRAINT ck_tblconstraint1_city; -- 활성화

-- 테이블 레벨 방식 제약 조건 설정
CREATE TABLE tbl_constraint1
(
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) 
    , email VARCHAR2(150) 
    , kor NUMBER(3) 
    , city VARCHAR2(20) 
    
    , CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY(empno)  --(empno, ename) 복합키
    , CONSTRAINT fk_tblconstraint1_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT uk_tblconstraint1_email UNIQUE(email)
    , CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)
    , CONSTRAINT ck_tblconstraint1_city CHECK( city IN ('서울','부산','대구') )  
);
-- 1) PK 제약조건 제거
ALTER TABLE tbl_constraint1
--DROP PRIMARY KEY
DROP CONSTRAINT PK_TBLCONSTRAINT1_EMPNO;
-- 2) CHECK 제약조건 삭제
ALTER TABLE tbl_constraint1
-- DROP CHECK(kor) X 불가
DROP CONSTRAINT CK_TBLCONSTRAINT1_KOR;
-- UNIQUE 삭제
ALTER TABLE tbl_constraint1
DROP UNIQUE(email);
--DROP CONSTRAINT UK_TBLCONSTRAINT1_EMAIL;

-- 기존 테이블 제약조건 추가
-- ALTER TABLE ... ADD [CONSTRAINT 제약조건명] 제약조건타입(컬럼명); 
-- NOT NULL 은 ALTER TABLE ... MODIFY 
DROP TABLE tbl_constraint3;
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);
--
1) empno 컬럼에 PK 제약조건 추가.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT pk_tblconstraint3_empno PRIMARY KEY(empno);
2) deptno 컬럼에 FK 제약조건 추가.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT fk_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);

-- FOREIGN KEY [ON DELETE CASCADE | ON DELETE SET NULL]
DELETE FROM dept
WHERE deptno = 10;

SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_%';
-- emp -> tbl_emp 생성
-- dept -> tbl_dept생성
CREATE TABLE tbl_emp
AS (SELECT * FROM emp);
CREATE TABLE tbl_dept
AS (SELECT * FROM dept);
-- tbl_dept
ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);

ALTER TABLE tbl_emp
ADD CONSTRAINT pk_tblemp_empno PRIMARY KEY(empno);
-- FK
ALTER TABLE tbl_emp
DROP CONSTRAINT FK_TBLEMP_DEPTNO;

ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tblemp_deptno FOREIGN KEY(deptno) 
                REFERENCES tbl_dept(deptno)
                ON DELETE SET NULL;
                --ON DELETE CASCADE;
SELECT *
FROM tbl_dept;
SELECT *
FROM tbl_emp;

DELETE FROM tbl_dept
WHERE deptno = 30;


-- JOIN(조인) --
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;

-- 단가테이블( 책의 가격 )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (식별관계 ***)
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- 책을 지은 저자테이블
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;

-- 고객            
-- 판매            출판사 <-> 서점
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- 판매
CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;
-- [문제] 책ID, 책제목, 출판사(c_name), 단가  컬럼 출력....
-- ㄱ.
SELECT b.*, price
FROM book b, danga d
WHERE b.b_id = d.b_id;
-- ㄴ.
SELECT b.*, price
FROM book b JOIN danga d ON b.b_id = d.b_id;
-- ㄷ. USING 절 ( 객체명. 별칭명. 사용X)
SELECT b_id, title, c_name, price
FROM book JOIN danga USING(b_id);
-- ㅁ. NATURAL JOIN 
SELECT b_id, title, c_name, price
FROM book NATURAL JOIN danga;
-- [문제]  책ID, 책제목, 판매수량, 단가, 서점명, 판매금액(=판매수량*단가) 출력

SELECT b.b_id, title, p_su, price, g.g_name, price * p_su 판매금액
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id
ORDER BY 1;

SELECT b.b_id, title, p_su, price, g.g_name, price * p_su 판매금액
FROM book b JOIN danga d ON b.b_id = d.b_id 
            JOIN panmai p ON b.b_id = p.b_id 
            JOIN gogaek g ON p.g_id = g.g_id
ORDER BY 1;
-- NON EQUI JOIN

SELECT * FROM emp;

UPDATE emp
SET deptno = NULL
WHERE ename = UPPER('king');
COMMIT;
-- JOIN 모든 emp 테이블의 사원 정보를 dept 테이블과 JOIN해서
-- dname, ename, hiredate 컬럼 출력
SELECT dname, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno(+) = e.deptno;

SELECT d.deptno, dname, COUNT(empno)
FROM emp e, dept d
WHERE e.deptno (+) = d.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno, dname;

SELECT *
FROM emp;

SELECT a.empno, a.ename, a.hiredate, b.ename 상사
FROM emp a, emp b
WHERE a.mgr = b.empno;

-- 문제) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
--      (    책ID, 책제목, 총판매권수, 단가 컬럼 출력   )

PANMAI BOOK DANGA

SELECT p.b_id, title, SUM(p_su) 총판매권수, price
FROM panmai p 
    JOIN book b ON p.b_id = b.b_id
    JOIN danga d ON b.b_id = d.b_id
GROUP BY p.b_id, title, price;

SELECT *
FROM
(
SELECT p.b_id, title, SUM(p_su) 총판매권수, price
FROM panmai p 
    JOIN book b ON p.b_id = b.b_id
    JOIN danga d ON b.b_id = d.b_id
GROUP BY p.b_id, title, price
ORDER BY 총판매권수 DESC
)
WHERE ROWNUM = 1;
--
-- 2) 순위 함수 
WITH t 
AS (
    SeLECT  b.b_id, title, SUM(p_su) 총판매권수, price
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY      b.b_id , title, price
), s AS (
  SELECT t.*
     , RANK() OVER(ORDER BY 총판매권수 DESC) 판매순위
   FROM t
)
SELECT s.*
FROM s
WHERE s.판매순위 = 1;-- 2) 순위 함수 
WITH t 
AS (
    SeLECT  b.b_id, title, SUM(p_su) 총판매권수, price
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY      b.b_id , title, price
), s AS (
  SELECT t.*
     , RANK() OVER(ORDER BY 총판매권수 DESC) 판매순위
   FROM t
)
SELECT s.*
FROM s
WHERE s.판매순위 = 1;
-- 3)
SELECT *
FROM(
SeLECT  b.b_id, title, SUM(p_su) 총판매권수, price
    , RANK()OVER(ORDER BY SUM(p_su) DESC) 판매순위
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY      b.b_id , title, price
) t
WHERE t.판매순위 =1;

-- 올해 판매권수가 가장 많은 책 정보 조회
SELECT *
FROM(
SeLECT  b.b_id, title, SUM(p_su) 총판매권수, price
    , RANK()OVER(ORDER BY SUM(p_su) DESC) 판매순위
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY b.b_id , title, price, TO_CHAR(p.P_DATE, 'yyyy')
    HAVING TO_CHAR(p.P_DATE, 'yyyy') = '2024'
) t
WHERE t.판매순위 =1;

SELECT *
FROM book;

SELECT b.b_id, title, price
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
        JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NULL
;
SELECT b.*, d.price
FROM book b JOIN danga d ON b.b_id = d.b_id 
WHERE b.b_id = ANY(SELECT DISTINCT b_id FROM panmai);
-- 문제) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)


SELECT g.g_id, g_name, SUM(p_su)
FROM panmai p, gogaek g, danga d
WHERE p.g_id = g.g_id AND p.b_id = d.b_id 
GROUP BY g.g_id, g_name;

SELECT p.b_id, SUM(p_su)
FROM panmai p JOIN danga d ON p.b_id = d.b_id 
GROUP BY p.b_id;

SELECT g.g_id, g_name, SUM(p_su * price) 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
        JOIN gogaek g ON p.g_id = g.g_id
GROUP BY g.g_id, g_name;

-- 년도 월별 판매
SELECT EXTRACT(year from p_date)년도, EXTRACT(month from p_date)월, SUM(p_su * price) 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
GROUP BY EXTRACT(year from p_date), EXTRACT(month from p_date)
ORDER BY EXTRACT(year from p_date), EXTRACT(month from p_date);

-- 서점별 년도별 판매현황
SELECT EXTRACT(year from p_date)년도, g_name, SUM(P_SU)판매수량
FROM panmai p, gogaek g WHERE p.g_id = g.g_id
GROUP BY EXTRACT(year from p_date), p.g_id, g_name
ORDER BY EXTRACT(year from p_date), p.g_id, g_name; 

-- 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )

SELECT p.b_id, b.title, price, SUM(p_su)총판매권수, SUM(p_su) * price 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
    JOIN book b ON b.b_id = p.b_id
GROUP BY p.b_id, price, b.title
HAVING SUM(p_su) * price >= 15000;