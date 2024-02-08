WITH EXT AS (
    SELECT C.ORDER_ID,
        C.PIZZA_ID, 
        ARRAY_SIZE(SPLIT(CASE WHEN EXTRAS = '' OR EXTRAS = 'null' THEN NULL ELSE EXTRAS END,',')) AS EXTRAS
    FROM CUSTOMER_ORDERS C
    LEFT JOIN RUNNER_ORDERS R
    ON C.ORDER_ID = R.ORDER_ID
    WHERE PICKUP_TIME <> 'null'
),

DISTANCIA AS (
    SELECT SUM(TO_DECIMAL(REPLACE(DISTANCE,'km'),9,2))*0.3 as distancia
    FROM RUNNER_ORDERS
    WHERE PICKUP_TIME <> 'null'
),

TOTAL_PED AS (
    SELECT DISTINCT C.ORDER_ID,
        C.PIZZA_ID,CASE WHEN C.PIZZA_ID = 1 THEN 10 ELSE 12 END AS TOTAL_PED,
        E.EXTRAS
    FROM CUSTOMER_ORDERS C
    LEFT JOIN RUNNER_ORDERS R
    ON C.ORDER_ID = R.ORDER_ID
    LEFT JOIN EXT E
    ON C.ORDER_ID = E.ORDER_ID
    AND C.PIZZA_ID = E.PIZZA_ID
    WHERE PICKUP_TIME <> 'null'
),

TOTAL_INGRESOS AS
(
    SELECT (SUM(TOTAL_PED) + SUM(EXTRAS)) AS TOT
    FROM TOTAL_PED
)

SELECT ROUND(TOT-DISTANCIA,2) as BENEFICIO
FROM TOTAL_INGRESOS
FULL OUTER JOIN DISTANCIA;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

No es del todo correcto el código, te has liado con el precio de las pizzas, el id_pizza = 1 son 12 euros y la otra 10.

Para limpiar campos puedes usar expresiones regulares: REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '').

*/
