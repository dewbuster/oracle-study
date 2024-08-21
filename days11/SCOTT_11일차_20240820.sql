DROP TABLE TBL_ANSWER;
DROP TABLE TBL_QUEST;
DROP TABLE TBL_USER;
DROP TABLE tbl_survey;



CREATE SEQUENCE seq_tblsurvey
NOCACHE;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 예쁜 아이돌은?','관리자','2023-05-01','2023-06-01',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '슬기');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '예나');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '아이린');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 잘생긴 아이돌은?','관리자','2023-05-12','2023-06-12',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '차은우');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '육성재');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '유노윤호');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '최강창민');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 잘생긴 배우는?','관리자','2024-07-28','2024-08-28',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '김수현');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '이정재');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '이병헌');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '오달수');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 5, '마동석');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 예쁜 배우는?','관리자','2024-08-19','2024-09-19',sysdate);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '김태희');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '김지원');
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

-- 1번 설문 항목수 3개
INSERT INTO TBL_ANSWER VALUES(1 ,'asd1', 1, SYSDATE); 
INSERT INTO TBL_ANSWER VALUES(1 ,'asd2', 1, SYSDATE);
INSERT INTO TBL_ANSWER VALUES(1 ,'asd3', 3, SYSDATE);

