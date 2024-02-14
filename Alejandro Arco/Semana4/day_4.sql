/* Day 4
    ¿Cuales son los valores (importe) de los percentiles 25,50 y 75 para los ingresos por transacción?
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE04;

WITH importe_transaccion AS (
    SELECT --distinct si hubiera duplicados
        txn_id,
        SUM(qty * price - discount) AS total_transaccion
    FROM sales
    GROUP BY txn_id
)

SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_transaccion) AS percentil_25,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_transaccion) AS percentil_50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_transaccion) AS percentil_75
FROM importe_transaccion;



