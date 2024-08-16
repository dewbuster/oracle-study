SELECT * FROM tbl_bonus;
SELECT * FROM tbl_emp;

MERGE INTO tbl_emp e
USING ( SELECT id, bonus FROM tbl_bonus ) b
ON (e.id = b.id)
WHEN MATCHED THEN
UPDATE SET e.bonus = b.bonus
WHEN NOT MATCHED THEN
INSERT (e.id, e.name, e.bonus) VALUES (b.id, 'new' , b.bonus)
;
ROLLBACK;
-- ��������(Constraint)
SELECT *
FROM user_constraints -- ��(view)
WHERE table_name = 'EMP';

-- �������� ��� ����?
-- 1) ���������� data integrity(������ ���Ἲ)�� ���Ͽ� �ַ� ���̺� ��(row)�� �Է�, ����, ������ �� ����Ǵ� ��Ģ���� ���Ǹ� 
-- 2) ���̺� ���� �����ǰ� �ִ� ��� ���̺��� ���� ������ ���ؼ��� ���ȴ�. 

-- (����) ���Ἲ (integrity)
-- �������� ��Ȯ���� �ϰ����� �����ϰ�, �����Ϳ� ��հ� �������� ������ �����ϴ� ��

-- ���������� �����ϴ� ��� 
-- (1) ���̺��� ������ ���ÿ� ���������� ���� (2���� ���)
       -- IN-LINE �������� ���� ��� (�÷� ����)
--          ��) SEQ NUMBER PRIMARY KEY
--       -- OUT-OF-LINE �������� ���� ��� (���̺� ����)
--          CREATE TABLE XX
--          (
--            �÷�1 -- �÷����� (NOT NULL ���� ������ �÷������� ��������)
--           ,�÷�2
--           
--           ,�������� ���� -- ���̺� ���� (����Ű ����)
--           ,�������� ����
--           ,�������� ����
--           ,�������� ����
--          )
--          
--          ��) ����Ű ���� ����?
--          [����� �޿� ���� ���̺�]
--          PK (�޿����޳�¥ + �����ȣ) ����Ű        [������ȭ]
--����       �޿����޳�¥ �����ȣ �޿���
--1         2024.7.15  1111   3,000,000
--2         2024.7.15  1112   3,000,000
--3         2024.7.15  1113   3,000,000
--          :
--4         2024.8.15  1111   3,000,000
--          2024.8.15  1112   3,000,000
--          2024.8.15  1113   3,000,000

-- �÷� ���� ��� ��������
DROP TABLE tbl_constraint1;
DROP TABLE tbl_emp;
CREATE TABLE tbl_constraint1
(
    --empno NUMBER(4) NOT NULL PRIMARY KEY
    empno NUMBER(4) NOT NULL CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) CONSTRAINT fk_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT uk_tblconstraint1_email UNIQUE
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK( city IN ('����','�λ�','�뱸') )
);

SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_C%';
-- ck_tblconstraint1_city üũ�������� ��Ȱ��ȭ disable/enable
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT ck_tblconstraint1_city [CASCADE]; -- ��Ȱ��ȭ
ENABLE CONSTRAINT ck_tblconstraint1_city; -- Ȱ��ȭ

-- ���̺� ���� ��� ���� ���� ����
CREATE TABLE tbl_constraint1
(
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) 
    , email VARCHAR2(150) 
    , kor NUMBER(3) 
    , city VARCHAR2(20) 
    
    , CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY(empno)  --(empno, ename) ����Ű
    , CONSTRAINT fk_tblconstraint1_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT uk_tblconstraint1_email UNIQUE(email)
    , CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)
    , CONSTRAINT ck_tblconstraint1_city CHECK( city IN ('����','�λ�','�뱸') )  
);
-- 1) PK �������� ����
ALTER TABLE tbl_constraint1
--DROP PRIMARY KEY
DROP CONSTRAINT PK_TBLCONSTRAINT1_EMPNO;
-- 2) CHECK �������� ����
ALTER TABLE tbl_constraint1
-- DROP CHECK(kor) X �Ұ�
DROP CONSTRAINT CK_TBLCONSTRAINT1_KOR;
-- UNIQUE ����
ALTER TABLE tbl_constraint1
DROP UNIQUE(email);
--DROP CONSTRAINT UK_TBLCONSTRAINT1_EMAIL;

