//**Perdón por el retraso. El trabajo diario no me permite ir al día con los ejercicios**//

WITH RUNNER_ORDERS AS (
    SELECT
        ORDER_ID,
        RUNNER_ID,
        PICKUP_TIME,
        DISTANCE,
        DURATION,
        CASE WHEN CANCELLATION IN ('', 'null') THEN NULL ELSE CANCELLATION END AS CANCELLATION_REAL
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
    WHERE CANCELLATION_REAL IS NULL
),

CUSTOMER_ORDERS AS (
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        PIZZA_ID,
        ORDER_TIME,
        CASE WHEN EXCLUSIONS IN ('', 'null') THEN NULL ELSE EXCLUSIONS END AS EXCLUSIONS_REAL,
        CASE WHEN EXTRAS IN ('', 'null') THEN NULL ELSE EXTRAS END AS EXTRAS_REAL
    FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
),

PEDIDOS_RUNNER AS (
    SELECT
        RUNNER_ID,
        COUNT(*) AS PEDIDOS_CON_EXITO
    FROM RUNNER_ORDERS
    GROUP BY RUNNER_ID
),

NUMERO_PIZZAS AS (
    SELECT
        RO.RUNNER_ID,
        COUNT(*) AS PIZZAS_CON_EXITO
    FROM RUNNER_ORDERS RO 
    INNER JOIN CUSTOMER_ORDERS CO
        ON RO.ORDER_ID = CO.ORDER_ID
    GROUP BY RO.RUNNER_ID
),

PEDIDOS_TOTALES AS (
    SELECT
        RUNNER_ID,
        COUNT(ORDER_ID) AS TOTAL_PEDIDOS
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
    GROUP BY RUNNER_ID
),

PIZZAS_MODIFICADAS AS (
    SELECT
        RO.RUNNER_ID,
        COUNT(*) AS PIZZAS_MODIFICADAS
    FROM RUNNER_ORDERS RO
    JOIN CUSTOMER_ORDERS CO
        ON RO.ORDER_ID = CO.ORDER_ID
    WHERE CO.EXCLUSIONS_REAL IS NOT NULL OR CO.EXTRAS_REAL IS NOT NULL
    GROUP BY RO.RUNNER_ID
)

SELECT
    R.RUNNER_ID,
    PR.PEDIDOS_CON_EXITO,
    NP.PIZZAS_CON_EXITO,
    CAST ((PR.PEDIDOS_CON_EXITO/PT.TOTAL_PEDIDOS)*100 AS NUMBER(5,2)) AS "%_PEDIDOS_EXITO",
    CAST((PM.PIZZAS_MODIFICADAS/NP.PIZZAS_CON_EXITO)*100 AS NUMBER(5,2)) AS "%_PIZZAS_MODIFICADAS_EXITO"
FROM PEDIDOS_RUNNER PR
INNER JOIN NUMERO_PIZZAS NP
    ON PR.RUNNER_ID = NP.RUNNER_ID
INNER JOIN PEDIDOS_TOTALES PT
    ON PR.RUNNER_ID = PT.RUNNER_ID
INNER JOIN PIZZAS_MODIFICADAS PM
    ON PR.RUNNER_ID = PM.RUNNER_ID
RIGHT JOIN SQL_EN_LLAMAS.CASE02.RUNNERS R
    ON PR.RUNNER_ID = R.RUNNER_ID
    ;
;
/*
JUANPE: No te preocupes por entregarlos más tarde, nos preocupaba que la gente se hubiera desanimado, pero si es por falta de tiempo no pasa nada :)

Resultado: Correcto.  

Código: Correcto. Correcto en el sentido de que no has hecho nada que no sea incorrecto o hubiera algo mejor de otra forma. De hecho tú idea 
de resolverlo es similiar a la que yo tuve, pero se podía haber hecho con menos lineas de código pues al fin y al cabo tus tablas intermedias 
todas usan las primeras, por tanto los conteos se podían haber hecho con uso de condicionales o "sabiendo que contar exactamente". 

Legibilidad: Correcta. Bien tabulado y ordenado. Aunque los dos with primeros es lioso si se llaman igual que las tablas originales. Personalmetne veo 
bien el uso de los with, pero cuando son tantos puede ser lioso, yo hubiera preferido alguna tabla temporal, es decir, un CREATE OR REPLACE TEMPORARY TABLE.
Pero completamente correcto los WITH.

Extra: Muy bien que esté redondeado a dos decimales. Hubiera sido un extra limpiar los resultados finales de nulos,  es decir,
para en pedidos y pizzas con éxito ver 0 en vez de null y en los porcentajes ver 0.00% en vez de null.

*/
