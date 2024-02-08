USE sql_en_llamas;
USE SCHEMA case02;

SELECT runner_id AS "Runner",
		SUM(CASE WHEN regexp_replace(distance, '[^0-9.]', '') <> '' THEN CAST(regexp_replace(distance, '[^0-9.]', '') AS DECIMAL(15,2)) ELSE 0 END) AS "Distancia Acumulada De Reparto", 
		SUM(CASE WHEN regexp_replace(distance, '[^0-9.]', '') <> '' THEN CAST(regexp_replace(distance, '[^0-9.]', '') AS DECIMAL(15,2)) ELSE 0 END) /
			(SUM(CASE WHEN regexp_replace(duration, '[^0-9.]', '') <> '' THEN CAST(regexp_replace(duration, '[^0-9.]', '') AS DECIMAL(15,2)) ELSE 0 END) / 60) AS "Velocidad Promedio (Km/h)"
FROM runner_orders
GROUP BY runner_id;



/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

No es del todo correcto el código, se pedía velocidad promedio. Una vez que calculas los km/hora de cada pedido, haz la media por runner.
Me gusta que hayas usado expresiones regulares para limpiar los campos, también podías haber usado: REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '').

*/
