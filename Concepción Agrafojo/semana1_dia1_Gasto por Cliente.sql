USE DATABASE sql_en_llamas;

select sales.customer_id CLIENTE, sum(menu.price) GASTO
from case01.sales
inner join case01.menu
    on sales.product_id= menu.product_id
group by sales.customer_id;


/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Al no utilizar la tabla MEMBERS estamos perdiendo al cliente D, por lo que la añadiría con LEFT JOIN para asi poder verlo, a pesar de no tener ningún pedido de dicho cliente.

select
      members.customer_id as CLIENTE
    , sum(ifnull(menu.price, 0)) as GASTO
from case01.members
    left join case01.sales
        on members.customer_id = sales.customer_id
    left join case01.menu
        on sales.product_id= menu.product_id
group by members.customer_id;

*/
