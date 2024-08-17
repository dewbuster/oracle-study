-- 프로그래머스 SQL 고득점 Kit

--JOIN
--특정 기간동안 대여 가능한 자동차들의 대여비용 구하기
SELECT car_id, c.car_type
    , (daily_fee * 30) * (100-discount_rate) / 100 FEE
FROM car_rental_company_car c JOIN car_rental_company_discount_plan p
ON c.car_type = p.car_type AND c.car_type IN ('세단', 'SUV') AND p.duration_type = '30일 이상'
WHERE c.car_id NOT IN (
    SELECT car_id FROM car_rental_company_rental_history
    WHERE TO_CHAR(end_date, 'YYYY-MM-DD') > '2022-11-01'
)
AND (daily_fee * 30) * (100-discount_rate) / 100 BETWEEN 500000 AND 1999999
ORDER BY FEE DESC, c.car_type, car_id DESC;

-- 상품을 구매한 회원 비율 구하기
SELECT EXTRACT(year from sales_date) YEAR
, EXTRACT(month from sales_date) MONTH
, COUNT( DISTINCT user_id) PURCHASED_USERS 
, ROUND(COUNT( DISTINCT user_id) / (SELECT COUNT(*) 
                         FROM user_info GROUP BY EXTRACT(year from joined) 
                         HAVING EXTRACT(year from joined) = '2021' ), 1) PUCHASED_RATIO
FROM online_sale
where user_id = ANY(SELECT USER_ID FROM USER_INFO WHERE TO_CHAR(JOINED, 'YYYY') = '2021')
GROUP BY EXTRACT(year from sales_date), EXTRACT(month from sales_date)
ORDER BY EXTRACT(year from sales_date), EXTRACT(month from sales_date);