SELECT mem.customer_id, COUNT(DISTINCT(sal.order_date))
    FROM members mem
    LEFT OUTER JOIN sales sal ON mem.customer_id = sal.customer_id
    GROUP BY mem.customer_id;