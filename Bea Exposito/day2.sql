-- ¿Cuántos días ha visitado el restaurante cada cliente?
SELECT 
    members.customer_id
   ,COUNT(DISTINCT order_date) AS visited_days
FROM case01.sales
FULL JOIN case01.members
       ON sales.customer_id = members.customer_id       
GROUP BY members.customer_id;