SELECT 
    DISTINCT AA.toppings AS codigo_ingrediente,
    BB.topping_name AS nombre_ingrediente,
    COUNT(toppings) OVER (PARTITION BY topping_id) AS repeticiones_veces
FROM (
        SELECT 
            pizza_id,
            TRIM(C.value::string,' ') AS toppings
        FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES A,
            LATERAL FLATTEN(input=>SPLIT(toppings, ',')) C
) AA
INNER JOIN SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS BB
    ON AA.toppings=BB.topping_id
ORDER BY toppings;


/*
COMENTARIOS JUANPE: 

RESULTADO: CORRECTO.

CÓDIGO: CORRECTOS 

LEGIBILIDAD: CORRECTA

EXTRAS: raro pero original hacer el conteo con una función ventana yel distinct, lo normal en estos casos es montar el group by pero y asi 
usasr un count normal y no hace falta distinct pero como te digo muy orignal ya que metes las funcinoes ventana

PD: el reto 8 (semana 2 día 3) no lo has entregado, ¿se te ha pasado o no te salía? cualquier cosa no dudes en contactar
*/
