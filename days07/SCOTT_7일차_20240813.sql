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
--����� �������� �ʴ� �μ��� �μ���ȣ, �μ��� ���

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
-- ��. SQL ������ ALL , ANY, SOME, [NOT] EXITS
SELECT m.deptno, m.dname
FROM dept m
WHERE NOT EXISTS (SELECT empno FROM emp WHERE deptno = m.deptno);

-- ��. ��� ��������
SELECT m.deptno, m.dname
FROM dept m
WHERE (SELECT COUNT(*) FROM emp WHERE deptno = m.deptno) = 0;   -- emp ���̺� �������� �ʴ� �μ�����

-- insa ���̺��� �� �μ��� ���ڻ���� 5�� �̻��� �μ�
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;

-- [����] insa ���̺�
--     [�ѻ����]      [���ڻ����]      [���ڻ����] [��������� �ѱ޿���]  [��������� �ѱ޿���] [����-max(�޿�)] [����-max(�޿�)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000
SELECT *
FROM insa;

SELECT
     DECODE(MOD(SUBSTR(ssn,-7,1),2), 1, '����',0,'����', '��ü') GENDER
    , COUNT(*)�����
    , SUM(basicpay) �޿���
    , MAX(basicpay) MAX�޿�
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,-7,1),2))
;

SELECT COUNT(*) �ѻ����
    ,COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'o')) ���ڻ����
    ,COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'o')) ���ڻ����
    ,SUM(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,basicpay)) ���ڱ޿���
    ,SUM(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,basicpay)) ���ڱ޿���
    ,MAX(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,basicpay)) ���ڱ޿���
    ,MAX(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,basicpay)) ���ڱ޿���
FROM insa
;

-- [����] emp ���̺���~
--      �� �μ��� �����, �μ� �ѱ޿���, �μ� ��ձ޿�
���)
    DEPTNO       �μ�����       �ѱ޿���            ���
---------- ----------       ----------    ----------
        10          3          8750       2916.67
        20          3          6775       2258.33
        30          6         11600       1933.33 
        40          0         0             0

SELECT d.deptno, COUNT(empno) �μ�����
    , NVL(SUM(sal+NVL(comm,0)),0) �ѱ޿���
    , NVL(ROUND(avg(sal+NVL(comm,0)),2),0) ���
FROM emp e RIGHT JOIN dept d
ON e.deptno = d.deptno
GROUP BY d.deptno
ORDER BY d.deptno
;

--[ ROLLUP �� CUBE ��]
-- �� GROUP BY ������ ��� �׷캰 �Ұ踦 �߰��� �����ִ� ����
-- �� ��, �߰����� ���� ������ �����ش�
SELECT
    CASE MOD( SUBSTR(ssn,-7,1), 2 )
    WHEN 1 THEN '����'
    WHEN 0 THEN '����'
    ELSE '��ü'
    END ����
    , COUNT(*) �����
FROM insa
GROUP BY ROLLUP(MOD( SUBSTR(ssn,-7,1),2));

SELECT
    CASE MOD( SUBSTR(ssn,-7,1), 2 )
    WHEN 1 THEN '����'
    WHEN 0 THEN '����'
    ELSE '��ü'
    END ����
    , COUNT(*) �����
FROM insa
GROUP BY CUBE(MOD( SUBSTR(ssn,-7,1),2));

-- ROLLUP / CUBE ������
-- 1�� �μ��� �׷���, 2�� ������ �׷���
SELECT buseo, jikwi, COUNT(*) �����
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi
;
SELECT buseo, jikwi, COUNT(*) �����
FROM insa
GROUP BY CUBE(buseo, jikwi)
ORDER BY buseo, jikwi
;

-- ���� ROLLUP
SELECT buseo, jikwi, COUNT(*)�����
FROM insa
GROUP BY ROLLUP(buseo), jikwi -- ������ ���� �κ� ����
--GROUP BY buseo, ROLLUP(jikwi) -- �μ��� ���� �κ� ����
--GROUP BY CUBE(buseo, jikwi)
ORDER BY buseo, jikwi
;

-- [ GROUPING SETS �Լ� ]
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
GROUP BY GROUPING SETS(buseo, jikwi) -- �׷����� ���踸 ������ �Ҷ�
ORDER BY buseo, jikwi
;

-- �Ǻ�(pivot) ����
-- 1. ���̺� ���� X
--tbl_pivot ���̺� ����
--��ȣ, �̸�, ��,��,�� ���� ���̺�

