/* Day 4
    ¿Cuales son los valores (importe) de los percentiles 25,50 y 75 para los ingresos por transacción?
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE04;

WITH importe_transaccion AS (
    SELECT --distinct si hubiera duplicados
        txn_id,
        --SUM(qty * price - discount) AS total_transaccion -- Con el descuento como cantidad
        SUM(price*qty*(1-discount/100)) AS total_transaccion -- Con el descuento como porcentaje
    FROM sales
    GROUP BY txn_id
)

SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_transaccion) AS percentil_25,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_transaccion) AS percentil_50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_transaccion) AS percentil_75
FROM importe_transaccion;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto.

He visto que has probado a utilizar distinct para quitar los duplicados pero eso tendrias que hacerlo en un paso previo sobre la tabla sales en su totalidad, y no es la CTE en la que calculas el total
de la transacción:

WITH CLEAN_SALES AS (
    SELECT DISTINCT * --AQUI QUITAMOS LOS DUPLICADOS
    FROM SALES
),

IMPORTE_TRANSACCION AS (
    SELECT
          TXN_ID
        , SUM(PRICE*QTY*(100-DISCOUNT)/100) AS TOTAL_TRANSACCION
    FROM CLEAN_SALES
    GROUP BY TXN_ID
)

SELECT
      PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY TOTAL_TRANSACCION) AS PERCENTIL_25
    , PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY TOTAL_TRANSACCION) AS PERCENTIL_50
    , PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY TOTAL_TRANSACCION) AS PERCENTIL_75
FROM IMPORTE_TRANSACCION;

*/
