USE sql_en_llamas;
USE SCHEMA case02;

SELECT runner_id AS "Runner",
		SUM(CASE WHEN regexp_replace(distance, '[^0-9.]', '') <> '' THEN CAST(regexp_replace(distance, '[^0-9.]', '') AS DECIMAL(15,2)) ELSE 0 END) AS "Distancia Acumulada De Reparto", 
		SUM(CASE WHEN regexp_replace(distance, '[^0-9.]', '') <> '' THEN CAST(regexp_replace(distance, '[^0-9.]', '') AS DECIMAL(15,2)) ELSE 0 END) /
			(SUM(CASE WHEN regexp_replace(duration, '[^0-9.]', '') <> '' THEN CAST(regexp_replace(duration, '[^0-9.]', '') AS DECIMAL(15,2)) ELSE 0 END) / 60) AS "Velocidad Promedio (Km/h)"
FROM runner_orders
GROUP BY runner_id;
