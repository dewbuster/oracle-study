-- 1) 게시판 테이블 생성 : tbl_board
-- 2) 컬럼: 글번호, 작성자, 비밀번호, 제목, 내용, 작성일, 조회수 등

CREATE TABLE tbl_board
(
    seq NUMBER(38) NOT NULL PRIMARY KEY
    , writer VARCHAR2(20) NOT NULL
    , password VARCHAR2(15) NOT NULL
    , title VARCHAR2(100) NOT NULL
    , content CLOB
    , regdate DATE DEFAULT SYSDATE
);
-- seq 글 번호에 사용할 시퀀스 생성

CREATE SEQUENCE seq_tblboard
--    INCREMENT BY 1
--    START WITH 1
    NOCACHE;
    
SELECT *
FROM user_sequences;

SELECT *
FROM tabs
WHERE table_name LIKE 'TBL_B%';
--
DROP TABLE tbl_board CASCADE;

-- 게시글 쓰기
INSERT INTO tbl_board (seq, writer, password, title, content) 
VALUES(seq_tblboard.NEXTVAL, 'aaa', '1234', 'TEST-1', 'TEST');
COMMIT;

INSERT INTO tbl_board (seq, writer, password, title, content) 
VALUES(seq_tblboard.NEXTVAL, '이시훈', '1234', 'TEST-2', 'TEST-2');

INSERT INTO tbl_board 
VALUES(seq_tblboard.NEXTVAL, '송세호', '1234', 'TEST-3', 'TEST-3', SYSDATE);
COMMIT;

SELECT seq, subject, writer
    , TO_CHAR(regdate, 'YYYY-MM-DD') regdate
    , readed
    , lastregdate
FROM tbl_board
ORDER BY seq DESC;

-- NN(C), PK(P)
SELECT *
FROM user_constraints
WHERE table_name = UPPER('tbl_board');

-- 조회수 컬럼 추가
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0;

INSERT INTO tbl_board (seq, writer, password, title)
VALUES(seq_tblboard.NEXTVAL, '원충희', '1234', 'TEST-4');
COMMIT;
-- 2번 게시글을 클릭 -> 게시글 상세보기 
-- 1) 조회수 1증가
UPDATE tbl_board
SET readed = readed + 1
WHERE seq = 2;
-- 2) 게시글(seq)의 정보를 조회
SELECT seq, subject, writer
    , TO_CHAR(regdate, 'YYYY-MM-DD') regdate
    , readed
    , content
FROM tbl_myboard
WHERE seq = 2;
--
SELECT seq, subject, writer
    , TO_CHAR(regdate, 'YYYY-MM-DD') regdate
    , readed
FROM tbl_myboard
ORDER BY seq DESC;
-- 게시판의 작성자 (writer 컬럼 20 -> 40 SIZE 확장)
-- 컬럼의 자료형의 크기를 수정..
ALTER TABLE tbl_board
MODIFY writer VARCHAR2(40); 
-- 제약 조건은 수정할 수 없다. (제약 조건 삭제 -> 생성 해야함)
DESC tbl_myboard;

-- 컬럼명이 title -> subject 수정
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;

-- 수정할 때의 날짜 정보를 저장할 컬럼을 추가. lastRegdate
ALTER TABLE tbl_board
ADD lastRegdate DATE;
--
UPDATE tbl_board
SET subject = '제목수정-3', content = '내용수정-3', lastregdate = SYSDATE
WHERE seq = 3;
COMMIT;

ALTER TABLE tbl_board
DROP COLUMN lastRegdate;

RENAME tbl_board TO tbl_myboard;

SELECT *
FROM tbl_myboard;
-- [테이블 생성하는 방법]
1. CREATE TABLE 생성
2. Subquery 를 이용한 테이블 생성.
    - 기존 이미 존재하는 테이블을 이용해서 새로운 테이블 생성
    - CREATE TABLE 테이블명 [컬럼명,...]
      AS (서브쿼리);
-- 예) emp 테이블로 부터 30번 사원들만 새로운 테이블 생성
CREATE TABLE tbl_emp30 -- ( eno, ename, hiredate, job, pay)
AS (
    SELECT empno, ename, hiredate, job, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno = 30
);
-- 제약 조건은 복사되지 않는다.
DESC tbl_emp30;

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP', 'TBL_EMP30');
-- emp -> 새로운 테이블 생성 + 데이타 복사 X
CREATE TABLE tbl_empcopy
AS
(
    SELECT *
    FROM emp
    WHERE 1 = 0
);
DROP TABLE tbl_tel;
-- SQL 확장 => PL/SQL
-- [문제] emp, dept, salgrade 테이블을 이용해서 
-- deptno, dname, empno, ename, hiredate, pay, grade 컬럼을
-- 가진 새로운 테이블 생성 (tbl_empgrade)
CREATE TABLE tbl_empgrade
AS(
SELECT b.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0)pay, grade
FROM emp a, dept b, salgrade c
WHERE a.deptno = b.deptno AND sal BETWEEN losal AND hisal
);

SELECT *
FROM tbl_empgrade;

