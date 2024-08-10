-- ���α׷��ӽ� SQL ����� Kit

--���� ��� ��ǰ ���ϱ�
SELECT MAX(PRICE)
FROM PRODUCT;

--������ ���� ��� ��ǰ�� ���� ����ϱ�
SELECT *
FROM (
SELECT product_id, product_name, product_cd, category, price
FROM FOOD_PRODUCT
ORDER BY price DESC
    ) fp
WHERE ROWNUM =1;

--�ִ� ���ϱ�
SELECT MAX(datetime)
FROM ANIMAL_INS;

--�ּڰ� ���ϱ�
SELECT MIN(DATETIME)
FROM ANIMAL_INS;

--���� �� ���ϱ�
SELECT COUNT(*)
FROM ANIMAL_INS;

--�ߺ� �����ϱ�
SELECT COUNT(DISTINCT name)
FROM ANIMAL_INS;