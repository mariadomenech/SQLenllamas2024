USE SQL_EN_LLAMAS;
USE SCHEMA CASE02;

---------DIA2---------
WITH DISTANCIA AS (
    SELECT TO_DECIMAL(REPLACE(DISTANCE,'km'),9,2) as distancia,
        RUNNER_ID,
        ORDER_ID
    FROM RUNNER_ORDERS
    WHERE PICKUP_TIME <> 'null'
),


TIEMPO AS (
    SELECT regexp_replace(duration, '[^0-9]', '')/60 as tiempo_h,
        RE.RUNNER_ID,
        ORDER_ID
    FROM RUNNERS RE
    LEFT JOIN RUNNER_ORDERS R
    ON RE.RUNNER_ID = R.RUNNER_ID
    WHERE PICKUP_TIME <> 'null'
)


SELECT ZEROIFNULL(SUM(DISTANCIA))
    ,ZEROIFNULL(round(AVG(DISTANCIA/TIEMPO_H),2)) AS VELOCIDAD
    ,R.RUNNER_ID    
FROM RUNNERS R
LEFT JOIN DISTANCIA D
ON R.RUNNER_ID = D.RUNNER_ID
LEFT JOIN TIEMPO T
ON D.RUNNER_ID = T.RUNNER_ID
AND T.ORDER_ID = D.ORDER_ID
GROUP BY R.RUNNER_ID;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto Juanqui! Me gusta que hayas utilizado expresiones regulares para limpiar los campos!
También podías haber usado: REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '')!

*/
