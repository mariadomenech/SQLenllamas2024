-- En este caso solo es necesaria la tabla "Sales" por lo que no necesitamos joins.
-- Tenemos que hacer count a order_date y agrupar por clientes,
-- pero es importante usar DISTINCT ya que en la misma visita puede haber varios pedidos del mismo cliente.
select customer_id as "Cliente", count(distinct(order_date)) as "Número de visitas" from sales
group by customer_id;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Para estar del todo correcto hace falta traer a todos los clientes de la tabla MEMBERS hayan o no realizado algún pedido.

En cuanto a la limpieza de código, aunque este tema siempre es más subjetivo, es conveniente no poner el from en la misma linea de la select.
*/
