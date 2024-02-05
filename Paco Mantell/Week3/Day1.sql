WITH CTE_CLEAN_DATA AS (
    /*Limpiamos la columna end_date, que contiene años erroneos, y obtenemos una columna de siguiente nodo*/
    SELECT customer_id,
        region_id,
        node_id,
        start_date,
        REPLACE(end_date,YEAR(end_date), YEAR(start_date)) end_date,
        LEAD(node_id) IGNORE NULLS OVER (ORDER BY customer_id) next_node
    FROM sql_en_llamas.case03.customer_nodes
), CTE_DAYDIFF AS(
    /*seleccionamos solo las filas correspondientes a un cambio de nodo y calculamos la diferencia de dias*/
    SELECT customer_id,
        DATEDIFF(DAY,start_date,end_date) daydiff
    FROM CTE_CLEAN_DATA
    WHERE node_id!=next_node
    
)
/*Mostramos la media de dias por cliente y el total en la primera fila*/
SELECT 'TOTAL' totals,
    CAST(AVG(daydiff) AS INT) avg_days
FROM CTE_DAYDIFF
GROUP BY 1

UNION ALL
SELECT TO_VARCHAR(customer_id),
    avg_days
FROM(
    SELECT customer_id,
        CAST(AVG(daydiff) AS INT) avg_days
    FROM CTE_DAYDIFF A
    GROUP BY 1
    ORDER BY 1 ASC
)


/*COMENTARIOS JUANPE:

RESULTADO: no es correcto, el correcto es: 17.865859.

CÓDIGO: dos cosas a comentar. La primera es que las fechas con años 9999-12-31 no suelen ser fechas erróneas (no solo en este ejercicio, si no en general
en los proyectos suele ocurrir) no suele ser fecha errónea si representa una fecha de fin o una fecha de vencimiento en definitiva algo a futuro, lo que significa 
es que no se ha cerrado, no ha vencido o en este caso no ha cambiado de nodo, ese es su nodo actual. Podría haber omitido eso pero ahí otra factor a tener en 
cuenta en este ejercicio. Y es que un nodo puede tardar en cambiar varios registros y eso no lo has tenido en cuenta. Te lo muestro con el customer_id = 1:
-------------------------------------------------
NODO    START        END           D1     D2
-------------------------------------------------
4	    02/01/2020    03/01/2020	1
                                          12
4	    04/01/2020    14/01/2020	10	
-------------------------------------------------
2	    15/01/2020    16/01/2020	1	  1
-------------------------------------------------
5	    17/01/2020    28/01/2020	11	  11
-------------------------------------------------
3	    29/01/2020    18/02/2020	20	  20
-------------------------------------------------
2	    19/02/2020    16/03/2020	26	
                                          26+X+1
2	    17/03/2020    31/12/9999	X	
-------------------------------------------------
D1 sería la diferencia de días por cada registro, y D2 es la diferencia de días hasta que cambia el nodo. Tú código está haciendo esto:
¿Que sería lo correcto?:
(12+1+11+20)/4=44/4=11

Te animo a que lo rehagas de nuevo teniendo esto en cuenta, puedes hacer la prueba con algunos concretos por ejemplo customer (1,24,62,447),
ver a mano que debe de salir y ver si te sale.

Si te atascas dimelo y lo vemos o si quieres te paso la solución.

*/
