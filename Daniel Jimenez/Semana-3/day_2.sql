/*DÍA 2 Para cada mes ?cuantos clientes realizan mas de 1 deposito y 1 compra ó 1 retiro en un solo mes?*/

WITH customer_transaction_limpito AS (
    SELECT  CUSTOMER_ID
        ,   TO_DATE(TXN_DATE) AS fecha_limpia
        ,   TXN_TYPE
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
        ),

    conteo_tipo AS (
    SELECT  CUSTOMER_ID
        ,    EXTRACT(MONTH FROM fecha_limpia) AS mes
        ,   COUNT(CASE WHEN TXN_TYPE = 'purchase' THEN 1 ELSE NULL END) AS num_compras
        ,   COUNT(CASE WHEN TXN_TYPE = 'deposit'  THEN 1 ELSE NULL END) AS num_depositos
        ,   COUNT(CASE WHEN TXN_TYPE = 'withdrawal' THEN 1 ELSE NULL END) AS num_retiros
    FROM customer_transaction_limpito
    GROUP BY CUSTOMER_ID , fecha_limpia
        ),
        
    conteo_limpio AS (
    SELECT  CUSTOMER_ID
        ,   MES
        ,   SUM(num_compras) as compras_totales
        ,   SUM(num_depositos) as depositos_totales
        ,   SUM(num_retiros) as retiros_totales
    FROM conteo_tipo
    GROUP BY CUSTOMER_ID , MES
    HAVING compras_totales > 1 AND depositos_totales > 1 OR retiros_totales > 1
    ORDER BY CUSTOMER_ID , MES
    ),

    conteo_adicional AS (
    SELECT  MES
        ,   COUNT(DISTINCT CASE WHEN compras_totales > 1 AND depositos_totales > 1 THEN CUSTOMER_ID ELSE NULL END) AS num_customers_compra_o_deposito
        ,   COUNT(DISTINCT CASE WHEN retiros_totales > 1 THEN CUSTOMER_ID ELSE NULL END) AS num_customers_retiro
        ,   COUNT(DISTINCT CUSTOMER_ID) AS total_customers
    FROM conteo_limpio
    GROUP BY MES
    )
    
SELECT  MES
    ,   COUNT(CUSTOMER_ID) AS num_customers
    ,   num_customers_compra_o_deposito
    ,   num_customers_retiro
    ,   total_customers
FROM conteo_limpio
JOIN conteo_adicional USING (MES)
GROUP BY MES, num_customers_compra_o_deposito, num_customers_retiro, total_customers
ORDER BY MES;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. Aunque se podría hacer de forma mas simple.

*/
