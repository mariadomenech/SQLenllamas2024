USE SCHEMA SQL_EN_LLAMAS.CASE04;

--Limpiamos la tabla quitando los duplicados.
WITH quitar_duplicados AS (
    SELECT DISTINCT
        *
    FROM SALES
),
/*
Calculamos los ingresos por transacción, siendos estos la suma de los ingresos de los productos que la conforman.
Los ingresos de cada producto se calculan como la cantidad comprada multiplicada por el importe de una unidad y 
aplicándole el descuento correspondiente.
*/
ingresos_transaccion AS (
    SELECT
        txn_id,
        ROUND(SUM(qty * price * (100 - discount) / 100), 2) AS ingresos_txn
    FROM SALES
    GROUP BY txn_id
)
--Calculamos finalmente los percentiles deseados con la función PERCENTILE_CONT al tratarse de una muestra continua.
SELECT
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ingresos_txn), 2) AS percentil_25,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY ingresos_txn), 2) AS percentil_50,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ingresos_txn), 2) AS percentil_75
FROM ingresos_transaccion;
