--TABLAS DE ESTUDIO
--select * from sales
--select * from members
--select * from menu

--CONSIDERACIONES PREVIAS
--TABLA HECHOS SALES S
--TABLA DIMENSIONES MENU M
--TABLA DIMENSIONES MEMBERS MEM

-- PRODUCTO FAVORITO:
select m.product_name
,count(s.customer_id) as veces_consumidas_producto
from sales s
left join menu m
on  m.product_id=s.product_id
group by m.product_name
order by veces_consumidas_producto desc;



--SI VA CON TRAMPA TIENEN QUE SER MIEMBROS ANTES DE LA FECHA DE PEDIDO MEM.JOIN_DATE < S.ORDER_DATE
select m.product_name
,count(s.customer_id) as veces_consumidas_producto
from sales s
left join members mem
left join menu m
on  m.product_id=s.product_id
and mem.customer_id=s.customer_id and mem.join_date<s.order_date
group by m.product_name
order by veces_consumidas_producto desc;


--DINERO GASTADO POR CLIENTE_Y_PRODUCTO

select 
s.customer_id
,m.product_name
,count(s.customer_id) as veces_consumidas_producto
,M.PRICE
,sum(m.price) as dinero_gastado_por_cliente_y_producto
from sales s
left join menu m
on  m.product_id=s.product_id
group by s.customer_id,m.product_name,m.price
order by dinero_gastado_por_cliente_y_producto desc;



--DINERO GASTADO EXCLUSIVAMENTE POR CLIENTE


select 
s.customer_id
,sum(m.price) as dinero_gastado_por_cliente
from sales s
left join menu m
on  m.product_id=s.product_id
group by s.customer_id
order by dinero_gastado_por_cliente desc;


