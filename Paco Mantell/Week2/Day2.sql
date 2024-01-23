WITH CTE_CLEAN_DATA AS (
    SELECT runner_id,
    CAST(ZEROIFNULL(regexp_substr(duration,'(\\d+\.\\d+)|(\\d+)')) AS FLOAT) duration_num,
    CAST(ZEROIFNULL(regexp_substr(distance,'(\\d+\.\\d+)|(\\d+)')) AS FLOAT) distance_num
    FROM sql_en_llamas.case02.runner_orders
)

SELECT runner_id runner,
CONCAT(SUM(distance_num), ' km') distancia_acum,
CONCAT(60 * AVG(distance_num)/AVG(duration_num), 'km/h') velocidad_prom
FROM CTE_CLEAN_DATA
GROUP BY 1
