---------------------------------------------------------------------------------DAY 1 SQL EN LLAMAS---------------------------------------------------------------------------------------------------------------
use database SQL_EN_LLAMAS;
use schema CASE01;

select * from members;
select * from sales;
select * from menu;

SELECT
  m.customer_id,
  SUM(IFNULL(p.price,0)) AS suma_gastos_cliente
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
LEFT JOIN menu p
ON s.product_id = p.product_id
GROUP BY m.customer_id
ORDER BY suma_gastos_cliente DESC;

-----------------------------------------------------------------------------------OUTPUT------------------------------------------------------------------------------------------------------------------------------
OUTPUT:
CUSTOMER_ID	SUMA_GASTOS_CLIENTE
A	76
B	74
C	36
D	0
