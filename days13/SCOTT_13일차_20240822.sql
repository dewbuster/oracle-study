--------------Ŀ��(cursor)-------------
DECLARE
    TYPE EmpDeptType IS RECORD
    (
       deptno dept.deptno%TYPE,
       dname dept.dname%TYPE,
       empno emp.empno%TYPE,
       ename emp.ename%TYPE,
       pay   NUMBER
    );
    vedrow EmpDeptType;
    -- 1) Ŀ�� ����
    CURSOR vdecursor IS (
              SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
              FROM dept d JOIN emp e ON d.deptno = e.deptno  
              );
BEGIN
  -- 2) Ŀ�� OPEN == SELECT ���� ����.
  OPEN vdecursor;   -- CTRL + F11
  -- 3) FETCH == ��������
  LOOP
    FETCH vdecursor INTO vedrow;
    EXIT WHEN vdecursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( vedrow.deptno || ', ' || vedrow.dname 
    || ', ' ||  vedrow.empno  || ', ' || vedrow.ename  ||
    ', ' ||  vedrow.pay );
  END LOOP;
  -- 4) Ŀ�� CLOSE
  CLOSE vdecursor;
END;
--
DECLARE
BEGIN
    FOR vedrow IN (
              SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
              FROM dept d JOIN emp e ON d.deptno = e.deptno  
              ) LOOP
    DBMS_OUTPUT.PUT_LINE( vedrow.deptno || ', ' || vedrow.dname 
        || ', ' ||  vedrow.empno  || ', ' || vedrow.ename  ||
        ', ' ||  vedrow.pay );
    END LOOP;
END;
--
-- STORED PROCEDURE
CREATE OR REPLACE PROCEDURE pr
(
    �Ű�����( argument, parameter ) ����, -- Ÿ��O ũ��X
    p�Ű������� [mode] �ڷ���
                IN �Է¿� �Ķ���� (����Ʈ)
                OUT ��¿� �Ķ����
                IN OUT ����¿� �Ķ����
                
)
IS
    ���� ��� ����;
    v
BEGIN

--EXCEPTION
END;
--
--1) EXECUTE ������ ����
--2) �͸� ���ν������� ȣ���ؼ� ����
--3) �� �ٸ� ���� ���ν������� ȣ���ؼ� ����

--���������� ����ؼ� ���̺� ����
CREATE TABLE tbl_emp
AS
(
    SELECT *
    FROM emp
);

SELECT * FROM tbl_emp;
--tbl_emp ���̺��� �����ȣ�� �Է¹޾Ƽ� ����� �����ϴ� ���� -> ���� ���ν���
CREATE OR REPLACE PROCEDURE up_deltblemp
(
    -- pempno [IN]����Ʈ tblemp.empno%TYPE
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
    --ROLLBACK;
END;
--1) EXECUTE ������ ����
EXECUTE UP_DELTBLEMP(7566);
EXECUTE UP_DELTBLEMP(pempno=>7369);
SELECT * FROM tbl_emp;
--2) �͸� ���ν������� ȣ���ؼ� ����
--DECLARE
BEGIN
    UP_DELTBLEMP(7499);
--EXCEPTION
END;
--3) �� �ٸ� ���� ���ν������� ȣ���ؼ� ����
CREATE OR REPLACE PROCEDURE up_DELTBLEMP_test
(
    pempno IN tbl_emp.empno%TYPE
)
IS
BEGIN
    UP_DELTBLEMP(pempno);
--EXCEPTION
END;

EXECUTE up_DELTBLEMP_test(7521);
SELECT * FROM tbl_emp;
-- dept -> tbl_dept ���̺�
CREATE TABLE tbl_dept
AS
(
    SELECT * FROM dept
);

SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_D%';

ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);
-- [����] tbl_dept ���̺� SELECT��... DBMS_OUTPUT. ����ϴ� �������ν��� ����
--  up_seltbldept

-- ����� Ŀ�� LOOP FETCH
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
    drow tbl_dept%ROWTYPE;
    CURSOR dcursor IS ( SELECT * FROM tbl_dept );
BEGIN
OPEN dcursor;
    LOOP
        FETCH dcursor INTO drow;
        EXIT WHEN dcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( drow.deptno || ', ' || drow.dname || ', ' ||  drow.loc );
    END LOOP;
CLOSE dcursor;
--EXCEPTION
END;
EXECUTE up_seltbldept;

