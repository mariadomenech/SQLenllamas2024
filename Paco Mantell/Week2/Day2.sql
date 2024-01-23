WITH CTE_CLEAN_DATA AS (
    SELECT runner_id,
    CAST(ZEROIFNULL(regexp_substr(duration,'(\\d+\.\\d+)|(\\d+)')) AS FLOAT) duration_num,
    CAST(ZEROIFNULL(regexp_substr(distance,'(\\d+\.\\d+)|(\\d+)')) AS FLOAT) distance_num
    FROM sql_en_llamas.case02.runner_orders
)

SELECT B.runner_id runner,
CONCAT(ZEROIFNULL(SUM(distance_num)), ' km') distancia_acum,
CONCAT(ZEROIFNULL(60 * AVG(distance_num)/AVG(duration_num)), ' km/h') velocidad_prom
FROM CTE_CLEAN_DATA A
RIGHT JOIN sql_en_llamas.case02.runners B
ON A.runner_id=B.runner_id
GROUP BY 1
