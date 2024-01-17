--TABLAS DE ESTUDIO
--select * from sales
--select * from members
--select * from menu

--CONSIDERACIONES PREVIAS
--TABLA HECHOS SALES S
--TABLA DIMENSIONES MENU M
--TABLA DIMENSIONES MEMBERS MEM

-- CUANTOS DÍAS HA VISITADO EL RESTAURANTE CADA CLIENTE :

select 
s.customer_id
,approx_count_distinct(s.order_date) as dias_visitados_distintos   --esta sería la solución
,count(s.order_date) as veces_visitadas
from sales s
group by s.customer_id
order by dias_visitados_distintos desc;