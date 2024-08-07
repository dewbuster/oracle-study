-- SYS
SELECT *
FROM dba_users;
-- SYS
SELECT *
FROM all_tables
WHERE owner = 'SCOTT';

SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE';