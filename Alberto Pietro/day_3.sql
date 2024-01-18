with prod_client_1 AS( SELECT
  m.customer_id AS customer_id,
  IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name,
  RANK() OVER (PARTITION BY m.customer_id ORDER BY s.order_date) AS earlier_order_date
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
LEFT JOIN menu p
ON s.product_id = p.product_id
GROUP BY m.customer_id,product_name,s.order_date
ORDER BY m.customer_id)

SELECT 
    customer_id,
    product_name
FROM 
    prod_client_1
WHERE earlier_order_date = 1;

----------------------------------------------------------OUTPUT-----------------------------

CUSTOMER_ID	PRODUCT_NAME
A	          sushi
A         	curry
B	          curry
C	          ramen
D	          NINGÙN PRODUCTO
