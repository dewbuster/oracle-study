-- [오라클 연산자(operator) 정리]
--1) 비교연산자
--2) 논리연산자
--3) SQL 연산자
--4) NULL 연산자
--5) 산술 연산자 : 덧셈, 뺄셈, 곱셈, 나눗셈  (우선 순위) 
--      ㄴ 나머지 연산자 -> 함수 : MOD(), REMAINDER()
--      ㄴ 몫 : 절삭 함수 : FLOOR()
--6) SET(집합) 연산자
--ㄱ) UNION    : 합집합
--ㄴ) UNION ALL: 합집합
--ORA-00937: not a single-group group function
SELECT name, city, buseo
FROM insa i
WHERE buseo = '개발부';

SELECT COUNT(*)  -- 9명
FROM (
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
) i;
--
SELECT name, city, buseo    -- 6명
FROM insa
WHERE city = '인천' AND buseo = '개발부';
-- 개발부 + 인천  사원들의 합집합 UNION 17명 UNION ALL 23명
-- 14 + 9 = 23 중복 제거
-- 컬럼의 갯수 같아야 한다. 
-- 컬럼의 타입 같아야 한다. 
-- 컬럼이름은 달라도 상관없다. 
-- 첫번째 select절 컬럼이름 따른다.

SELECT name, city, buseo
FROM insa i
WHERE buseo = '개발부'
 -- ORA-00933: SQL command not properly ended
--UNION
UNION ALL
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;

SELECT empno, ename, hiredate, dname, dept.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.ename, e.hiredate, d.dname
FROM emp e, dept d
WHERE d.deptno = e.deptno
UNION
SELECT name, ibsadate, buseo
FROM insa;

SELECT e.ename, e.hiredate, d.dname
FROM emp e JOIN dept d ON d.deptno = e.deptno
UNION
SELECT name, ibsadate, buseo
FROM insa;

SELECT ename, hiredate, (SELECT dname FROM dept d WHERE d.deptno = e.deptno)dname
FROM emp e
UNION
SELECT name, ibsadate, buseo
FROM insa;

--ㄷ) INTERSECT: 교집합
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;

--ㄹ) MINUS    : 차집합
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;

-- 프로젝트 --
SELECT name, NULL city, buseo
FROM insa i
WHERE buseo = '개발부'
UNION
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;

-- [계층적 질의 연산자] PRIOR, CONNECT_BY_ROOT 연산자
-- IS [NOT] NAN  = Not A Number
-- IS [NOT] INFINITE

-- [오라클 함수(function)]
-- 1) 단일행 함수
--    ㄱ. 문자 함수
-- [UPPER][LOWER][INITCAP]
-- [LENGTH] 문자열 길이
SELECT dname
    ,LENGTH(dname)
FROM dept;
-- [CONCAT]
-- [SUBSTR]
SELECT ssn
    , SUBSTR(ssn, -7)
FROM insa;
-- [INSTR]
SELECT dname
    ,INSTR(dname, 'S')
    ,INSTR(dname, 'S', 2) -- 2번째부터 찾음
    ,INSTR(dname, 'S', -1) -- 뒤에서부터 찾음
    ,INSTR(dname, 'S', -1, 2) -- 뒤에서부터 찾아서 2번째 값
FROM dept;

SELECT *
FROM tbl_tel;
-- 문제 1) 지역번호만 추출해서 출력
SELECT tel
    ,INSTR(tel, ')')ㄱ
    ,INSTR(tel, '-')ㄴ
    ,SUBSTR(tel, 0, INSTR(tel, ')')-1)ㄷ
    ,SUBSTR(tel, INSTR(tel, ')')+1, INSTR(tel, '-')-INSTR(tel, ')')-1 )ㄹ
    ,SUBSTR(tel, INSTR(tel, '-')+1)ㅁ
FROM tbl_tel;

-- [RPAD/LPAD]
SELECT RPAD('Corea',12,'*') 
FROM dual;

SELECT ename, sal+NVL(comm, 0) pay
    ,LPAD(sal+NVL(comm, 0), 10, '*')
FROM emp;

-- [RTRIM/LTRIM]
SELECT RTRIM('BROWINGyxXxy','xy') "RTRIM ex"
    , LTRIM('****8978', '*')
    , TRIM('   xxx   ')
FROM dual;

SELECT ASCII('A')
    ,CHR(65)
FROM dual;

SELECT ename
    ,SUBSTR(ename, 1,1)s
    ,ASCII(SUBSTR(ename,1,1))a
FROM emp;

