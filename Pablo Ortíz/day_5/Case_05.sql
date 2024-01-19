-- Primero hago una subconsulta para hacer los joins, elegir los campos que necesito y cambiar el nombre de las columnas. Luego sobre esta
-- consulta hago otra con un case que será el que use para calcular los puntos para cada cliente. Luego usando la función "nlv"
 -- Cambio los valores nulos por 0. Por último hago un group by por cliente.
select cliente
, nvl(sum(
    case when producto= 'sushi' then precio_producto*10*2
    else precio_producto *10
    
    end
    ),0) as puntos
from
        (
    select  b.customer_id as cliente
    ,product_name as producto
    ,price as precio_producto
    from Sales as a
    full join members as b
    on a.customer_id=b.customer_id
    full join Menu as c
    on a.product_id=c.product_id
        )
        group by 1;
