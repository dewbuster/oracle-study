-- SCOTT
-- [����1] emp ���̺� - ename, pay, ��ձ޿� ,  ����,�ݿø�,���� �Լ� (�Ҽ��� 3�ڸ�)
--[ ������ ]
--ENAME             PAY    AVG_PAY       �� �ø�      �� �ݿø�       �� ����
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
      , CEIL( (t.pay - t.avg_pay)*100 )/100  "�� �ø�" -- CEIL(n)
      , ROUND( t.pay - t.avg_pay, 2 ) "�� �ݿø�"
      --, FLOOR()
      , TRUNC(t.pay - t.avg_pay, 2) "�� ����" 
FROM temp t; 

-- [����2] emp ���̺��� 
--        pay,   avg_pay
--                          ����, ����, ����. ���
--       ename, pay, avg_pay, (��,��,����) 
--        ��. SET ���� ������( U, UA, M, I )
WITH temp AS (
    SELECT ename, sal+NVL(comm,0) pay
        , ( SELECT AVG( sal + NVL(comm, 0) ) FROM emp) avg_pay
    FROM emp
)
SELECT t.*
     , CASE 
          WHEN pay > avg_pay THEN '����'
          WHEN pay < avg_pay THEN '����'
          ELSE '����'
       END ��
FROM temp t;

-- [����3] insa ���̺��� ssn �ֹε�Ϲ�ȣ, ������ ���� ������.������ �ʾҴ��� ���.
SELECT *
FROM insa;
-- 1) 1002 �̼���  �ֹε�Ϲ�ȣ ��/�� -> ���ó�¥�� ��/�Ϸ� ����(UPDATE)
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
-- 2) ���� ���� ���� ���.
SELECT name
    ,SUBSTR(ssn, 3, 4)
    ,TO_DATE(SUBSTR(ssn, 3,4), 'MMDD') bd
    ,CASE SIGN(TO_DATE(SUBSTR(ssn, 3,4), 'MMDD') - TRUNC(SYSDATE))
        WHEN 1 THEN 'X'
        WHEN -1 THEN 'O'
        ELSE '����'
    END s
FROM insa
WHERE num = 1002;

-- [����] insa ���̺��� �ֹε�Ϲ�ȣ �� ���̸� ����ؼ� ���
-- ����(1,2) 1900 (3,4) 2000 (0,9) 1800 (5,6) �ܱ���1900 (7,8) �ܱ��� 2000
-- ���ϳ⵵
--SELECT name, ssn, ����⵵, ���س⵵, ������
--FROM insa;

WITH temp AS(
SELECT name, ssn
    ,SUBSTR(ssn, 1, 2) + CASE 
            WHEN SUBSTR(ssn, -7, 1) IN (1,2,5,6) THEN 1900
            WHEN SUBSTR(ssn, -7, 1) IN (3,4,7,8) THEN 2000
            ELSE 1800
    END ����⵵
    , TO_CHAR(SYSDATE, 'YYYY') ���س⵵
    , SIGN(TO_DATE(SUBSTR(ssn, 3,4), 'MMDD') - TRUNC(SYSDATE)) bs
FROM insa
)
SELECT temp.name, temp.ssn, ����⵵, ���س⵵
    ,���س⵵ - ����⵵ + CASE bs
        WHEN -1 THEN -1
        ELSE 0
        END ������
FROM temp;
-- JAVA
-- Math.random() ������ ��
-- Random Ŭ���� nextInt() ������ ��
-- DBMS_RANDOM ��Ű��
-- �ڹ� ��Ű�� - ���� ���õ� Ŭ�������� ����
-- ����Ŭ ��Ű�� - ���� ���õ� Ÿ��, ���α׷� ��ü, �������α׷�(procedure, function)�� �������� ���� ���� ��
SELECT 
    SYS.dbms_random.value
--    , SYS.dbms_random.value(0, 100) --0.0 <= �Ǽ� < 100.0
--    , SYS.dbms_random.string('U', 5)u -- �빮�� 
--    , SYS.dbms_random.string('L', 5)l -- �ҹ���
    , SYS.dbms_random.string('X', 5)x -- �빮�� + ����
    , SYS.dbms_random.string('P', 5)p -- ��ҹ��� + ���� + Ư������
    , SYS.dbms_random.string('A', 5)a -- ���ĺ�
FROM dual;

--[����] ������ ���� ���� 1�� ���
SELECT 
    ROUND(SYS.dbms_random.value(0, 100)) ��������
