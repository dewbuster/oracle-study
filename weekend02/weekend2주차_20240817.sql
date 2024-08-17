-- ���α׷��ӽ� SQL ����� Kit

--JOIN
--Ư�� �Ⱓ���� �뿩 ������ �ڵ������� �뿩��� ���ϱ�
SELECT car_id, c.car_type
    , (daily_fee * 30) * (100-discount_rate) / 100 FEE
FROM car_rental_company_car c JOIN car_rental_company_discount_plan p
ON c.car_type = p.car_type AND c.car_type IN ('����', 'SUV') AND p.duration_type = '30�� �̻�'
WHERE c.car_id NOT IN (
    SELECT car_id FROM car_rental_company_rental_history
    WHERE TO_CHAR(end_date, 'YYYY-MM-DD') > '2022-11-01'
)
AND (daily_fee * 30) * (100-discount_rate) / 100 BETWEEN 500000 AND 1999999
ORDER BY FEE DESC, c.car_type, car_id DESC;

-- ��ǰ�� ������ ȸ�� ���� ���ϱ�
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