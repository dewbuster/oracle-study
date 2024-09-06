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