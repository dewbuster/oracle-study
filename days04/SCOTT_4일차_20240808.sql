-- [����Ŭ ������(operator) ����]
--1) �񱳿�����
--2) ��������
--3) SQL ������
--4) NULL ������
--5) ��� ������ : ����, ����, ����, ������  (�켱 ����) 
--      �� ������ ������ -> �Լ� : MOD(), REMAINDER()
--      �� �� : ���� �Լ� : FLOOR()
--6) SET(����) ������
--��) UNION    : ������
--��) UNION ALL: ������
--ORA-00937: not a single-group group function
SELECT name, city, buseo
FROM insa i
WHERE buseo = '���ߺ�';

SELECT COUNT(*)  -- 9��
FROM (
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
) i;
--
SELECT name, city, buseo    -- 6��
FROM insa
WHERE city = '��õ' AND buseo = '���ߺ�';
-- ���ߺ� + ��õ  ������� ������ UNION 17�� UNION ALL 23��
-- 14 + 9 = 23 �ߺ� ����
-- �÷��� ���� ���ƾ� �Ѵ�. 
-- �÷��� Ÿ�� ���ƾ� �Ѵ�. 
-- �÷��̸��� �޶� �������. 
-- ù��° select�� �÷��̸� ������.

SELECT name, city, buseo
FROM insa i
WHERE buseo = '���ߺ�'
 -- ORA-00933: SQL command not properly ended
--UNION
UNION ALL
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
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

--��) INTERSECT: ������
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
ORDER BY buseo;

--��) MINUS    : ������
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
ORDER BY buseo;

-- ������Ʈ --
SELECT name, NULL city, buseo
FROM insa i
WHERE buseo = '���ߺ�'
UNION
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
ORDER BY buseo;

-- [������ ���� ������] PRIOR, CONNECT_BY_ROOT ������
-- IS [NOT] NAN  = Not A Number
-- IS [NOT] INFINITE

-- [����Ŭ �Լ�(function)]
-- 1) ������ �Լ�
--    ��. ���� �Լ�
-- [UPPER][LOWER][INITCAP]
-- [LENGTH] ���ڿ� ����
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
    ,INSTR(dname, 'S', 2) -- 2��°���� ã��
    ,INSTR(dname, 'S', -1) -- �ڿ������� ã��
    ,INSTR(dname, 'S', -1, 2) -- �ڿ������� ã�Ƽ� 2��° ��
FROM dept;

SELECT *
FROM tbl_tel;
-- ���� 1) ������ȣ�� �����ؼ� ���
SELECT tel
    ,INSTR(tel, ')')��
    ,INSTR(tel, '-')��
    ,SUBSTR(tel, 0, INSTR(tel, ')')-1)��
    ,SUBSTR(tel, INSTR(tel, ')')+1, INSTR(tel, '-')-INSTR(tel, ')')-1 )��
    ,SUBSTR(tel, INSTR(tel, '-')+1)��
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

--[GREATEST/LEAST] ������ ���� �Ǵ� ���� �߿� ���� ū, �������� ��ȯ�ϴ� �Լ�
SELECT GREATEST(3,5,2,4,1) max
    ,LEAST(3,5,2,4,1) min
    ,GREATEST('R','A','Z','X') max
    ,LEAST('R','A','Z','X') min
FROM dual;

--[VSIZE]
SELECT VSIZE(1), VSIZE('A'), VSIZE('��')
FROM dual;
--    ��. ���� �Լ�
--    [ROUND(a[,b���,����])] - �ݿø��Լ�
SELECT 3.141592
    ,ROUND(3.141592)��
    ,ROUND(3.141592, 0)��       -- b+1 �ڸ����� �ݿø�
    ,ROUND(3.141592, 3)��
    ,ROUND(12345.6789, -2)��    -- ������ �Ҽ��� ���� b �ڸ�
FROM dual;
-- [�����Լ� TRUNC(), FLOOR() ������]
SELECT FLOOR(3.141592)
    , FLOOR(3.9)
    , TRUNC(3.141592, 3)
    , TRUNC(123.192, -1)
FROM dual;
-- [�ø�(����)�Լ� CEIL()]
SELECT CEIL(3.14)
    ,CEIL(3.94)
    ,CEIL(161/10)��   -- �Խ��� �� ������ �� ��� CEIL
    ,ABS(10), ABS(-10)��    -- ���밪
FROM dual;
--- SIGN
SELECT SIGN(100)    -- 1
    ,SIGN(0)        -- 0 
    ,SIGN(-111)     -- -1
FROM dual;
--
SELECT POWER(2,3)   --2��3��
    , SQRT(16)       --16��������
FROM dual;
--    ��. ��¥ �Լ� SYSDATE/ROUND,TRUNC(��¥)
SELECT SYSDATE s  -- ���� ��¥ �ð�(��)
    ,ROUND(SYSDATE)r --������ �������� ��¥ �ݿø�
    ,ROUND(SYSDATE, 'DD') --������ �������� ��¥ �ݿø�
    ,ROUND(SYSDATE, 'MONTH') a  -- 15�� ����
    ,ROUND(SYSDATE, 'YEAR') b -- 
FROM dual;

SELECT SYSDATE s
--    ,TO_CHAR(SYSDATE, 'DS TS')a
--    ,TRUNC(SYSDATE)b    --�ð�, ��,�� ����
--    ,TO_CHAR(TRUNC(SYSDATE), 'DS TS')c
--    ,TRUNC(SYSDATE, 'DD')d --�ð�, ��,�� ����
--    ,TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS')e
    ,TRUNC(SYSDATE, 'MONTH') m
    ,TO_CHAR(TRUNC(SYSDATE, 'MONTH'), 'DS TS') m
    ,TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS') y
FROM dual;

