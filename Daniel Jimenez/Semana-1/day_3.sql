//¿Cual es el primer producto que ha pedido cada cliente?
WITH PrimerPedido AS (
    SELECT customer_id, 
    MIN(order_date) as PrimerFecha
    FROM SQL_EN_LLAMAS.CASE01.SALES
    GROUP BY customer_id
)

SELECT  members.customer_id ,
        COALESCE(menu.product_name, 'No ha hecho pedidos') as product_name
        --COALESCE(CAST(menu.price AS VARCHAR), 'No ha hecho pedidos') as price,
        --COALESCE(CAST(pp.PrimerFecha AS VARCHAR), 'No ha hecho pedidos') as PrimerFecha
FROM SQL_EN_LLAMAS.CASE01.MEMBERS
LEFT JOIN PrimerPedido pp 
    ON members.customer_id = pp.customer_id
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES 
    ON members.customer_id = sales.customer_id
    AND pp.PrimerFecha = sales.order_date
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
    ON sales.product_id = menu.product_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Quitando los campos price y PrimerFecha, que no se piden en el ejercicio, el resultado sería correcto. Simplificaría la salida de la query con LISTAGG para así tener un único registro por cliente:

WITH PrimerPedido AS (
    SELECT customer_id, 
    MIN(order_date) as PrimerFecha
    FROM SQL_EN_LLAMAS.CASE01.SALES
    GROUP BY customer_id
)

SELECT
      members.customer_id 
    , LISTAGG(distinct COALESCE(menu.product_name, 'No ha hecho pedidos'), ', ') as product_name
FROM SQL_EN_LLAMAS.CASE01.MEMBERS
LEFT JOIN PrimerPedido pp 
    ON members.customer_id = pp.customer_id
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES 
    ON members.customer_id = sales.customer_id
    AND pp.PrimerFecha = sales.order_date
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
    ON sales.product_id = menu.product_id
GROUP BY members.customer_id
ORDER BY members.customer_id asc;

*/