--[GREATEST/LEAST] 나열된 숫자 또는 문자 중에 가장 큰, 작은값을 반환하는 함수
SELECT GREATEST(3,5,2,4,1) max
    ,LEAST(3,5,2,4,1) min
    ,GREATEST('R','A','Z','X') max
    ,LEAST('R','A','Z','X') min
FROM dual;

--[VSIZE]
SELECT VSIZE(1), VSIZE('A'), VSIZE('한')
FROM dual;
--    ㄴ. 숫자 함수
--    [ROUND(a[,b양수,음수])] - 반올림함수
SELECT 3.141592
    ,ROUND(3.141592)ㄱ
    ,ROUND(3.141592, 0)ㄴ       -- b+1 자리에서 반올림
    ,ROUND(3.141592, 3)ㄷ
    ,ROUND(12345.6789, -2)ㄹ    -- 음수는 소수점 왼쪽 b 자리
FROM dual;
-- [절삭함수 TRUNC(), FLOOR() 차이점]
SELECT FLOOR(3.141592)
    , FLOOR(3.9)
    , TRUNC(3.141592, 3)
    , TRUNC(123.192, -1)
FROM dual;
-- [올림(절상)함수 CEIL()]
SELECT CEIL(3.14)
    ,CEIL(3.94)
    ,CEIL(161/10)ㄷ   -- 게시판 총 페이지 수 계산 CEIL
    ,ABS(10), ABS(-10)ㄹ    -- 절대값
FROM dual;
--- SIGN
SELECT SIGN(100)    -- 1
    ,SIGN(0)        -- 0 
    ,SIGN(-111)     -- -1
FROM dual;
--
SELECT POWER(2,3)   --2의3승
    , SQRT(16)       --16의제곱근
FROM dual;
--    ㄷ. 날짜 함수 SYSDATE/ROUND,TRUNC(날짜)
SELECT SYSDATE s  -- 현재 날짜 시간(초)
    ,ROUND(SYSDATE)r --정오를 기준으로 날짜 반올림
    ,ROUND(SYSDATE, 'DD') --정오를 기준으로 날짜 반올림
    ,ROUND(SYSDATE, 'MONTH') a  -- 15일 기준
    ,ROUND(SYSDATE, 'YEAR') b -- 
FROM dual;

SELECT SYSDATE s
--    ,TO_CHAR(SYSDATE, 'DS TS')a
--    ,TRUNC(SYSDATE)b    --시간, 분,초 절삭
--    ,TO_CHAR(TRUNC(SYSDATE), 'DS TS')c
--    ,TRUNC(SYSDATE, 'DD')d --시간, 분,초 절삭
--    ,TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS')e
    ,TRUNC(SYSDATE, 'MONTH') m
    ,TO_CHAR(TRUNC(SYSDATE, 'MONTH'), 'DS TS') m
    ,TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS') y
FROM dual;

-- 날짜에 산술연산을 사용하는 경우...
SELECT SYSDATE
    ,SYSDATE + 7    -- + 7일
    ,SYSDATE + 2/24 -- + 2시간
    -- ,SYSDATE - 날짜 = 두 날짜 사이의 일수(간격)
FROM dual;
-- 회사 입사후 몇일이 지났는지?
SELECT ename, hiredate
    ,CEIL(SYSDATE - hiredate) 근무일수
FROM emp;
-- 문제) 우리가 개강일로 부터 현재 몇일이 지났는가?
SELECT CEIL(SYSDATE - TO_DATE('2024/07/01')) D
FROM dual;

SELECT ename, hiredate, SYSDATE
    ,CEIL(MONTHS_BETWEEN(SYSDATE, hiredate)) 근무개월수
    ,CEIL(MONTHS_BETWEEN(SYSDATE, hiredate)/12) 근무년수
FROM emp;

SELECT SYSDATE
    ,ADD_MONTHS(SYSDATE, 1)m  -- 1달 증가
    ,ADD_MONTHS(SYSDATE, -1)m  -- 1달 감소
    ,ADD_MONTHS(SYSDATE, 1*12)y -- 1년 증가
    ,ADD_MONTHS(SYSDATE, -1*12)y -- 1년 감소
FROM dual;

SELECT SYSDATE s
--    ,LAST_DAY(SYSDATE)
--    ,EXTRACT(DAY from LAST_DAY(SYSDATE)) lastday
--    ,TRUNC(SYSDATE, 'MM') t -- 1일 만들기
    ,TO_CHAR(TRUNC(SYSDATE, 'MM'), 'DY') dy
    ,ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1) -1 "last"  -- = LAST_DAY()
FROM dual;

