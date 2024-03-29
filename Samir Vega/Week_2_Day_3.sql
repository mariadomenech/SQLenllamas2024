-----------------------------------------------------LIMPIEZA DE TABLAS-----------------------------------------------------------------------
CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN AS
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        PIZZA_ID,
        DECODE(EXCLUSIONS,'',NULL,'null',NULL,EXCLUSIONS) AS EXCLUSIONS,
        DECODE(EXTRAS,'',NULL,'null',NULL,EXTRAS) AS EXTRAS,
        ORDER_TIME   
    FROM CUSTOMER_ORDERS;

CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN AS
    SELECT
        ORDER_ID,
        RUNNER_ID,
        TRY_CAST(PICKUP_TIME AS TIMESTAMP) AS PICKUP_TIME,
        CAST(REPLACE(UPPER(DECODE(DISTANCE,'',NULL,'null',NULL,DISTANCE)), 'KM') AS DECIMAL(15,2)) AS DISTANCE_KM,
        TO_NUMBER(REGEXP_REPLACE(DECODE(DURATION,'',NULL,'null',NULL,DURATION), '[a-zA-Z]', ''))AS DURATION_MIN,
        CASE
            WHEN TRIM(CANCELLATION) IN ('null', '') OR CANCELLATION IS NULL THEN NULL
            ELSE 'CANCELED'
        END AS CANCELLATION   
    FROM RUNNER_ORDERS;

--------------------------------------------------------------DIA_3----------------------------------------------------------

SELECT
    SUM(
        CASE
            WHEN TRIM(PIZZA_NAME) = 'Meatlovers' THEN 12
            WHEN TRIM(PIZZA_NAME) = 'Vegetarian' THEN 10
        END)
    + (SUM(REGEXP_COUNT(EXTRAS,',')+1)) AS INGRESOS_EUROS,
    TRUNC((SUM(ZEROIFNULL(DISTANCE_KM)) * 0.3),2) AS GASTOS_EUROS,
    SUM(
        CASE
            WHEN TRIM(PIZZA_NAME) = 'Meatlovers' THEN 12
            WHEN TRIM(PIZZA_NAME) = 'Vegetarian' THEN 10
        END)
    + (SUM(REGEXP_COUNT(EXTRAS,',')+1))
    - TRUNC((SUM(ZEROIFNULL(DISTANCE_KM)) * 0.3),2) AS BENEFICIO_EUROS
FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN A
RIGHT JOIN ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN B
    ON A.ORDER_ID = B.ORDER_ID
INNER JOIN PIZZA_NAMES C
    ON A.PIZZA_ID = C.PIZZA_ID
WHERE CANCELLATION IS NULL;


/*
COMENTARIO JUANPE:

RESULTADO: Incorrecto. El problema está en el gasto por km. Este gasto solo cuenta una vez por pedido, no una vez por pizza, que es lo que has hecho.
Ya que si una pedido tiene 3 pizzas no recorre la distancia 3 veces pues las lleva juntas.

CÓDIGO: Muy original el uso del REGEXP_COUNT(EXTRAS,',')+1) para saber la cantidad de extras pero dado el problema que te he comentaod en el RESULDATO, 
el código no es correcto.

LEGIBILIDD: Correcta y poco que decir me gusta como está tabulado.

EXTRA: Poco que comentar.
*/
