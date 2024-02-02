-- Limpio la tabla runners_order
with Runnersorder as (
select order_id
, runner_id
, case 
    when pickup_time in('null','') then null
    else pickup_time end as pickup_time
, case 
    when distance in('null','') then null
    else distance end as distance
, case 
    when duration in('null','') then null
    else duration end as duration
, case 
    when cancellation in('null','') then null
    else cancellation end as cancellation
from runner_orders
) ,

-- Paso los valores de distancia y duracion a datos numericos
 Datos_limpios as (
 select runner_ID
 ,cast(replace(distance,'km','') as number(6,2)) as distancia_Km
 ,CAST(REPLACE(REPLACE(REPLACE(DURATION,'minutes',''),'mins',''),'minute','') AS NUMBER(6,2)) as duracion_minutos
 from runnersorder
 )
 -- hago los calculos de la distancia acumulada y velocidad media
 select runner_id
 , round(Sum(distancia_Km),2) as Distancia_acumulada_Km
 , round(avg(distancia_Km/duracion_minutos)*60,2) as Velocidad_promedio_Kmh
 from datos_limpios
 group by runner_id
 ;


/*
COMENTARIOS JUANE:

RESULTADO: Correcto pero hubiera estado bien sacar al 4 runner

CODIGO: Correcto. Aunque hay opciones más genericas para limpiar los campos. Al final te pongo mi versión para que veas como limpiar los campos de una sola vez
y no en dos partes donde primeros quitas los nulos y luego los que tienen 'km', 'mins' ....

LEGIBILIDAD: Lo que te he comentado en el ejercicio anterior. Pondría tabulación a cada campo de la select, los case when han quedado muy legibles, eso me gusta.
Una cosa más, hay quien no le da improtancia pero visualmetne suele ser mejor usas siempre mayusculas, o minusculas o usar unas para los campos y otro para las
funciones... usar al menos algún criterio (yo por ejemplo prefiero todo en mayuscula) pero en tu caso haces un mix a partir de la linea 22.

EXTRA: Bien por limpiar la salida a dos decimales pero hubiera sido mejor sacar al runner 4.
*/

-- TE DEJO MI VERSIÓN DE LA SOLUCIÓN DE ESTE EJERCICIO PARA QUE VEAS FUNCIONES MUY ÚTILES COMO LAS EXPRESIONES REGULARES (REG_EXP...) Y EL USO DEL TRY_CAST
-- FRENTE AL CAST QUE PUEDE SER ÚTIL SEGÚN LO QUE SE BUSQUE
SELECT B.RUNNER_ID
     , NVL(SUM(A.DISTANCIA_KM),0) AS DISTANCIA_ACUMULADA_KM
     , NVL(ROUND(AVG(A.VELOCIDAD_KM_H),2),0) AS VELOCIDAD_PROMEDIO_KM_H
FROM (SELECT RUNNER_ID
           , TRY_CAST(REGEXP_REPLACE(DISTANCE, '[^0-9.]', '') AS NUMBER(10, 2)) AS DISTANCIA_KM
           , TRY_CAST(REGEXP_SUBSTR(DURATION, '[0-9.]*') AS NUMBER) AS TIEMPO_MIN
           , 60*DISTANCIA_KM/TIEMPO_MIN AS VELOCIDAD_KM_H
      FROM RUNNER_ORDERS) A
RIGHT JOIN RUNNERS B
     USING (RUNNER_ID)
GROUP BY RUNNER_ID;