DROP TABLE tbl_empgrade; -- 정식버전에서는 휴지통으로 감
PURGE RECYCLEBIN; -- 휴지통 비우기
DROP TABLE tbl_empgrade PURGE; -- 휴지통으로 이동하지 않고 완전삭제

-- JOIN ~ ON 구문 수정..
CREATE TABLE tbl_empgrade
AS(
SELECT b.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0)pay
, c.losal || ' ~ ' || c.hisal sal_range , grade
FROM emp a JOIN dept b ON a.deptno = b.deptno
           JOIN salgrade c ON sal BETWEEN losal AND hisal
);

-- emp 테이블의 구조만 복사해서 새로운 tbl_emp 테이블 생성
CREATE TABLE tbl_emp
AS(
    SELECT *
    FROM emp
    WHERE 1=2
);
SELECT *
FROM tbl_emp;
-- emp 테이블의 10번 부서원들을 tbl_emp 테이블에 INSERT 작업..

INSERT INTO tbl_emp SELECT * FROM emp WHERE deptno = 10;
COMMIT;
SELECT *
FROM tbl_emp;
INSERT INTO tbl_emp (empno, ename) SELECT empno, ename FROM emp WHERE deptno = 20;
COMMIT;

-- [다중 INSERT 문 4가지]
-- 1) unconditional insert all - 조건이 없는 INSERT ALL
CREATE TABLE tbl_emp10 AS( SELECT * FROM emp WHERE 1=0);
CREATE TABLE tbl_emp20 AS( SELECT * FROM emp WHERE 1=0);
CREATE TABLE tbl_emp30 AS( SELECT * FROM emp WHERE 1=0);
CREATE TABLE tbl_emp40 AS( SELECT * FROM emp WHERE 1=0);
--
INSERT INTO tbl_emp10 SELECT * FROM emp;
INSERT INTO tbl_emp20 SELECT * FROM emp;
INSERT INTO tbl_emp30 SELECT * FROM emp;
INSERT INTO tbl_emp40 SELECT * FROM emp;
-- 위의 쿼리 4개를 한번에 처리
INSERT ALL
    INTO tbl_emp10 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    INTO tbl_emp20 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    INTO tbl_emp30 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    INTO tbl_emp40 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT *
FROM emp;
ROLLBACK;
--2) conditional insert all - 조건이 있는 INSERT ALL 문
INSERT ALL
    WHEN deptno = 10 THEN 
        INTO tbl_emp10 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 20 THEN     
        INTO tbl_emp20 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 30 THEN 
        INTO tbl_emp30 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    ELSE
        INTO tbl_emp40 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT *
FROM emp;

SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;
SELECT * FROM tbl_emp40;
ROLLBACK;
-- 3) conditional first insert
INSERT FIRST  -- else if 처럼 조건 만족시 이후 조건 통과
    WHEN deptno = 10 THEN 
        INTO tbl_emp10 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN sal >= 2500 THEN     
        INTO tbl_emp20 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 30 THEN 
        INTO tbl_emp30 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    ELSE
        INTO tbl_emp40 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT *
FROM emp;
-- 4) pivoting insert
CREATE TABLE tbl_sales
(
    employee_id       number(6),
    week_id            number(2),
    sales_mon          number(8,2),
    sales_tue          number(8,2),
    sales_wed          number(8,2),
    sales_thu          number(8,2),
    sales_fri          number(8,2)
);


INSERT INTO tbl_sales VALUES(1101,4,100,150,80,60,120);
INSERT INTO tbl_sales VALUES(1102,5,300,300,230,120,150);
COMMIT;

SELECT *
FROM tbl_sales;

CREATE TABLE tbl_salesdata(
    employee_id        number(6),
    week_id            number(2),
    sales              number(8,2)
    );

INSERT ALL
    INTO tbl_salesdata VALUES(employee_id, week_id, sales_mon)
    INTO tbl_salesdata VALUES(employee_id, week_id, sales_tue)
    INTO tbl_salesdata VALUES(employee_id, week_id, sales_wed)
    INTO tbl_salesdata VALUES(employee_id, week_id, sales_thu)
    INTO tbl_salesdata VALUES(employee_id, week_id, sales_fri)
    SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed,
           sales_thu, sales_fri
FROM tbl_sales;

SELECT *
FROM tbl_salesdata;
DROP TABLE tbl_salesdata PURGE;

-- DELETE 문,    DROP TABLE 문,  TRUNCATE문 차이점
-- 레코드 삭제     테이블 삭제       레코드 모두 삭제
-- DML문         DDL             DML
-- 커밋/롤백                      자동커밋 - ROLLBACK X

-- insa 테이블에서 num , name 컬럼만을 복사해서 새로운 테이블 tbl_score
CREATE TABLE tbl_score
AS (
  SELECT num, name FROM insa WHERE num <= 1005
);
ALTER TABLE tbl_score
ADD(
    kor NUMBER(3) DEFAULT 0
    ,eng NUMBER(3) DEFAULT 0
    ,mat NUMBER(3) DEFAULT 0
    ,tot NUMBER(3) DEFAULT 0
    ,avg NUMBER(5,2) DEFAULT 0
    ,grade CHAR(1 CHAR)
    ,rank NUMBER(3)
);
--kor,eng,mat,tot,avg,grade,rank 컬럼 추가
DESC tbl_score;

