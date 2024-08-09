SELECT COUNT(DISTINCT job)
FROM emp;

SELECT *
FROM emp;

[����2] emp ���̺� �μ��� ��� �� ��ȸ
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT 10 "deptno", COUNT(*) �����
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
-- emp ���̺� �������� �ʴ� �μ��� ��ȸ
SELECT COUNT(*)
    ,COUNT(DECODE(deptno, 10, 1)) "10"
    ,COUNT(DECODE(deptno, 20, 1)) "20"
    ,COUNT(DECODE(deptno, 30, 1)) "30"
    ,COUNT(DECODE(deptno, 40, 1)) "40"
FROM emp;

-- [����] insa ���̺� �ѻ����, ���ڻ����, ���ڻ���� ��ȸ
SELECT *
FROM insa;
--DECODE
SELECT COUNT(*)
    ,COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2), 1, 1)) "����"
    ,COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2), 0, 1)) "����"
FROM insa;
--GROUP BY
SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2), 1, '����', 0,'����', '��ü') GENDER
    , COUNT(*) 
FROM insa
GROUP BY ROLLUP(SUBSTR(ssn,-7,1));

SELECT 
    CASE MOD(SUBSTR(ssn,-7,1),2)
        WHEN 1 THEN '����'
        WHEN 0 THEN '����'
        ELSE '��ü'
    END GENDER
    , COUNT(*)
FROM insa
GROUP BY ROLLUP(SUBSTR(ssn,-7,1));

-- [����] emp ���̺��� ���� �޿� ���� �޴� ���
SELECT MAX( sal + NVL(comm,0) ) 
FROM emp;
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MAX( sal + NVL(comm,0) ) FROM emp);

SELECT deptno, MAX(sal+NVL(comm,0))
FROM emp
GROUP BY deptno;

-- SQL ������ : ALL, SOME, ANY, EXISTS
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= ALL (SELECT sal + NVL(comm,0) FROM emp);
-- �޿� ���� ����
SELECT *
FROM emp
WHERE sal+NVL(comm,0) <= ALL (SELECT sal + NVL(comm,0) FROM emp);
--[����] emp ���̺��� �� �μ��� �ְ� �޿��� �޴� ��� ���
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

--[����] insa ���̺��� �μ��� �ο����� 10�� �̻��� �μ��� ��ȸ
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

-- [����] insa ���̺��� ���ڻ������ 5�� �̻��� �μ�

SELECT buseo, SUBSTR(ssn,-7,1), COUNT(*)
FROM insa
GROUP BY buseo, SUBSTR(ssn,-7,1)
ORDER BY buseo;

SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����')) "����"
FROM insa
GROUP BY buseo;

HAVING COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����')) >= 5;

SELECT buseo,COUNT(*)
FROM insa
GROUP BY buseo, SUBSTR(ssn,-7,1)
HAVING COUNT(NULLIF(MOD(SUBSTR(ssn,-7,1),2),1)) >= 5;

SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;

--[����] emp ���̺��� 
--      ��� ��ü ��ձ޿��� ����� �� �� ������� �޿��� ��ձ޿����� ���� ��� "����"
--                                                  ""      ���� ��� "����" ���
SELECT AVG( sal + NVL(comm, 0) )  avg_pay
FROM emp;
--
SELECT empno, ename, pay , ROUND( avg_pay, 2) avg_pay
     , CASE 
          WHEN pay > avg_pay   THEN '����'
          WHEN pay < avg_pay THEN '����'
          ELSE '����'
       END ee
FROM (
        SELECT emp.*
              , sal + NVL(comm,0) pay
              , (SELECT AVG( sal + NVL(comm, 0) )  FROM emp) avg_pay
        FROM emp
    ) e;


SELECT e.*
    ,CASE 
        WHEN sal+NVL(comm,0) <(SELECT AVG(sal+NVL(comm,0))FROM emp) THEN '����'
        ELSE '����'
    END p
FROM emp e;

