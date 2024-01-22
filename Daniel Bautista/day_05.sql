WITH puntos AS (
SELECT
    a.customer_id,
    b.product_name,
    CASE 
        WHEN product_name = 'sushi' THEN b.price * 10 * 2
        ELSE b.price * 10
    END AS puntos
FROM
    SQL_EN_LLAMAS.CASE01.SALES as a
INNER JOIN
    SQL_EN_LLAMAS.CASE01.MENU as b
ON
    a.product_id = b.product_id
)

SELECT 
c.customer_id,
SUM(c.puntos) AS puntos_totales

FROM 
puntos c

GROUP BY 
c.customer_id

ORDER BY 
puntos_totales DESC;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Añadiría un cruce con MEMBERS para tener a los clientes que no tienen pedidos y mejoraría un poco la legibilidad del código.

WITH puntos AS (
    SELECT
        c.customer_id,
        b.product_name,
        CASE 
            WHEN product_name = 'sushi' THEN ifnull(b.price * 10 * 2, 0)
            ELSE ifnull(b.price * 10, 0)
        END AS puntos
    FROM SQL_EN_LLAMAS.CASE01.SALES as a
        INNER JOIN SQL_EN_LLAMAS.CASE01.MENU as b
            ON a.product_id = b.product_id
        RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS c
            ON a.customer_id = c.customer_id
)

SELECT 
    c.customer_id,
    SUM(c.puntos) AS puntos_totales
FROM puntos c
GROUP BY c.customer_id
ORDER BY puntos_totales DESC;

También se podría sustituir el CASE por un IFF, personalmente usaría CASE cuando haya un control de casuísticas
o cuando la condición de la única casuística es compleja:

IFNULL(IFF(product_name = 'sushi', b.price * 10 * 2, b.price * 10), 0) AS puntos

*/
