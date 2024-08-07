SELECT *
FROM emp;

SELECT DISTINCT buseo
FROM insa
ORDER BY buseo ASC;
-- ASC ��������
-- DESC ��������
--
SELECT deptno, ename, sal + NVL(comm, 0) PAY
FROM emp
ORDER BY 1 ASC, 3 DESC;  -- 1 deptno, 3 pay ����
--ORDER BY deptno ASC, PAY DESC;
-- 2�� ���� �μ���ȣ�� ���� �����ϰ� �� �ȿ��� PAY�� ����

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
    ,NVL(tel, '����ó ��� �ȵ�') TEL
FROM insa
WHERE tel IS NULL;

SELECT num
    ,name
    ,NVL2(tel, 'O', 'X') TEL
FROM insa
WHERE buseo = '���ߺ�';

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
WHERE CITY NOT IN ('����', '���', '��õ');
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
-- WHERE REGEXP_LIKE(ename, 'la', 'i'); -- ��ҹ��� ���� X
-- WHERE ename LIKE '%' || UPPER('la') || '%';

SELECT * from insa;
--23 
-- PL/SQL ( DQL ) : SELECT
SELECT name, ssn
    , NVL2(NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1 ),'O','X')GENDER
FROM insa;
-- DECODE() �Լ�
-- CASE() �Լ�

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
WHERE REGEXP_LIKE(name, '^[����]') AND ssn LIKE '7_12%';

SELECT COUNT(*)
FROM insa;

-- 3����
-- LIKE �������� ESCAPE �ɼ�
SELECT deptno, dname, loc
FROM dept;
-- dept ���̺� ���ο� �μ�����.. DML : INSERT ��
-- PK = NN + UK ����
INSERT INTO dept (deptno, dname, loc) VALUES (60, '�ѱ�_����', 'COREA');
INSERT INTO dept VALUES (60, '�ѱ�_����', 'COREA');
COMMIT;
ROLLBACK;

-- �μ��� % ���Ե� �μ�
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';

SELECT *
FROM dept;
-- DML(DELETE) WHERE �������� ������ ��� ���ڵ� ����
DELETE FROM dept
WHERE deptno = 60;
COMMIT;
-- DML(UPDATE)
UPDATE dept
SET dname = 'QC' -- WHERE ������ ������ ��� ���ڵ� ����
ROLLBACK;

UPDATE dept
--SET dname = dname || 'XX'
SET dname = SUBSTR( dname, 0, 2), loc = 'COREA'
WHERE deptno = 50;
ROLLBACK;
-- [����] 40�� �μ��� �μ���, �������� ���ͼ� 50�� �μ��� �μ���, ���������� ����

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

-- [����] emp ���̺� ��� ��� sal �⺻���� pay�޿��� 10% �λ��ϴ� UPDATE
SELECT *
FROM emp;
ROLLBACK;
UPDATE emp
SET SAL = sal + (sal + NVL(comm, 0)) * 0.1;
--dual ���̺� = SYNONYM(�ó��)
-- public �ó�� ���� ���� ���� DBA�� ����
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

-- ���� �ο�
GRANT SELECT ON emp TO HR;
-- ���� ȸ��
REVOKE SELECT ON emp FROM HR;

----------------------------------------------------
-- [����Ŭ ������(operator) ����]
--1) �񱳿����� : = !=  >   <   >=   <=
--            WHERE ������ ����,����,��¥�� ���� �� ���
--            ANY, SOME, ALL �񱳿�����, SQL������
--2) �������� : AND   OR   NOT
--            WHERE ������ ������ ������ ��...
--3) SQL ������ : SQL ���� �ִ� ������
--            [NOT] IN (list)
--            [NOT] BETWEEN a AND b 
--            [NOT] LIKE 
--            IS [NOT] NULL 
--            ANY, SOME, ALL      WHERE �� + (��������)
--            EXISTS(TRUE/FALSE)  WHERE �� + (��������)
--4) NULL ������
--5) ��� ������ : ����, ����, ����, ������  (�켱 ����)            
SELECT 5+3, 5-3, 5*3, 5/3
    , FLOOR(5/3)
    , MOD(5,3)
FROM dual;