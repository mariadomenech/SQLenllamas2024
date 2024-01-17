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
/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Esto no se pedía pero el resutlado es correcto
*/


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
/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Esto no se pedía pero el resutlado ESTA MAL. 
Por un lado decir que ya no tiene sentido esa distinción que haces ya que se han updateado las fechas de la tabla MEMBERS
para que coincida con el primer pedido de los clientes A,B,C.
Esta mal por otro motivo, toda cláusula JOIN debe llevar su ON una vez se especifica la tabla, tu has puesto dos JOIN y un
solo ON esto está mal, de hecho hay lenguajes y editores que no acpetan esa sintaxis (Oracle por ejemplo). En este caso 
SNOWFLAKE aunque acepta esa sintaxsis lo que te devuelve primero es un cruce total de todas las filas de sales con members,
15x4 = 60 registros, a esa tabla de 60 registros le haces luego el left join pero los and que forman parte del ON ya no actuan
de manera correcta, pues esa condición de cruce en los and que es para sales con member se ha realizado después de que se hayan 
cruzado.
Lo que tu querias haber hecho debia haber sido algo así:
    select m.product_name
    ,count(s.customer_id) as veces_consumidas_producto
    from sales s
    left join members mem
    on mem.customer_id=s.customer_id and mem.join_date<s.order_date
    left join menu m
    on  m.product_id=s.product_id
    group by m.product_name
    order by veces_consumidas_producto desc;
El resultado de esto si te sale igual que la query que has llamado "-- PRODUCTO FAVORITO:" pero sale igual porque como te he dicho
se han updateado los campos de fecha de members. Si no se hubiera hecho dicho cambio, la query con el cambio que te cuento sí sacaría
eso que habias considerado "trampa". 
Si no he sido muy claro explianco no dudes en contactar.
*/


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

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Esto no se pedía pero el resutlado es correcto
*/



--DINERO GASTADO EXCLUSIVAMENTE POR CLIENTE


select 
s.customer_id
,sum(m.price) as dinero_gastado_por_cliente
from sales s
left join menu m
on  m.product_id=s.product_id
group by s.customer_id
order by dinero_gastado_por_cliente desc;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
El Código no es del todo correcto, pues tú resultado omite un cliente que está en la tabla de clientes MEMBERS, 
pero que no está en la de pedidos SALES, es decir, no ha hecho ningún pedido (un ejemplo puede ser alguien que se
registra en la web, pero luego no llegó a realizar ningún pedido).
        
Para que la solución del todo correcta, debes usar la tabla MEMBERS, y está debiera estar en el FROM (no obligatoriamente,
pero si recomendable) teniendo está en el FROM, cruzas con SALES por medio de un LEFT JOIN y esta con MENU por medio de 
otro LEFT JOIN.
              
Con estos cambios, ten cuenta que CUSTOMER_ID no puede venir de la tabla SALES ¿te animas a decirme por qué? :D
        
Por último, para el cliente que no ha tenido ningún pedido va a salirte un gasto NULL, pero visualmente Josep prefiere 
ver un 0 en vez de un NULL, para ello hay un algunas funciones que puedes usar: NVL() y IFNULL() por ejemplo, échales
un ojo si no las conoces.
        
Te animo a que rehagas el código a continuación de este comentario. Cualquier duda no dudes en contactar.
*/
