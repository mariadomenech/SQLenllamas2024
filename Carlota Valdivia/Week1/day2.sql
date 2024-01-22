-------------------------- DÍA 2 -----------------------------
--- ¿CUÁNTOS DÍAS HA VISITADO EL RESTAURANTE CADA CLIENTE? ---
--------------------------------------------------------------

select m.customer_id, zeroifnull(count(distinct(s.order_date))) as DIAS_VISITADOS
from SQL_EN_LLAMAS.CASE01.MEMBERS m
left join SQL_EN_LLAMAS.CASE01.SALES s 
on m.customer_id = s.customer_id
group by m.customer_id
ORDER BY DIAS_VISITADOS DESC;
