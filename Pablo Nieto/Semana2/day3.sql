--Anotamos el precio de cada pizza.
WITH precio_pizzas AS (
    SELECT
        pizza_id,
        CASE
            WHEN pizza_name = 'Meatlovers' THEN 12
            ELSE 10
        END AS precio
    FROM SQL_EN_LLAMAS.CASE02.PIZZA_NAMES
),
/*
Calculamos el precio de las pizzas con los extra incluidos para cada pedido que no haya sido cancelado y limpiamos el campo distancia. 
No hice un cruce con la tabla de los riders porque solo nos interesan aquellos que recorrieron alguna distancia.
*/
precios_distancias AS (
    SELECT
        co.order_id,
        ro.runner_id,
        TO_NUMBER(RTRIM(DECODE(ro.distance, 'null', '0', ro.distance), 'km'), 10, 2) AS clean_distance,
        SUM(CASE
            WHEN extras IN ('', 'null') OR extras IS NULL THEN pp.precio
            ELSE precio + LENGTH(REPLACE(extras, ', ', ''))
        END) AS precio_pizzas
    FROM precio_pizzas pp
    LEFT JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS co USING (pizza_id)
    LEFT JOIN SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS ro USING (order_id)
    WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
    GROUP BY co.order_id, ro.runner_id, ro.distance
)
--Calculamos el balance total siguiendo las pautas del enunciado.
SELECT
    ROUND(SUM(precio_pizzas) - SUM(clean_distance) * 0.3, 2) AS balance_total
FROM precios_distancias;


/*
COMENTARIOS JUANPE: 

RESULTADO: Correcto.

CODIGO: Correcto pero para el precio de los extras... te sirve porque el id de los extras es de un digito y por ello LENGTH(REPLACE(extras, ', ', '')) te sirve
pero si uno de los extras hubiera sido Tomate que tiene el el id 10 hubieras contado el lengh uno más. Esto hubiera sido más correcto:
    ARRAY_SIZE(SPLIT(DECODE(A.EXTRAS,'',NULL,'null',NULL,A.EXTRAS),','))
con el decode limpio el campo pero una vez esta limpio con split convertimos la lista en vector indicando que cada elemento del vector es donde la lista separa 
por ',' y luego el array_size para decirmeel tamaño de ese vector.

LEGIBIIDAD: Correcto bien tabulado y ordenado

EXTRA: Poco que decir en este caso.
*/
