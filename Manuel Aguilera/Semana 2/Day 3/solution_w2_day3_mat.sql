WITH RUNNER_ORDERS_CLEAN AS (
    SELECT 
        ORDER_ID,
        RUNNER_ID,
        DECODE(PICKUP_TIME, '', NULL, 'null', NULL, PICKUP_TIME) AS PICKUP_TIME,
        TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2)) AS DISTANCE_KM,
        TRY_CAST(REGEXP_REPLACE(DURATION, '[a-zA-Z]', '') AS NUMBER) AS DURATION_MIN,
        DECODE(CANCELLATION, '', NULL, 'null', NULL, CANCELLATION) AS CANCELLATION
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
), -- Limpieza de datos de la tabla runner_orders

CUSTOMER_ORDERS_CLEAN AS (
    SELECT 
        ORDER_ID,
        CUSTOMER_ID,
        PIZZA_ID,
        DECODE(EXCLUSIONS, '', NULL, 'null', NULL, TO_VARIANT(SPLIT(EXCLUSIONS, ','))) AS EXCLUSIONS,
        DECODE(EXTRAS, '', NULL, 'null', NULL, TO_VARIANT(SPLIT(EXTRAS, ','))) AS EXTRAS
    FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
), -- Limpieza de datos de la tabla customer_ord

PIZZA_PRICES AS (
    SELECT 
        *, 
        DECODE(PIZZA_NAME, 'Meatlovers', 12, 'Vegetarian', 10) AS PIZZA_PRICE
    FROM SQL_EN_LLAMAS.CASE02.PIZZA_NAMES
) -- Limpieza de datos de la tabla precios para incluir el precio de la pizza

SELECT 
    A.ORDER_ID, 
    B.PIZZA_PRICE_TOTAL - A.GANANCIA_RUNNER AS BENEFICIO
FROM (
    SELECT 
        ORDER_ID,
        NVL(SUM(DISTANCE_KM * 0.3), 0) AS GANANCIA_RUNNER 
    FROM RUNNER_ORDERS_CLEAN 
    WHERE CANCELLATION IS NULL
    GROUP BY 1
) A --Calculamos la ganancia de cada runner por pedido
INNER JOIN (
    SELECT 
        A.ORDER_ID,
        SUM(PIZZA_PRICE + NVL(ARRAY_SIZE(EXTRAS), 0)) AS PIZZA_PRICE_TOTAL
    FROM CUSTOMER_ORDERS_CLEAN A
    LEFT JOIN PIZZA_PRICES C ON A.PIZZA_ID = C.PIZZA_ID
    GROUP BY 1
) B --Calculamos el precio total de cada pizza en cada pedido
ON A.ORDER_ID = B.ORDER_ID;

/*
COMENTARIOS JUANPE: 

RESULTADO: Correcto, hubiera faltado hacer la suma total pero aún así correcto.

CODIGO: Correcto, se puede hacer con menos pasos pero tu lógica para resolverla es correcta.

LEGIBILIDAD: Correcta bien tabulado.

*/
