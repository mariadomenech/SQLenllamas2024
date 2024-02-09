USE SQL_EN_LLAMAS;
USE SCHEMA case03;

SELECT AVG(days_to_reassign) as "Número de días promedio en que se reasignan los clientes a un nodo diferente"
FROM
	(SELECT customer_id,
			start_date,
			CASE
				WHEN LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) IS NOT NULL THEN
					(end_date - start_date) 
				ELSE
					0
			END AS days_to_reassign
	 FROM customer_nodes)
	 WHERE days_to_reassign > 0;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Buen intento, el resultado estaría correcto, pero hay un matiz que estropea el resultado final:
- El último nodo del cliente no cuenta para ver la diferencia de días.

RESULTADO CORRECTO: 17.865859.

CÓDIGO: te explico con un ejemplo. Cogemos el customer_id = 1:
-------------------------------------------------------
NODO    START        END           D1             D2
------------------------------------------------------
4	    02/01/2020    03/01/2020	1
                                                 12
4	    04/01/2020    14/01/2020	10	
------------------------------------------------------
2	    15/01/2020    16/01/2020	1	  1
------------------------------------------------------
5	    17/01/2020    28/01/2020	11	  11
------------------------------------------------------
3	    29/01/2020    18/02/2020	20	  20
-------------------------------------------------------
2	    19/02/2020    16/03/2020	26	
                                                  26+X+1
2	    17/03/2020    31/12/9999	X	
--------------------------------------------------------
D1 sería la diferencia de días por cada registro, y D2 es la diferencia de días hasta que cambia el nodo. Tú código está haciendo esto:
(10+1+11+1+20+26)=69/4=11.5
¿Que sería lo correcto?:
(12+1+11+20)/4=44/4=11

Te animo a que lo rehagas de nuevo teniendo esto en cuenta, puedes hacer la prueba con algunos concretos por ejemplo customer (1,24,62,447),
ver a mano que debe de salir y ver si te sale.

A parte del lead también existe el lag que en vez del siguiente te mira el anterior, te lo digo porque puede ayudarte a identificar las casuisticas
a tener en cuenta para resolverlo.

*/
