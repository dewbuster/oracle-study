-- SESSION B
SELECT * FROM tbl_dept;
--
UPDATE tbl_dept
SET loc = 'COREA'
WHERE deptno = 40;
COMMIT;