-- PREGUNTA
-- ¿Cuál es la distancia acumulada de reparto de cada runner y su velocidad promedio en km/h?

-- Creamos una tabla temporal con los campos limpios e incluimos en esta tabla
-- todos los corredores, hayan hecho o no un pedido
CREATE OR REPLACE TEMPORARY TABLE T_RUNNER_ORDERS AS
SELECT
    ORDER_ID
    ,R.RUNNER_ID
    ,PICKUP_TIME
    ,CAST(REPLACE(
                REPLACE(
                    COALESCE(DISTANCE,'0'
                    ),'null','0'
                ),'km','') AS DECIMAL(4,2)) AS DISTANCE
    ,ROUND
        (CAST
            (REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            COALESCE(DURATION,'0'
                            ),'null','0'
                        ),'minutes',''
                    ),'minute',''
                ),'mins',''
            ) AS DECIMAL(4,2))/60,2) AS DURATION_H
    ,REPLACE(
        COALESCE(CANCELLATION,''
            ),'null','') AS CANCELLATION
FROM RUNNER_ORDERS RO
    RIGHT JOIN RUNNERS R
    ON RO.RUNNER_ID = R.RUNNER_ID
;

-- SQL
--_____________________________________________________
WITH DISTANCIA_RECORRIDA AS(
    SELECT 
        RUNNER_ID
        ,COUNT(ORDER_ID) AS PEDIDOS
        ,SUM(DISTANCE) AS DISTANCE
    FROM T_RUNNER_ORDERS
    GROUP BY RUNNER_ID
)
, KM_H AS(
    SELECT
        RUNNER_ID
        ,CASE
            WHEN DURATION_H > 0 THEN ROUND(DISTANCE/DURATION_H,2)
            ELSE 0
        END AS "km/h"
    FROM T_RUNNER_ORDERS   
), KM_H_PROMEDIO AS(
    SELECT
        RUNNER_ID
        , ROUND(AVG("km/h"),2) AS "Promedio km/h"
    FROM KM_H   
    GROUP BY RUNNER_ID
)
SELECT 
    DISTINCT DR.RUNNER_ID AS "Corredores"
    , DISTANCE AS "Distancia total recorrida"
    , PEDIDOS AS "Pedidos realizados"
    , "Promedio km/h"
FROM 
    DISTANCIA_RECORRIDA DR
    LEFT JOIN KM_H KH
        ON DR.RUNNER_ID = KH.RUNNER_ID
    LEFT JOIN KM_H_PROMEDIO KHP
        ON DR.RUNNER_ID = KHP.RUNNER_ID
;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Muy buen intento, pero el resultado final no es del todo correcto.

Te explico, al hacer un tratamiento de nulo en la CTE KM_H, estás haciendo media con los pedidos que no se han entregado 
y eso baja la media de la velocidad promedio del runner. Ejemplo: el runner 3 tiene 2 pedidos, uno lo entrega y el otro no.

Si filtras por los pedidos no cancelados, te saldrá la solución correcta!!

*/
