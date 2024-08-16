SELECT *
FROM departments d
WHERE EXISTS(
    SELECT *
    FROM employees e
    WHERE d.department_id = e.department_id
        AND e.salary > 2500
);