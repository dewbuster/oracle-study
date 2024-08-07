-- HR
SELECT * FROM employees;

SELECT first_name
    , last_name
    , (first_name || ' ' || last_name) NAME
FROM employees
WHERE last_name IN ('McCain', 'McEwen', 'Mikkilineni', 'Mourgos', 'Nayer' );


SELECT *
FROM arirang;