WITH CUSTOMER_ORDERS AS (
    SELECT
        CO.ORDER_ID,
        CASE WHEN PN.PIZZA_NAME = 'Meatlovers' THEN 12 ELSE 10 END AS PRECIO,
        CASE WHEN CO.EXTRAS IN ('', 'null') THEN NULL ELSE CO.EXTRAS END AS EXTRAS_CLEANED,
        IFNULL(LENGTH(REPLACE(REPLACE(EXTRAS_CLEANED,',',''),' ','')), 0) AS NUM_TOPPINGS_EXTRA,
        PRECIO + NUM_TOPPINGS_EXTRA AS PRECIO_TOTAL
    FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS CO
    INNER JOIN SQL_EN_LLAMAS.CASE02.PIZZA_NAMES PN
    ON CO.PIZZA_ID = PN.PIZZA_ID
),

RUNNER_ORDERS AS (
    SELECT
        ORDER_ID,
        CAST(REPLACE(DISTANCE,'km','') AS NUMBER(5,2)) AS DISTANCE_NUMBER,
        0.3 * DISTANCE_NUMBER AS COSTE_RUNNER_PEDIDO,
        CASE WHEN CANCELLATION IN ('', 'null') THEN NULL ELSE CANCELLATION END AS CANCELLATION_REAL
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
    WHERE CANCELLATION_REAL IS NULL
),

BENEFICIO_LIMPIO_POR_PEDIDO AS (
    SELECT
        CO.ORDER_ID,
        CAST(SUM(CO.PRECIO_TOTAL) AS NUMBER(5,2)) AS GANANCIA_PEDIDO,
        RO.COSTE_RUNNER_PEDIDO,
        CAST((GANANCIA_PEDIDO - RO.COSTE_RUNNER_PEDIDO) AS NUMBER(5,2)) AS BENEFICIO_LIMPIO
    FROM CUSTOMER_ORDERS CO
    INNER JOIN RUNNER_ORDERS RO
    ON CO.ORDER_ID = RO.ORDER_ID
    GROUP BY CO.ORDER_ID, RO.COSTE_RUNNER_PEDIDO
)

SELECT SUM(BENEFICIO_LIMPIO) AS BENEFICIO_TOTAL
FROM BENEFICIO_LIMPIO_POR_PEDIDO;


/*
COMENTARIOS JUANPE:

RESULTADO: Correcto

CODIGO: Correcto pero para el precio de los extras... te sirve porque el id de los extras es de un digito y por ello LENGTH(REPLACE(....) te sirve
pero si uno de los extras hubiera sido Tomate que tiene el el id 10 hubieras contado el lengh uno más. Esto hubiera sido más correcto:
    ARRAY_SIZE(SPLIT(DECODE(A.EXTRAS,'',NULL,'null',NULL,A.EXTRAS),','))
con el decode limpio el campo pero una vez esta limpio con split convertimos la lista en vector indicando que cada elemento del vector es donde la lista separa 
por ',' y luego el array_size para decirmeel tamaño de ese vector. O con el uso de expresiones regulares puedes contar cuantas veces aparece la ',' y le sumas 1
ya que habrá tantos ingredietes como ',' +1:
     REGEXP_COUNT(EXTRAS,',')+1

LEGIBIIDAD: Correcto bien tabulado y ordenado (aunque no esta de más darle una tabulación a las sentencias ON de los JOIN)

EXTRA: Muy clara tu forma de resolverlo.
*/
