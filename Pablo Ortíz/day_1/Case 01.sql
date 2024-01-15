-- Hago un join con las 3 tablas y calculo la suma del precio del producto agrupada por cada cliente
Select  c.customer_id, sum(b.price) as "Gasto total" from sales as a
join menu as b
on a.product_id=b.product_id
join members as c
on a.customer_id=c.customer_id
group by c.customer_id;
