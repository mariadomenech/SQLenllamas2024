
WITH t_puntos AS (
SELECT a.customer_id,
        b.product_id,
        b.product_name,
        b.price,
        CASE
            WHEN b.product_id = 1 THEN sum((b.price*10)*2)
            ELSE sum (b.price * 10) 
            END AS puntos
    FROM SQL_EN_LLAMAS.CASE01.MEMBERS a
        LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES c
            ON a.customer_id=c.customer_id
        LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU b
            ON b.product_id=c.product_id
        GROUP BY a.customer_id, b.product_id, b.product_name, b.price
)
SELECT customer_id, sum(puntos) as puntos
    FROM 
    t_puntos
    GROUP BY customer_id