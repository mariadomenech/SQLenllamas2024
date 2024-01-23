WITH RUNNER_ORDERS_CLEAN AS 
(
SELECT 
    ORDER_ID,
    RUNNER_ID,
    CASE 
        WHEN PICKUP_TIME='null' OR PICKUP_TIME='' THEN null
        ELSE PICKUP_TIME
    END AS PICKUP_TIME,
    CASE 
        WHEN DISTANCE='null' OR DISTANCE ='' THEN null
        ELSE TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2)) 
    END AS DISTANCE_KM,
    CASE 
        WHEN DURATION='null' OR DURATION = '' THEN null
        ELSE TRY_CAST(REGEXP_REPLACE(DURATION, '[a-zA-Z]', '') AS NUMBER) 
    END AS DURATION_MIN,
    CASE 
        WHEN CANCELLATION='null' OR CANCELLATION='' THEN null
        ELSE CANCELLATION 
    END AS CANCELLATION
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
), --Limpieza de datos de la tablla runner_orders
CUSTOMER_ORDERS_CLEAN AS
(
SELECT 
    ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
    CASE 
        WHEN EXCLUSIONS='null' or EXCLUSIONS='' THEN null
        ELSE EXCLUSIONS
    END AS EXCLUSIONS, 
    CASE 
        WHEN EXTRAS='null' or EXTRAS='' THEN null
        ELSE EXTRAS
    END AS EXTRAS
FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
) --Limpieza de datos de la tablla customer_orders
SELECT RUNNER_ID,
COUNT(DISTINCT CASE
                    WHEN CANCELLATION IS NULL THEN A.ORDER_ID
                END) AS PEDIDOS_EXITOSOS, 
        -- Cuento los distintos ORDER_ID siempre que no haya sido CANCELADO el pedido
 COUNT (CASE
            WHEN CANCELLATION IS NULL THEN 1
        END) AS PIZZAS_EXITOSAS,
       -- Cuanto las distintas filas que tiene siempre que el pedido no haya sido CANCELADO, que van a ser las pizzas pedidas 
       (100 * COUNT(DISTINCT CASE
                                 WHEN CANCELLATION IS NULL THEN A.ORDER_ID
                             END)) / COUNT(DISTINCT A.ORDER_ID) AS PEDIDOS_EXITOSOS_PORCENTAJE, 
        --Divido los distintos ORDER_ID siempre que no haya sido CANCELADO el pedido por los pedidos totales y lo multiplico por 100 para sacar el porcentaje
 (100 * COUNT (CASE
                   WHEN CANCELLATION IS NULL
                        AND (EXCLUSIONS IS NOT NULL
                             OR EXTRAS IS NOT NULL) THEN 1 -- Casos en que las pizzas han sufrido modificaciones
               END)) / COUNT (CASE
                                  WHEN CANCELLATION IS NULL THEN 1
                              END) AS PIZZAS_MODIFICADAS_PORCENTAJE
                --Divido las pizzas modificadas por los pizzas totales y lo multiplico por 100 para sacar el porcentaje
FROM RUNNER_ORDERS_CLEAN A
INNER JOIN CUSTOMER_ORDERS_CLEAN B 
    ON (A.ORDER_ID=B.ORDER_ID)
GROUP BY 1;

/**************************/
/*** COMENTARIOS JUANPE ***/
/**************************/
/*
Respecto RUNNER_ORDERS_CLEAN muy bien usada la función REGEXP_REPLACE para limpiar las celdas y me ha gustado mucho el uso de TRY_CAST 
para convertir el campo, aunque te comento un detalle, no te hace falta el CASE WHEN y validar los nulos y en el ELSE tu función ya que
la función TRY_CAST va a hacer eso por ti, dado que esta función si no puede convertir el dato en lo que le pides en lugar de dar error,
te devuelve NULL, por tanto lo que viene ‘’ o ‘null’ te lo va devolver NULL igualmente, esto te ahorraría unas líneas de código.

Respecto CUSTOMER_ORDERS_CLEAN muy bien, como detalle comentarte que cuando el CASE WHEN solo valida un campo siempre puedes tomar como
alternativa el DECODE, esto te permitiría que el CASE WHEN que ocupa 4 lineas se quede en una sola:
    DECODE(CAMPO,WHEN1,THEN1,WHEN2,THEN2,(WHENn,THENn),ELSE)
    DECODE(EXCLUSIONS,'',NULL,'null',NULL,EXCLUSIONS)
Dicho esto, el CASE WHEN es totalmente válido.

Para terminar la SELECT final es correcta y esos son los resultados que deben de salir, buen manejo de la función COUNT usando DISTINCT
y CASE WHEN dentro de dicha función, aunque había formas de hacer los conteos con algo menos de código, pero totalmente correcta tu propuesta.

He echado en falta al RUNNER que no ha realizado ningún pedido y no esta de más expresar los resultados de porcentajes redondeados a dos decimales.
En general muy bien resuelto, ¡enhorabuena por el ejercicio!
*/