-- ����� Ŀ�� FOR
CREATE OR REPLACE PROCEDURE up_seltbldept_for
IS
    CURSOR dcursor IS ( SELECT * FROM tbl_dept );
BEGIN
    FOR drow IN dcursor LOOP
    DBMS_OUTPUT.PUT_LINE( drow.deptno || ', ' || drow.dname 
        || ', ' ||  drow.loc );
    END LOOP;
--EXCEPTION
END;
EXECUTE up_seltbldept_for;

-- ���ο� �μ� �߰��ϴ� ���� ���ν��� up_INStbldept
SELECT * FROM user_sequences;
CREATE SEQUENCE  seq_tbldept
INCREMENT BY 10 START WITH 50
NOCACHE  NOORDER  NOCYCLE ;
select * from tbl_dept;
-- dname, loc NULL ���
CREATE OR REPLACE PROCEDURE up_INStbldept
(
    pdname tbl_dept.dname%TYPE DEFAULT NULL
    ,ploc tbl_dept.loc%TYPE := NULL
)
IS
BEGIN
    INSERT INTO tbl_dept (deptno, dname, loc)
    VALUES ( seq_tbldept.NEXTVAL, pdname, ploc );
--EXCEPTION
END;

EXEC up_INStbldept;
select * from tbl_dept;
EXEC up_INStbldept('QC','SEOUL');
--EXEC up_INStbldept(pdname=>'QC',ploc=>'SEOUL');
--EXEC up_INStbldept(ploc=>'SEOUL');
-- �μ���ȣ �Է� �޾Ƽ� �����ϴ� up_deltbldept

CREATE OR REPLACE PROCEDURE up_deltbldept
(
    pdeptno tbl_dept.deptno%TYPE
)
IS
BEGIN
    DELETE FROM tbl_dept WHERE deptno = pdeptno;
END;

EXEC up_deltbldept(70);

EXEC up_updtbldept( 60, 'X', 'Y' );  -- dname, loc
EXEC up_updtbldept( pdeptno=>60,  pdname=>'QC3' );  -- loc
EXEC up_updtbldept( pdeptno=>60,  ploc=>'SEOUL' );  -- 

CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno tbl_dept.deptno%TYPE,
    pdname tbl_dept.dname%TYPE := NULL,
    ploc tbl_dept.loc%TYPE := NULL
)
IS
BEGIN
    UPDATE tbl_dept
    SET dname = NVL(pdname, dname), loc = NVL(ploc, loc)
    WHERE deptno = pdeptno;
--EXCEPTION
END;
SELECT * FROM tbl_dept;
EXEC up_updtbldept(60, 'QC', 'SO');
EXEC up_updtbldept(pdeptno=>60, ploc=>'SSO');
--
EXEC up_deltbldept(60);
DROP SEQUENCE seq_tbldept;
-- [����] Ŀ�� ��� ��� �μ����� ��ȸ
-- �μ���ȣ�� �Ķ���ͷ� �޾Ƽ� �ش� �μ����� ��ȸ
SELECT * FROM tbl_emp;
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
BEGIN
    FOR drow IN ( SELECT * FROM tbl_emp WHERE deptno = NVL(pdeptno,10))
    LOOP
        DBMS_OUTPUT.PUT_LINE( drow.empno || ', ' || drow.ename 
        || ', ' ||  drow.job || ', ' ||  drow.mgr || 
        ', ' ||  drow.hiredate || ', ' ||  drow.sal || ', ' 
        ||  drow.comm || ', ' ||  drow.deptno );
    END LOOP;
--EXCEPTION
END;
EXEC up_seltblemp(30);
-- ���� ���ν���
-- �Ķ���� IN ���, OUT ���, IN OUT ���
-- �����ȣ(IN) -> �����, �ֹι�ȣ ��¿� �Ű����� ���� ���ν��� ����
CREATE OR REPLACE PROCEDURE up_selinsa
(
    pnum IN insa.num%TYPE
    , pname OUT insa.name%TYPE
    , pssn OUT insa.ssn%TYPE
)
IS
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    SELECT name, ssn INTO vname, vssn
    FROM insa
    WHERE num = pnum;

    pname := vname;
    pssn := CONCAT(SUBSTR(vssn, 0, 8), '******');
--EXCEPTION
END;

