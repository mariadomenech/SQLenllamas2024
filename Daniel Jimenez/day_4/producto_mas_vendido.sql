//¿Cual es el producto mas pedido y cuantas veces se ha pedido?

SELECT  menu.product_name as producto_mas_pedido,
        COUNT(*) as veces_vendidos
FROM SQL_EN_LLAMAS.CASE01.SALES
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY veces_vendidos DESC
LIMIT 1;
