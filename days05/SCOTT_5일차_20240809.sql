SELECT COUNT(DISTINCT job)
FROM emp;

SELECT *
FROM emp;

[문제2] emp 테이블 부서별 사원 수 조회
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT 10 "deptno", COUNT(*) 사원수
FROM emp
WHERE deptno = 10
UNION ALL
SELECT 20, COUNT(*)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT 30, COUNT(*)
FROM emp
WHERE deptno = 30
UNION ALL
SELECT 40, COUNT(*)
FROM emp
WHERE deptno = 40
UNION ALL
SELECT NULL ,COUNT(*)
FROM emp;

SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;
-- emp 테이블에 존재하지 않는 부서도 조회
SELECT COUNT(*)
    ,COUNT(DECODE(deptno, 10, 1)) "10"
    ,COUNT(DECODE(deptno, 20, 1)) "20"
    ,COUNT(DECODE(deptno, 30, 1)) "30"
    ,COUNT(DECODE(deptno, 40, 1)) "40"
FROM emp;

-- [문제] insa 테이블 총사원수, 남자사원수, 여자사원수 조회
SELECT *
FROM insa;
--DECODE
SELECT COUNT(*)
    ,COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2), 1, 1)) "남자"
    ,COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2), 0, 1)) "여자"
FROM insa;
--GROUP BY
SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2), 1, '남자', 0,'여자', '전체') GENDER
    , COUNT(*) 
FROM insa
GROUP BY ROLLUP(SUBSTR(ssn,-7,1));

SELECT 
    CASE MOD(SUBSTR(ssn,-7,1),2)
        WHEN 1 THEN '남자'
        WHEN 0 THEN '여자'
        ELSE '전체'
    END GENDER
    , COUNT(*)
FROM insa
GROUP BY ROLLUP(SUBSTR(ssn,-7,1));

-- [문제] emp 테이블에서 가장 급여 많이 받는 사원
SELECT MAX( sal + NVL(comm,0) ) 
FROM emp;
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MAX( sal + NVL(comm,0) ) FROM emp);

SELECT deptno, MAX(sal+NVL(comm,0))
FROM emp
GROUP BY deptno;

-- SQL 연산자 : ALL, SOME, ANY, EXISTS
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= ALL (SELECT sal + NVL(comm,0) FROM emp);
-- 급여 제일 적은
SELECT *
FROM emp
WHERE sal+NVL(comm,0) <= ALL (SELECT sal + NVL(comm,0) FROM emp);
--[문제] emp 테이블에서 각 부서별 최고 급여를 받는 사원 출력
SELECT *
FROM emp e1
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0))FROM emp e2 WHERE e2.deptno = e1.deptno)
ORDER BY deptno;

SELECT m.* , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal ) RANK
    ,(SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno ) DEPT_RANK
FROM emp m
ORDER BY deptno, dept_rank;

SELECT *
FROM (
SELECT m.* , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal ) RANK
    ,(SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno ) DEPT_RANK
FROM emp m
) t
WHERE t.dept_rank <= 2
ORDER BY deptno, dept_rank;

SELECT e.*, RANK()OVER(ORDER BY sal) RANK
FROM emp e;

--[문제] insa 테이블에서 부서별 인원수가 10명 이상인 부서를 조회
SELECT *
FROM(
    SELECT buseo, COUNT(*) c
    FROM insa 
    GROUP BY buseo
    ) t
WHERE c >= 10;

SELECT buseo, COUNT(*)
FROM insa 
GROUP BY buseo
HAVING COUNT(*) >= 10;

-- [문제] insa 테이블에서 여자사원수가 5명 이상인 부서

SELECT buseo, SUBSTR(ssn,-7,1), COUNT(*)
FROM insa
GROUP BY buseo, SUBSTR(ssn,-7,1)
ORDER BY buseo;

SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자')) "여수"
FROM insa
GROUP BY buseo;

HAVING COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자')) >= 5;

SELECT buseo,COUNT(*)
FROM insa
GROUP BY buseo, SUBSTR(ssn,-7,1)
HAVING COUNT(NULLIF(MOD(SUBSTR(ssn,-7,1),2),1)) >= 5;

SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;

--[문제] emp 테이블에서 
--      사원 전체 평균급여를 계산한 후 각 사원들의 급여가 평균급여보다 많을 경우 "많다"
--                                                  ""      적을 경우 "적다" 출력
SELECT AVG( sal + NVL(comm, 0) )  avg_pay
FROM emp;
--
SELECT empno, ename, pay , ROUND( avg_pay, 2) avg_pay
     , CASE 
          WHEN pay > avg_pay   THEN '많다'
          WHEN pay < avg_pay THEN '적다'
          ELSE '같다'
       END ee
FROM (
        SELECT emp.*
              , sal + NVL(comm,0) pay
              , (SELECT AVG( sal + NVL(comm, 0) )  FROM emp) avg_pay
        FROM emp
    ) e;


SELECT e.*
    ,CASE 
        WHEN sal+NVL(comm,0) <(SELECT AVG(sal+NVL(comm,0))FROM emp) THEN '적다'
        ELSE '많다'
    END p
FROM emp e;