--[emp ���̺��� �޿� ���� max, min ��� ���� ��ȸ
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

-- [����] insa ���� ��� �� �μ��� ����, ���� �����, �μ��� ���� �޿� ����, ���ڱ޿� ���� ��ȸ

SELECT *
FROM insa;
--
SELECT buseo
    , COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2),0,1)) ����
    , COUNT(DECODE(MOD(SUBSTR(ssn, -7, 1),2),1,1)) ����
    , COUNT(*) "�����"
    , SUM(DECODE(MOD(SUBSTR(ssn, -7, 1),2),0,basicpay)) "���ڱ޿�"
    , SUM(DECODE(MOD(SUBSTR(ssn, -7, 1),2),1,basicpay)) "���ڱ޿�"
FROM insa
WHERE city = '����'
GROUP BY buseo
ORDER BY buseo;
-- Ǯ��2
SELECT buseo
    , DECODE(MOD(SUBSTR(ssn, -7, 1),2), 0, '����', '����') GENDER
    , COUNT(*) �����
    , SUM(basicpay)
FROM insa
WHERE city = '����'
GROUP BY buseo, MOD(SUBSTR(ssn, -7, 1),2)
ORDER BY buseo, MOD(SUBSTR(ssn, -7, 1),2);

SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi);

-- ROWNUM �ǻ��÷�
DESC emp;
SELECT ROWNUM, ROWID, ename, hiredate, job
FROM emp;

SELECT ROWNUM, e.*
FROM (SELECT * FROM emp ORDER BY sal DESC) e
WHERE ROWNUM <= 3;
-- WHERE ROWNUM BETWEEN 3 AND 5; �߰� ���� ���ʹ� �ȵ� �Ϸ��� �ѹ��� �ζ��κ� �����
SELECT *
FROM (
        SELECT ROWNUM seq, e.*
        FROM (SELECT * FROM emp ORDER BY sal DESC) e
)
WHERE seq BETWEEN 3 AND 5;

--ORDER BY ���� �ִ� �������� ROWNUM ��� X ���� �Բ� ��� X
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC;

-- ROLLUP / CUBE
-- 1) ROLLUP : �׷�ȭ�ϰ� �׷쿡 ���� �κ���
SELECT d.dname, e.job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname,e.job)
ORDER BY d.dname;
--GROUP BY ROLLUP( d.dname, e.job);
--ORDER BY dname ASC;

--2) CUBE : ROLLUP ����� GROUP BY ���� ���ǿ� ���� ��� ������ �׷��� ���� ���
SELECT d.dname, e.job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY CUBE(d.dname,e.job)
ORDER BY d.dname;

-- ����(RANK) �Լ�
SELECT ename, sal, sal+NVL(comm,0) pay
    ,RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "RANK����"
    ,DENSE_RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "DENSE_RANK����"
    ,ROW_NUMBER() OVER(ORDER BY sal+NVL(comm,0) DESC) "ROW_NUMBER����"
FROM emp;

UPDATE emp
SET sal = 2850
WHERE empno = 7566;
COMMIT;

-- ���� �Լ� ����
-- emp ���̺��� �μ����� �޿� ���� �ű��
SELECT *
FROM (
        SELECT emp.*
            ,RANK()OVER(PARTITION BY deptno ORDER BY (sal+NVL(comm,0)) DESC) ����
            ,RANK()OVER(ORDER BY (sal+NVL(comm,0)) DESC) ��ü����
        FROM emp
)
WHERE ���� BETWEEN 1 AND 3;

-- insa ���̺� ����� 14�� ��
--SELECT CEIL(COUNT(*)/14)
SELECT *
FROM insa;
-- [����] insa ���̺��� ��� ���� ���� ���� �μ��� �μ���, ��� ���� ���
SELECT *
FROM(
    SELECT buseo, COUNT(*)
        , RANK() OVER(ORDER BY COUNT(*) DESC) �μ�����
    FROM insa 
    GROUP BY buseo
) e
WHERE ROWNUM =1;
WHERE �μ�����=1;

-- insa ���̺��� ���ڻ������ ���� ���� �μ� �� ��� �� ���
SELECT *
FROM(
    SELECT buseo
        , COUNT(*)
        , RANK() OVER(ORDER BY COUNT(*) DESC) �μ�����
    FROM insa 
    WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
    GROUP BY buseo
) a
WHERE �μ����� = 1;
--[����] insa ���̺��� basicpay(�⺻��)�� ���� 10%�� ���..(�̸�, �⺻��)

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