-- SCOTT
-- [문제1] emp 테이블 - ename, pay, 평균급여 ,  절상,반올림,절삭 함수 (소수점 3자리)
--[ 실행결과 ]
--ENAME             PAY    AVG_PAY       차 올림      차 반올림       차 내림
------------ ---------- ---------- ---------- ---------- ----------
--SMITH             800    2260.42   -1460.41   -1460.42   -1460.41
--ALLEN            1900    2260.42    -360.41    -360.42    -360.41
--WARD             1750    2260.42    -510.41    -510.42    -510.41
--:
SELECT  AVG( sal + NVL(comm, 0) ) avg_pay
FROM emp;
-- ORA-00937: not a single-group group function
WITH temp AS (
    SELECT ename, sal + NVL(comm, 0) pay
    --    , AVG( sal + NVL(comm, 0) ) avg_pay
          , (SELECT  AVG( sal + NVL(comm, 0) )  FROM emp) avg_pay
    FROM emp
)
SELECT t.*
      --         123.46
      , CEIL( (t.pay - t.avg_pay)*100 )/100  "차 올림" -- CEIL(n)
      , ROUND( t.pay - t.avg_pay, 2 ) "차 반올림"
      --, FLOOR()
      , TRUNC(t.pay - t.avg_pay, 2) "차 내림" 
FROM temp t; 

-- [문제2] emp 테이블에서 
--        pay,   avg_pay
--                          많다, 적다, 같다. 출력
--       ename, pay, avg_pay, (많,적,같다) 
--        ㄱ. SET 집합 연산자( U, UA, M, I )
WITH temp AS (
    SELECT ename, sal+NVL(comm,0) pay
        , ( SELECT AVG( sal + NVL(comm, 0) ) FROM emp) avg_pay
    FROM emp
)
SELECT t.*
     , CASE 
          WHEN pay > avg_pay THEN '많다'
          WHEN pay < avg_pay THEN '적다'
          ELSE '같다'
       END 평가
FROM temp t;

-- [문제3] insa 테이블에서 ssn 주민등록번호, 오늘이 생일 지났다.지나지 않았는지 출력.
SELECT *
FROM insa;
-- 1) 1002 이순신  주민등록번호 월/일 -> 오늘날짜의 월/일로 수정(UPDATE)
SELECT name
,   ssn
,  SUBSTR( ssn, 0, 2)
,  TO_CHAR( SYSDATE, 'MMDD')
, SUBSTR( ssn, 7)
FROM insa
WHERE num = 1002;

UPDATE insa
SET   ssn = SUBSTR( ssn, 0, 2) || TO_CHAR( SYSDATE, 'MMDD') || SUBSTR( ssn, 7)
WHERE  num = 1002;
COMMIT;
-- 2) 생일 지남 여부 출력.
SELECT name
    ,SUBSTR(ssn, 3, 4)
    ,TO_DATE(SUBSTR(ssn, 3,4), 'MMDD') bd
    ,CASE SIGN(TO_DATE(SUBSTR(ssn, 3,4), 'MMDD') - TRUNC(SYSDATE))
        WHEN 1 THEN 'X'
        WHEN -1 THEN 'O'
        ELSE '오늘'
    END s
FROM insa
WHERE num = 1002;

-- [문제] insa 테이블의 주민등록번호 만 나이를 계산해서 출력
-- 성별(1,2) 1900 (3,4) 2000 (0,9) 1800 (5,6) 외국인1900 (7,8) 외국인 2000
-- 생일년도
--SELECT name, ssn, 출생년도, 올해년도, 만나이
--FROM insa;

WITH temp AS(
SELECT name, ssn
    ,SUBSTR(ssn, 1, 2) + CASE 
            WHEN SUBSTR(ssn, -7, 1) IN (1,2,5,6) THEN 1900
            WHEN SUBSTR(ssn, -7, 1) IN (3,4,7,8) THEN 2000
            ELSE 1800
    END 출생년도
    , TO_CHAR(SYSDATE, 'YYYY') 올해년도
    , SIGN(TO_DATE(SUBSTR(ssn, 3,4), 'MMDD') - TRUNC(SYSDATE)) bs
FROM insa
)
SELECT temp.name, temp.ssn, 출생년도, 올해년도
    ,올해년도 - 출생년도 + CASE bs
        WHEN -1 THEN -1
        ELSE 0
        END 만나이
FROM temp;
-- JAVA
-- Math.random() 임의의 수
-- Random 클래스 nextInt() 임의의 수
-- DBMS_RANDOM 패키지
-- 자바 패키지 - 서로 관련된 클래스들의 묶음
-- 오라클 패키지 - 서로 관련된 타입, 프로그램 객체, 서브프로그램(procedure, function)을 논리적으로 묶어 놓은 것
SELECT 
    SYS.dbms_random.value
