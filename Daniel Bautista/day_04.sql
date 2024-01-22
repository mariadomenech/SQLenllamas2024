SELECT
    b.product_name,
    COUNT(a.product_id) AS ventas
FROM
    SQL_EN_LLAMAS.CASE01.SALES as a
INNER JOIN
    SQL_EN_LLAMAS.CASE01.MENU as b
ON
    a.product_id = b.product_id
GROUP BY
    b.product_name
ORDER BY
    ventas DESC
LIMIT 1;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. La única mejora que haría seria a la legibilidad del código.

SELECT
    b.product_name,
    COUNT(a.product_id) AS ventas
FROM SQL_EN_LLAMAS.CASE01.SALES as a
    INNER JOIN SQL_EN_LLAMAS.CASE01.MENU as b
        ON a.product_id = b.product_id
GROUP BY b.product_name
ORDER BY ventas DESC
LIMIT 1;

*/