CREATE TABLE tbl_pivot
(
--    �÷��� �ڷ���(ũ��) ��������
    no NUMBER PRIMARY KEY -- ����Ű
    , name VARCHAR2(20 BYTE) NOT NULL --NN ��������(=�ʼ��Է»���)
    , jumsu NUMBER(3) -- NULL ���
);
--
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '�ڿ���', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '�ڿ���', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '�ڿ���', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '�Ƚ���', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '�Ƚ���', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '�Ƚ���', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '���', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '���', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '���', 100 );  -- mat 

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
    SUM(jumsu) FOR s IN ('1'����, '2'����, '0'����)
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
PIVOT( SUM(jumsu) FOR subject IN (1 AS ����,2 AS ����,3 AS ����))
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

-- [Ǯ��] insa ���� �μ���, ������ �����
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
    ,b.jikwi �ּ�����, b.tot_count �ּһ����
    
FROM t2 a, t1 b
WHERE a.buseo = b.buseo AND a.buseo_min_count = b.tot_count;
;

-- FIRST / LAST �м��Լ� Ǯ��
WITH t AS (
    SELECT buseo, jikwi, COUNT(num)tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
SELECT t.buseo
    ,MIN(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count) �ּ�����
    ,MIN(t.tot_count) �ּһ����
    ,MAX(t.jikwi) KEEP(DENSE_RANK LAST ORDER BY t.tot_count) �ִ�����
    ,MAX(t.tot_count) �ִ�����
FROM t
GROUP BY t.buseo
ORDER BY 1;

-- ���� �� �μ��� ������ �ּһ�� ��, �ִ� ��� �� ��ȸ
-- 1) �м��Լ� FIRST, LAST
--           �����Լ�(COUNT, SUM, AVG, MAX, MIN)�� ���� ����Ͽ�
--           �־��� �׷쿡 ���� ���������� ������ �Ű� ����� �����ϴ� �Լ�
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
SELECT a.empno, a.ename, a.mgr, b.ename ���
FROM emp a JOIN emp b ON a.mgr = b.empno
;

-- NON EQUAL JOIN
SELECT empno, ename, sal, s.grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

-- emp ���̺��� ���� �Ի����ڰ� ���� ����� ���� ���� ������� �Ի� ���� �ϼ�
SELECT MAX(hiredate) - MIN(hiredate)
FROM emp;

-- �м��Լ� : CUME_DIST()
--  �� �־��� �׷쿡 ���� ������� ���� ������ ���� ��ȯ
--  �� ��������(����) 0 <    <= 1

SELECT deptno, ename, sal
--    , CUME_DIST() OVER(ORDER BY sal) dept_list
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_list
FROM emp;

-- �м��Լ� : PERCENT_RANK()
--  �� �ش� �׷� ���� ����� ����
--  0<= ���� �� <= 1
-- ����� ���� : �׷� �ȿ��� �ش� ���� ������ ���� ���� ����

-- NTILE() ( NŸ�� )
-- �� ��Ƽ�� ���� expr�� ��õ� ��ŭ ������ ����� ��ȯ�ϴ� �Լ�
-- �����ϴ� ���� ��Ŷ(bucket)�̶�� �Ѵ�
SELECT deptno, ename, sal
    , NTILE(2) OVER(PARTITION BY deptno ORDER BY sal) ntiles
FROM emp;

SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) ntiles
    , WIDTH_BUCKET(sal, 1000, 4000, 4 ) widthbuckets
FROM emp;

-- LAG( expr, offset, default_value )
--  �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
--  �� ����(��) ��
-- LEAD( expr, offset, default_value )
--  �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
--  �� ����(��) ��
SELECT deptno, ename, hiredate, sal
    ,LAG(sal, 3, 100)OVER(ORDER BY hiredate) pre_sal
    ,LEAD(sal, 1, -1)OVER(ORDER BY hiredate) next_sal
FROM emp
WHERE deptno = 30;

-----------------------------------------
-- [����Ŭ �ڷ���(Data Type)]
1) CHAR[(size[BYTE ? CHAR])] ���ڿ� �ڷ���
    CHAR = CHAR(1 BYTE) = CHAR(1)
    CHAR(3 BYTE) = CHAR(3) 'ABC' '��'
    CHAR(3 CHAR) 'ABC' '�ѵѼ�'
    ���� ������ ���ڿ� �ڷ��� 
    name CHAR(10 BYTE)  - 3�� ����ص� 10����Ʈ
    �ִ� 2000 BYTE �Ҵ� ����
    
CREATE TABLE tbl_char
(
    aa CHAR         -- CHAR(1) == CHAR(1 BYTE)
    ,bb CHAR(3)     -- CHAR(3BYTE)
    ,cc CHAR(3 CHAR)
);

DESC tbl_char;

INSERT INTO tbl_char VALUES('a','aaa','aaa');

INSERT INTO tbl_char VALUES('b','��','�ѿ츮');

INSERT INTO tbl_char VALUES('c', '�ѿ츮', '�ѿ츮');

