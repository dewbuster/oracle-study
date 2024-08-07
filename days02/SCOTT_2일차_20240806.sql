-- SCOTT
-- 1) SCOTT ������ ���̺� ��� ��ȸ
SELECT *
FROM user_tables;
FROM tabs;

-- INSA ���̺� ���� �ľ�
DESC insa;
--NUMBER(5) == NUMBER(5,0) �Ҽ��� 0�ڸ�
SELECT *
FROM insa;
-- IBSADATE - DATE
-- '98/10/11'
SELECT * 
FROM v$nls_parameters;
-- ����(pay) = �⺻��(Sal) + ����(comm)
SELECT *
FROM emp;
SELECT empno, ename, hiredate
--, NVL2(comm, comm, 0)
, sal + NVL(comm, 0) AS pay
FROM emp;
-- ����) emp ���̺��� �����ȣ, �����, ���ӻ��
-- ���ӻ�簡 null�� ��� 'CEO' ��� ���
SELECT empno, ename, mgr
, NVL( TO_CHAR(mgr), 'CEO' ) AS MGR -- TO_CHAR() �÷� Ÿ���� ���ڷ� �ٲ�
, NVL( mgr||'', 'CEO' ) AS MGR -- ||'' �÷� Ÿ���� ���ڷ� �ٲ�
FROM emp;
DESC emp;
-- emp ���̺��� �̸��� 'smith'�̰�, ������ clerk�̴�
SELECT '�̸��� ''' || ename || '''�̰�, ������' || job || '�̴�.'
FROM emp;

-- emp ���̺��� �μ���ȣ�� 10���� ����鸸 ��ȸ
SELECT *
FROM dept;

SELECT *
FROM emp
WHERE deptno = 10;
-- ����) emp ���̺��� 10�� �μ����� ������ ������ ����� ��ȸ
SELECT *
FROM emp
WHERE deptno != 10;
WHERE deptno ^= 10;
WHERE deptno <> 10;
-- ����Ŭ �� ������ AND, OR, NOT  - deptno = 20 OR deptno = 30
SELECT *
FROM emp
WHERE deptno IN ( 20, 30, 40 );  -- �Ʒ��� ���� ���� OR �����ڷ� ó��
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;

-- [����] emp ���̺��� ������� ford�� ����� ��� ��������� ���
SELECT *
FROM emp
WHERE ename = UPPER('ford');

SELECT LOWER(ename), INITCAP(job)
FROM emp;

-- [����] emp ���̺��� Ŀ�̼��� Null�� ����� ���� ���
SELECT *
FROM emp
WHERE comm IS NULL;
WHERE comm IS NOT NULL;

-- [����] 2000 �̻� ����(pay) 4000 ���� �޴� ���
SELECT e.*, sal + NVL(comm, 0) PAY
FROM emp e
WHERE sal + NVL(comm, 0) BETWEEN 2000 and 4000;
-- WITH [temp] AS ��������
WITH temp AS (
            SELECT e.*, sal + NVL(comm, 0) pay
            FROM emp e
            )
SELECT *
FROM temp
WHERE pay BETWEEN 2000 AND 4000;
-- �ζ��κ� (inline view) ���
--���������� FROM ���� ������ �̸� Inline view���ϰ�
--���������� WHERE ���� ������ �̸� ��øNested subquery�� �ϸ�
--Nested subquery�߿��� �����ϴ� ���̺��� parent, child���踦 ������ �̸� �����������correlated subquery�� �Ѵ�.
SELECT *
FROM(
    SELECT emp.*, sal + NVL(comm, 0) pay
    FROM emp
    ) e
WHERE pay BETWEEN 2000 AND 4000;

-- [����] insa ���̺��� 70������ ����� ������ ��ȸ
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
      -- EXTRACT() ����  - NUMBER Ÿ�� ����
      , EXTRACT(year FROM hiredate) YEAR
      , EXTRACT(month FROM hiredate) MONTH
      , EXTRACT(DAY FROM hiredate) DAY
FROM emp;

-- ���� ��¥���� �⵵/��/��/�ð�/��/�� ���
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'DL') 
    , TO_CHAR(SYSDATE, 'DS TS')
    , TO_CHAR(SYSDATE, 'TS')
    , TO_CHAR(SYSDATE, 'HH24:MI:SS')
    , CURRENT_TIMESTAMP
FROM emp;
-- REGEXP_LIKE �Լ�
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
WHERE name LIKE '%��';
WHERE name LIKE '%��%';
WHERE name LIKE '��%';

-- [����] insa ���̺��� �达 ���� ������ ��� ���  ���
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[^����ȫ]');
WHERE name NOT LIKE '��%';

-- [����]��ŵ��� ����, �λ�, �뱸 �̸鼭 ��ȭ��ȣ�� 5 �Ǵ� 7�� ���Ե� �ڷ� ����ϵ�
--      �μ����� ������ �δ� ��µ��� �ʵ�����. 
--      (�̸�, ��ŵ�, �μ���, ��ȭ��ȣ)
SELECT name, city, SUBSTR(buseo, 0, LENGTH(buseo)-1) BUSEO, tel
FROM insa
WHERE 
    city IN('����','�λ�','�뱸') 
    AND
    REGEXP_LIKE(tel, '[57]');
    --(tel LIKE '%5%' OR tel LIKE '%7%');

