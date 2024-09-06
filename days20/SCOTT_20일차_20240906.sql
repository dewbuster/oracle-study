--mssql
CREATE TABLE tbl_cstVSBoard (
  seq int identity (1, 1) not null primary key clustered,  --�۹�ȣ
  writer varchar (20) not null ,   --�ۼ���
  pwd varchar (20) not null ,      --���
  email varchar (100) null ,        --�̸���
  title varchar (200) not null ,    --����
  writedate smalldatetime not null default (getdate()), --�ۼ���
  readed int not null default (0),  --��ȸ��
  mode tinyint not null ,   -- ���� ���� TEXT 0, HTML�±���� 1
  content text null         -- ���� ����
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
       VALUES ( SEQ_TBLCSTVSBOARD.NEXTVAL, 'ȫ�浿' || MOD(i,10), '1234'
       , 'ȫ�浿' || MOD(i,10) || '@sist.co.kr', '����...'  || i, 0, '����...' || i );
   END LOOP;
   COMMIT;
END;

SELECT * 
FROM tbl_cstVSBoard;

BEGIN
    UPDATE tbl_cstVSBoard
    SET writer = '���ؿ�'
    WHERE MOD(seq, 15) = 4;
    COMMIT;
END;

BEGIN
    UPDATE tbl_cstVSBoard
    SET title = '�Խ��� ����'
    WHERE MOD(seq, 15) IN (3, 5, 8);
    COMMIT;
END;

-- TOP-N ���
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
SET title = 'updatetitle2', writer = 'ȫ���2'
WHERE seq = 149;