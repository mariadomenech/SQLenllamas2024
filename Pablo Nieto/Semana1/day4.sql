--Número de pedidos por producto (estén o no en la carta)
WITH veces_pedido AS (
    SELECT 
        product_id,
        COUNT(9) AS num_pedidos
    FROM SQL_EN_LLAMAS.CASE01.SALES
    GROUP BY product_id
)
--Nombre y número de veces pedido del producto más demandado de la carta
SELECT
    mn.product_name,
    vp.num_pedidos
FROM SQL_EN_LLAMAS.CASE01.MENU mn
LEFT JOIN veces_pedido vp
       ON mn.product_id = vp.product_id
WHERE vp.num_pedidos = (SELECT MAX(num_pedidos) FROM veces_pedido)
