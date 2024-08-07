SELECT *
FROM all_tables
WHERE table_name = 'DUAL';

SELECT *
FROM scott.emp;
-- FROM 스키마.emp

-- SYNONYM ARIRANG이(가) 생성.
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;
-- SYNONYM ARIRANG이(가) 삭제.
DROP PUBLIC SYNONYM arirang;
-- SYNONYM 조회
SELECT *
FROM all_synonyms
WHERE synonym_name = 'DUAL';
