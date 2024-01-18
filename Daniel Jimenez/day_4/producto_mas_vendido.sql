//¿Cual es el producto mas pedido y cuantas veces se ha pedido?

SELECT  menu.product_name as producto_mas_pedido,
        COUNT(*) as veces_vendidos
FROM SQL_EN_LLAMAS.CASE01.SALES
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY veces_vendidos DESC
LIMIT 1;


//En esta nueva forma ampliamos el límite a 3 para mostrar todos los productos, algo sencillo 

SELECT  menu.product_name as producto_mas_pedido,
        COUNT(*) as veces_vendidos
FROM SQL_EN_LLAMAS.CASE01.SALES
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY veces_vendidos DESC
LIMIT 3;

//Esta ultima forma devuelve el mismo resultado pero la he elaborado usando algunos agregados y una subconsulta y volviendola ligeramente mas compleja 

SELECT producto_mas_pedido, veces_vendidos
FROM (
    SELECT  menu.product_name as producto_mas_pedido,
            COUNT(*) as veces_vendidos,
            RANK() OVER (ORDER BY COUNT(*) DESC) as ranking
    FROM SQL_EN_LLAMAS.CASE01.SALES
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
    ON sales.product_id = menu.product_id
    GROUP BY menu.product_name
) AS subconsulta
WHERE ranking = 1;