-- ���� ���̺� �������� �߰�
-- ALTER TABLE ... ADD [CONSTRAINT �������Ǹ�] ��������Ÿ��(�÷���); 
-- NOT NULL �� ALTER TABLE ... MODIFY 
DROP TABLE tbl_constraint3;
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);
--
1) empno �÷��� PK �������� �߰�.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT pk_tblconstraint3_empno PRIMARY KEY(empno);
2) deptno �÷��� FK �������� �߰�.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT fk_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);

-- FOREIGN KEY [ON DELETE CASCADE | ON DELETE SET NULL]
DELETE FROM dept
WHERE deptno = 10;

SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_%';
-- emp -> tbl_emp ����
-- dept -> tbl_dept����
CREATE TABLE tbl_emp
AS (SELECT * FROM emp);
CREATE TABLE tbl_dept
AS (SELECT * FROM dept);
-- tbl_dept
ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);

ALTER TABLE tbl_emp
ADD CONSTRAINT pk_tblemp_empno PRIMARY KEY(empno);
-- FK
ALTER TABLE tbl_emp
DROP CONSTRAINT FK_TBLEMP_DEPTNO;

ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tblemp_deptno FOREIGN KEY(deptno) 
                REFERENCES tbl_dept(deptno)
                ON DELETE SET NULL;
                --ON DELETE CASCADE;
SELECT *
FROM tbl_dept;
SELECT *
FROM tbl_emp;

DELETE FROM tbl_dept
WHERE deptno = 30;


-- JOIN(����) --
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title      VARCHAR2(100) NOT NULL  -- å ����
      ,c_name  VARCHAR2(100)    NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;

-- �ܰ����̺�( å�� ���� )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (�ĺ����� ***)
      ,price  NUMBER(7) NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA��(��) �����Ǿ����ϴ�.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- å�� ���� �������̺�
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;

-- ��            
-- �Ǹ�            ���ǻ� <-> ����
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- �Ǹ�
CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;
-- [����] åID, å����, ���ǻ�(c_name), �ܰ�  �÷� ���....
-- ��.
SELECT b.*, price
FROM book b, danga d
WHERE b.b_id = d.b_id;
-- ��.
SELECT b.*, price
FROM book b JOIN danga d ON b.b_id = d.b_id;
-- ��. USING �� ( ��ü��. ��Ī��. ���X)
SELECT b_id, title, c_name, price
FROM book JOIN danga USING(b_id);
-- ��. NATURAL JOIN 
SELECT b_id, title, c_name, price
FROM book NATURAL JOIN danga;
-- [����]  åID, å����, �Ǹż���, �ܰ�, ������, �Ǹűݾ�(=�Ǹż���*�ܰ�) ���

SELECT b.b_id, title, p_su, price, g.g_name, price * p_su �Ǹűݾ�
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id
ORDER BY 1;

SELECT b.b_id, title, p_su, price, g.g_name, price * p_su �Ǹűݾ�
FROM book b JOIN danga d ON b.b_id = d.b_id 
            JOIN panmai p ON b.b_id = p.b_id 
            JOIN gogaek g ON p.g_id = g.g_id
ORDER BY 1;
-- NON EQUI JOIN

SELECT * FROM emp;

UPDATE emp
SET deptno = NULL
WHERE ename = UPPER('king');
COMMIT;
-- JOIN ��� emp ���̺��� ��� ������ dept ���̺�� JOIN�ؼ�
-- dname, ename, hiredate �÷� ���
SELECT dname, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno(+) = e.deptno;

SELECT d.deptno, dname, COUNT(empno)
FROM emp e, dept d
WHERE e.deptno (+) = d.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno, dname;

SELECT *
FROM emp;

SELECT a.empno, a.ename, a.hiredate, b.ename ���
FROM emp a, emp b
WHERE a.mgr = b.empno;

-- ����) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ     
--      (    åID, å����, ���ǸűǼ�, �ܰ� �÷� ���   )

PANMAI BOOK DANGA

SELECT p.b_id, title, SUM(p_su) ���ǸűǼ�, price
FROM panmai p 
    JOIN book b ON p.b_id = b.b_id
    JOIN danga d ON b.b_id = d.b_id
