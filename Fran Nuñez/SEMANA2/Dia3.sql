/*TABLAS TEMPORALES*/
CREATE OR REPLACE TEMP TABLE CUSTOMER_ORDERS_SILVER AS 
SELECT 
    ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
    CASE
        WHEN TRIM(EXCLUSIONS) IN ('null','') THEN NULL
        ELSE EXCLUSIONS
    END AS EXCLUSIONS,
    CASE
        WHEN TRIM(EXTRAS) IN ('null','') THEN NULL
        ELSE EXTRAS
    END AS EXTRAS,
    ORDER_TIME
FROM CUSTOMER_ORDERS;

CREATE OR REPLACE TEMP TABLE RUNNER_ORDERS_SILVER AS 
SELECT 
    ORDER_ID,
    RUNNER_ID,
    CASE
        WHEN TRIM(PICKUP_TIME) IN ('null') THEN NULL
        ELSE PICKUP_TIME
    END AS PICKUP_TIME,
    CASE
        WHEN TRIM(DISTANCE) IN ('null') THEN NULL
        ELSE REPLACE(RUNNER_ORDERS.DISTANCE,'km','')
        END AS DISTANCIA_KM,
    CASE
        WHEN TRIM(DURATION) IN ('null') THEN NULL
        ELSE SUBSTR(DURATION, 0, 2)
        END AS DURACION_MINUTOS,
    CASE
        WHEN TRIM(CANCELLATION) IN ('null','') THEN NULL
        ELSE CANCELLATION
    END AS CANCELLATION
FROM RUNNER_ORDERS;

/*DESARROLLO EJERCICIO DIA 3*/
SELECT ROUND(((SUM(A.BENEFICIO_PIZZAS)+SUM(A.EXTRAS))-SUM(A.GASTO_RUNNERS)),2) AS BENEFICIO_GIUSEPPE
FROM
(
SELECT PIZZA_ID,
    COUNT(PIZZA_ID) AS NUMERO_PIZZAS,
    CASE
    WHEN PIZZA_ID = 1 THEN NUMERO_PIZZAS*12
    ELSE NUMERO_PIZZAS*10
    END AS BENEFICIO_PIZZAS,
    ARRAY_SIZE(SPLIT(EXTRAS,',')) AS EXTRAS,
    SUM(DISTANCIA_KM*0.3) AS GASTO_RUNNERS
FROM CUSTOMER_ORDERS_SILVER
JOIN RUNNER_ORDERS_SILVER
ON RUNNER_ORDERS_SILVER.ORDER_ID = CUSTOMER_ORDERS_SILVER.ORDER_ID
WHERE CANCELLATION IS NULL
GROUP BY PIZZA_ID, EXTRAS
)A




/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto Fran pero has tenido un fallo que incluso yo tuve cuando planteé el ejericicio.
Si un  pedido tiene dos pizzas, la distancia solo la cuentas una vez. Ten cuidado porque has contado como si cada pizza fuera un viaje diferente.
El gasto total debe salir  43.56.

Por tanto, puedes hacerte un indicador que te diga cuantas pizzas hay por pedido, y te quedas solo con el registro cuando el contador sea 1.


Por lo demás genial!

*/
