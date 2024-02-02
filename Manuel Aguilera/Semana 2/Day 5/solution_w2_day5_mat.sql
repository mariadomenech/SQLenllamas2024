WITH TOPPINGS_PIZZAS AS (
    SELECT 
        PIZZA_ID,
        CASE WHEN ARRAY_CONTAINS('1'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "1", 
        CASE WHEN ARRAY_CONTAINS('2'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "2",
        CASE WHEN ARRAY_CONTAINS('3'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "3", 
        CASE WHEN ARRAY_CONTAINS('4'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "4",
        CASE WHEN ARRAY_CONTAINS('5'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "5", 
        CASE WHEN ARRAY_CONTAINS('6'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "6",
        CASE WHEN ARRAY_CONTAINS('7'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "7", 
        CASE WHEN ARRAY_CONTAINS('8'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "8",
        CASE WHEN ARRAY_CONTAINS('9'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "9", 
        CASE WHEN ARRAY_CONTAINS('10'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "10",
        CASE WHEN ARRAY_CONTAINS('11'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "11", 
        CASE WHEN ARRAY_CONTAINS('12'::VARIANT, SPLIT(TOPPINGS, ', ')) THEN 1 ELSE 0 END AS "12"
    FROM 
        SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES
),
CUSTOMER_ORDERS_CLEAN AS
(
SELECT 
    ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
    DECODE(EXCLUSIONS,'',NULL,'null',NULL,TO_VARIANT(SPLIT(DECODE(EXCLUSIONS,'beef','3',EXCLUSIONS), ', '))) as EXCLUSIONS,
    DECODE(EXTRAS,'',NULL,'null',NULL,TO_VARIANT(SPLIT(EXTRAS, ', '))) as EXTRAS
FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS),
RUNNER_ORDERS_CLEAN AS (
    SELECT 
        ORDER_ID,
        RUNNER_ID,
        DECODE(PICKUP_TIME, '', NULL, 'null', NULL, PICKUP_TIME) AS PICKUP_TIME,
        TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2)) AS DISTANCE_KM,
        TRY_CAST(REGEXP_REPLACE(DURATION, '[a-zA-Z]', '') AS NUMBER) AS DURATION_MIN,
        DECODE(CANCELLATION, '', NULL, 'null', NULL, CANCELLATION) AS CANCELLATION
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
)
-- Consulta principal para obtener el conteo total de toppings
SELECT  
	TOPPING_ID, 
	TOPPING_NAME, 
	SUM(CONTEO) + SUM(CONTEO_EXTRAS) - SUM(CONTEO_EXCLUSIONES) AS CONTEO_TOTAL --Sumamos los ingredientes de la pizza, mas los extras , menos las exclusiones
FROM(
	-- Subconsulta para calcular el conteo de toppings, exclusiones y extras
	SELECT 
		*, 
		CASE WHEN ARRAY_CONTAINS(TOPPING_ID::VARIANT, EXCLUSIONS) THEN 1 ELSE 0 END AS CONTEO_EXCLUSIONES,
	CASE WHEN ARRAY_CONTAINS(TOPPING_ID::VARIANT, EXTRAS) THEN 1 ELSE 0 END AS CONTEO_EXTRAS 
	FROM 
		RUNNER_ORDERS_CLEAN A
		INNER JOIN CUSTOMER_ORDERS_CLEAN B
			ON(A.ORDER_ID=B.ORDER_ID AND A.CANCELLATION IS NULL) --filtramos que los pedidos hayan sido completados
	LEFT JOIN(
		-- Subconsulta para obtener el conteo de toppings
		SELECT 
			PIZZA_ID,
			B.TOPPING_ID,
			A.TOPPING_NAME, 
			SUM(CONTIENE) AS CONTEO
		FROM 
			SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS A
			LEFT JOIN (
				-- Subconsulta para pivote y obtener los toppings
				SELECT *
				FROM TOPPINGS_PIZZAS
				UNPIVOT (CONTIENE FOR TOPPING_ID IN ("1","2","3","4","5","6","7","8","9","10","11","12"))
			) B
				ON A.TOPPING_ID = B.TOPPING_ID
		GROUP BY 1,2,3
	) C
	ON (B.PIZZA_ID=C. PIZZA_ID)
)
GROUP BY 1,2
ORDER BY 3 DESC;

/*

COMENTARIOS JUANPE: MUY BIEN!

RESULTADO: CORRECTO.

CÓDIGO: CORRECTO y bien usada la función unpivot. Aunque no era tu idea la que los evaluadores teniamos en mente cuando queriamos que usarias el unpivot
pero muy bien por buscar una lógica para resolverlo en la que tambien use el unpivot. Realmente el uso del unpivot lo hemos puesto para que lo practicasesis 
pero no era realmente necesario usarlo, se puede resovler de otras formas. Muy muy bien.

LEGIBILIDAD: CORRECTA

EXTRA: Solo te hubiera faltado usar el listag para una salida más limpia pero todo correcto.
*/
