SELECT 
     members.customer_id
    ,COALESCE(SUM(menu.price),0) AS total_spend
FROM case01.sales
JOIN case01.menu
        ON sales.product_id = menu.product_id
FULL JOIN case01.members 
        ON sales.customer_id = members.customer_id
GROUP BY members.customer_id;