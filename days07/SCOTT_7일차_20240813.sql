WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, Count(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c
ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;
--
SELECT buseo, c.city, COUNT(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN (SELECT DISTINCT city
    FROM insa) c
ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;
--사원이 존재하지 않는 부서의 부서번호, 부서명 출력

SELECT d.deptno, d.dname, COUNT(empno)
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
GROUP BY d.deptno, d.dname
HAVING COUNT(empno) = 0;

WITH t AS (
    SELECT deptno
    FROM dept
    MINUS
    SELECT DISTINCT deptno
    FROM emp
)
SELECT t.deptno, d.dname
FROM t JOIN dept d ON t.deptno = d.deptno;
--
SELECT t.deptno, d.dname
FROM (SELECT deptno
    FROM dept
    MINUS
    SELECT DISTINCT deptno
    FROM emp)t JOIN dept d ON t.deptno = d.deptno;
-- ㄹ. SQL 연산자 ALL , ANY, SOME, [NOT] EXITS
SELECT m.deptno, m.dname
FROM dept m
WHERE NOT EXISTS (SELECT empno FROM emp WHERE deptno = m.deptno);

-- ㅁ. 상관 서브쿼리
SELECT m.deptno, m.dname
FROM dept m
WHERE (SELECT COUNT(*) FROM emp WHERE deptno = m.deptno) = 0;   -- emp 테이블에 존재하지 않는 부서정보

-- insa 테이블에서 각 부서별 여자사원수 5명 이상인 부서
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;

-- [문제] insa 테이블
--     [총사원수]      [남자사원수]      [여자사원수] [남사원들의 총급여합]  [여사원들의 총급여합] [남자-max(급여)] [여자-max(급여)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000
SELECT *
FROM insa;

SELECT
     DECODE(MOD(SUBSTR(ssn,-7,1),2), 1, '남자',0,'여자', '전체') GENDER
    , COUNT(*)사원수
    , SUM(basicpay) 급여합
    , MAX(basicpay) MAX급여
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,-7,1),2))
;

SELECT COUNT(*) 총사원수
    ,COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'o')) 남자사원수
    ,COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'o')) 여자사원수
    ,SUM(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,basicpay)) 남자급여합
    ,SUM(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,basicpay)) 여자급여합
    ,MAX(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,basicpay)) 남자급여합
    ,MAX(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,basicpay)) 여자급여합
FROM insa
;

-- [문제] emp 테이블에서~
--      각 부서의 사원수, 부서 총급여합, 부서 평균급여
결과)
    DEPTNO       부서원수       총급여합            평균
---------- ----------       ----------    ----------
        10          3          8750       2916.67
        20          3          6775       2258.33
        30          6         11600       1933.33 
        40          0         0             0

SELECT d.deptno, COUNT(empno) 부서원수
    , NVL(SUM(sal+NVL(comm,0)),0) 총급여합
    , NVL(ROUND(avg(sal+NVL(comm,0)),2),0) 평균
FROM emp e RIGHT JOIN dept d
ON e.deptno = d.deptno
GROUP BY d.deptno
ORDER BY d.deptno
;

--[ ROLLUP 절 CUBE 절]
-- ㄴ GROUP BY 절에서 사용 그룹별 소계를 추가로 보여주는 역할
-- ㄴ 즉, 추가적인 집계 정보를 보여준다
SELECT
    CASE MOD( SUBSTR(ssn,-7,1), 2 )
    WHEN 1 THEN '남자'
    WHEN 0 THEN '여자'
    ELSE '전체'
    END 성별
    , COUNT(*) 사원수
FROM insa
GROUP BY ROLLUP(MOD( SUBSTR(ssn,-7,1),2));

SELECT
    CASE MOD( SUBSTR(ssn,-7,1), 2 )
    WHEN 1 THEN '남자'
    WHEN 0 THEN '여자'
    ELSE '전체'
    END 성별
    , COUNT(*) 사원수
FROM insa
GROUP BY CUBE(MOD( SUBSTR(ssn,-7,1),2));

-- ROLLUP / CUBE 차이점
-- 1차 부서별 그룹핑, 2차 직위별 그룹핑
SELECT buseo, jikwi, COUNT(*) 사원수
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi
;
SELECT buseo, jikwi, COUNT(*) 사원수
FROM insa
GROUP BY CUBE(buseo, jikwi)
ORDER BY buseo, jikwi
;

-- 분할 ROLLUP
SELECT buseo, jikwi, COUNT(*)사원수
FROM insa
GROUP BY ROLLUP(buseo), jikwi -- 직위에 대한 부분 집계
--GROUP BY buseo, ROLLUP(jikwi) -- 부서에 대한 부분 집계
--GROUP BY CUBE(buseo, jikwi)
ORDER BY buseo, jikwi
;

