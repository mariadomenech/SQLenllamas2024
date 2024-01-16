SELECT mem.customer_id, COUNT(DISTINCT(sal.order_date))
    FROM sales sal
    JOIN members mem ON sal.customer_id = mem.customer_id
    GROUP BY mem.customer_id;