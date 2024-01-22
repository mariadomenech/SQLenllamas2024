SELECT mem.customer_id, sum(men.price)
    FROM members mem
        JOIN sales sal ON mem.customer_id = sal.customer_id
        JOIN menu men ON sal.product_id = men.product_id
    GROUP BY mem.customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/*

Dale un alias a la columna SUM(MENU.PRICE)  y PERFECTO!

*/
