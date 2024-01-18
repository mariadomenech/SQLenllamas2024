SELECT
  IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name,
  COUNT(p.product_name) AS product_count
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
LEFT JOIN menu p
ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY product_count DESC
LIMIT 1;

--------------------------------------------------OUTPUT----------------------------------------------------------

PRODUCT_NAME	PRODUCT_COUNT
ramen	        8
