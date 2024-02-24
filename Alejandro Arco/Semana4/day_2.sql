/* Day 2
    ¿Cuál es la combinación de productos distintos más repetida en una sola transacción?
    La combinación debe ser de al menos 3 productos distintos
*/
USE SQL_EN_LLAMAS;
USE SCHEMA CASE04;

-- Agrupar por pedido y contar el número de productos. me quedo con los que tienen 3 o más
WITH pedidos_filtrados AS (
    SELECT
        txn_id,
        count(prod_id) as count_products_sale
    FROM sales
    GROUP BY txn_id
    HAVING count(prod_id) >= 3      
),

-- LISTAGG concatena el texto en una linea. 
combinaciones_pedidos AS (
    SELECT
        p.txn_id,
        LISTAGG(DISTINCT s.prod_id,',') WITHIN GROUP (ORDER BY s.prod_id) as combinacion
    FROM pedidos_filtrados as p
    LEFT JOIN sales as s
    ON p.txn_id = s.txn_id
    GROUP BY p.txn_id
)

-- agrupas por esas listas y cuentas el número de repeticiones de cada lista. ordenas por desc y muestras el top. (limit 1)
SELECT TOP 1
    combinacion,
    COUNT(txn_id) as total_combinacion
FROM combinaciones_pedidos
GROUP BY combinacion
ORDER BY total_combinacion DESC;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. 

*/
