-- 프로그래머스 SQL 고득점 Kit

--SUM,MAX,MIN
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

-- GROUP BY
--고양이와 개는 몇 마리 있을까
SELECT ANIMAL_TYPE, COUNT(*) count
FROM ANIMAL_INS
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE;

--동명 동물 수 찾기
SELECT *
FROM
(
SELECT NAME, COUNT(NAME) COUNT
FROM ANIMAL_INS
GROUP BY NAME
ORDER BY NAME
) a
WHERE COUNT > 1;

--년, 월, 성별 별 상품 구매 회원 수 구하기
SELECT EXTRACT(year from TRUNC(sales_date, 'MM')) YEAR
    ,EXTRACT(month FROM TRUNC(sales_date, 'MM')) MONTH
    , GENDER
    ,COUNT(DISTINCT os.user_id) USERS
FROM user_info ui , online_sale os
WHERE ui.user_id = os.user_id AND gender IS NOT NULL
GROUP BY TRUNC(sales_date, 'MM'), GENDER
ORDER BY TRUNC(sales_date, 'MM'), GENDER
;

-- String, Date
-- 자동차 대여 기록 별 대여 금액 구하기
SELECT h.history_id
    , (h.end_date - h.start_date + 1) 
    * (c.daily_fee * (100 - CASE
                    WHEN (h.end_date - h.start_date + 1)  >= 90  
                    THEN(SELECT discount_rate
                            FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
                            WHERE car_type = '트럭' AND duration_type = '90일 이상')
                    WHEN (h.end_date - h.start_date + 1)  >= 30
                    THEN (SELECT discount_rate
                            FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
                            WHERE car_type = '트럭' AND duration_type = '30일 이상')
                    WHEN (h.end_date - h.start_date + 1)  >= 7
                    THEN (SELECT discount_rate
                            FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
                            WHERE car_type = '트럭' AND duration_type = '7일 이상')
                    ELSE 0
                    END
       )/100) FEE
FROM car_rental_company_rental_history h, car_rental_company_car c
WHERE h.car_id = c.car_id AND c.car_type ='트럭'
ORDER BY FEE DESC, history_id DESC;

-- SELECT 
-- 서울에 위치한 식당 목록 출력하기
SELECT i.rest_id, rest_name, food_type, favorites, address, r.score
FROM rest_info i,
(
    SELECT rest_id, ROUND(AVG(review_score),2) SCORE
    FROM rest_review
    GROUP BY rest_id 
) r
WHERE SUBSTR(i.address, 1, 2) = '서울' AND i.rest_id = r.rest_id
ORDER BY r.score DESC, favorites DESC;

--오프라인/온라인 판매 데이터 통합하기
SELECT TO_CHAR(sales_date, 'YYYY-MM-DD') SALES_DATE
    , product_id
    , user_id
    , sales_amount
FROM online_sale
WHERE TO_CHAR(sales_date, 'YYYY/MM') = '2022/03'
UNION
SELECT TO_CHAR(sales_date, 'YYYY-MM-DD') SALES_DATE
    , product_id
    , NULL
    , sales_amount
FROM offline_sale
WHERE TO_CHAR(sales_date, 'YYYY/MM') = '2022/03'
ORDER BY sales_date, product_id, user_id;