DECLARE
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    up_selinsa(1001,vname,vssn); --  VARIABLE�� ����� ���� => :������
    DBMS_OUTPUT.PUT_LINE(vname || ' ' || vssn );
END;
-- IN/OUT ����¿� �Ķ����
-- �ֹε�Ϲ�ȣ(14)�� �Ķ���� IN
-- �������(�ֹι�ȣ6) �ڸ��� OUT
CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2
)
IS
BEGIN
    pssn := SUBSTR(pssn, 0, 6);
--EXCEPTION
END;

DECLARE
    vssn VARCHAR2(14) := '761230-1700001';
BEGIN
    UP_SSN(vssn);
    DBMS_OUTPUT.PUT_LINE(vssn);
END;
-- ���� �Լ� ex)�ֹε�Ϲ�ȣ -> ���� üũ
--              �����ڷ��� varchar2     ���ϰ� '����', '����'
CREATE OR REPLACE FUNCTION uf_gender
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2
IS
    vgender NVARCHAR2(2);
BEGIN
    IF MOD(SUBSTR(pssn,-7,1),2) = 1 THEN
        vgender := '����';
    ELSE
        vgender := '����';
    END IF;
    RETURN (vgender);
--EXCEPTION
END;
SELECT num, name, ssn, uf_gender(ssn) gender
    ,uf_age(ssn, 0) a_age
    ,uf_age(ssn, 1) c_age
FROM insa;

CREATE OR REPLACE FUNCTION uf_age
(
    pssn IN insa.ssn%TYPE
    , ptype IN NUMBER
)
RETURN NUMBER
IS
    vbirth NUMBER(4);
    vage NUMBER(3);
BEGIN
    IF SUBSTR(pssn, -7, 1) IN (1,2,5,6) THEN vbirth := 1900 + SUBSTR(pssn,0,2);
    ELSIF SUBSTR(pssn, -7, 1) IN (3,4,7,8) THEN vbirth := 2000 + SUBSTR(pssn,0,2);
    ELSE vbirth := 1800 + SUBSTR(pssn,0,2);
    END IF;
    
    IF  SIGN( TO_DATE(SUBSTR(pssn,3,4),'mmdd') - TRUNC( sysdate) ) = 0
    OR SIGN( TO_DATE(SUBSTR(pssn,3,4),'mmdd') - TRUNC( sysdate) ) = -1
    THEN vage :=  TO_CHAR(sysdate , 'yyyy') - vbirth -1;
    ELSE vage := TO_CHAR(sysdate , 'yyyy') - vbirth;
    END IF;
    
    RETURN(vage);
--EXCEPTION
END;

CREATE OR REPLACE FUNCTION uf_age
(
    pssn IN insa.ssn%TYPE
    , ptype IN NUMBER
)
RETURN NUMBER
IS
    �� NUMBER(4); --���س⵵
    �� NUMBER(4); --���ϳ⵵
    �� NUMBER(1); -- ������������
    vcounting_age NUMBER(3);
    vamerican_age NUMBER(3);
BEGIN
    �� := TO_CHAR(SYSDATE, 'YYYY');
    �� := CASE
            WHEN SUBSTR(pssn,-7,1) IN (1,2,5,6) THEN 1900
            WHEN SUBSTR(pssn,-7,1) IN (3,4,7,8) THEN 2000 
            ELSE 1800
          END + SUBSTR(pssn,0,2);
    �� := SIGN(TO_DATE(SUBSTR(pssn,3,4),'MMDD') - TRUNC( sysdate) );
    vcounting_age := �� - �� + 1;
    vamerican_age := vcounting_age -1 + CASE ��
                                            WHEN 1 THEN -1
                                            ELSE 0
                                        END;
    IF ptype =1 THEN
        RETURN vcounting_age;
    ELSE
        RETURN vamerican_age;
    END IF;
--EXCEPTION
END;
SELECT num, name, ssn, uf_gender(ssn) gender
    ,uf_age(ssn, 0) a_age
    ,uf_age(ssn, 1) c_age
FROM insa;
-- ��) �ֹε�Ϲ�ȣ -> "1998.01.20(ȭ)" ������ ���ڿ��� ��ȯ
--          uf_birth
CREATE OR REPLACE FUNCTION uf_birth
(
    pssn IN insa.ssn%TYPE
)
RETURN VARCHAR2
IS
    vbirth VARCHAR2(20);
