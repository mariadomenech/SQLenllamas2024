--¿EN CUÁNTOS DÍAS DE MEDIA SE REASIGNAN LOS CLIENTES A UN NODO DIFERENTE?--
WITH FECHA_CAMBIO_NODO AS
( 
    SELECT
         CUSTOMER_ID
        ,NODE_ID
        ,START_DATE
        ,END_DATE
        ,LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS FECHA_CAMBIO_NODO
        ,LEAD(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS NODO_SIGUIENTE
    FROM CUSTOMER_NODES
)
SELECT
    ROUND(AVG(DATEDIFF(DAY,START_DATE,FECHA_CAMBIO_NODO)),2) AS MEDIA_DIAS_CAMBIO_NODO
FROM FECHA_CAMBIO_NODO
WHERE FECHA_CAMBIO_NODO IS NOT NULL
AND END_DATE <> '9999-12-31'
AND NODO_SIGUIENTE <> NODE_ID;
