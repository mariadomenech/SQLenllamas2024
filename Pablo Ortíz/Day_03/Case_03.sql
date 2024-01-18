-- En este caso he usado la funcion rank para obtener una columna que me de valor 1 cuando la fecha sea mínima, partiendolo por cada cliente.
-- Luego he generado una subconsulta para poder quedarme con los registros donde la columna hecha con rank valía 1 usando la función having.

select customer_id,order_date,product_name from
(
select  customer_id
,a.product_id
, b.product_name
, order_date
, RANK() OVER (PARTITION BY customer_id ORDER BY order_date asc) AS orden
from Sales as a
left join menu as b
on a.product_id=b.product_id
)
having orden =1;
