-- 모든 사용자 정보를 조회하는 질의(쿼리)
SELECT * 
FROM all_users;
--F5, Ctrl+Enter
-- SCOTT/tiger 계정 생성
CREATE USER SCOTT IDENTIFIED BY tiger;
--
SELECT * 
FROM dba_users;
-- SYS가 CREATE SESSION 권한 부여
-- GRANT CREATE SESSION TO SCOTT;
GRANT CONNECT, RESOURCE TO SCOTT;

SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;  -- 뷰( View )
FROM tabs;

--ORA-01922: CASCADE must be specified to drop 'SCOTT'
CREATE USER SCOTT IDENTIFIED BY tiger;

-- 모든 사용자 정보 조회
-- hr 계정 확인 (샘플 계정)
select *
from all_users;
-- hr 계정의 비밀번호 lion 수정을 한 후 오라클 접속(녹색)
ALTER USER hr IDENTIFIED BY lion;

ALTER USER hr ACCOUNT UNLOCK;

CREATE USER madang IDENTIFIED BY madang;
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO madang IDENTIFIED BY madang;