--    , SYS.dbms_random.value(0, 100) --0.0 <= 실수 < 100.0
--    , SYS.dbms_random.string('U', 5)u -- 대문자 
--    , SYS.dbms_random.string('L', 5)l -- 소문자
    , SYS.dbms_random.string('X', 5)x -- 대문자 + 숫자
    , SYS.dbms_random.string('P', 5)p -- 대소문자 + 숫자 + 특수문자
    , SYS.dbms_random.string('A', 5)a -- 알파벳
FROM dual;

--[문제] 임의의 국어 점수 1개 출력
SELECT 
    ROUND(SYS.dbms_random.value(0, 100)) 국어점수
FROM dual;
--[문제] 임의의 로또 번호 1개 출력
SELECT 
    ROUND(SYS.dbms_random.value(1, 46)) 로또번호
FROM dual;
--[문제] 임의의 숫자 6자리 발생시켜서 출력
SELECT 
    SUBSTR(TO_CHAR(ROUND(SYS.dbms_random.value(1000000, 9999999))),2) 숫자6자리
FROM dual;
--[문제] 인사테이블에서 남자사원수, 여자사원수
SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2), 0, '여자','남자') GENDER
    , COUNT(*) 사원수
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1),2);

SELECT buseo
    , DECODE(MOD(SUBSTR(ssn,-7,1),2), 0, '여자','남자') GENDER
    , COUNT(*) 사원수
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn,-7,1),2)
ORDER BY buseo;


SELECT *
FROM emp
ORDER BY deptno;
--[문제] emp 테이블에서 최고, 최저 급여자 누군지 사원 정보
SELECT *
FROM emp a, (SELECT MAX(sal) max, MIN(Sal) min FROM emp) b
WHERE a.sal IN (b.max, b.min)
ORDER BY sal;

--[문제] emp 테이블에서 각 부서별 최고, 최저 급여자 누군지 사원 정보
SELECT a.*
FROM emp a, 
(SELECT deptno, MAX(sal) max, MIN(sal) min
FROM emp
GROUP BY deptno) b
WHERE a.sal IN(b.max, b.min) AND a.deptno = b.deptno
ORDER BY a.deptno;

SELECT *
FROM (
SELECT emp.*
    ,RANK() OVER( PARTITION BY deptno ORDER BY sal DESC) dr
    ,RANK() OVER( PARTITION BY deptno ORDER BY sal) ar
FROM emp
) t
WHERE t.dr = 1 OR t.ar = 1;

-- [문제] emp 테이블에서 comm이 400 이하인 사원의 정보 조회(조건 comm이 NULL인 사원도 포함)
SELECT ename, job, sal, NVL(comm, 0)
FROM emp
WHERE NVL(comm, 0) <= 400
ORDER BY NVL(comm,0) DESC;

--LNNVL() 함수
SELECT ename, job, sal, NVL(comm, 0)
FROM emp
WHERE LNNVL(comm > 400); -- == comm <= 400 OR comm IS NULL

-- [문제] 이번 달의 마지막 날짜가
SELECT SYSDATE
    , TRUNC(SYSDATE, 'MONTH') m -- 24/08/01
    , LAST_DAY(SYSDATE) l
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD') ld
FROM dual;

-- [문제] emp 테이블에서 sal가 상위 20%에 해당되는 사원의 정보 조회
SELECT *
FROM
(
SELECT emp.*, 
    PERCENT_RANK()OVER(ORDER BY sal DESC) p
FROM emp
)
WHERE p <= 0.2;

-- [다음 주 월요일 휴강 - 날짜 조회]
SELECT TO_CHAR(SYSDATE, 'DY')
    , NEXT_DAY( SYSDATE, '월' )
FROM dual;

-- emp 테이블에서 각 사원들의 입사일자를 기준으로 10년 5개월 20일째 되는 날짜 출력
SELECT ename, hiredate
    , ADD_MONTHS(hiredate, 10*12+5)+20 "10년5개월20일" 
FROM emp;

--insa 테이블에서 
[실행결과]
                                           부서사원수/전체사원수 == 부/전 비율
                                           부서의 해당성별사원수/전체사원수 == 부성/전%
                                           부서의 해당성별사원수/부서사원수 == 성/부%
                                           