FROM dual;
--[����] ������ �ζ� ��ȣ 1�� ���
SELECT 
    ROUND(SYS.dbms_random.value(1, 46)) �ζǹ�ȣ
FROM dual;
--[����] ������ ���� 6�ڸ� �߻����Ѽ� ���
SELECT 
    SUBSTR(TO_CHAR(ROUND(SYS.dbms_random.value(1000000, 9999999))),2) ����6�ڸ�
FROM dual;
--[����] �λ����̺��� ���ڻ����, ���ڻ����
SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2), 0, '����','����') GENDER
    , COUNT(*) �����
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1),2);

SELECT buseo
    , DECODE(MOD(SUBSTR(ssn,-7,1),2), 0, '����','����') GENDER
    , COUNT(*) �����
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn,-7,1),2)
ORDER BY buseo;


SELECT *
FROM emp
ORDER BY deptno;
--[����] emp ���̺��� �ְ�, ���� �޿��� ������ ��� ����
SELECT *
FROM emp a, (SELECT MAX(sal) max, MIN(Sal) min FROM emp) b
WHERE a.sal IN (b.max, b.min)
ORDER BY sal;

--[����] emp ���̺��� �� �μ��� �ְ�, ���� �޿��� ������ ��� ����
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

-- [����] emp ���̺��� comm�� 400 ������ ����� ���� ��ȸ(���� comm�� NULL�� ����� ����)
SELECT ename, job, sal, NVL(comm, 0)
FROM emp
WHERE NVL(comm, 0) <= 400
ORDER BY NVL(comm,0) DESC;

--LNNVL() �Լ�
SELECT ename, job, sal, NVL(comm, 0)
FROM emp
WHERE LNNVL(comm > 400); -- == comm <= 400 OR comm IS NULL

-- [����] �̹� ���� ������ ��¥��
SELECT SYSDATE
    , TRUNC(SYSDATE, 'MONTH') m -- 24/08/01
    , LAST_DAY(SYSDATE) l
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD') ld
FROM dual;

-- [����] emp ���̺��� sal�� ���� 20%�� �ش�Ǵ� ����� ���� ��ȸ
SELECT *
FROM
(
SELECT emp.*, 
    PERCENT_RANK()OVER(ORDER BY sal DESC) p
FROM emp
)
WHERE p <= 0.2;

-- [���� �� ������ �ް� - ��¥ ��ȸ]
SELECT TO_CHAR(SYSDATE, 'DY')
    , NEXT_DAY( SYSDATE, '��' )
FROM dual;

-- emp ���̺��� �� ������� �Ի����ڸ� �������� 10�� 5���� 20��° �Ǵ� ��¥ ���
SELECT ename, hiredate
    , ADD_MONTHS(hiredate, 10*12+5)+20 "10��5����20��" 
FROM emp;

--insa ���̺��� 
[������]
                                           �μ������/��ü����� == ��/�� ����
                                           �μ��� �ش缺�������/��ü����� == �μ�/��%
                                           �μ��� �ش缺�������/�μ������ == ��/��%
                                           
�μ���     �ѻ���� �μ������ ����  ���������  ��/��%   �μ�/��%   ��/��%
���ߺ�       60       14         F       8       23.3%     13.3%       57.1%
���ߺ�       60       14         M       6       23.3%     10%       42.9%
��ȹ��       60       7         F       3       11.7%       5%       42.9%
��ȹ��       60       7         M       4       11.7%   6.7%       57.1%
������       60       16         F       8       26.7%   13.3%       50%
������       60       16         M       8       26.7%   13.3%       50%
�λ��       60       4         M       4       6.7%   6.7%       100%
�����       60       6         F       4       10%       6.7%       66.7%
�����       60       6         M       2       10%       3.3%       33.3%
�ѹ���       60       7         F       3       11.7%   5%           42.9%
�ѹ���       60       7         M    4       11.7%   6.7%       57.1%
ȫ����       60       6         F       3       10%       5%           50%
ȫ����       60       6         M       

SELECT COUNT(*)
FROM insa;

(SELECT buseo, COUNT(*) bc
FROM insa
GROUP BY buseo);

SELECT a.buseo
    , (SELECT COUNT(*) FROM insa) �ѻ����
    , b.�μ������
    , DECODE(a.����, 0, 'F', 'M') ����
    , a.���������
    , ROUND(b.�μ������/(SELECT COUNT(*) FROM insa) *100, 2)||'%'"��/��%"
    , ROUND(a.���������/(SELECT COUNT(*) FROM insa) *100, 2)||'%' "�μ�/��%"
    , ROUND(a.���������/b.�μ������ *100, 1)||'%' "��/��%"
