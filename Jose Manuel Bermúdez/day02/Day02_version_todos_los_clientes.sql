SELECT mem.customer_id, COUNT(DISTINCT(sal.order_date))
    FROM members mem
    LEFT OUTER JOIN sales sal ON mem.customer_id = sal.customer_id
    GROUP BY mem.customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/*

Por otro lado, el OUTER aquí es opcional, pero si personalmente lo ves más claro, no hay diferencia.
Dale un alias a la columna COALESCE(sum(men.price), 0) y PERFECTO!

*/
