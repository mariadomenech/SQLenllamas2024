--Puntos de cada producto
WITH puntos_producto AS (
    SELECT
        s.customer_id,
        nvl(CASE
            WHEN mn.product_id = 1 THEN mn.price * 20
            ELSE mn.price * 10
        END, 0) AS puntos
    FROM SQL_EN_LLAMAS.CASE01.SALES s
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU mn
           ON s.product_id = mn.product_id
)
--Total de puntos que tiene cada cliente
SELECT
    mb.customer_id,
    nvl(SUM(puntos), 0) AS total_puntos
FROM SQL_EN_LLAMAS.CASE01.MEMBERS mb
LEFT JOIN puntos_producto pp
       ON mb.customer_id = pp.customer_id
GROUP BY mb.customer_id;
