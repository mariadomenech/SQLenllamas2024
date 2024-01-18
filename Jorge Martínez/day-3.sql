with first_product as(
select a.customer_id,
        c.order_date,
        b.product_name,
        row_number() over (partition by a.customer_id order by c.order_date) as fila,
        first_value(c.product_id) over (partition by a.customer_id order by c.order_date) as product
    from SQL_EN_LLAMAS.CASE01.MEMBERS a
        left join SQL_EN_LLAMAS.CASE01.SALES c 
            on a.customer_id = c.customer_id
        left join SQL_EN_LLAMAS.CASE01.MENU b
            on b.product_id = c.product_id
        group by a.customer_id, c.product_id, c.order_date, b.product_name
        order by c.order_date asc
)
select customer_id, product, product_name
    from first_product
        where fila=1
    order by customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Oye muy bien que uses las tablas CTES!

Por otro lado, tu caso me sirve de ejemplo para explicar la diferencia entre las funciones RANK() y ROW_NUMBER(), 
al principio parecen hacer la misma acción, pero se diferencian ligeramente en algo que te cambia el resultado.

La función ROW_NUMBER() devuelve un número contiguo y ÚNICO para cada fila dentro de una partición de ventana.
Sin embargo la función RANK(), si para una misma partición, si dos valores son iguales al ordenarlos, tienen el mismo rango o número, 
por lo que el número que devuelve RANK() no tiene por qué ser único para la partición.

Al utilizar ROW_NUMBER, hay que tener cuidado en que el orden sea único, si no fuera así nos numeraría aleatoriamente los registros, que cumplan el mismo orden.

Ahora vamos al caso del cliente A, para un mismo día, pidió CURRY y SUSHI, pero con los campos disponibles es imposible saber si uno fue antes que otro.
Queremos mostrar ambos, en este caso tenemos que hacer uso de la función de ventana RANK() ya que al revisar la columna de ordenación ORDER_DATE, 
no va a ver diferencia y va a asignar el mismo rango a ambos platos.

*/
