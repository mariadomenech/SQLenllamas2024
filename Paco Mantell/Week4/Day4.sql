/*Supongo muestra discontinua*/
WITH CTE_CLEAN_DATA AS(
    SELECT DISTINCT * FROM sql_en_llamas.case04.sales
), CTE_AMOUNT AS(
    SELECT txn_id,
        SUM((qty * price) - discount) amount
    FROM CTE_CLEAN_DATA
    GROUP BY 1
) SELECT
    AVG(amount)::decimal(10,2) "Avg",
    MEDIAN(amount)::decimal(10,2) "Median",
    MODE(amount) "Mode",
    PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY amount) P_25,
    PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY amount) P_50,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY amount) P_75
FROM CTE_AMOUNT

/*Supongo muestra continua -> AQUÍ SI SE PUEDE VER CÓMO EL P_50 COINCIDE CON LA MEDIANA*/
WITH CTE_CLEAN_DATA AS(
    SELECT DISTINCT * FROM sql_en_llamas.case04.sales
), CTE_AMOUNT AS(
    SELECT txn_id,
        SUM((qty * price) - discount) amount
    FROM CTE_CLEAN_DATA
    GROUP BY 1
) SELECT
    AVG(amount)::decimal(10,2) "Avg",
    MEDIAN(amount)::decimal(10,2) "Median",
    MODE(amount) "Mode",
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount)::decimal(10,2) P_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY amount)::decimal(10,2) P_50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount)::decimal(10,2) P_75
FROM CTE_AMOUNT
