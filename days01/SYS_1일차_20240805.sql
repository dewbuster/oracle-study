-- ��� ����� ������ ��ȸ�ϴ� ����(����)
SELECT * 
FROM all_users;
--F5, Ctrl+Enter
-- SCOTT/tiger ���� ����
CREATE USER SCOTT IDENTIFIED BY tiger;
--
SELECT * 
FROM dba_users;
-- SYS�� CREATE SESSION ���� �ο�
-- GRANT CREATE SESSION TO SCOTT;
GRANT CONNECT, RESOURCE TO SCOTT;

SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;  -- ��( View )
FROM tabs;

--ORA-01922: CASCADE must be specified to drop 'SCOTT'
CREATE USER SCOTT IDENTIFIED BY tiger;

-- ��� ����� ���� ��ȸ
-- hr ���� Ȯ�� (���� ����)
select *
from all_users;
-- hr ������ ��й�ȣ lion ������ �� �� ����Ŭ ����(���)
ALTER USER hr IDENTIFIED BY lion;

ALTER USER hr ACCOUNT UNLOCK;

CREATE USER madang IDENTIFIED BY madang;
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO madang IDENTIFIED BY madang;