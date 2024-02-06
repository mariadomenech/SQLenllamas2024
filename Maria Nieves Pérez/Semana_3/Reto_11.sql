select
    round(avg(datediff(day, start_date, end_date)),2) as diferencia
from (
    select 
        customer_id,  
        node_id, 
        start_date, 
        end_date, 
        lead(customer_id) over (order by customer_id, start_date) as cliente_posterior,
        lead(node_id) over (order by customer_id, start_date) as nodo_posterior
    from SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    )
where end_date != '9999-12-31' 
    and (nodo_posterior != node_id or customer_id != cliente_posterior)
order by customer_id, start_date;

/*COMENTARIOS JUANPE:

RESULTADO: no es correcto, el correcto es: 17.865859.

CÓDIGO: te explico con un ejemplo. Cojemos el customer_id = 1:
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
(10+1+11+20)/4=42/4=10.5
¿Que sería lo correcto?:
(12+1+11+20)/4=44/4=11

Te animo a que lo rehagas de nuevo teniendo esto en cuenta, puedes hacer la prueba con algunos concretos por ejemplo customer (1,24,62,447),
ver a mano que debe de salir y ver si te sale.

A parte del lead también existe el lag que en vez del siguiente te mira el anterior, te lo digo porque puede ayudarte a identificar las casuisticas
a tener en cuenta para resolverlo.

Si te atascas dimelo y lo vemos o si quieres te pas la solución.

*/
