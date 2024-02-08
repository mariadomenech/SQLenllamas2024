/*DÍA 4 ¿Cuales son los valores (IMPORTE) de los percentiles 25, 50 y 74 para los ingresos por transacción*/

/*Calculamos percentiles continuos*/

WITH importe_limpito AS (
    SELECT  QTY
        ,   PRICE
        ,   DISCOUNT
        ,   TXN_ID
        ,   (QTY * PRICE) - DISCOUNT AS importe_total
    FROM SALES
),

percentiles_continuos AS (
    SELECT  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY importe_total) AS percentile_25 --Aquí se calculan los percentiles continuos.
        ,   PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY importe_total) AS percentile_50
        ,   PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY importe_total) AS percentile_75
        ,   TXN_ID 
    FROM importe_limpito
    GROUP BY TXN_ID
)

SELECT  TXN_ID
    ,   ROUND(percentile_25 , 2) AS percentil_redondeado_25
    ,   ROUND(percentile_50, 2) AS percentil_redondeado_50
    ,   ROUND(percentile_75, 2) AS percentil_redondeado_75
FROM percentiles_continuos;
 /*Ahora calculando percentiles discretos*/
 WITH importe_limpito AS (
    SELECT  QTY
        ,   PRICE
        ,   DISCOUNT
        ,   TXN_ID
        ,   (QTY * PRICE) - DISCOUNT AS importe_total
    FROM SALES
),

percentiles_discretos AS (
    SELECT  PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY importe_total) AS percentile_25 --Aquí se calculan los percentiles discretos.
        ,   PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY importe_total) AS percentile_50
        ,   PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY importe_total) AS percentile_75
        ,   TXN_ID 
    FROM importe_limpito
    GROUP BY TXN_ID
)

SELECT  TXN_ID
    ,   percentile_25 AS percentil_redondeado_25
    ,   percentile_50 AS percentil_redondeado_50
    ,   percentile_75 AS percentil_redondeado_75
FROM percentiles_discretos;
