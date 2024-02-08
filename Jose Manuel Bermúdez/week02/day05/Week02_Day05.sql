USE SQL_EN_LLAMAS;
USE SCHEMA case02;

WITH TOPPINGS_BY_PIZZA AS (
    SELECT pizza_id,
            CASE WHEN ARRAY_CONTAINS('1'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping01, 
            CASE WHEN ARRAY_CONTAINS('2'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping02, 
            CASE WHEN ARRAY_CONTAINS('3'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping03, 
            CASE WHEN ARRAY_CONTAINS('4'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping04, 
            CASE WHEN ARRAY_CONTAINS('5'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping05,
            CASE WHEN ARRAY_CONTAINS('6'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping06,
            CASE WHEN ARRAY_CONTAINS('7'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping07,
            CASE WHEN ARRAY_CONTAINS('8'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping08,
            CASE WHEN ARRAY_CONTAINS('9'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping09,
            CASE WHEN ARRAY_CONTAINS('10'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping10,
            CASE WHEN ARRAY_CONTAINS('11'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping11, 
            CASE WHEN ARRAY_CONTAINS('12'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS topping12
    FROM PIZZA_RECIPES
),
ORDERS_DELIVERED AS (
	SELECT ro.order_id,
			customer_id,
			co.pizza_id,
			exclusions,
			extras
	FROM runner_orders ro
	INNER JOIN customer_orders co
		ON ro.order_id = co.order_id
	WHERE NOT (ro.cancellation <> 'null' AND ro.cancellation <> '' AND ro.cancellation IS NOT NULL)    
),
TOPPINGS_ORDERS_DELIVERED AS (
	SELECT order_id,
			customer_id,
			od.pizza_id,
			exclusions,
			extras,
			topping01,
			topping02,
			topping03,
			topping04,
			topping05,
			topping06,
			topping07,
			topping08,
			topping09,
			topping10,
			topping11,
			topping12
	FROM ORDERS_DELIVERED od
	INNER JOIN TOPPINGS_BY_PIZZA tbp
		ON od.pizza_id = tbp.pizza_id
),
EXTRAS_ORDERS_DELIVERED AS (
	SELECT order_id,
			customer_id,
			pizza_id,
			extras,
			TRIM(NULLIF(SPLIT_PART(extras, ', ', 1), '')) AS extra01,
			TRIM(NULLIF(SPLIT_PART(extras, ', ', 2), '')) AS extra02
	FROM TOPPINGS_ORDERS_DELIVERED
	WHERE extras <> 'null' AND extras <> '' AND extras IS NOT NULL
),
EXCLUSIONS_ORDERS_DELIVERED AS (
	SELECT order_id,
			customer_id,
			pizza_id,
			exclusions,
			TRIM(NULLIF(SPLIT_PART(exclusions, ', ', 1), '')) AS exclusion01,
			TRIM(NULLIF(SPLIT_PART(exclusions, ', ', 2), '')) AS exclusion02
	FROM TOPPINGS_ORDERS_DELIVERED
	WHERE exclusions <> 'null' AND exclusions <> '' AND exclusions IS NOT NULL
),
CONVERT_EXCLUSIONS_ORDERS_DELIVERED_WITHOUT_ID AS (
    SELECT ode.order_id,
			customer_id,
			pizza_id,
			exclusions,
			CAST(topping_id AS int) AS exclusion01,
			CAST(exclusion02 AS int) AS exclusion02
	FROM EXCLUSIONS_ORDERS_DELIVERED ode
	INNER JOIN pizza_toppings pt
		ON lower(topping_name) = lower(exclusion01)
    UNION
    SELECT ode.order_id,
			customer_id,
			pizza_id,
			exclusions,
			CAST(exclusion01 AS int) AS exclusion01,
			CAST(topping_id AS int) AS exclusion02
	FROM EXCLUSIONS_ORDERS_DELIVERED ode
	INNER JOIN pizza_toppings pt
		ON lower(topping_name) = lower(exclusion02)
),
EXCLUSIONS_ORDERS_DELIVERED_BY_ID AS (
    SELECT order_id,
			customer_id,
			pizza_id,
			exclusions,
			CAST(exclusion01 AS int) AS exclusion01,
			CAST(exclusion02 AS int) AS exclusion02
	FROM EXCLUSIONS_ORDERS_DELIVERED
	WHERE (NOT REGEXP_LIKE(exclusion01, '.*[a-zA-Z].*') OR exclusion01 IS NULL) AND
			(NOT REGEXP_LIKE(exclusion02, '.*[a-zA-Z].*') OR exclusion02 IS NULL)
    UNION ALL
    SELECT order_id,
			customer_id,
			pizza_id,
			exclusions,
			CAST(exclusion01 AS int) AS exclusion01,
			CAST(exclusion02 AS int) AS exclusion02
	FROM CONVERT_EXCLUSIONS_ORDERS_DELIVERED_WITHOUT_ID
),
TOPPINGS_ORDERS_DELIVERED_UNPIVOT AS (
	SELECT *
	FROM TOPPINGS_ORDERS_DELIVERED
		unpivot(num_top FOR topping IN (topping01, topping02, topping03, topping04, topping05, topping06, topping07, topping08, topping09, topping10, topping11, topping12))
),
EXTRAS_ORDERS_DELIVERED_UNPIVOT AS (
	SELECT *
	FROM EXTRAS_ORDERS_DELIVERED
		unpivot(num_ext FOR extra IN (extra01, extra02))
	WHERE REGEXP_LIKE(num_ext, '.*[0-9].*')
),
EXCLUSIONS_ORDERS_DELIVERED_UNPIVOT AS (
	SELECT *
	FROM EXCLUSIONS_ORDERS_DELIVERED_BY_ID
		unpivot(num_excl FOR excl IN (exclusion01, exclusion02))
	WHERE REGEXP_LIKE(num_excl, '.*[0-9].*')
),
NUM_TOPPINGS_PIZZAS_ORDERS_DELIVERED AS (
    SELECT topping AS Ingrediente,
			SUM(num_top) AS Numero
	FROM TOPPINGS_ORDERS_DELIVERED_UNPIVOT
	GROUP BY topping
),
NUM_EXTRAS_TOPPINGS_PIZZAS_ORDERS_DELIVERED AS (
	SELECT concat('TOPPING',
					trim(to_varchar(CAST(num_ext AS INT), '00'), ' ')) AS Ingrediente,
			COUNT(*) AS Numero
	FROM EXTRAS_ORDERS_DELIVERED_UNPIVOT
	GROUP BY num_ext
),
NUM_EXCLUSIONS_TOPPINGS_PIZZAS_ORDERS_DELIVERED AS (
	SELECT concat('TOPPING',
					trim(to_varchar(CAST(num_excl AS INT), '00'), ' ')) AS Ingrediente,
			(COUNT(*) * -1) AS Numero
	FROM EXCLUSIONS_ORDERS_DELIVERED_UNPIVOT
	GROUP BY num_excl
),
SUM_TOTAL_TOPPINGS_ORDERS_DELIVERED AS (
	SELECT Ingrediente,
			SUM(Numero) AS Total
	FROM (
		SELECT *
		FROM NUM_TOPPINGS_PIZZAS_ORDERS_DELIVERED
		UNION
		SELECT *
		FROM NUM_EXTRAS_TOPPINGS_PIZZAS_ORDERS_DELIVERED
		UNION
		SELECT *
		FROM NUM_EXCLUSIONS_TOPPINGS_PIZZAS_ORDERS_DELIVERED)
	GROUP BY Ingrediente
	ORDER BY Total DESC
),
SUM_TOTAL_TOPPINGS_ORDERS_DELIVERED_BY_ID AS (
	SELECT CAST(replace(Ingrediente, 'TOPPING', '') AS int) AS topping_id,
			Total
	FROM SUM_TOTAL_TOPPINGS_ORDERS_DELIVERED
),
SUM_TOTAL_TOPPINGS_ORDERS_DELIVERED_BY_NAME AS (
	SELECT RANK() OVER (ORDER BY Total DESC) AS Ranking,
            topping_name AS Ingrediente,
			Total
	FROM SUM_TOTAL_TOPPINGS_ORDERS_DELIVERED_BY_ID t
	INNER JOIN pizza_toppings pt
		ON t.topping_id = pt.topping_id
	ORDER BY Ingrediente
)

SELECT Ranking AS RANKING,
		Total AS "NÚMERO VECES USADO",
        listagg(Ingrediente, ', ') AS INGREDIENTES
FROM SUM_TOTAL_TOPPINGS_ORDERS_DELIVERED_BY_NAME
GROUP BY Ranking, Total
ORDER BY Ranking, Total DESC;



/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto!! Me interesaba el uso del UNPIVOT más que nada, y lo has entendido perfectamente. 
También me ha gustado que te hayas trabajado la salida para que no sea dificil de leer.
Enhorabuena!

*/
