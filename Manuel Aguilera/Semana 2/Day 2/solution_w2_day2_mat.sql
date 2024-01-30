WITH RUNNER_ORDERS_CLEAN AS 
(
SELECT 
    ORDER_ID,
    RUNNER_ID,
    DECODE(PICKUP_TIME,'',NULL,'null',NULL,PICKUP_TIME) as PICKUP_TIME,
    TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2)) AS DISTANCE_KM,
    TRY_CAST(REGEXP_REPLACE(DURATION, '[a-zA-Z]', '') AS NUMBER) AS DURATION_MIN,
    DECODE(CANCELLATION,'',NULL,'null',NULL,CANCELLATION) as CANCELLATION
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
) --Limpieza de datos de la tablla runner_orders
SELECT 
    A.RUNNER_ID, 
    NVL(SUM(DISTANCE_KM),0) AS DISTANCIA_TOTAL,
    NVL((SUM(DISTANCE_KM)/SUM(DURATION_MIN))*60,0) AS VELOCIDAD_KM_H
FROM SQL_EN_LLAMAS.CASE02.RUNNERS A
LEFT JOIN RUNNER_ORDERS_CLEAN B
    ON (A.RUNNER_ID=B.RUNNER_ID)
GROUP BY 1;



/*JUANPE: 

Resultado: Incorrecto. El motivo son las mates. La velocidad es distancia entre tiempo y la velocidad media es la media de las velocidades pero esto no coincide
con la suma de las distancias entre las sumas de los tiempo.
V_m=(v1+v2+vn)/n = (d1/t1+d2/t2+dn/tn)/n <> d_m/t_m = ((d1+d2+dn)/n)/((t1+t2+tn)/n) =(d1+d2+dn)/(t1+t2+tn)
No sé si esto que te he puesto es un poco lioso, si tienes interes lo podemos ver más despacio (soy un friki de las mates como puedes comprobar).

Código: Lo correto en el código para el resultado correct hubiera sido avg(DISTANCE_KM/DURATION_MIN)*60. Me gusta mucho el uso del TRY_CAST(REGEXP_REPLACE()) para
limpiar las columnas.
Otra versión puede ser:
    TRY_CAST(REGEXP_REPLACE(DISTANCE, '[^0-9.]', '') AS NUMBER(10, 2))
Aquí le estamos diciendo que remplace cualquier caracter menos (^) los digitos del 0 al 9 y el "." y los reemplazmos por nada.
Otra versión puede ser con la función substr (para substraer), su versión mejorada nos permite:
    TRY_CAST(REGEXP_SUBSTR(DURATION, '[0-9.]*') AS NUMBER)
Aquí le estamos diciendo que substraiga cualquier conjunto de dígitos entre el 0 y el 9 y el punto el * es para que cojo todo lo que le pedimos tantas veces como 
haga falta.

Legibilidad: Correcto

Extra: Bien en sacar al runner 4 y limpiar los nulos por ceros pero la velocidad mostrada solo con dos decimales hubiera sido otro plus

*/
