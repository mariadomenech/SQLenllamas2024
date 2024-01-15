SELECT mem.customer_id, COALESCE(sum(men.price), 0)
    FROM members mem
        LEFT OUTER JOIN sales sal ON mem.customer_id = sal.customer_id
        LEFT OUTER JOIN menu men ON sal.product_id = men.product_id
    GROUP BY mem.customer_id;