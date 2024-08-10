-- 프로그래머스 SQL 고득점 Kit

--가장 비싼 상품 구하기
SELECT MAX(PRICE)
FROM PRODUCT;

--가격이 제일 비싼 식품의 정보 출력하기
SELECT *
FROM (
SELECT product_id, product_name, product_cd, category, price
FROM FOOD_PRODUCT
ORDER BY price DESC
    ) fp
WHERE ROWNUM =1;

--최댓값 구하기
SELECT MAX(datetime)
FROM ANIMAL_INS;

--최솟값 구하기
SELECT MIN(DATETIME)
FROM ANIMAL_INS;

--동물 수 구하기
SELECT COUNT(*)
FROM ANIMAL_INS;

--중복 제거하기
SELECT COUNT(DISTINCT name)
FROM ANIMAL_INS;