2) NCHAR
    N == UNICODE(�����ڵ�)
    NCHAR[(SIZE)]
    NCHAR == NCHAR(1)
    NCHAR(10)
    �������� ���ڿ� �ڷ���
    2000 BYTE

CREATE TABLE tbl_nchar
(
    aa CHAR(3)   -- (3byte) ��3 ��1
    ,bb CHAR(3 CHAR) 
    ,cc NCHAR(3)
);

INSERT INTO tbl_nchar VALUES('ȫ', '�浿', 'ȫ�浿');
INSERT INTO tbl_nchar VALUES('ȫ�浿', 'ȫ�浿', 'ȫ�浿');
COMMIT;

���� ���ڿ� - CHAR / NCHAR 2000 BYTE

3) VAR+CHAR2 ==> VARCHAR
    ���� ���� ���ڿ� �ڷ���
    4000 BYTE
    VARCHAR2(SIZE BYTE/CHAR)
    VARCHAR2(1) = VARCHAR2(1 BYTE) = VARCHAR2
    
4) NVARCHAR2
    �����ڵ� + �������� + ���ڿ� �ڷ���
    NVARCHAR2(size) -- ����� ����
    NVARCHAR2(1) = NVARCHAR2
    4000 BYTE
    
5) NUMBER[(p[,s])]
        precision, scale
        ��Ȯ��      �Ը�
        ��ü�ڸ���   �Ҽ��������ڸ���
        1��38      -84��127
    NUMBER = NUMBER(38, 127) --�ִ�
    NUMBER(p) = NNUMBER(p,0)
    
    ��)
    CREATE TABLE tbl_number
    (
        no NUMBER(2) NOT NULL PRIMARY KEY  -- NN, UK
        , name VARCHAR2(30) NOT NULL
        , kor NUMBER(3) -- -999 ~ 999
        , eng NUMBER(3) -- 0 <=  <= 100 checked ��������
        , mat NUMBER(3) DEFAULT 0
    );
    
    INSERT INTO tbl_number VALUES(1, 'ȫ�浿', 90, 88, 98);
    COMMIT;
    
INSERT INTO tbl_number (no, name, kor, eng)  VALUES(2, '�̽���', 100, 100);
COMMIT;

INSERT INTO tbl_number VALUES(3, '�ۼ�ȣ', 50, 50, 100);
COMMIT;

INSERT INTO tbl_number (name, no, kor, eng, mat)  VALUES('�����', 4, 50, 50, 100);
COMMIT;
--
SELECT *
FROM tbl_number;
--
INSERT INTO tbl_number VALUES(5, '�輱��', 110, 56.934, -999); --56.934 => �ݿø�

6) FLOAT[(p)] == ���������� NUMBER ó�� ��Ÿ����.
7) LONG ��������(VAR) ���ڿ� �ڷ���, 2GB
8) DATE ��¥.�ð� 
9) RAW(SIZE) - 2000 BYTE ����������
   LONG RAW - 2GB        ����������
10) LOB : CLOB, NCLOB, BLOB, BFILE

-- FIRST_VALUE �м��Լ� : ���ĵ� �� �߿� ù��° ��

SELECT DISTINCT FIRST_VALUE(basicpay)OVER(ORDER BY basicpay DESC)
FROM insa;

-- ���� ���� �޿�(basicpay) �� ����� basicpay�� ����
SELECT buseo, name, basicpay
    , FIRST_VALUE(basicpay)OVER(PARTITION BY buseo ORDER BY basicpay DESC) MAX_BASICPAY
    , FIRST_VALUE(basicpay)OVER(PARTITION BY buseo ORDER BY basicpay DESC) - basicpay ����
FROM insa;

-- COUNT ~ OVER : ������ ���� ������ ��� ��ȯ
-- SUM ~ OVER : ������ ���� ������ (��)��� ��ȯ
-- AVG ~ OVER : ������ ���� ������ (���)��� ��ȯ
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

-- ���̺� ����, ����, ���� -DDL : CREATE, ALTER, DROP - TABLE
-- ���̵� ���� 10
-- �̸� ���� 20
-- ���� ���� 3
-- ��ȭ��ȣ ���� 20
-- ���� ��¥
-- ��� ���� 255

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
-- ��� �÷��� ũ�� ����, �ڷ��� ����
-- ( 255 -> 100 )

ALTER TABLE tbl_sample
MODIFY (
    bigo VARCHAR2(100)
);

DESC tbl_example;
-- ���� bigo �÷��� -> memo ����
ALTER TABLE tbl_sample
RENAME COLUMN bigo TO memo;

-- memo �÷� ����
ALTER TABLE tbl_sample
DROP COLUMN memo;

-- ���̺���� ���� tbl_sample -> tbl_example
RENAME tbl_sample TO tbl_example;