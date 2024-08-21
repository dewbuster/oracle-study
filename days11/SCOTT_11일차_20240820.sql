DROP TABLE TBL_ANSWER;
DROP TABLE TBL_QUEST;
DROP TABLE TBL_USER;
DROP TABLE tbl_survey;



CREATE SEQUENCE seq_tblsurvey
NOCACHE;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� ���� ���̵���?','������','2023-05-01','2023-06-01',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '���̸�');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� �߻��� ���̵���?','������','2023-05-12','2023-06-12',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '������ȣ');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '�ְ�â��');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� �߻��� ����?','������','2024-07-28','2024-08-28',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '�����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '�̺���');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '���޼�');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 5, '������');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� ���� ����?','������','2024-08-19','2024-09-19',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
COMMIT;

SELECT * FROM TBL_quest;
select * FROM tbl_survey;

ALTER TABLE TBL_QUEST
RENAME COLUMN Q_COUNT TO Q_ITEM;

DELETE FROM tbl_survey
WHERE s_no = 1;

SELECT * from tbl_answer;

INSERT INTO tbl_user VALUES ( 'asd1', '123123', 'aaaa');
INSERT INTO tbl_user VALUES ( 'asd2', '123123', 'bsa');
INSERT INTO tbl_user VALUES ( 'asd3', '123123', 'asda');

-- 1�� ���� �׸�� 3��
INSERT INTO TBL_ANSWER VALUES(1 ,'asd1', 1, SYSDATE); 
INSERT INTO TBL_ANSWER VALUES(1 ,'asd2', 1, SYSDATE);
INSERT INTO TBL_ANSWER VALUES(1 ,'asd3', 3, SYSDATE);

