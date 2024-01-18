use database SQL_EN_LLAMAS;
use schema CASE01;

select * from members;
select * from sales;
select * from menu;

SELECT
  m.customer_id,
  COUNT(s.order_date,0) AS dias_visitados
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
GROUP BY m.customer_id
ORDER BY dias_visitados DESC;

------------------------------------------------------OUTPUT------------------------------

CUSTOMER_ID	DIAS_VISITADOS
A	6
B	6
C	3
D	0