BEGIN
    vbirth := CASE
            WHEN SUBSTR(pssn,-7,1) IN (1,2,5,6) THEN '19'
            WHEN SUBSTR(pssn,-7,1) IN (3,4,7,8) THEN '20'
            ELSE '18'
          END || SUBSTR(pssn,0,6);
    vbirth := TO_CHAR(TO_DATE(vbirth), 'YYYY.MM.DD(DY)');
    RETURN vbirth;
--EXCEPTION
END;

SELECT ssn, uf_birth(ssn) birth
FROM insa;
-----------------------------------------
CREATE TABLE tbl_score
(
     num   NUMBER(4) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)  
   , eng   NUMBER(3)
   , mat   NUMBER(3)  
   , tot   NUMBER(3)
   , avg   NUMBER(5,2)
   , rank  NUMBER(4) 
   , grade CHAR(1 CHAR)
);

CREATE SEQUENCE seq_tblscore;
--1) �л��� �߰��ϴ� ���� ���ν��� ����/�׽�Ʈ
EXEC up_INStblscore('ȫ�浿', 89,44,55 );
EXEC up_INStblscore('�����', 49,55,95 );
EXEC up_INStblscore('�赵��', 90,94,95 );

EXEC up_INStblscore('�̽���', 89,75,15 );
EXEC up_INStblscore('�ۼ�ȣ', 67,44,75 );
CREATE OR REPLACE PROCEDURE up_INStblscore
(
    pname tbl_score.name%TYPE
    , pkor tbl_score.kor%TYPE
    , peng tbl_score.eng%TYPE
    , pmat tbl_score.mat%TYPE
)
IS
    vtot NUMBER(3) := 0;
    vavg NUMBER(5,2);
    vgrade tbl_score.grade%TYPE;
BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot / 3;
    IF vavg >= 90 THEN
        vgrade := 'A';
    ELSIF vavg >= 80 THEN
        vgrade := 'B';
    ELSIF vavg >= 70 THEN
        vgrade := 'C';
    ELSIF vavg >= 60 THEN
        vgrade := 'D';
    ELSE
        vgrade := 'F';
    END IF;
    
    INSERT INTO tbl_score( num, name, kor, eng, mat, tot, avg, rank, grade)
    VALUES ( seq_tblscore.NEXTVAL, pname, pkor, peng, pmat, vtot, vavg, 1, vgrade);
    -- ��� ó���ϴ� UPDATE��
    UP_RANKSCORE;
    
    COMMIT;
--EXCEPTION
END;
SELECT * FROM tbl_score;
-- [Ʈ����~]
-- ����2) up_updateScore �������ν���
--EXEC up_updateScore( 1, 100, 100, 100 );
--EXEC up_updateScore( 1, pkor =>34 );
EXEC up_updateScore( 1, pkor =>55, pmat => 78 );
--EXEC up_updateScore( 1, peng =>45, pmat => 90 );
CREATE OR REPLACE PROCEDURE up_updateScore
(
    pnum tbl_score.num%TYPE
    , pkor tbl_score.kor%TYPE := NULL
    , peng tbl_score.eng%TYPE := NULL
    , pmat tbl_score.mat%TYPE := NULL
)
IS
BEGIN
    UPDATE tbl_score
    SET kor = NVL(pkor, kor), eng = NVL(peng, eng), mat = NVL(pmat, mat)
        , tot = NVL(pkor, kor) + NVL(peng, eng) + NVL(pmat, mat)
        , avg = (NVL(pkor, kor) + NVL(peng, eng) + NVL(pmat, mat)) / 3
    WHERE num = pnum;
    
    UPDATE tbl_score
    SET grade = CASE
                WHEN avg >= 90 THEN 'A'
                WHEN avg >= 80 THEN 'B'
                WHEN avg >= 70 THEN 'C'
                WHEN avg >= 60 THEN 'D'
                ELSE 'F'
                END
    WHERE num = pnum;
    
    UP_RANKSCORE;
    COMMIT;
--EXCEPTION
END;
-- [Ʈ����]
-- [����] tbl_score ���̺��� ��� �л��� ����� ó���ϴ� ���ν��� ����
-- up_rankScore
SELECT * FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_rankScore
IS
BEGIN
    UPDATE tbl_score p
    SET rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE p.tot < c.tot  );
    COMMIT;
--EXCEPTION
END;
--
EXEC UP_RANKSCORE;

