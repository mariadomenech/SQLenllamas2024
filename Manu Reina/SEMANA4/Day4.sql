-- DAY 4 --
/*¿CUALES SON LOS VALORES (IMPORTE) DE LOS PERCENTILES 
25, 50 Y 75 PARA LOS INGRESOS POR TRANSACCIÓN*/

--LIMPIEZA DUPLICADOS--
WITH CLEANED_SALES AS
(
    SELECT
        DISTINCT *
    FROM SALES
),
TXN_IMPORTE AS
(
    SELECT
        TXN_ID
       ,SUM(QTY*PRICE * (1-DISCOUNT/100)) AS IMPORTE
    FROM CLEANED_SALES
    GROUP BY 1
)
SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY IMPORTE) AS PERCENTIL25
   ,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY IMPORTE) AS PERCENTIL50
   ,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY IMPORTE) AS PERCENTIL75
FROM TXN_IMPORTE;

/*COMENTARIOS JUANPE: TODO CORRECTO*/