부서명     총사원수 부서사원수 성별  성별사원수  부/전%   부성/전%   성/부%
개발부       60       14         F       8       23.3%     13.3%       57.1%
개발부       60       14         M       6       23.3%     10%       42.9%
기획부       60       7         F       3       11.7%       5%       42.9%
기획부       60       7         M       4       11.7%   6.7%       57.1%
영업부       60       16         F       8       26.7%   13.3%       50%
영업부       60       16         M       8       26.7%   13.3%       50%
인사부       60       4         M       4       6.7%   6.7%       100%
자재부       60       6         F       4       10%       6.7%       66.7%
자재부       60       6         M       2       10%       3.3%       33.3%
총무부       60       7         F       3       11.7%   5%           42.9%
총무부       60       7         M    4       11.7%   6.7%       57.1%
홍보부       60       6         F       3       10%       5%           50%
홍보부       60       6         M       

SELECT COUNT(*)
FROM insa;

(SELECT buseo, COUNT(*) bc
FROM insa
GROUP BY buseo);

SELECT a.buseo
    , (SELECT COUNT(*) FROM insa) 총사원수
    , b.부서사원수
    , DECODE(a.성별, 0, 'F', 'M') 성별
    , a.성별사원수
    , ROUND(b.부서사원수/(SELECT COUNT(*) FROM insa) *100, 2)||'%'"부/전%"
    , ROUND(a.성별사원수/(SELECT COUNT(*) FROM insa) *100, 2)||'%' "부성/전%"
    , ROUND(a.성별사원수/b.부서사원수 *100, 1)||'%' "성/부%"
FROM
(SELECT buseo
, MOD(SUBSTR(ssn, -7, 1),2) 성별
, COUNT(*) 성별사원수
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn, -7, 1),2)) a,
(SELECT buseo, COUNT(*) "부서사원수"
FROM insa
GROUP BY buseo) b
WHERE a.buseo = b.buseo
ORDER BY a.buseo;

-- LISTAGG() ***(암기)
[실행결과]
10   CLARK/MILLER/KING
20   FORD/JONES/SMITH
30   ALLEN/BLAKE/JAMES/MARTIN/TURNER/WARD
40  사원없음   

SELECT EMPNO, ENAME, JOB, DEPTNO FROM EMP ;

SELECT deptno, LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename ASC) ename
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- [문제] insa 테이블에서 TOP-N 분석방식으로
-- 급여많이 받는 TOP 10

SELECT *
FROM(
SELECT *
FROM insa
ORDER BY basicpay DESC
)
WHERE ROWNUM <= 10;

--[문제]
SELECT TRUNC(SYSDATE, 'YEAR') -- 2024-01-01
    ,TRUNC(SYSDATE, 'MONTH') --2024-08-01
    ,TRUNC(SYSDATE, 'DD') -- 2024-08-12
    ,TRUNC(SYSDATE) -- 2024-08-12 - 시간 절삭
FROM dual;

--[다음문제]
[실행결과]
DEPTNO ENAME PAY BAR_LENGTH      
---------- ---------- ---------- ----------
30   BLAKE   2850   29    #############################
30   MARTIN   2650   27    ###########################
30   ALLEN   1900   19    ###################
30   WARD   1750   18    ##################
30   TURNER   1500   15    ###############
30   JAMES   950       10    ##########

SELECT deptno, ename, sal + NVL(comm,0) pay, CEIL((sal + NVL(comm,0))/100) BAR_LENGTH
    , RPAD(' ',CEIL((sal + NVL(comm,0))/100),'#')
FROM emp
WHERE deptno = 30
ORDER BY pay DESC;
-- ww / iw / w 차이점 파악.
SELECT hiredate
    , TO_CHAR(hiredate,'WW') ww -- 년중 몇 번째 주
    , TO_CHAR(hiredate,'IW') iw -- 년중 몇 번째 주
    , TO_CHAR(hiredate,'W') w -- 월중 몇 번째 주
FROM emp;

-- 사원수가 가장 많은 부서명, 사원수
-- 사원수가 가장 작은 부서명, 사원수

SELECT b.dname, a.c
FROM (
SELECT deptno, COUNT(*) c 
FROM emp
GROUP BY deptno) a
, (SELECT * FROM dept) b
WHERE a.deptno = b.deptno
;

SELECT *
FROM dept;

SELECT s.dname, s.count
FROM 
(
SELECT t.*
    ,RANK()OVER(ORDER BY count DESC) dr
    ,RANK()OVER(ORDER BY count) ar
FROM(
SELECT d.dname, COUNT(*) count
FROM dept d JOIN emp e 
ON d.deptno = e.deptno 
GROUP BY d.dname
) t
) s
WHERE s.dr =1 OR s.ar =1
ORDER BY COUNT DESC;

SELECT *
FROM(
SELECT d.deptno, dname, COUNT(empno) CNT
    , RANK() OVER(ORDER BY COUNT(empno)DESC) cnt_rank
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno, dname
ORDER BY cnt_rank
) t
WHERE t.cnt_rank IN (1, 4);


