select *
from tabs;
-- ����Ŭ :'���ڿ�' '��¥'
SELECT first_name||' '||last_name AS "N A M E"
, CONCAT(CONCAT(first_name, ' '), last_name) AS NAME
, CONCAT(CONCAT(first_name, ' '), last_name) NAME
FROM employees;