UPDATE tbl_score
SET kor = ROUND(dbms_random.value(0, 100))
    ,eng = ROUND(dbms_random.value(0, 100))
    , mat = ROUND(dbms_random.value(0, 100));
COMMIT;    
SELECT * FROM tbl_score;

UPDATE tbl_score
SET (kor ,eng ,mat) = (SELECT kor, eng, mat FROM tbl_score WHERE num = 1001) 
WHERE num = 1005
;

UPDATE tbl_score
SET tot = kor + eng + mat
    ,avg = (kor + eng + mat) / 3;
COMMIT;
-- [문제] 모든 학생의 등수를 업데이트
UPDATE tbl_score m
SET rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot> m.tot);

UPDATE tbl_score p
SET rank = (
               SELECT t.r
               FROM (
                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
                   FROM tbl_score
               ) t
               WHERE t.num =p.num
           );
SELECT num, tot
    ,(SELECT COUNT(*)+1 FROM tbl_score WHERE tot>m.tot) rank
FROM tbl_score m;
SELECT *
FROM tbl_score;

UPDATE tbl_score
SET grade = DECODE( FLOOR(avg/10), 10,'수',9,'수',8,'우',7,'미',6,'양','가');
ROLLBACK;
INSERT ALL
    WHEN avg >= 90 THEN
         INTO tbl_score (grade) VALUES( 'A' )
    WHEN avg >= 80 THEN
         INTO tbl_score (grade) VALUES( 'B' )
    WHEN avg >= 70 THEN
         INTO tbl_score (grade) VALUES( 'C' )
    WHEN avg >= 60 THEN
         INTO tbl_score (grade) VALUES( 'D' )
    ELSE
         INTO tbl_score (grade) VALUES( 'F' )
SELECT avg FROM tbl_score ;

SELECT *
FROM tbl_score;
-- 모든 학생의 영어 점수를 40점
UPDATE tbl_score
SET eng = CASE
    WHEN eng >= 60 THEN 100
    ELSE eng + 40
    END;
ROLLBACK;
-- 남학생의 국어 점수를 -5점 감소

UPDATE tbl_score
SET kor = CASE
            WHEN kor -5 < 0 THEN 0 
            ELSE kor -5
          END
WHERE num = ANY(
    SELECT t.num FROM tbl_score t, insa i WHERE t.num = i.num AND MOD(SUBSTR(ssn,-7,1),2) = 1
    );
-- [문제] result 컬럼 추가
--      합격, 불합격, 과락
ALTER TABLE tbl_score
ADD(
    result CHAR(9)
);

UPDATE tbl_score
SET kor = 56
WHERE num = 1003;

SELECT *
FROM tbl_score;

UPDATE tbl_score
SET result = CASE
    WHEN kor < 40 OR eng < 40 OR mat < 40 THEN '과락'
    WHEN avg >= 60 THEN '합격'
    ELSE '불합격'
    END;
-----------------------------------------------------------

create table tbl_emp(
    id      number primary key 
    ,name   varchar2(10) not null
    ,salary number
    ,bonus  number default 100
);

INSERT INTO tbl_emp(id,name,salary) VALUES(1001,'jijoe',150);
INSERT INTO tbl_emp(id,name,salary) VALUES(1002,'cho',130);
INSERT INTO tbl_emp(id,name,salary) VALUES(1003,'kim',140);
COMMIT;
SELECT * FROM tbl_emp;
1001	jijoe	150	100
1002	cho	    130	100
1003	kim	    140	100
CREATE TABLE tbl_bonus
(
    id number
    , bonus number default 100
);
INSERT INTO tbl_bonus(id)(select e.id from tbl_emp e);
INSERT INTO tbl_bonus VALUES (1004, 50);
COMMIT;
SELECT * FROM tbl_bonus;
1001	100
1002	100
1003	100
1004	50
-- MERGE
MERGE INTO tbl_bonus b
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id)
WHEN MATCHED THEN
    UPDATE SET b.bonus = b.bonus + e.salary * 0.01
WHEN NOT MATCHED THEN
    INSERT (b.id, b.bonus) VALUES(e.id, e.salary * 0.01)
    ;
--------------- MERGE---------
--MERGE
--INTO T1 T
--USING T2 S
--ON (T.EMPNO = S.EMPNO)
--WHEN MATCHED THEN
--UPDATE
--SET T.SAL = S.SAL - 500
--WHERE T.JOB = 'CLERK'
--DELETE                 -- update 한 결과가 <2000면 삭제
--WHERE T.SAL < 2000
--WHEN NOT MATCHED THEN
--INSERT (T.EMPNO, T.ENAME, T.JOB)
--VALUES (S.EMPNO, S.ENAME, S.JOB)
--WHERE S.JOB = 'CLERK';  -- source job이 clerk 인 경우만 insert
-----------------------------