-- [ GROUPING SETS 함수 ]
SELECT buseo, '', COUNT(*)
FROM insa
GROUP BY buseo
UNION ALL
SELECT '', jikwi, COUNT(*)
FROM insa
GROUP BY jikwi;
--
SELECT buseo, jikwi, COUNT(*)
FROM insa
GROUP BY GROUPING SETS(buseo, jikwi) -- 그룹핑한 집계만 보고자 할때
ORDER BY buseo, jikwi
;

-- 피봇(pivot) 문제
-- 1. 테이블 설계 X
--tbl_pivot 테이블 생성
--번호, 이름, 국,영,수 관리 테이블

CREATE TABLE tbl_pivot
(
--    컬럼명 자료형(크기) 제약조건
    no NUMBER PRIMARY KEY -- 고유키
    , name VARCHAR2(20 BYTE) NOT NULL --NN 제약조건(=필수입력사항)
    , jumsu NUMBER(3) -- NULL 허용
);
--
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '박예린', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '박예린', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '박예린', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '안시은', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '안시은', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '안시은', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '김민', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '김민', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '김민', 100 );  -- mat 

COMMIT;
---
SELECT *
FROM tbl_pivot;

SELECT *
FROM(
SELECT TO_CHAR(MOD(no,3))s, name, jumsu
FROM tbl_pivot
)
PIVOT(
    SUM(jumsu) FOR s IN ('1'국어, '2'영어, '0'수학)
)
;

SELECT *
FROM (
      SELECT TRUNC( (no-1)/3 )+1  no
            , name
            , jumsu
            , ROW_NUMBER()OVER(PARTITION BY name ORDER BY no) subject 
      FROM tbl_pivot
)
PIVOT( SUM(jumsu) FOR subject IN (1 AS 국어,2 AS 영어,3 AS 수학))
ORDER BY no ASC;

--(SELECT LEVEL - 1 HOUR , 0 COUNT FROM dual CONNECT BY LEVEL <= 24) temp

YEAR      MONTH          N
---- ---------- ----------
1980          1          0
1980          2          0
1980          3          0
1980          4          0
1980          5          0
1980          6          0
1980          7          0
1980          8          0
1980          9          0
1980         10          0
1980         11          0
1980         12          1
1981          1          0
1981          2          2
1981          3          0
1981          4          1
1981          5          1
1981          6          1
1981          7          0
1981          8          0
1981          9          2
1981         10          0
1981         11          1
1981         12          2
1982          1          1
1982          2          0
1982          3          0
1982          4          0
1982          5          0
1982          6          0
1982          7          0
1982          8          0
1982          9          0
1982         10          0
1982         11          0
1982         12          0

SELECT LEVEL month , 0 N FROM dual CONNECT BY LEVEL <= 12;

SELECT year, m.month, NVL(COUNT(empno), 0) n
FROM (
      SELECT empno, TO_CHAR( hiredate, 'YYYY') year
            , TO_CHAR( hiredate, 'MM' ) month
      FROM emp
     ) e
PARTITION BY ( e.year ) RIGHT OUTER JOIN 
    (
       SELECT LEVEL month   
       FROM dual
       CONNECT BY LEVEL <= 12
     ) m 
ON e.month = m.month
GROUP BY year, m.month
ORDER BY year, m.month;

-- [풀이] insa 에서 부서별, 직위별 사원수
SELECT a.buseo, a.jikwi, a.c
FROM
(
SELECT m.buseo, m.jikwi, m.c
, RANK()OVER(PARTITION BY buseo ORDER BY m.c DESC) dc
, RANK()OVER(PARTITION BY buseo ORDER BY m.c) ac
FROM
(
SELECT buseo, jikwi, COUNT(*)c
FROM insa
GROUP BY buseo, jikwi
ORDER BY buseo, jikwi
) m
) a
WHERE a.dc = 1 OR a.ac = 1;


WITH t1 AS (
    SELECT buseo, jikwi, COUNT(num)tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
, t2 AS (
    SELECT buseo, MIN(tot_count) buseo_min_count
                , MAX(tot_count) buseo_max_count
    FROM t1
    GROUP BY buseo
)
SELECT a.buseo
    ,b.jikwi 최소직위, b.tot_count 최소사원수
    
FROM t2 a, t1 b
WHERE a.buseo = b.buseo AND a.buseo_min_count = b.tot_count;
;

-- FIRST / LAST 분석함수 풀이
WITH t AS (
    SELECT buseo, jikwi, COUNT(num)tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
SELECT t.buseo
    ,MIN(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count) 최소직위
    ,MIN(t.tot_count) 최소사원수
    ,MAX(t.jikwi) KEEP(DENSE_RANK LAST ORDER BY t.tot_count) 최대직위
    ,MAX(t.tot_count) 최대사원수
FROM t
GROUP BY t.buseo
ORDER BY 1;

-- 문제 각 부서별 직위별 최소사원 수, 최대 사원 수 조회
-- 1) 분석함수 FIRST, LAST
--           집계함수(COUNT, SUM, AVG, MAX, MIN)와 같이 사용하여
--           주어진 그룹에 대해 내부적으로 순위를 매겨 결과를 산출하는 함수
-- 2) SELF JOIN

