SELECT *
FROM emp;

SELECT DISTINCT buseo
FROM insa
ORDER BY buseo ASC;
-- ASC 오름차순
-- DESC 내림차순
--
SELECT deptno, ename, sal + NVL(comm, 0) PAY
FROM emp
ORDER BY 1 ASC, 3 DESC;  -- 1 deptno, 3 pay 뜻함
--ORDER BY deptno ASC, PAY DESC;
-- 2차 정렬 부서번호를 먼저 정렬하고 그 안에서 PAY로 정렬

SELECT ename, sal + NVL(comm, 0) PAY
FROM emp
WHERE sal + NVL(comm, 0) BETWEEN 1000 AND 3000 AND deptno != 30
ORDER BY ename;

SELECT *
FROM (
    SELECT deptno, ename, sal + NVL(comm, 0) PAY
    FROM emp
    WHERE deptno != 30
    ) e
WHERE PAY BETWEEN 1000 AND 3000
ORDER BY ename;

WITH temp AS ( 
            SELECT deptno, ename, sal + NVL(comm, 0) PAY
            FROM emp
            WHERE deptno != 30
            )
SELECT *
FROM temp
WHERE PAY BETWEEN 1000 AND 3000
ORDER BY ename;
------------

SELECT *
FROM emp
WHERE mgr IS NULL;

SELECT empno
    ,ename
    ,job
    ,NVL(TO_CHAR(MGR), 'CEO') MGR
FROM emp
WHERE mgr IS NULL;

SELECT *
FROM insa;

SELECT num
    ,name
    ,NVL(tel, '연락처 등록 안됨') TEL
FROM insa
WHERE tel IS NULL;

SELECT num
    ,name
    ,NVL2(tel, 'O', 'X') TEL
FROM insa
WHERE buseo = '개발부';

select * from emp;

SELECT empno
    ,ename
    ,sal
    ,NVL(comm, 0) COMM
    ,sal + NVL(comm, 0) PAY
FROM emp;
--
select * from emp;
SELECT empno
    ,ename
    ,sal
    ,NVL(comm, 0) COMM
    ,sal + NVL(comm, 0) PAY
FROM emp
WHERE ename = 'KING';
--
select * from insa;
--
SELECT *
FROM insa
WHERE CITY NOT IN ('서울', '경기', '인천');
--
select * from emp;
SELECT *
FROM emp
WHERE deptno = 30 AND comm IS NULL;

SELECT deptno
    ,ename
    ,sal
    ,NVL(comm, 0) COMM
    ,sal + NVL(comm, 0) pay
FROM emp
WHERE deptno = 30 AND comm IS NULL;

select * from insa;

SELECT ssn
    ,SUBSTR(ssn, 0, 2) YEAR
    ,TO_CHAR( TO_DATE( SUBSTR(ssn, 0, 6)), 'MM') MONTH
    ,EXTRACT( DAY FROM TO_DATE( SUBSTR(ssn, 0, 6))) "DATE"
    ,SUBSTR(ssn, 8, 1) GENDER
FROM insa;

SELECT name
    ,ssn
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d12')
--WHERE REGEXP_LIKE(ssn, '^7[0-9]12')
--WHERE REGEXP_LIKE(ssn, '^7.12')
ORDER BY ssn;

select * from insa;

SELECT e.*
    , MOD(SUBSTR(ssn, -7, 1), 2)
FROM insa e
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, -7, 1), 2) = 1;

SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d{5}-[13579]');

SELECT *
FROM emp
WHERE LOWER(ename) LIKE '%la%';
-- WHERE REGEXP_LIKE(ename, 'la', 'i'); -- 대소문자 구분 X
-- WHERE ename LIKE '%' || UPPER('la') || '%';

SELECT * from insa;
--23 
-- PL/SQL ( DQL ) : SELECT
SELECT name, ssn
    , NVL2(NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1 ),'O','X')GENDER
FROM insa;
-- DECODE() 함수
-- CASE() 함수

--24
SELECT *
FROM insa
WHERE TO_CHAR(ibsadate, 'YYYY') BETWEEN '2000' and '2099';
--
SELECT 
TO_CHAR(SYSDATE, 'YYYY') y
,TO_CHAR(SYSDATE, 'MM') m
,TO_CHAR(SYSDATE, 'DD') d
,TO_CHAR(SYSDATE, 'HH') h
,TO_CHAR(SYSDATE, 'MI') m
,TO_CHAR(SYSDATE, 'SS') s
FROM dual;

