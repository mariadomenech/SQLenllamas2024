/*
Limpiamos las columnas distancia y duración casteándolas a number habiendo eliminado
previamente los caracteres no numéricos y cambiando los 'null' por '0'.
*/
WITH pedidos_limpios AS (
    SELECT 
        runner_id,
        TO_NUMBER(RTRIM(DECODE(distance, 'null', '0', distance), 'km'), 10, 2) AS clean_distance_km,
        TO_NUMBER(LEFT(DECODE(duration, 'null', '0', duration), 2), 10, 2) AS clean_duration_min
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
)
/*
Calculamos la distancia acumulada de cada rider y su velocidad media en km/h
*/
SELECT 
    r.runner_id,
    nvl(SUM(pl.clean_distance_km), 0) AS km_recorridos,
    ROUND(nvl(SUM(pl.clean_distance_km) / NULLIF(SUM(pl.clean_duration_min), 0) * 60, 0), 2) AS velocidad_media_km_h
FROM SQL_EN_LLAMAS.CASE02.RUNNERS r
LEFT JOIN pedidos_limpios pl
       ON r.runner_id = pl.runner_id
GROUP BY r.runner_id;


/*JUANPE: 

Resultado: Incorrecto. El motivo son las mates. La velocidad es distancia entre tiempo y la velocidad media es la media de las velocidades pero esto no coincide
con la suma de las distancias entre las sumas de los tiempo.
V_m=(v1+v2+vn)/n = (d1/t1+d2/t2+dn/tn)/n <> d_m/t_m = ((d1+d2+dn)/n)/((t1+t2+tn)/n) =(d1+d2+dn)/(t1+t2+tn)
No sé si esto que te he puesto es un poco lioso, si tienes interes lo podemos ver más despacio (soy un friki de las mates como puedes comprobar).

Código: Lo correto en el código para el resultado correct hubiera sido avg(clean_distance_km/clean_duration_min)*60 (aunque esto te obliga a filtrar los cancelados en la cte)
para no tener problemas en la división.
Además te quiero comentar unas funciones útiles que puedes usar para la limpieza de los campos DISTANCE y DURATION. Hay unas expresiones que se conocen como
expresiones regulares empiezan por "REGEXP_" son como una versión más "pro" de funciones como replace, substr, count, instr ... En el caso de querer limpiar el 
campo con un replace podríamos hacer algo así: 
    TRY_CAST(REGEXP_REPLACE(DISTANCE, '[^0-9.]', '') AS NUMBER(10, 2))
Aquí le estamos diciendo que remplazo cualquier caracter menos (^) los digitos del 0 al 9 y el "." y los reemplazmos por nada.
Otra versión puede ser con la función substr (para substraer), su versión mejorada nos permite:
    TRY_CAST(REGEXP_SUBSTR(DURATION, '[0-9.]*') AS NUMBER)
Aquí le estamos diciendo que substraiga cualquier conjunto de dígitos entre el 0 y el 9 y el punto el * es para que cojo todo lo que le pedimos tantas veces como haga falta.
La diferencia entre el try_cast y el cast es que si hay un registro que no pueda convertir el cast falla y el try_cast lo convierte a nulo. No es mejor o peor uno u otro es cuestión de gustos
pues si se usa bien no hay problema. Pero en cuanto a las expresiones regulares si te pueden ofrecer ciertas ventajas.
Aunque correcta tu forma, es menos genérica.

Legibilidad: Correcto

Extra: Bien en redondear a dos decimales el resultado y limpiar los nulos por ceros para el runner 4. 

*/

/*
Toda la razón Juanpe, lamentable por mi parte haberme equivocado calculando la media. Adjunto solución corregida utilizando también las expresiones regulares. ¡Gracias!
*/
/*
Limpiamos las columnas distancia y duración casteándolas a number habiendo eliminado
previamente los caracteres no numéricos y cambiando los 'null' por '0'.
*/
WITH pedidos_limpios AS (
    SELECT 
        *,
        TRY_CAST(REGEXP_REPLACE(distance, '[^0-9.]', '') AS NUMBER(10, 2)) AS clean_distance_km,
        TRY_CAST(REGEXP_REPLACE(duration, '[^0-9.]', '') AS NUMBER(10, 2)) AS clean_duration_min
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
    WHERE cancellation IS NULL OR cancellation IN ('', 'null')
)
/*
Calculamos la distancia acumulada de cada rider y su velocidad media en km/h
*/
SELECT 
    r.runner_id,
    NVL(SUM(pl.clean_distance_km), 0) AS km_recorridos,
    ROUND(NVL(AVG(pl.clean_distance_km / NULLIF(pl.clean_duration_min, 0) * 60), 0), 2) AS velocidad_media_km_h
FROM SQL_EN_LLAMAS.CASE02.RUNNERS r
LEFT JOIN pedidos_limpios pl
       ON r.runner_id = pl.runner_id
GROUP BY r.runner_id;