SELECT MAX(ename) KEEP(DENSE_RANK FIRST ORDER BY sal DESC) max_ename
    ,MAX(sal)
    ,MAX(ename) KEEP(DENSE_RANK LAST ORDER BY sal DESC) min_ename
    ,MIN(sal)
FROM emp;

WITH a AS
(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
)
SELECT MIN(cnt), MIN(dname) KEEP(DENSE_RANK LAST ORDER BY cnt DESC) min_dname
    ,MAX(cnt), MAX(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt DESC) max_dname
FROM a;

-- SELF JOIN
SELECT a.empno, a.ename, a.mgr, b.ename 사수
FROM emp a JOIN emp b ON a.mgr = b.empno
;

-- NON EQUAL JOIN
SELECT empno, ename, sal, s.grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

-- emp 테이블에서 가장 입사일자가 빠른 사원과 가장 늦은 사원과의 입사 차이 일수
SELECT MAX(hiredate) - MIN(hiredate)
FROM emp;

-- 분석함수 : CUME_DIST()
--  ㄴ 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
--  ㄴ 분포도값(비율) 0 <    <= 1

SELECT deptno, ename, sal
--    , CUME_DIST() OVER(ORDER BY sal) dept_list
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_list
FROM emp;

-- 분석함수 : PERCENT_RANK()
--  ㄴ 해당 그룹 내의 백분위 순위
--  0<= 사이 값 <= 1
-- 백분위 순위 : 그룹 안에서 해당 행의 값보다 작은 값의 비율

-- NTILE() ( N타일 )
-- ㄴ 파티션 별로 expr에 명시된 만큼 분할한 결과를 반환하는 함수
-- 분할하는 수를 버킷(bucket)이라고 한다
SELECT deptno, ename, sal
    , NTILE(2) OVER(PARTITION BY deptno ORDER BY sal) ntiles
FROM emp;

SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) ntiles
    , WIDTH_BUCKET(sal, 1000, 4000, 4 ) widthbuckets
FROM emp;

-- LAG( expr, offset, default_value )
--  ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
--  ㄴ 선행(앞) 행
-- LEAD( expr, offset, default_value )
--  ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
--  ㄴ 후행(뒤) 행
SELECT deptno, ename, hiredate, sal
    ,LAG(sal, 3, 100)OVER(ORDER BY hiredate) pre_sal
    ,LEAD(sal, 1, -1)OVER(ORDER BY hiredate) next_sal
FROM emp
WHERE deptno = 30;

-----------------------------------------
-- [오라클 자료형(Data Type)]
1) CHAR[(size[BYTE ? CHAR])] 문자열 자료형
    CHAR = CHAR(1 BYTE) = CHAR(1)
    CHAR(3 BYTE) = CHAR(3) 'ABC' '한'
    CHAR(3 CHAR) 'ABC' '한둘셋'
    고정 길이의 문자열 자료형 
    name CHAR(10 BYTE)  - 3자 사용해도 10바이트
    최대 2000 BYTE 할당 가능
    
CREATE TABLE tbl_char
(
    aa CHAR         -- CHAR(1) == CHAR(1 BYTE)
    ,bb CHAR(3)     -- CHAR(3BYTE)
    ,cc CHAR(3 CHAR)
);

DESC tbl_char;

INSERT INTO tbl_char VALUES('a','aaa','aaa');

INSERT INTO tbl_char VALUES('b','한','한우리');

INSERT INTO tbl_char VALUES('c', '한우리', '한우리');

2) NCHAR
    N == UNICODE(유니코드)
    NCHAR[(SIZE)]
    NCHAR == NCHAR(1)
    NCHAR(10)
    고정길이 문자열 자료형
    2000 BYTE

CREATE TABLE tbl_nchar
(
    aa CHAR(3)   -- (3byte) 알3 한1
    ,bb CHAR(3 CHAR) 
    ,cc NCHAR(3)
);

INSERT INTO tbl_nchar VALUES('홍', '길동', '홍길동');
INSERT INTO tbl_nchar VALUES('홍길동', '홍길동', '홍길동');
COMMIT;

고정 문자열 - CHAR / NCHAR 2000 BYTE

3) VAR+CHAR2 ==> VARCHAR
    가변 길이 문자열 자료형
    4000 BYTE
    VARCHAR2(SIZE BYTE/CHAR)
    VARCHAR2(1) = VARCHAR2(1 BYTE) = VARCHAR2
    