-- up_deleteScore �л� 1�� �й����� ����
CREATE OR REPLACE PROCEDURE up_deleteScore
(
    pnum NUMBER
)
IS
BEGIN
    DELETE FROM tbl_score
    WHERE num = pnum;
    UP_RANKSCORE;
    COMMIT;
--EXCEPTION
END;

EXEC up_deleteScore(2);
SELECT * FROM tbl_score;

-- [����] up_selectScore ��� �л� ���� ��ȸ

CREATE OR REPLACE PROCEDURE up_selectScore
IS
BEGIN
    FOR drow IN ( SELECT * FROM tbl_score)
    LOOP
    DBMS_OUTPUT.PUT_LINE( drow.num || ', ' || drow.name 
        || ', ' ||  drow.kor || ', ' ||  drow.eng || 
        ', ' ||  drow.mat || ', ' ||  drow.tot || ', ' 
        ||  drow.avg || ', ' ||  drow.rank || ', ' ||  drow.grade );
    END LOOP;
--EXCEPTION
END;
EXEC up_selectScore;
-- [Ʈ����]
-- (�ϱ�, ���)
CREATE OR REPLACE PROCEDURE up_selectinsa
(
  -- Ŀ���� �Ķ���ͷ� ���� 
  pinsacursor  SYS_REFCURSOR  -- ����Ŭ 9i ����  REF CURSORS
)
IS 
   vname insa.name%TYPE;
   vcity insa.city%TYPE;
   vbasicpay insa.basicpay%TYPE;
BEGIN
  LOOP
    FETCH pinsacursor INTO vname, vcity, vbasicpay;
    EXIT WHEN pinsacursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(vname || ', ' || vcity || ', ' || vbasicpay);
  END LOOP;
  CLOSE pinsacursor;
--EXCEPTION
END;

CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
    vinsacursor SYS_REFCURSOR;
BEGIN
    OPEN vinsacursor FOR SELECT name, city, basicpay FROM insa;
    UP_SELECTINSA(vinsacursor);
END;
EXEC up_selectinsa_test;
EXEC up_selectinsa();

CREATE TABLE tbl_exam1
(
   id NUMBER PRIMARY KEY
   , name VARCHAR2(20)
);
CREATE TABLE tbl_exam2
(
   memo VARCHAR2(100)
   , ilja DATE DEFAULT SYSDATE
);

-- tbl_exam1 ���̺� INSERT, UPDATE, DELETE �̺�Ʈ�� �߻��ϸ�
-- �ڵ����� tbl_exam2 ���̺� tbl_exam1 ���̺��� �Ͼ �۾��� Ʈ���ŷ� �α� ���

CREATE OR REPLACE TRIGGER ut_log 
AFTER
INSERT OR DELETE OR UPDATE ON tbl_exam1
FOR EACH ROW
--DECLARE
BEGIN
    IF INSERTING THEN
        INSERT INTO tbl_exam2 (memo) VALUES(:NEW.name || ' �߰� �α� ���...');
    ELSIF DELETING THEN
        INSERT INTO tbl_exam2 (memo) VALUES(:OLD.name || ' ���� �α� ���...');
    ELSIF UPDATING THEN
        INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name||' -> '||:NEW.name);    
    END IF;
--EXCEPTION
END;

SELECT * FROM tbl_exam1;
SELECT * FROM tbl_exam2;

INSERT INTO tbl_exam1 VALUES(3, 'hssss');
DELETE FROM tbl_exam1
WHERE id = 1;
UPDATE tbl_exam1
SET name = 'admin'
WHERE id = 1;
ROLLBACK;
COMMIT;

-- tbl_exam1 ��� ���̺�� DML�� �ٹ��ð�(9~17��)�� �Ǵ� �ָ����� ó�� X
CREATE OR REPLACE TRIGGER ut_log_before
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1
-- FOR EACH ROW
--DECLARE
BEGIN
    IF TO_CHAR(SYSDATE, 'DY') IN ('��','��') 
        OR TO_CHAR(SYSDATE, 'HH24') NOT BETWEEN 9 AND 16  
    THEN
        RAISE_APPLICATION_ERROR(-20001, '�ٹ��ð��� �ƴϱ⿡ DML �۾�ó���� �� �� ����');
    END IF;
--EXCEPTION
END;

DROP TABLE tbl_emp;
DROP TABLE tbl_exam1;
DROP TABLE tbl_exam2;
DROP TABLE tbl_score;