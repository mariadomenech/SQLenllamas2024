-----------------------------------------------------LIMPIEZA DE TABLAS-----------------------------------------------------------------------
CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN AS
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        PIZZA_ID,
        CASE
            WHEN TRIM(EXCLUSIONS) IN ('null', '') OR EXCLUSIONS IS NULL THEN NULL
            ELSE EXCLUSIONS
        END AS EXCLUSIONS,
        CASE
            WHEN TRIM(EXTRAS) IN ('null', '') OR EXTRAS IS NULL THEN NULL
            ELSE EXTRAS
        END AS EXTRAS,
        ORDER_TIME   
    FROM CUSTOMER_ORDERS;

CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN AS
    SELECT
        ORDER_ID,
        RUNNER_ID,
        PICKUP_TIME,
        DISTANCE,
        DURATION,
        CASE
            WHEN TRIM(CANCELLATION) IN ('null', '') OR CANCELLATION IS NULL THEN NULL
            ELSE 'CANCELED'
        END AS CANCELLATION   
    FROM RUNNER_ORDERS;

--------------------------------------------------------------DIA_1----------------------------------------------------------
WITH AUX_1 AS (
    SELECT 
        C.RUNNER_ID,
        COUNT(DISTINCT A.ORDER_ID) AS PEDIDOS_ENTREGADOS,
        COUNT(A.ORDER_ID) AS PIZZAS_ENTREGADAS
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN A
    RIGHT JOIN ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN B
        ON A.ORDER_ID = B.ORDER_ID
    RIGHT JOIN RUNNERS C
        ON B.RUNNER_ID = C.RUNNER_ID
    WHERE CANCELLATION IS NULL
    GROUP BY C.RUNNER_ID
),
AUX_2 AS(
    SELECT
        B.RUNNER_ID,
        CASE
            WHEN TOTAL_PIZZAS != 0 THEN TRUNC((PIZZAS_ENTREGADAS_MODIFICADAS/TOTAL_PIZZAS)*100,2)
            ELSE 0
        END AS EXITO_DE_ENTREGA_EN_PIZZAS_MODIFICADAS
    FROM (  SELECT
                RUNNER_ID,
                COUNT(*) AS TOTAL_PIZZAS
            FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN A
            INNER JOIN ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN B
                ON A.ORDER_ID = B.ORDER_ID
            GROUP BY RUNNER_ID) A
    INNER JOIN (SELECT
                    RUNNER_ID,
                    COUNT(*) AS PIZZAS_ENTREGADAS_MODIFICADAS
                FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN A
                INNER JOIN ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN B
                    ON A.ORDER_ID = B.ORDER_ID
                WHERE CANCELLATION IS NULL
                    AND (EXTRAS IS NOT NULL OR EXCLUSIONS IS NOT NULL)
                GROUP BY RUNNER_ID) B
        ON A.RUNNER_ID = B.RUNNER_ID)
SELECT
    A.RUNNER_ID,
    PEDIDOS_ENTREGADOS,
    PIZZAS_ENTREGADAS,
    CASE
        WHEN TOTAL_PEDIDOS != 0 THEN TRUNC((PEDIDOS_ENTREGADOS/TOTAL_PEDIDOS)*100,2)
        ELSE 0
    END AS PORCENTAJE_DE_EXITO,
    EXITO_DE_ENTREGA_EN_PIZZAS_MODIFICADAS
FROM AUX_1 A
LEFT JOIN (    SELECT
                    RUNNER_ID,
                    COUNT(*) AS TOTAL_PEDIDOS
                FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN
                GROUP BY RUNNER_ID)B
ON A.RUNNER_ID = B.RUNNER_ID
INNER JOIN AUX_2 C
ON A.RUNNER_ID = C.RUNNER_ID;

/****************************/
/**** COMENTARIOS JUANPE ****/
/****************************/
/* 
En CUSTOMER_ORDERS_CLEAN, comentarte que, aunque yo soy de usar los CASE WHEN también, 
te ánimo a conocer la función DECODE, está puede sustituir a los CASE WHEN cuando solo se 
comprueba los posibles, valores de un solo campo de esta forma: 
    DECODE(CAMPO,WHEN1,THEN1,WHEN2,THEN2,WHEN3,THEN3,ELSE) 
    O en nuestro caso: DECODE(EXCLUSIONS,'',NULL,'null',NULL,EXCLUSIONS)
Esto puede ayudarnos a limpiar el código, pues es una forma de escribir un CASE WHEN en una 
sola línea, si el WHEN requiere la comprobación conjunta de varios campos ya si que tenemos
que usar CASE WHEN.

Respecto a la tabla RUNNER_ORDERS_CLEAN para este ejercicio no hace más de lo que has hecho,
pero el campo DISTANCE y el campo DURATION habrá que limpiarlos también, en futuros ejercicios,
pues te hará falta extraer el valor numérico, así, si quieres, puedes ir pensando cómo hacerlo.
En cuanto al campo PICKUP_TIME te recomiendo también convertirlo te cuento una función que puede
serte útil: TRY_CAST(PICKUP_TIME AS TIMESTAMP), la función CAST es para convertir tipo de datos,
pero si hay inconsistencia falla, en cambio TRY_CAST es una versión de dicha función que devuelve
NULL si no puede convertirlo esto quiere decir que si viene algo como 'hola','1234', 'null' u otro
te los va a devolver NULL, algo útil para limpiar ese campo.

Respecto a AUX_1, bien calculo los pedidos y las pizzas entregadas pero el total de pedidos lo
podías haber obtenido aquí, si no filtras por cancelados y en lugar de COUNT, usas sum(case ...),
esto haría que no te hiciera falta el LEFT JOIN de la SELECT final.

Todo esto son solo consejos para simplificar el código, pero si que hay un fallo en AUX_2, pues
en el FROM de esta tabla te faltaría el filtro de WHERE CANCELLATION IS NULL ya que el porcentaje
de pizzas modificadas se debe calcular respecto de las PIZZAS_ENTREGADAS, aunque de todas formas 
no haría falta calcularlo ya que lo tienes en la AUX_1, teniendo esto en cuenta podrías simplificar
como obtienes la tabla AUX_2.

Como siempre, cualquier duda, no dudes en preguntar.
*/
