SELECT mem.customer_id, COALESCE(sum(men.price), 0)
    FROM members mem
        LEFT OUTER JOIN sales sal ON mem.customer_id = sal.customer_id
        LEFT OUTER JOIN menu men ON sal.product_id = men.product_id
    GROUP BY mem.customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/*

Guay que conozcas la función colaesce como alternativa a un CASE WHEN o un IFNULL.
Por otro lado, el OUTER aquí es opcional, pero si personalmente lo ves más claro, no hay diferencia.
Dale un alias a la columna COALESCE(sum(men.price), 0) y PERFECTO!

*/
