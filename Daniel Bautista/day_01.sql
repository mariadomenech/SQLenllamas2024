SELECT 
    a.customer_id AS cliente,
    SUM(b.price) AS precio_total
FROM 
    SQL_EN_LLAMAS.CASE01.SALES AS a
INNER JOIN 
    SQL_EN_LLAMAS.CASE01.MENU AS b
ON 
    a.product_id = b.product_id
GROUP BY 
    a.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es del todo correcto, añadiría la tabla MEMBERS para que se muestre el cliente D a pesar de no tener pedidos para dicho cliente. También mejoraría un poco el formateo de la query para hacerla más legible.

SELECT 
      a.customer_id AS cliente
    , SUM(IFNULL(c.price, 0)) AS precio_total
FROM SQL_EN_LLAMAS.CASE01.MEMBERS a
    LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES AS b
        ON a.customer_id = b.customer_id
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU AS c
        ON b.product_id = c.product_id
GROUP BY a.customer_id;

*/
