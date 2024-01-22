use database SQL_EN_LLAMAS;
use schema CASE01;

with PONTOS AS ( 
  SELECT
    m.customer_id AS customer_id,
    SUM(
            CASE
                WHEN p.product_name = 'sushi' 
                    THEN 2 * 10 * p.price
                ELSE 10 * p.price
            END
       )  AS prices
  FROM members m
    LEFT JOIN sales s
      ON m.customer_id = s.customer_id
    LEFT JOIN menu p
      ON s.product_id = p.product_id
  GROUP BY m.customer_id,s.order_date
  ORDER BY m.customer_id
)

SELECT 
    customer_id,
    IFNULL(SUM (prices),0) AS PONTOS
FROM 
    PONTOS
GROUP BY customer_id
;

---------------------------------OUTPUT--------------------------

CUSTOMER_ID	PONTOS
A	          860
B	          940
C	          360
D	          0
