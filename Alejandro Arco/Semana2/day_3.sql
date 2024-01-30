/* Day 3
    Una pizza Meat Lovers cuesta 12 euros y una vegetariana 10 euros, y cada
    ingrediente extra supone 1 euro adicional.
    Por otro lado, a cada corredor se le paga 0.30euros/km recorrido.
    ¿Cuánto dinero le sobra a Giuseppe después de estas entregas?
*/

WITH SUM_EUR_KM AS (
    SELECT         
        SUM(RTRIM(DECODE(DISTANCE,'null',NULL,DISTANCE),'km'))*0.3 AS TOTAL_EUR_KM_RUNNERS
    FROM RUNNER_ORDERS
),

RUNNER_ORDERS_CLEAN AS (
    SELECT
        ORDER_ID,
        DECODE(PICKUP_TIME,'null',NULL,PICKUP_TIME) AS PICKUP_TIME
    FROM RUNNER_ORDERS
),

CUSTOMER_ORDERS_CLEAN AS (
    SELECT
        R.ORDER_ID,
        PIZZA_ID,
        DECODE(EXTRAS,'null',NULL,'',NULL,EXTRAS) AS EXTRAS
    FROM CUSTOMER_ORDERS AS C
    RIGHT JOIN RUNNER_ORDERS_CLEAN AS R
        ON C.ORDER_ID = R.ORDER_ID
    WHERE PICKUP_TIME IS NOT NULL
),

PIZZA_PRICES AS (
    SELECT
        ORDER_ID,
        PIZZA_ID,
        CASE
            WHEN PIZZA_ID = 1 THEN 12
            ELSE 10
        END AS PIZZA_PRICE,
        EXTRAS,
        ARRAY_SIZE(SPLIT(EXTRAS,',')) AS NUM_EXTRAS
    FROM CUSTOMER_ORDERS_CLEAN
),

TOTAL_PIZZA_PRICES AS (
    SELECT
        SUM(PIZZA_PRICE) + SUM(NUM_EXTRAS) AS TOTAL_PRICE 
    FROM PIZZA_PRICES
)

SELECT 
    TOTAL_PRICE - TOTAL_EUR_KM_RUNNERS AS DINERO_SOBRANTE_GIUSEPPE_EUROS
FROM TOTAL_PIZZA_PRICES
FULL OUTER JOIN SUM_EUR_KM;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

*/