SELECT 
EXTRACT(YEAR FROM SYSDATE) y
,EXTRACT(MONTH FROM SYSDATE) m
,EXTRACT(DAY FROM SYSDATE) d
,EXTRACT(HOUR FROM CAST(SYSDATE AS TIMESTAMP)) h
,EXTRACT(MINUTE FROM CAST(SYSDATE AS TIMESTAMP)) mi
,EXTRACT(SECOND FROM CAST(SYSDATE AS TIMESTAMP)) s
FROM dual;

SELECT *
FROM dual;

SELECT *
FROM insa
WHERE ibsadate >= '2000.01.01';
WHERE EXTRACT(year FROM ibsadate) BETWEEN '2000' and '2099';

SELECT SYSDATE
    , CURRENT_TIMESTAMP
FROM dual;

SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[김이]') AND ssn LIKE '7_12%';

SELECT COUNT(*)
FROM insa;

-- 3일차
-- LIKE 연산자의 ESCAPE 옵션
SELECT deptno, dname, loc
FROM dept;
-- dept 테이블에 새로운 부서정보.. DML : INSERT 문
-- PK = NN + UK 조건
INSERT INTO dept (deptno, dname, loc) VALUES (60, '한글_나라', 'COREA');
INSERT INTO dept VALUES (60, '한글_나라', 'COREA');
COMMIT;
ROLLBACK;

-- 부서명에 % 포함된 부서
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';

SELECT *
FROM dept;
-- DML(DELETE) WHERE 조건절이 없으면 모든 레코드 삭제
DELETE FROM dept
WHERE deptno = 60;
COMMIT;
-- DML(UPDATE)
UPDATE dept
SET dname = 'QC' -- WHERE 조건절 없으면 모든 레코드 수정
ROLLBACK;

UPDATE dept
--SET dname = dname || 'XX'
SET dname = SUBSTR( dname, 0, 2), loc = 'COREA'
WHERE deptno = 50;
ROLLBACK;
-- [문제] 40번 부서의 부서명, 지역명을 얻어와서 50번 부서의 부서명, 지역명으로 수정

UPDATE dept
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno = 40)
WHERE deptno = 50;
ROLLBACK;
---
SELECT *
FROM dept;
---
DELETE FROM dept
WHERE deptno IN (50, 60, 70);
--WHERE deptno BETWEEN 50 AND 70;
COMMIT;

-- [문제] emp 테이블 모든 사원 sal 기본급을 pay급여에 10% 인상하는 UPDATE
SELECT *
FROM emp;
ROLLBACK;
UPDATE emp
SET SAL = sal + (sal + NVL(comm, 0)) * 0.1;
--dual 테이블 = SYNONYM(시노님)
-- public 시노님 생성 권한 없음 DBA만 가능
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

-- 권한 부여
GRANT SELECT ON emp TO HR;
-- 권한 회수
REVOKE SELECT ON emp FROM HR;

----------------------------------------------------
-- [오라클 연산자(operator) 정리]
--1) 비교연산자 : = !=  >   <   >=   <=
--            WHERE 절에서 숫자,문자,날짜를 비교할 때 사용
--            ANY, SOME, ALL 비교연산자, SQL연산자
--2) 논리연산자 : AND   OR   NOT
--            WHERE 절에서 조건을 결합할 때...
--3) SQL 연산자 : SQL 언어에만 있는 연산자
--            [NOT] IN (list)
--            [NOT] BETWEEN a AND b 
--            [NOT] LIKE 
--            IS [NOT] NULL 
--            ANY, SOME, ALL      WHERE 절 + (서브쿼리)
--            EXISTS(TRUE/FALSE)  WHERE 절 + (서브쿼리)
--4) NULL 연산자
--5) 산술 연산자 : 덧셈, 뺄셈, 곱셈, 나눗셈  (우선 순위)            
SELECT 5+3, 5-3, 5*3, 5/3
    , FLOOR(5/3)
    , MOD(5,3)
FROM dual;