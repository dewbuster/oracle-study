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

--5�� ��ǰ���� �Ѹ��� ��ȸ�ϱ�
SELECT p.PRODUCT_ID, p.PRODUCT_NAME, SUM(p.PRICE*o.AMOUNT) TOTAL_SALES
FROM FOOD_PRODUCT p JOIN FOOD_ORDER o ON p.PRODUCT_ID = o.PRODUCT_ID
WHERE TO_CHAR(PRODUCE_DATE, 'YYYY-MM') = '2022-05'
GROUP BY p.PRODUCT_ID, p.PRODUCT_NAME
ORDER BY TOTAL_SALES DESC, PRODUCT_ID ASC

--�ֹ����� ���� ���̽�ũ���� ��ȸ�ϱ�
SELECT
        FLAVOR
  FROM (
        SELECT 
                A.FLAVOR,
                SUM(A.TOTAL_ORDER + B.TOTAL_ORDER) AS TOTAL_ORDER
          FROM FIRST_HALF A,JULY B
         WHERE A.FLAVOR = B.FLAVOR         
       GROUP BY A.FLAVOR
       ORDER BY TOTAL_ORDER DESC
       )
 WHERE ROWNUM <= 3

--���ǿ� �´� ������ ���� ����Ʈ ����ϱ�
SELECT a.book_id, b.author_name,
    TO_CHAR(a.published_date,'YYYY-MM-DD')
FROM book a JOIN author b
    ON a.author_id = b.author_id
WHERE category = '����'
ORDER BY a.published_date ASC;

--�׷캰 ���ǿ� �´� �Ĵ� ��� ����ϱ�
select MEMBER_NAME,REVIEW_TEXT,to_char(REVIEW_DATE,'YYYY-mm-dd')as REVIEW_DATE
from MEMBER_PROFILE a join REST_REVIEW b on a.MEMBER_ID = b.MEMBER_ID
where b.MEMBER_ID in (select MEMBER_ID
from REST_REVIEW
group by MEMBER_ID
having count(MEMBER_ID) = (select max(count(MEMBER_ID)) from REST_REVIEW group by member_id ))
order by REVIEW_DATE,REVIEW_TEXT

--������ ��� ã��
SELECT O.ANIMAL_ID, O.NAME
FROM ANIMAL_OUTS O 
LEFT JOIN ANIMAL_INS I
ON O.ANIMAL_ID = I.ANIMAL_ID
WHERE I.ANIMAL_ID IS NULL
ORDER BY o.ANIMAL_ID;

--�־��µ��� �������ϴ�
SELECT I.ANIMAL_ID, I.NAME
FROM ANIMAL_INS I
JOIN ANIMAL_OUTS O
ON I.ANIMAL_ID = O.ANIMAL_ID
WHERE O.DATETIME < I.DATETIME
ORDER BY I.DATETIME;

--���� �Ⱓ ��ȣ�� ����(1)
SELECT NAME, DATETIME
FROM (
        SELECT 
        I.NAME
       ,I.DATETIME
       ,RANK() OVER (ORDER BY I.DATETIME) AS RANK
        FROM ANIMAL_INS I 
        LEFT JOIN ANIMAL_OUTS O
        ON I.ANIMAL_ID = O.ANIMAL_ID
        WHERE O.ANIMAL_ID IS NULL
) R
WHERE R.RANK <= 3
ORDER BY R.DATETIME;

--��ȣ�ҿ��� �߼�ȭ�� ����
SELECT b.ANIMAL_ID,b.ANIMAL_TYPE,b.NAME
from ANIMAL_INS a 
join ANIMAL_OUTS b 
on a.ANIMAL_ID = b.ANIMAL_ID and a.SEX_UPON_INTAKE != b.SEX_UPON_OUTCOME
order by b.ANIMAL_ID;

--��ǰ �� �������� ���� ���ϱ�
SELECT a.PRODUCT_CODE
    , SUM(PRICE * SALES_AMOUNT) sales
FROM PRODUCT a JOIN OFFLINE_SALE b
    ON a.PRODUCT_ID = b.PRODUCT_ID
GROUP BY a.PRODUCT_CODE
ORDER BY sales DESC
    , a.PRODUCT_CODE ASC;

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