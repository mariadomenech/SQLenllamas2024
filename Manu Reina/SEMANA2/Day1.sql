--¿Cuántos pedidos y cuántas pizzas se han entregado con éxito por cada runner?
--¿Cuál es el porcentaje de éxito de cada runner?
--¿Qué porcentaje de las pizzas entregadas tenían modificaciones?

WITH PEDIDOS_TOTALES AS
(
    SELECT 
         R.RUNNER_ID
        ,COALESCE(COUNT(ORDER_ID),0) AS PEDIDOS_TOTALES
    FROM RUNNER_ORDERS RO
    RIGHT JOIN RUNNERS R
            ON RO.RUNNER_ID = R.RUNNER_ID
    GROUP BY 1     
),
ESTADO_PEDIDO AS
(
    SELECT 
         A.RUNNER_ID
        ,A.ORDER_ID
        ,CASE
             WHEN (TRIM(CANCELLATION) = 'null' 
               OR CANCELLATION IS NULL 
               OR CANCELLATION = '') THEN 'NO_CANCELADO'
             ELSE 'CANCELADO'
         END AS STATUS
    FROM RUNNER_ORDERS A   
),
PEDIDOS_COMPLETADOS AS
(
    SELECT
         A.RUNNER_ID
        ,COALESCE(COUNT(A.ORDER_ID),0) AS NUMERO_PEDIDOS_COMPLETADOS
    FROM ESTADO_PEDIDO A
    WHERE A.STATUS = 'NO_CANCELADO'
    GROUP BY 1
),
PIZZAS_ENTREGADAS AS
(
    SELECT 
         A.RUNNER_ID
        ,COUNT(B.PIZZA_ID) AS NUM_PIZZAS
    FROM ESTADO_PEDIDO A
    RIGHT JOIN CUSTOMER_ORDERS B
            ON A.ORDER_ID = B.ORDER_ID
    WHERE A.STATUS = 'NO_CANCELADO'
    GROUP BY 1
),
PIZZAS_MODIFICADAS AS
(
    SELECT 
         B.RUNNER_ID
        ,COUNT(A.PIZZA_ID) AS NUM_PIZZAS_MODIF
        ,CASE
             WHEN (TRIM(EXCLUSIONS) = 'null' OR EXCLUSIONS IS NULL OR EXCLUSIONS = '')
              AND (TRIM(EXTRAS) = 'null' OR EXTRAS IS NULL  OR EXTRAS = '') THEN 'NO'
             ELSE 'SI'
         END AS MODIFICADA
    FROM CUSTOMER_ORDERS A
    RIGHT JOIN ESTADO_PEDIDO B
            ON A.ORDER_ID = B.ORDER_ID
    WHERE B.STATUS = 'NO_CANCELADO'
    AND MODIFICADA = 'SI'
    GROUP BY 1,3
)

SELECT 
     A.RUNNER_ID
    ,COALESCE(B.NUMERO_PEDIDOS_COMPLETADOS,0) AS NUMERO_PEDIDOS_COMPLETADOS
    ,COALESCE(C.NUM_PIZZAS,0) AS PIZZAS_ENTREGADAS
    ,ROUND(COALESCE((B.NUMERO_PEDIDOS_COMPLETADOS/A.PEDIDOS_TOTALES)*100,0),2) AS PCT_PEDIDOS_EXITOSOS
    ,ROUND(COALESCE((NUM_PIZZAS_MODIF/C.NUM_PIZZAS) * 100, 0),2) AS PCT_PIZZAS_MODIF
FROM PEDIDOS_TOTALES A
LEFT JOIN PEDIDOS_COMPLETADOS B
       ON A.RUNNER_ID = B.RUNNER_ID   
LEFT JOIN PIZZAS_ENTREGADAS C
       ON A.RUNNER_ID = C.RUNNER_ID
LEFT JOIN PIZZAS_MODIFICADAS D
       ON A.RUNNER_ID = D.RUNNER_ID;


/*
JUANPE:

Resultado: Correcto.  

Código: Correcto. La lógica de tu solución es correcta aunque te podias haber ahorrado alguna select intentado sacar en una misma lo que sacas en varias,
para tener menos líneas de código pero aún así muy clara la lógdica usada.

Legibilidad: Correcta. Bien tabulado y ordenado. Cuando hay tantos with casi prefiero sustituir alguno por una tabla temporal, pero es una opinión 
más subjetiva.

Extra: Muy bien que esté redondeado a dos decimales. Y bien limpizados los nulos por 0.

*/