FROM
(SELECT buseo
, MOD(SUBSTR(ssn, -7, 1),2) ����
, COUNT(*) ���������
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn, -7, 1),2)) a,
(SELECT buseo, COUNT(*) "�μ������"
FROM insa
GROUP BY buseo) b
WHERE a.buseo = b.buseo
ORDER BY a.buseo;

-- LISTAGG() ***(�ϱ�)
[������]
10   CLARK/MILLER/KING
20   FORD/JONES/SMITH
30   ALLEN/BLAKE/JAMES/MARTIN/TURNER/WARD
40  �������   

SELECT EMPNO, ENAME, JOB, DEPTNO FROM EMP ;

SELECT deptno, LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename ASC) ename
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- [����] insa ���̺��� TOP-N �м��������
-- �޿����� �޴� TOP 10

SELECT *
FROM(
SELECT *
FROM insa
ORDER BY basicpay DESC
)
WHERE ROWNUM <= 10;

--[����]
SELECT TRUNC(SYSDATE, 'YEAR') -- 2024-01-01
    ,TRUNC(SYSDATE, 'MONTH') --2024-08-01
    ,TRUNC(SYSDATE, 'DD') -- 2024-08-12
    ,TRUNC(SYSDATE) -- 2024-08-12 - �ð� ����
FROM dual;

--[��������]
[������]
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
-- ww / iw / w ������ �ľ�.
SELECT hiredate
    , TO_CHAR(hiredate,'WW') ww -- ���� �� ��° ��
    , TO_CHAR(hiredate,'IW') iw -- ���� �� ��° ��
    , TO_CHAR(hiredate,'W') w -- ���� �� ��° ��
FROM emp;

-- ������� ���� ���� �μ���, �����
-- ������� ���� ���� �μ���, �����

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
-- WITH �� ���� (�ϱ�)

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

-- �Ǻ�(pivot) / ���Ǻ�(unpivot) (�ϱ�)
--  https://blog.naver.com/gurrms95/222697767118
-- job�� ����� ���
SELECT
    COUNT(DECODE(job, 'CLERK', 'O')) CLERK
    ,COUNT(DECODE(job, 'SALESMAN', 'O')) SALESMAN
    ,COUNT(DECODE(job, 'PRESIDENT', 'O')) PRESIDENT
    ,COUNT(DECODE(job, 'MANAGER', 'O')) MANAGER
    ,COUNT(DECODE(job, 'ANALYST', 'O')) ANALYST
FROM emp;

SELECT 
FROM (�Ǻ� ��� ������)
PIVOT (�׷��Լ�(�����÷�) FOR �ǹ��÷� IN (�ǹ��÷� AS ��Ī...) );

SELECT *
FROM (
SELECT job 
FROM emp)
PIVOT (
COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));

-- 2) emp ���̺��� �� ���� �Ի��� ����� ��ȸ
SELECT *
FROM emp;

SELECT EXTRACT(month FROM hiredate) �Ի��, COUNT(*)
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
    FOR month IN ('01' AS "1��",'02','03','04','05','06','07','08','09','10','11','12')
    )
    ORDER BY year;
    
[����] emp ���̺��� job�� ����� ��ȸ
-- clerck  p
--   3     1

-- [] emp �μ��� / �⺰ �����
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
-- �� �μ��� �� �޿� ���� ��ȸ
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
    SUM(sal) AS �հ�
    FOR deptno IN ('10','20','30','40')
);

-- �Ǻ� ����)
-- ���� ���� o     x    ����
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
    FOR s IN ('1' AS "����X", '0' AS "���û���", '-1' AS "����O")
);
-- [�μ���ȣ 4�ڸ� ���]
SELECT deptno
    ,TO_CHAR(deptno, '0999')
    , LPAD(deptno, 4, '0')
FROM dept;

-- (�ϱ�)  insa ���̺��� �� �μ���/���������/����� ������� ���(��ȸ)
SELECT *
FROM insa;
-- ������� city 11��
SELECT DISTINCT city
FROM insa;

SELECT buseo, city, COUNT(*)
FROM insa
GROUP BY buseo, city
ORDER BY buseo, city;

-- ����Ŭ 10G ���� �߰��� ��� : (PARTITION BY OUTER JOIN) ���� ���

WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, COUNT(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c
ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;