--[emp 테이블에서 급여 가장 max, min 사원 정보 조회
SELECT *
FROM emp;

SELECT MAX(sal+NVL(comm,0)) FROM emp;
SELECT MIN(sal+NVL(comm,0)) FROM emp;

SELECT *
FROM emp
WHERE sal+NVL(comm,0) IN ( (SELECT MAX(sal+NVL(comm,0)) FROM emp),
                           (SELECT MIN(sal+NVL(comm,0)) FROM emp)) ;


SELECT ename, sal
FROM emp;

-- [문제] insa 서울 사람 중 부서별 남자, 여자 사원수, 부서별 남자 급여 총합, 여자급여 총합 조회

SELECT *
FROM insa;
--
SELECT buseo
    , COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2),0,1)) 여자
    , COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2),1,1)) 남자
    , COUNT(*) "사원수"
    , SUM(DECODE(MOD(SUBSTR(ssn, -7, 1),2),0,basicpay)) "여자급여"
    , SUM(DECODE(MOD(SUBSTR(ssn, -7, 1),2),1,basicpay)) "남자급여"
FROM insa
WHERE city = '서울'
GROUP BY buseo
ORDER BY buseo;
-- 풀이2
SELECT buseo
    , DECODE(MOD(SUBSTR(ssn, -7, 1),2), 0, '여자', '남자') GENDER
    , COUNT(*) 사원수
    , SUM(basicpay)
FROM insa
WHERE city = '서울'
GROUP BY buseo, MOD(SUBSTR(ssn, -7, 1),2)
ORDER BY buseo, MOD(SUBSTR(ssn, -7, 1),2);

SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi);

-- ROWNUM 의사컬럼
DESC emp;
SELECT ROWNUM, ROWID, ename, hiredate, job
FROM emp;

SELECT ROWNUM, e.*
FROM (SELECT * FROM emp ORDER BY sal DESC) e
WHERE ROWNUM <= 3;
-- WHERE ROWNUM BETWEEN 3 AND 5; 중간 라인 부터는 안됨 하려면 한번더 인라인뷰 쓰면됨
SELECT *
FROM (
        SELECT ROWNUM seq, e.*
        FROM (SELECT * FROM emp ORDER BY sal DESC) e
)
WHERE seq BETWEEN 3 AND 5;

--ORDER BY 절이 있는 곳에서는 ROWNUM 사용 X 둘이 함께 사용 X
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC;

-- ROLLUP / CUBE
-- 1) ROLLUP : 그룹화하고 그룹에 대한 부분합
SELECT d.dname, e.job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname,e.job)
ORDER BY d.dname;
--GROUP BY ROLLUP( d.dname, e.job);
--ORDER BY dname ASC;

--2) CUBE : ROLLUP 결과에 GROUP BY 절에 조건에 따라 모든 가능한 그룹핑 조합 출력
SELECT d.dname, e.job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY CUBE(d.dname,e.job)
ORDER BY d.dname;

-- 순위(RANK) 함수
SELECT ename, sal, sal+NVL(comm,0) pay
    ,RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "RANK순번"
    ,DENSE_RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "DENSE_RANK순번"
    ,ROW_NUMBER() OVER(ORDER BY sal+NVL(comm,0) DESC) "ROW_NUMBER순번"
FROM emp;

UPDATE emp
SET sal = 2850
WHERE empno = 7566;
COMMIT;

-- 순위 함수 예제
-- emp 테이블에서 부서별로 급여 순위 매기기
SELECT *
FROM (
        SELECT emp.*
            ,RANK()OVER(PARTITION BY deptno ORDER BY (sal+NVL(comm,0)) DESC) 순위
            ,RANK()OVER(ORDER BY (sal+NVL(comm,0)) DESC) 전체순위
        FROM emp
)
WHERE 순위 BETWEEN 1 AND 3;

-- insa 테이블 사원들 14명씩 팀
--SELECT CEIL(COUNT(*)/14)
SELECT *
FROM insa;
-- [문제] insa 테이블에서 사원 수가 가장 많은 부서의 부서명, 사원 수를 출력
SELECT *
FROM(
    SELECT buseo, COUNT(*)
        , RANK() OVER(ORDER BY COUNT(*) DESC) 부서순위
    FROM insa 
    GROUP BY buseo
) e
WHERE ROWNUM =1;
WHERE 부서순위=1;

-- insa 테이블에서 여자사원수가 가장 많은 부서 및 사원 수 출력
SELECT *
FROM(
    SELECT buseo
        , COUNT(*)
        , RANK() OVER(ORDER BY COUNT(*) DESC) 부서순위
    FROM insa 
    WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
    GROUP BY buseo
) a
WHERE 부서순위 = 1;
--[문제] insa 테이블에서 basicpay(기본급)이 상위 10%만 출력..(이름, 기본급)

SELECT 
    COUNT() OVER(ORDER BY basicpay DESC)
    ,RANK()OVER(ORDER BY basicpay DESC)
FROM insa;

SELECT *
from insa order by basicpay;

SELECT *
FROM(
    SELECT insa.*,
    RANK()OVER(ORDER BY basicpay DESC) rank
    FROM insa
    ) a
WHERE ROWNUM <= (SELECT COUNT(*) FROM insa) * 0.1;

SELECT *
FROM(
    SELECT name, basicpay
        ,PERCENT_RANK() OVER(ORDER BY basicpay DESC) pr
    FROM insa
    )
WHERE pr <= 0.1;