-- ��¥�� ��������� ����ϴ� ���...
SELECT SYSDATE
    ,SYSDATE + 7    -- + 7��
    ,SYSDATE + 2/24 -- + 2�ð�
    -- ,SYSDATE - ��¥ = �� ��¥ ������ �ϼ�(����)
FROM dual;
-- ȸ�� �Ի��� ������ ��������?
SELECT ename, hiredate
    ,CEIL(SYSDATE - hiredate) �ٹ��ϼ�
FROM emp;
-- ����) �츮�� �����Ϸ� ���� ���� ������ �����°�?
SELECT CEIL(SYSDATE - TO_DATE('2024/07/01')) D
FROM dual;

SELECT ename, hiredate, SYSDATE
    ,CEIL(MONTHS_BETWEEN(SYSDATE, hiredate)) �ٹ�������
    ,CEIL(MONTHS_BETWEEN(SYSDATE, hiredate)/12) �ٹ����
FROM emp;

SELECT SYSDATE
    ,ADD_MONTHS(SYSDATE, 1)m  -- 1�� ����
    ,ADD_MONTHS(SYSDATE, -1)m  -- 1�� ����
    ,ADD_MONTHS(SYSDATE, 1*12)y -- 1�� ����
    ,ADD_MONTHS(SYSDATE, -1*12)y -- 1�� ����
FROM dual;

SELECT SYSDATE s
--    ,LAST_DAY(SYSDATE)
--    ,EXTRACT(DAY from LAST_DAY(SYSDATE)) lastday
--    ,TRUNC(SYSDATE, 'MM') t -- 1�� �����
    ,TO_CHAR(TRUNC(SYSDATE, 'MM'), 'DY') dy
    ,ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1) -1 "last"  -- = LAST_DAY()
FROM dual;

SELECT SYSDATE
    ,NEXT_DAY(SYSDATE, '��')
FROM dual;

-- ����) 10�� ù��° �����ϳ� �ް�..
SELECT NEXT_DAY( TRUNC( ADD_MONTHS(SYSDATE, 2), 'MM'), '��') m
FROM dual;
SELECT NEXT_DAY(TO_DATE('2024/10/01'), '��') m
FROM dual;

SELECT CURRENT_DATE c     -- *����*�� ��¥�ð�����
FROM dual;
--    ��. ��ȯ �Լ�
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
    , TO_CHAR((sal+NVL(comm, 0)) * 12, 'L9,999,999') ����
FROM emp;

-- TO_CHAR ���� �ȿ� text ���� �� "" ���
SELECT name, ibsadate
    ,TO_CHAR(ibsadate, 'YYYY"��"MM"��"DD"��" DAY') dd  
    ,TO_CHAR(ibsadate, 'DL') dl
FROM insa;
--    ��. �Ϲ� �Լ�
SELECT ename
    ,sal + NVL(comm,0) pay
    ,sal + NVL2(comm, comm, 0) pay
    ,COALESCE(sal+comm, sal, 0) �� -- sal+comm�� null�̸� sal��ȯ, sal�� null�̸� 0��ȯ
FROM emp;

-- DECODE �Լ�    ****�߿�****
--  �� ���α׷��� ����� if ���� sql, pl/sql ������ ������� ���ؼ� ������� ����Ŭ �Լ�
--  �� FROM ���� ��� ��� ����
--  �� �� ������ = �� ����
--  �� DECODE �Լ��� Ȯ�� �Լ� : CASE �Լ�
if (A = B) {
    return C  
} else {
    return D
}
==> DECODE(A,B,C,D)

if (A = B) {
    return  ��;
} else if(A = C){
    return ��;
} else if (A = D){
    return ��;
} else if (A = E){
    return ��;
} else {
    return ��;
}
==> DECODE(A, B, ��, C, ��, D, ��, E, ��, ��);

SELECT name, ssn
--    ,NVL2(NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1 ),'����','����')GENDER
    ,DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 0, '����', '����') GENDER
FROM insa;

-- CASE �Լ�      ****�߿�****
-- ����) emp ���̺��� sal�� 10%�� �λ�
SELECT *
FROM emp;

-- ����) emp ���̺��� 10���μ� 15% pay�λ�, 20�� �μ� 10%, �� �� 20%
SELECT ename, sal, comm, deptno
    ,sal + NVL(comm, 0) pay
    , (sal + NVL(comm, 0)) * DECODE(deptno, 10, 1.15, 20, 1.1, 1.2) "�λ�"
FROM emp;

SELECT name, ssn
 --   ,DECODE(MOD(SUBSTR(ssn, -7, 1), 2), 0, '����', '����') GENDER
    ,CASE MOD(SUBSTR(ssn, -7, 1), 2) 
        WHEN 1 THEN '����'
        ELSE '����'
    END GENDER
FROM insa;

SELECT ename, sal, comm, deptno
    ,sal + NVL(comm, 0) pay
    , (sal + NVL(comm, 0)) * DECODE(deptno, 10, 1.15, 20, 1.1, 1.2) "�λ�DECODE"
    ,(sal + NVL(comm, 0)) * CASE deptno
                            WHEN 10 THEN 1.15
                            WHEN 20 THEN 1.1
                            ELSE 1.2
                            END "�λ�CASE"
FROM emp;

-- 2) ������ �Լ� (�׷� �Լ�)
SELECT COUNT(*)
    ,SUM(sal) s
--    ,SUM(comm)/COUNT(*) c   -- �̷��� ����ϸ� null���� ī����
    ,AVG(comm) a     -- null �� ���� ���
    ,MAX(sal)
    ,MIN(sal)
FROM emp;
SELECT *
FROM emp;
-- �� ����� ��ȸ
-- �� �μ��� ��� �� ��ȸ

SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;