GROUP BY p.b_id, title, price;

SELECT *
FROM
(
SELECT p.b_id, title, SUM(p_su) ���ǸűǼ�, price
FROM panmai p 
    JOIN book b ON p.b_id = b.b_id
    JOIN danga d ON b.b_id = d.b_id
GROUP BY p.b_id, title, price
ORDER BY ���ǸűǼ� DESC
)
WHERE ROWNUM = 1;
--
-- 2) ���� �Լ� 
WITH t 
AS (
    SeLECT  b.b_id, title, SUM(p_su) ���ǸűǼ�, price
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY      b.b_id , title, price
), s AS (
  SELECT t.*
     , RANK() OVER(ORDER BY ���ǸűǼ� DESC) �Ǹż���
   FROM t
)
SELECT s.*
FROM s
WHERE s.�Ǹż��� = 1;-- 2) ���� �Լ� 
WITH t 
AS (
    SeLECT  b.b_id, title, SUM(p_su) ���ǸűǼ�, price
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY      b.b_id , title, price
), s AS (
  SELECT t.*
     , RANK() OVER(ORDER BY ���ǸűǼ� DESC) �Ǹż���
   FROM t
)
SELECT s.*
FROM s
WHERE s.�Ǹż��� = 1;
-- 3)
SELECT *
FROM(
SeLECT  b.b_id, title, SUM(p_su) ���ǸűǼ�, price
    , RANK()OVER(ORDER BY SUM(p_su) DESC) �Ǹż���
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY      b.b_id , title, price
) t
WHERE t.�Ǹż��� =1;

-- ���� �ǸűǼ��� ���� ���� å ���� ��ȸ
SELECT *
FROM(
SeLECT  b.b_id, title, SUM(p_su) ���ǸűǼ�, price
    , RANK()OVER(ORDER BY SUM(p_su) DESC) �Ǹż���
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d  ON b.b_id = d.b_id
    GROUP BY b.b_id , title, price, TO_CHAR(p.P_DATE, 'yyyy')
    HAVING TO_CHAR(p.P_DATE, 'yyyy') = '2024'
) t
WHERE t.�Ǹż��� =1;

SELECT *
FROM book;

SELECT b.b_id, title, price
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
        JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NULL
;
SELECT b.*, d.price
FROM book b JOIN danga d ON b.b_id = d.b_id 
WHERE b.b_id = ANY(SELECT DISTINCT b_id FROM panmai);
-- ����) ���� �Ǹ� �ݾ� ��� (���ڵ�, ����, �Ǹűݾ�)


SELECT g.g_id, g_name, SUM(p_su)
FROM panmai p, gogaek g, danga d
WHERE p.g_id = g.g_id AND p.b_id = d.b_id 
GROUP BY g.g_id, g_name;

SELECT p.b_id, SUM(p_su)
FROM panmai p JOIN danga d ON p.b_id = d.b_id 
GROUP BY p.b_id;

SELECT g.g_id, g_name, SUM(p_su * price) �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
        JOIN gogaek g ON p.g_id = g.g_id
GROUP BY g.g_id, g_name;

-- �⵵ ���� �Ǹ�
SELECT EXTRACT(year from p_date)�⵵, EXTRACT(month from p_date)��, SUM(p_su * price) �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
GROUP BY EXTRACT(year from p_date), EXTRACT(month from p_date)
ORDER BY EXTRACT(year from p_date), EXTRACT(month from p_date);

-- ������ �⵵�� �Ǹ���Ȳ
SELECT EXTRACT(year from p_date)�⵵, g_name, SUM(P_SU)�Ǹż���
FROM panmai p, gogaek g WHERE p.g_id = g.g_id
GROUP BY EXTRACT(year from p_date), p.g_id, g_name
ORDER BY EXTRACT(year from p_date), p.g_id, g_name; 

-- å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )

SELECT p.b_id, b.title, price, SUM(p_su)���ǸűǼ�, SUM(p_su) * price �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
    JOIN book b ON b.b_id = p.b_id
GROUP BY p.b_id, price, b.title
HAVING SUM(p_su) * price >= 15000;