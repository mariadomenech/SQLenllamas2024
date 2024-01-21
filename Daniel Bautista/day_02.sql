SELECT 
    a.customer_id AS cliente,
    COUNT(distinct a.order_date) AS visitas
FROM 
    SQL_EN_LLAMAS.CASE01.SALES AS a
GROUP BY 
    a.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es del todo correcto, añadiría la tabla MEMBERS para que se muestre el cliente D a pesar de no haber visitado el restaurante aún.
También mejoraría un poco el formateo de la query para hacerla más legible.

SELECT 
    a.customer_id AS cliente,
    COUNT(distinct b.order_date) AS visitas
FROM SQL_EN_LLAMAS.CASE01.MEMBERS a
    LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES b
        ON a.customer_id = b.customer_id
GROUP BY a.customer_id;

*/
