SELECT *
FROM all_tables
WHERE table_name = 'DUAL';

SELECT *
FROM scott.emp;
-- FROM ��Ű��.emp

-- SYNONYM ARIRANG��(��) ����.
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;
-- SYNONYM ARIRANG��(��) ����.
DROP PUBLIC SYNONYM arirang;
-- SYNONYM ��ȸ
SELECT *
FROM all_synonyms
WHERE synonym_name = 'DUAL';
