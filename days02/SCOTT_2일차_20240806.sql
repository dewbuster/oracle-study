-- SCOTT
-- 1) SCOTT 소유한 테이블 목록 조회
SELECT *
FROM user_tables;
FROM tabs;

-- INSA 테이블 구조 파악
DESC insa;
--NUMBER(5) == NUMBER(5,0) 소수점 0자리
SELECT *
FROM insa;
-- IBSADATE - DATE
-- '98/10/11'
SELECT * 
FROM v$nls_parameters;
-- 월급(pay) = 기본급(Sal) + 수당(comm)
SELECT *
FROM emp;
SELECT empno, ename, hiredate
--, NVL2(comm, comm, 0)
, sal + NVL(comm, 0) AS pay
FROM emp;
-- 문제) emp 테이블에서 사원번호, 사원명, 직속상사
-- 직속상사가 null일 경우 'CEO' 라고 출력
SELECT empno, ename, mgr
, NVL( TO_CHAR(mgr), 'CEO' ) AS MGR -- TO_CHAR() 컬럼 타입을 문자로 바꿈
, NVL( mgr||'', 'CEO' ) AS MGR -- ||'' 컬럼 타입을 문자로 바꿈
FROM emp;
DESC emp;
-- emp 테이블에서 이름은 'smith'이고, 직업은 clerk이다
SELECT '이름은 ''' || ename || '''이고, 직업은' || job || '이다.'
FROM emp;

-- emp 테이블에서 부서번호가 10번인 사원들만 조회
SELECT *
FROM dept;

SELECT *
FROM emp
WHERE deptno = 10;
-- 문제) emp 테이블에서 10번 부서원만 제외한 나머지 사원들 조회
SELECT *
FROM emp
WHERE deptno != 10;
WHERE deptno ^= 10;
WHERE deptno <> 10;
-- 오라클 논리 연산자 AND, OR, NOT  - deptno = 20 OR deptno = 30
SELECT *
FROM emp
WHERE deptno IN ( 20, 30, 40 );  -- 아래와 동일 내부 OR 연산자로 처리
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;

-- [문제] emp 테이블에서 사원명이 ford인 사원의 모든 사원정보를 출력
SELECT *
FROM emp
WHERE ename = UPPER('ford');

SELECT LOWER(ename), INITCAP(job)
FROM emp;

-- [문제] emp 테이블에서 커미션이 Null인 사원의 정보 출력
SELECT *
FROM emp
WHERE comm IS NULL;
WHERE comm IS NOT NULL;

-- [문제] 2000 이상 월급(pay) 4000 이하 받는 사원
SELECT e.*, sal + NVL(comm, 0) PAY
FROM emp e
WHERE sal + NVL(comm, 0) BETWEEN 2000 and 4000;
-- WITH [temp] AS 서브쿼리
WITH temp AS (
            SELECT e.*, sal + NVL(comm, 0) pay
            FROM emp e
            )
SELECT *
FROM temp
WHERE pay BETWEEN 2000 AND 4000;
-- 인라인뷰 (inline view) 사용
--서브쿼리가 FROM 절에 있으면 이를 Inline view라하고
--서브쿼리가 WHERE 절에 있으면 이를 중첩Nested subquery라 하며
--Nested subquery중에서 참조하는 테이블이 parent, child관계를 가지면 이를 상관서브쿼리correlated subquery라 한다.
SELECT *
FROM(
    SELECT emp.*, sal + NVL(comm, 0) pay
    FROM emp
    ) e
WHERE pay BETWEEN 2000 AND 4000;

-- [문제] insa 테이블에서 70년대생인 사원의 정보를 조회
SELECT name, ssn
FROM insa
WHERE SUBSTR(ssn, 0, 2) BETWEEN 70 AND 79;

SELECT name, ssn
FROM insa
WHERE SUBSTR(ssn, 0, 1) = 7;

-- SUBSTR() --
SELECT name, ssn
    , RPAD(SUBSTR(ssn, 0, 8), 14, '*')
FROM insa;

SELECT name, ssn
    , CONCAT( SUBSTR(ssn, 0, 8), '******')
FROM insa;

SELECT name, ssn,
    REGEXP_REPLACE(ssn, '(\d{6}-\d)\d{6}', '\1******')
FROM insa;

SELECT name, ssn
    , SUBSTR( ssn, 0, 6 )
    , SUBSTR( ssn, 0, 2 ) YEAR
    , SUBSTR( ssn, 3, 2 ) MONTH
    , SUBSTR( ssn, 5, 2 ) "DATE"
    , TO_DATE(SUBSTR( ssn, 0, 6 )) BIRTHDAY
    , TO_CHAR(TO_DATE(SUBSTR( ssn, 0, 6 )), 'YY') y
FROM insa
WHERE TO_CHAR(TO_DATE(SUBSTR( ssn, 0, 6 )), 'YY') BETWEEN 70 AND 79;
WHERE TO_DATE(SUBSTR( ssn, 0, 6 )) BETWEEN '70/01/01' AND '79/12/31';
--
SELECT ename, hiredate
--    , TO_CHAR(hiredate, 'YYYY') YYYY
--    , TO_CHAR(hiredate, 'MM') MM
--    , TO_CHAR(hiredate, 'DD') DD
--    , TO_CHAR(hiredate, 'DY') DY
--    , TO_CHAR(hiredate, 'DAY') DAY
      -- EXTRACT() 추출  - NUMBER 타입 추출
      , EXTRACT(year FROM hiredate) YEAR
      , EXTRACT(month FROM hiredate) MONTH
      , EXTRACT(DAY FROM hiredate) DAY
FROM emp;

-- 오늘 날짜에서 년도/월/일/시간/분/초 얻기
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'DL') 
    , TO_CHAR(SYSDATE, 'DS TS')
    , TO_CHAR(SYSDATE, 'TS')
    , TO_CHAR(SYSDATE, 'HH24:MI:SS')
    , CURRENT_TIMESTAMP
FROM emp;
-- REGEXP_LIKE 함수
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d12');
WHERE REGEXP_LIKE(ssn, '^7[0-9]12');
WHERE REGEXP_LIKE(ssn, '^7.12');
WHERE REGEXP_LIKE(ssn, '^[7-8]');
WHERE REGEXP_LIKE(ssn, '^7');
WHERE ssn LIKE '7_12%';
WHERE ssn LIKE '7%';
WHERE ssn LIKE '______-1______';
WHERE ssn LIKE '%-1%';
WHERE name LIKE '%자';
WHERE name LIKE '%말%';
WHERE name LIKE '김%';

-- [문제] insa 테이블에서 김씨 성을 제외한 모든 사원  출력
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[^김이홍]');
WHERE name NOT LIKE '김%';

-- [문제]출신도가 서울, 부산, 대구 이면서 전화번호에 5 또는 7이 포함된 자료 출력하되
--      부서명의 마지막 부는 출력되지 않도록함. 
--      (이름, 출신도, 부서명, 전화번호)
SELECT name, city, SUBSTR(buseo, 0, LENGTH(buseo)-1) BUSEO, tel
FROM insa
WHERE 
    city IN('서울','부산','대구') 
    AND
    REGEXP_LIKE(tel, '[57]');
    --(tel LIKE '%5%' OR tel LIKE '%7%');