4) NVARCHAR2
    유니코드 + 가변길이 + 문자열 자료형
    NVARCHAR2(size) -- 사이즈만 있음
    NVARCHAR2(1) = NVARCHAR2
    4000 BYTE
    
5) NUMBER[(p[,s])]
        precision, scale
        정확도      규모
        전체자리수   소수점이하자리수
        1∼38      -84∼127
    NUMBER = NUMBER(38, 127) --최댓값
    NUMBER(p) = NNUMBER(p,0)
    
    예)
    CREATE TABLE tbl_number
    (
        no NUMBER(2) NOT NULL PRIMARY KEY  -- NN, UK
        , name VARCHAR2(30) NOT NULL
        , kor NUMBER(3) -- -999 ~ 999
        , eng NUMBER(3) -- 0 <=  <= 100 checked 제약조건
        , mat NUMBER(3) DEFAULT 0
    );
    
    INSERT INTO tbl_number VALUES(1, '홍길동', 90, 88, 98);
    COMMIT;
    
INSERT INTO tbl_number (no, name, kor, eng)  VALUES(2, '이시훈', 100, 100);
COMMIT;

INSERT INTO tbl_number VALUES(3, '송세호', 50, 50, 100);
COMMIT;

INSERT INTO tbl_number (name, no, kor, eng, mat)  VALUES('김재민', 4, 50, 50, 100);
COMMIT;
--
SELECT *
FROM tbl_number;
--
INSERT INTO tbl_number VALUES(5, '김선우', 110, 56.934, -999); --56.934 => 반올림

6) FLOAT[(p)] == 내부적으로 NUMBER 처럼 나타낸다.
7) LONG 가변길이(VAR) 문자열 자료형, 2GB
8) DATE 날짜.시간 
9) RAW(SIZE) - 2000 BYTE 이진데이터
   LONG RAW - 2GB        이진데이터
10) LOB : CLOB, NCLOB, BLOB, BFILE

-- FIRST_VALUE 분석함수 : 정렬된 값 중에 첫번째 값

SELECT DISTINCT FIRST_VALUE(basicpay)OVER(ORDER BY basicpay DESC)
FROM insa;

-- 가장 많은 급여(basicpay) 각 사원의 basicpay의 차이
SELECT buseo, name, basicpay
    , FIRST_VALUE(basicpay)OVER(PARTITION BY buseo ORDER BY basicpay DESC) MAX_BASICPAY
    , FIRST_VALUE(basicpay)OVER(PARTITION BY buseo ORDER BY basicpay DESC) - basicpay 차이
FROM insa;

-- COUNT ~ OVER : 질의한 행의 누적된 결과 반환
-- SUM ~ OVER : 질의한 행의 누적된 (합)결과 반환
-- AVG ~ OVER : 질의한 행의 누적된 (평균)결과 반환
SELECT name, basicpay
    , COUNT(*) OVER(ORDER BY basicpay)
FROM insa;

SELECT name, basicpay, buseo
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

SELECT name, basicpay, buseo
    , SUM(basicpay) OVER(ORDER BY buseo)
FROM insa;

SELECT name, basicpay, buseo
    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

SELECT name, basicpay, buseo
    , AVG(basicpay) OVER(ORDER BY buseo)
FROM insa;

-- 테이블 생성, 수정, 삭제 -DDL : CREATE, ALTER, DROP - TABLE
-- 아이디 문자 10
-- 이름 문자 20
-- 나이 숫자 3
-- 전화번호 문자 20
-- 생일 날짜
-- 비고 문자 255

CREATE TABLE tbl_sample
(
    id VARCHAR2(10)
    , name VARCHAR2(20)
    , age NUMBER(3)
    , birth DATE
);

SELECT *
FROM tabs
WHERE REGEXP_LIKE(table_name, '^tbl_', 'i');

DESC tbl_sample;

ALTER TABLE tbl_sample
ADD(
    tel VARCHAR2(20)  -- DEFAULT '000-0000-0000'
    , bigo VARCHAR2(255)
);

SELECT *
FROM tbl_example;
-- 비고 컬럼의 크기 수정, 자료형 수정
-- ( 255 -> 100 )

ALTER TABLE tbl_sample
MODIFY (
    bigo VARCHAR2(100)
);

DESC tbl_example;
-- 문제 bigo 컬럼명 -> memo 변경
ALTER TABLE tbl_sample
RENAME COLUMN bigo TO memo;

-- memo 컬럼 제거
ALTER TABLE tbl_sample
DROP COLUMN memo;

-- 테이블명을 변경 tbl_sample -> tbl_example
RENAME tbl_sample TO tbl_example;