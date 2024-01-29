WITH CTE_CLEAN_DATA AS (
    SELECT runner_id,
    CAST(ZEROIFNULL(regexp_substr(duration,'(\\d+\.\\d+)|(\\d+)')) AS FLOAT) duration_num,
    CAST(ZEROIFNULL(regexp_substr(distance,'(\\d+\.\\d+)|(\\d+)')) AS FLOAT) distance_num
    FROM sql_en_llamas.case02.runner_orders
)

SELECT B.runner_id runner,
CONCAT(ZEROIFNULL(SUM(distance_num))::decimal(10,2), ' km') distancia_acum,
CONCAT(ZEROIFNULL(60 * AVG(distance_num)/AVG(duration_num))::decimal(10,2), ' km/h') velocidad_prom
FROM CTE_CLEAN_DATA A
RIGHT JOIN sql_en_llamas.case02.runners B
ON A.runner_id=B.runner_id
GROUP BY 1


/*JUANPE: 

Resultado: Incorrecto. El problema es que el promedio de la velocidad no es el promedio de la distancia entre el promedio del tiempo:
V_m=(v1+v2+vn)/n = (d1/t1+d2/t2+dn/tn)/n <> d_m/t_m = ((d1+d2+dn)/n)/((t1+t2+tn)/n) =(d1+d2+dn)/(t1+t2+tn)

Código: Incorrecto. Por el mismo motivo que te comento antes. Hubiera sido correcto si en lugar de AVG(distance_num)/AVG(duration_num) 
hubieras puesto AVG(distance_num/duration_num). Salvo eso lo demás todo ok.


Legibilidad: insisto en que esto es cuestión de gustos pero es casi una opinión general que los campos de la select esten tabulados
y no estén en la misma linea de la select y el from. Al igual que la clausula on es también opinión general que es mejor darle una 
tabulación para que visualmente este "dentro del join"

Extra: Bien por limpiar los nulos por 0 y por sacar los resultados con 2 decimales y muy original poner las unidades. Aunque en esto último
una de cal y otra de arena pues añadir unidades te convierte tu campo númerico en un string con sus consecuencias. Es decir si lo quisieras para
otra cosa tendrías que volver a limpiar los campos por eso yo personalmente prefiero poner las unidades en la cabecera. Tiene otro problema 
tener numeros como string y es que, si decides ordenar... como número, 20<100 pero como string '100<20'. Por esto considero mejor ponerlos 
en la cabecera del campo o dejar las unidades para un informe de reultados, pero en la tabla puede tener ese problema. Dicho esto y que quede 
claro los posibles problemas, me gusta y es original haberlos puesto.

*/
