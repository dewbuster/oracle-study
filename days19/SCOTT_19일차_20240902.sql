SELECT * FROM user_indexes
WHERE table_name = 'EMP';

SELECT * FROM emp
WHERE SUBSTR(empno, 0, 2) = 76;   -- 0.011초 FULL SCAN
WHERE empno = 7369;       -- 0.005초 INDEX (UNIQUE SCAN)

WHERE deptno=30 AND sal > 1300;  -- 0.006초 FULL SCAN

CREATE INDEX DS_EMP ON emp(deptno,sal);  -- 0.009초 INDEX (RANGE SCAN) 
DROP INDEX DS_EMP;
WHERE deptno = 10;
WHERE empno > 7600;
WHERE ename = 'SMITH';
WHERE empno = 7369;

SELECT * FROM salgrade;

SELECT grade, e.deptno, dname, empno, ename, sal 
FROM emp e JOIN salgrade s ON sal BETWEEN losal AND hisal
           JOIN dept d ON e.deptno = d.deptno
;

SELECT grade, losal, hisal, COUNT(*) FROM emp e JOIN salgrade s ON sal BETWEEN losal AND hisal
GROUP BY grade, hisal, losal;

SELECT * FROM dept;

SELECT dname, count(empno)
FROM dept d FULL JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno
;

SELECT empno, ename, hiredate, sal+NVL(comm,0) pay
FROM emp
WHERE deptno = 10;

CREATE OR REPLACE PROCEDURE up_idcheck
(
    pid IN emp.empno%TYPE
    , pcheck OUT NUMBER -- 0 / 1
)
IS
BEGIN
    SELECT COUNT(*) INTO pcheck
    FROM emp
    WHERE empno = pid;
--EXCEPTION
--    WHEN OTHERS THEN
--        RAISE_
END;

DECLARE
    vcheck NUMBER(1);
BEGIN
    up_idcheck(9999, vcheck);
    DBMS_OUTPUT.PUT_LINE( vcheck );
END;
-- ID/PWD 인증처리하는 저장프로시저
CREATE OR REPLACE PROCEDURE up_login
(
    pid IN emp.empno%TYPE
    , ppwd IN emp.ename%TYPE
    , pcheck OUT NUMBER -- 0(인증성공), 1(ID 존재,PWD x), -1(ID존재x)
)
IS
    vpwd emp.ename%TYPE;
BEGIN
    SELECT COUNT(*) INTO pcheck
    FROM emp
    WHERE empno = pid;
    
    IF pcheck = 1 THEN
        SELECT ename INTO vpwd
        FROM emp
        WHERE empno = pid;
        
        IF vpwd = ppwd THEN
            pcheck := 0;
        ELSE
            pcheck := 1;
        END IF;
    ELSE
        pcheck := -1;
    END IF;
--EXCEPTION
--    WHEN OTHERS THEN
--        RAISE_
END;

DECLARE
    vcheck NUMBER;
BEGIN
    up_login(7369, 'SMITH', vcheck);
    DBMS_OUTPUT.PUT_LINE(vcheck);
END;

-- dept 테이블의 모든 부서 정보를 조회하는 저장프로시저
CREATE OR REPLACE PROCEDURE up_selectdept
(
    pdeptcursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pdeptcursor FOR 
    SELECT *
    FROM dept;
END;

INSERT INTO dept VALUES (50, null, null);
COMMIT;
CREATE OR REPLACE PROCEDURE UP_INSERTDEPT
(
    pdeptno dept.deptno%TYPE
    , pdname dept.dname%TYPE
    , ploc dept.loc%TYPE
)
IS
BEGIN
    INSERT INTO dept (deptno, dname, loc) VALUES (pdeptno, pdname, ploc);
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE up_deletedept
( 
     pdeptno IN dept.deptno%TYPE
)
IS   
BEGIN
    DELETE FROM  dept 
    WHERE deptno = pdeptno;
    COMMIT;
-- EXCEPTION    
END; 
--mssql
CREATE TABLE tbl_cstVSBoard (
  seq int identity (1, 1) not null primary key clustered,  --글번호
  writer varchar (20) not null ,   --작성자
  pwd varchar (20) not null ,      --비번
  email varchar (100) null ,        --이메일
  title varchar (200) not null ,    --제목
  writedate smalldatetime not null default (getdate()), --작성일
  readed int not null default (0),  --조회수
  mode tinyint not null ,   -- 글의 형식 TEXT 0, HTML태그허용 1
  content text null         -- 글의 내용
)
-- oracle
CREATE SEQUENCE seq_tblcstVSBoard
NOCACHE;
CREATE TABLE tbl_cstVSBoard (
  seq NUMBER NOT NULL PRIMARY KEY ,
  writer VARCHAR2(20) NOT NULL ,
  pwd VARCHAR2(20) NOT NULL ,
  email VARCHAR2(100),
  title VARCHAR2(200) NOT NULL ,
  writedate DATE DEFAULT SYSDATE,
  readed NUMBER DEFAULT 0,
  tag NUMBER(1) NOT NULL ,
  content CLOB
);

--
BEGIN
   FOR i IN 1..150 LOOP
       INSERT INTO tbl_cstVSBoard ( seq,  writer, pwd, email, title, tag,  content) 
       VALUES ( SEQ_TBLCSTVSBOARD.NEXTVAL, '홍길동' || MOD(i,10), '1234'
       , '홍길동' || MOD(i,10) || '@sist.co.kr', '더미...'  || i, 0, '더미...' || i );
   END LOOP;
   COMMIT;
END;

SELECT * 
FROM tbl_cstVSBoard;

BEGIN
    UPDATE tbl_cstVSBoard
    SET writer = '박준용'
    WHERE MOD(seq, 15) = 4;
    COMMIT;
END;

BEGIN
    UPDATE tbl_cstVSBoard
    SET title = '게시판 구현'
    WHERE MOD(seq, 15) IN (3, 5, 8);
    COMMIT;
END;

-- TOP-N 방식
SELECT *
FROM(
SELECT ROWNUM no, t.*
FROM (
SELECT seq, title, writer, email, writedate, readed
FROM tbl_cstVSBoard
ORDER BY seq DESC
) t
) b
WHERE no BETWEEN 1 AND 10;

UPDATE tbl_cstvsboard
SET title = 'updatetitle2', writer = '홍길순2'
WHERE seq = 149;