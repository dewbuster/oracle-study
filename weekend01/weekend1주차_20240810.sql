-- ���α׷��ӽ� SQL ����� Kit

--SUM,MAX,MIN
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

-- GROUP BY
--����̿� ���� �� ���� ������
SELECT ANIMAL_TYPE, COUNT(*) count
FROM ANIMAL_INS
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE;

--���� ���� �� ã��
SELECT *
FROM
(
SELECT NAME, COUNT(NAME) COUNT
FROM ANIMAL_INS
GROUP BY NAME
ORDER BY NAME
) a
WHERE COUNT > 1;

--��, ��, ���� �� ��ǰ ���� ȸ�� �� ���ϱ�
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
-- �ڵ��� �뿩 ��� �� �뿩 �ݾ� ���ϱ�
SELECT h.history_id
    , (h.end_date - h.start_date + 1) 
    * (c.daily_fee * (100 - CASE
                    WHEN (h.end_date - h.start_date + 1)  >= 90  
                    THEN(SELECT discount_rate
                            FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
                            WHERE car_type = 'Ʈ��' AND duration_type = '90�� �̻�')
                    WHEN (h.end_date - h.start_date + 1)  >= 30
                    THEN (SELECT discount_rate
                            FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
                            WHERE car_type = 'Ʈ��' AND duration_type = '30�� �̻�')
                    WHEN (h.end_date - h.start_date + 1)  >= 7
                    THEN (SELECT discount_rate
                            FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
                            WHERE car_type = 'Ʈ��' AND duration_type = '7�� �̻�')
                    ELSE 0
                    END
       )/100) FEE
FROM car_rental_company_rental_history h, car_rental_company_car c
WHERE h.car_id = c.car_id AND c.car_type ='Ʈ��'
ORDER BY FEE DESC, history_id DESC;

-- SELECT 
-- ���￡ ��ġ�� �Ĵ� ��� ����ϱ�
SELECT i.rest_id, rest_name, food_type, favorites, address, r.score
FROM rest_info i,
(
    SELECT rest_id, ROUND(AVG(review_score),2) SCORE
    FROM rest_review
    GROUP BY rest_id 
) r
WHERE SUBSTR(i.address, 1, 2) = '����' AND i.rest_id = r.rest_id
ORDER BY r.score DESC, favorites DESC;

--��������/�¶��� �Ǹ� ������ �����ϱ�
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

