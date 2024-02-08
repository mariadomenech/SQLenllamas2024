--Tabla temporal para limpiar las columnas de tiempo y distancia
WITH T_CLEAN AS (
SELECT
    a.runner_id as runner,
    CASE
        WHEN a.distance = 'null' THEN NULL
        ELSE CAST(REPLACE (a.distance, 'km','') AS  DECIMAL (15,2))
    END AS dist,
    CASE
        WHEN a.duration = 'null' THEN NULL
        ELSE LEFT (a.duration,2)/60
    END AS hours
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS a
    )
    -- Cálculo de agregaciones
    SELECT  b.runner_id,
            sum(dist) AS km,
            CAST(km/sum(hours) AS DECIMAL(15,2)) AS kmh
    FROM SQL_EN_LLAMAS.CASE02.RUNNERS b
        LEFT JOIN T_CLEAN c
        ON b.runner_id=c.runner
    GROUP BY b.runner_id

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

No es del todo correcto el código, se pedía velocidad promedio. Una vez que calculas los km/hora de cada pedido, haz la media por runner. Tal que así: 

WITH T_CLEAN
AS (
	SELECT a.runner_id AS runner
		,CASE 
			WHEN a.distance = 'null'
				THEN NULL
			ELSE CAST(REPLACE(a.distance, 'km', '') AS DECIMAL(15, 2))
			END AS dist
		,CASE 
			WHEN a.duration = 'null'
				THEN NULL
			ELSE LEFT(a.duration, 2) / 60
			END AS hours
	FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS a
	)
-- Cálculo de agregaciones
SELECT runner_id
	,avg(kmh) media_velocidad
	,sum(dist) AS distancia
FROM (
	SELECT b.runner_id
		,dist
		,(dist / hours) AS kmh
	FROM SQL_EN_LLAMAS.CASE02.RUNNERS b
	LEFT JOIN T_CLEAN c ON b.runner_id = c.runner
	)
GROUP BY runner_id

*/
