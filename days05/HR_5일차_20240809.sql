SELECT last_name, RPAD(' ',salary/1000/1, '*') "Salary"
FROM employees
WHERE department_id = 80
ORDER BY last_name, "Salary";

SELECT last_name
--    ,salary
--    ,salary/1000
    ,ROUND(salary/1000)
    ,RPAD(' ', ROUND(salary/1000)+1, '*') "Salary"
FROM employees;

--
UPDATE employees
SET salary = salary * '100.00'
WHERE last_name = 'Perkins';
ROLLBACK;
SELECT *
FROM employees;