with nodes_previous_and_next as(
    select
        customer_id,
        region_id,
        node_id,
        start_date,
        end_date,
        nvl(LAG(node_id) OVER (PARTITION BY customer_id ORDER BY end_date), -1) as previous_node,
        nvl(LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY end_date), -1) as next_node

    from 
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    where 
        end_date != to_date('9999-12-31')
    order by customer_id, end_date, region_id, node_id
),
clean_intermediates as (
    select
        *
    from nodes_previous_and_next
    where not (next_node = node_id  and previous_node = node_id)
    order by  start_date

),
get_date_ranges as (
    select
        distinct customer_id,
        region_id,
        node_id,
        case 
            when previous_node = node_id then LAG(start_date) OVER (PARTITION BY customer_id ORDER BY end_date)
            when previous_node != node_id then start_date
        end as new_start_date,
        case 
            when next_node = node_id then LEAD(end_date) OVER (PARTITION BY customer_id ORDER BY end_date)
            when next_node != node_id then end_date
        end as new_end_date
    from 
        clean_intermediates
    order by  
        new_start_date
) 
select 
    avg( (new_end_date + 1) - new_start_date)::number(10,2) as average_node_change
from get_date_ranges;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Muy buen intento, bien el tratamiento para cuando un nodo está varios registros.
Pero el resultado no es del todo correcto. Hay un par de matices que estropean el resultado final:

- Nos quedamos solo con los inicios en cada nodo y restamos las fechas de inicio del siguiente tramo con el actual
menos 1 porque la fecha fin en el tramo es el día anterior a la del comienzo en el siguiente nodo. Por lo que: new_end_date - new_start_date.

- El último nodo del cliente no cuenta para ver la diferencia de días.

RESULTADO CORRECTO: 17.865859.

CÓDIGO: te explico con un ejemplo. Asumimos que ya hemos corregido el día de más. Cogemos el customer_id = 1:
-------------------------------------------------------
NODO    START        END           D1             D2
------------------------------------------------------
4	    02/01/2020    03/01/2020	1
                                                 12
4	    04/01/2020    14/01/2020	10	
------------------------------------------------------
2	    15/01/2020    16/01/2020	1	          1
------------------------------------------------------
5	    17/01/2020    28/01/2020	11	          11
------------------------------------------------------
3	    29/01/2020    18/02/2020	20	          20
-------------------------------------------------------
2	    19/02/2020    16/03/2020	26	
                                                  26+X+1
2	    17/03/2020    31/12/9999	X	
--------------------------------------------------------
D1 sería la diferencia de días por cada registro, y D2 es la diferencia de días hasta que cambia el nodo. Tú código está haciendo esto:
(12+1+11+20+26)=69/5= 14
¿Que sería lo correcto?:
(12+1+11+20) =44/4=11

Te animo a que lo rehagas de nuevo teniendo esto en cuenta, puedes hacer la prueba con algunos concretos por ejemplo customer (1,24,62,447),
ver a mano que debe de salir y ver si te sale.

*/
