-- En este caso solo es necesaria la tabla "Sales" por lo que no necesitamos joins.
-- Tenemos que hacer count a order_date y agrupar por clientes,
-- pero es importante usar DISTINCT ya que en la misma visita puede haber varios pedidos del mismo cliente.
select customer_id as "Cliente", count(distinct(order_date)) as "Número de visitas" from sales
group by customer_id;