SELECT SYSDATE
    ,NEXT_DAY(SYSDATE, '월')
FROM dual;

-- 문제) 10월 첫번째 월요일날 휴강..
SELECT NEXT_DAY( TRUNC( ADD_MONTHS(SYSDATE, 2), 'MM'), '월') m
FROM dual;
SELECT NEXT_DAY(TO_DATE('2024/10/01'), '월') m
FROM dual;

SELECT CURRENT_DATE c     -- *세션*의 날짜시간분초
FROM dual;
--    ㄹ. 변환 함수
SELECT '1234'
    ,TO_NUMBER('1234')
FROM dual;

SELECT num, name
    , basicpay, sudang
    , basicpay + sudang
    , TO_CHAR(basicpay + sudang, 'L9G999G999D00') pay
FROM insa;

SELECT
    TO_CHAR(100, 'S9999')a
    ,TO_CHAR(-100, 'S9999')b
    ,TO_CHAR(100, '9999MI')c
    ,TO_CHAR(-100, '9999MI')d
    ,TO_CHAR(100, '9999PR')e
    ,TO_CHAR(-100, '9999PR')f
FROM dual;

SELECT ename
    , TO_CHAR((sal+NVL(comm, 0)) * 12, 'L9,999,999') 연봉
FROM emp;

-- TO_CHAR 패턴 안에 text 삽입 시 "" 사용
SELECT name, ibsadate
    ,TO_CHAR(ibsadate, 'YYYY"년"MM"월"DD"일" DAY') dd  
    ,TO_CHAR(ibsadate, 'DL') dl
FROM insa;
--    ㅁ. 일반 함수
SELECT ename
    ,sal + NVL(comm,0) pay
    ,sal + NVL2(comm, comm, 0) pay
    ,COALESCE(sal+comm, sal, 0) ㄴ -- sal+comm이 null이면 sal반환, sal도 null이면 0반환
FROM emp;

-- DECODE 함수    ****중요****
--  ㄴ 프로그래밍 언어의 if 문을 sql, pl/sql 안으로 끌어오기 위해서 만들어진 오라클 함수
--  ㄴ FROM 제외 어디나 사용 가능
--  ㄴ 비교 연산은 = 만 가능
--  ㄴ DECODE 함수의 확장 함수 : CASE 함수
if (A = B) {
    return C  
} else {
    return D
}
==> DECODE(A,B,C,D)

if (A = B) {
    return  ㄱ;
} else if(A = C){
    return ㄴ;
} else if (A = D){
    return ㄷ;
} else if (A = E){
    return ㄹ;
} else {
    return ㅁ;
}
==> DECODE(A, B, ㄱ, C, ㄴ, D, ㄹ, E, ㄹ, ㅁ);

SELECT name, ssn
--    ,NVL2(NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1 ),'여자','남자')GENDER
    ,DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 0, '여자', '남자') GENDER
FROM insa;

-- CASE 함수      ****중요****
-- 문제) emp 테이블에서 sal의 10%를 인상
SELECT *
FROM emp;

-- 문제) emp 테이블에서 10번부서 15% pay인상, 20번 부서 10%, 그 외 20%
SELECT ename, sal, comm, deptno
    ,sal + NVL(comm, 0) pay
    , (sal + NVL(comm, 0)) * DECODE(deptno, 10, 1.15, 20, 1.1, 1.2) "인상"
FROM emp;

SELECT name, ssn
 --   ,DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 0, '여자', '남자') GENDER
    ,CASE MOD(SUBSTR(ssn, -7, 1), 2) 
        WHEN 1 THEN '남자'
        ELSE '여자'
    END GENDER
FROM insa;

SELECT ename, sal, comm, deptno
    ,sal + NVL(comm, 0) pay
    , (sal + NVL(comm, 0)) * DECODE(deptno, 10, 1.15, 20, 1.1, 1.2) "인상DECODE"
    ,(sal + NVL(comm, 0)) * CASE deptno
                            WHEN 10 THEN 1.15
                            WHEN 20 THEN 1.1
                            ELSE 1.2
                            END "인상CASE"
FROM emp;

-- 2) 복수행 함수 (그룹 함수)
SELECT COUNT(*)
    ,SUM(sal) s
--    ,SUM(comm)/COUNT(*) c   -- 이렇게 계산하면 null까지 카운팅
    ,AVG(comm) a     -- null 값 제외 평균
    ,MAX(sal)
    ,MIN(sal)
FROM emp;
SELECT *
FROM emp;
-- 총 사원수 조회
-- 각 부서별 사원 수 조회

SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;