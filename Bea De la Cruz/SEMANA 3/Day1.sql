
with tmp as (
    select 
        case
            when node_id = lead(node_id) over (order by customer_id,region_id,start_date) 
                and end_date is not null then datediff(day,start_date,lead(iff(end_date = '9999-12-31',null,end_date)) over (order by customer_id,region_id,start_date))
            when node_id != lead(node_id) over (order by customer_id,region_id,start_date) 
                and node_id = lag(node_id) over (order by customer_id,region_id,start_date) then null
            when node_id != lead(node_id) over (order by customer_id,region_id,start_date) 
                and node_id != lag(node_id) over (order by customer_id,region_id,start_date) then datediff(day,start_date,iff(end_date = '9999-12-31',null,end_date))
            when end_date is null then null
            else '999999'
        end as dias
    from tabla
)
select round(avg(dias)) as media_nodos
from tmp;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto. Tal cual esta el código no ejecuta ya que el from de la CTE Temp llama a Tabla la cual no existe, entiendo que deberia llamar a CUSTOMER_NODES.

Intentas controlar muchos casos en un case cuando no sería necesario, lo que te recomendaría sería crear en una primera CTE un indicador para aquellos nodos que son el primer registro del cliente 
(con la ayuda de la función LAG), posteriormente en una 2ª CTE utilizaría esos primeros registros para a raíz de ahí contar los días respecto a las siguientes fechas (función LEAD), y por último
una vez que ya tenemos los días transcurridos de una fecha a otra, haría la media.

*/