WITH temp AS(
SELECT d.deptno, dname, COUNT(empno) CNT
    , RANK() OVER(ORDER BY COUNT(empno)DESC) cnt_rank
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno, dname
ORDER BY cnt_rank
)
SELECT *
FROM temp
WHERE temp.cnt_rank IN ((SELECT MAX(temp.cnt_rank) FROM temp), (SELECT MIN(temp.cnt_rank) FROM temp ));
-- WITH 절 이해 (암기)

WITH a AS (
    SELECT d.deptno, dname, COUNT(empno) CNT
    , RANK() OVER(ORDER BY COUNT(empno)DESC) cnt_rank
    FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
    GROUP BY d.deptno, dname
    )
, b AS (
    SELECT MAX(cnt) maxcnt, MIN(cnt) mincnt 
    FROM a
    )
SELECT a.deptno, a.dname, a.cnt, a.cnt_rank
FROM a, b
WHERE a.cnt IN (b.maxcnt, b.mincnt);

-- 피봇(pivot) / 언피봇(unpivot) (암기)
--  https://blog.naver.com/gurrms95/222697767118
-- job별 사원수 출력
SELECT
    COUNT(DECODE(job, 'CLERK', 'O')) CLERK
    ,COUNT(DECODE(job, 'SALESMAN', 'O')) SALESMAN
    ,COUNT(DECODE(job, 'PRESIDENT', 'O')) PRESIDENT
    ,COUNT(DECODE(job, 'MANAGER', 'O')) MANAGER
    ,COUNT(DECODE(job, 'ANALYST', 'O')) ANALYST
FROM emp;

SELECT 
FROM (피봇 대상 쿼리문)
PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN (피벗컬럼 AS 별칭...) );

SELECT *
FROM (
SELECT job 
FROM emp)
PIVOT (
COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));

-- 2) emp 테이블에서 각 월별 입사한 사원수 조회
SELECT *
FROM emp;

SELECT EXTRACT(month FROM hiredate) 입사월, COUNT(*)
FROM emp
GROUP BY EXTRACT(month FROM hiredate)
ORDER BY EXTRACT(month FROM hiredate);

SELECT *
FROM (
    SELECT TO_CHAR(hiredate, 'YYYY') year
        ,TO_CHAR(hiredate, 'MM') month
    FROM emp
)
PIVOT(
    COUNT(month) 
    FOR month IN ('01' AS "1월",'02','03','04','05','06','07','08','09','10','11','12')
    )
    ORDER BY year;
    
[문제] emp 테이블에서 job별 사원수 조회
-- clerck  p
--   3     1

-- [] emp 부서별 / 잡별 사원수
--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0

SELECT *
FROM (
    SELECT d.deptno, d.dname ,e.job
    FROM emp e, dept d
    WHERE e.deptno(+) = d.deptno
-- FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
)
PIVOT (
COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'))
ORDER BY deptno;
-- 각 부서별 총 급여 합을 조회
SELECT deptno, sal+NVL(comm, 0) pay
FROM emp;


SELECT *
FROM (
SELECT deptno, sal+NVL(comm, 0) pay
FROM emp
)
PIVOT(
    SUM(PAY) FOR deptno IN ('10','20','30','40')
);

-- 
SELECT *
FROM(
SELECT job, deptno, sal, ename
FROM emp
)
PIVOT(
    SUM(sal) AS 합계
    FOR deptno IN ('10','20','30','40')
);

-- 피봇 문제)
-- 생일 지남 o     x    오늘
--        20     30    1

SELECT *
FROM
(
SELECT 
    SIGN(TO_DATE(SUBSTR(ssn, 3,4), 'MMDD') - TRUNC(SYSDATE)) s
FROM insa
)
PIVOT
(
    COUNT(s)
    FOR s IN ('1' AS "생일X", '0' AS "오늘생일", '-1' AS "생일O")
);
-- [부서번호 4자리 출력]
SELECT deptno
    ,TO_CHAR(deptno, '0999')
    , LPAD(deptno, 4, '0')
FROM dept;

-- (암기)  insa 테이블에서 각 부서별/출신지역별/사원수 몇명인지 출력(조회)
SELECT *
FROM insa;
-- 출신지역 city 11개
SELECT DISTINCT city
FROM insa;

SELECT buseo, city, COUNT(*)
FROM insa
GROUP BY buseo, city
ORDER BY buseo, city;

-- 오라클 10G 새로 추가된 기능 : (PARTITION BY OUTER JOIN) 구문 사용

WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, COUNT(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c
ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;
