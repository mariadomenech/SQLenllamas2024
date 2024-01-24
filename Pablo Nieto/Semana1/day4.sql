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


/*JUANPE: CORRECTO! una de las formas que habia de hacerlo y que fuese correcto al 100%! Ya que usando un filtro te aseguras que en caso de empate
siempre te de todos los resultados, un TOP o un LIMIT o un ROW_NUMBER no tienen en cuenta los empates.
Para que la sepas la otra opción correcta es usar RANK (no sé si conoces las funciones ventana) a mi personalmente me gusta más porque te permite
un código mucho más corto sobre todo si la usas junto a un QUALIFY que te evita usar subconsultas y con una sola select lo tendrías. Te muestro 
mi propuesta: (Aprovecho y te muestro otra forma de hacer el cruce en un JOIN por si no lo conocias (hay otras también) está obliga a que los campos
de cruce se llamen iguales)*/
    SELECT INITCAP(B.PRODUCT_NAME) AS PRODUCTO
         , COUNT(A.PRODUCT_ID) AS NUMERO_PEDIDOS
    FROM SALES A
    LEFT JOIN MENU B USING (PRODUCT_ID) 
    GROUP BY B.PRODUCT_NAME
    QUALIFY RANK() OVER (ORDER BY COUNT(A.PRODUCT_ID) DESC) = 1;

