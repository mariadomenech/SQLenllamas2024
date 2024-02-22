WITH temporal AS
    (SELECT 
        a.ORDER_ID,
        CASE
            WHEN a.extras is null or a.extras='null' THEN 0
            ELSE  ARRAY_SIZE(SPLIT(a.EXTRAS, ','))
        END AS numero_de_extras,
        CASE 
            WHEN a.pizza_id = 1 THEN 12
            ELSE 10
        END AS precio,
        numero_de_extras + precio AS ingresos,
        CASE
                WHEN b.distance LIKE '%km' THEN CAST(LEFT(b.distance, POSITION('km' IN b.distance) - 1) AS DECIMAL(10,1))*0.3
                WHEN b.distance IS NULL OR b.distance = 'null' THEN 0
                ELSE CAST(b.distance AS DECIMAL(10,1))*0.3
        END AS gastos
    FROM 
        SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS AS a
    INNER JOIN SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS AS b
    ON a.order_id = b.order_id
    )

SELECT 
   SUM(c.ingresos-c.gastos) AS beneficio
FROM
    temporal AS c;
