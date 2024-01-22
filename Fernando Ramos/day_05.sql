with puntos as (
    select
          product_id
        , product_name
        , price
        , case
            when product_name = 'sushi' then price*10*2
            else price*10
          end
          as puntos
    from SQL_EN_LLAMAS.CASE01.MENU
),

total_gastado as (
    select
          customer_id
        , sum (puntos) as total_puntos
    from SQL_EN_LLAMAS.CASE01.SALES s
    join puntos p
        on s.product_id = p.product_id
    group by customer_id
),

clientes as (
    select
            m.customer_id
          , total_puntos as puntos_acumulados
    from SQL_EN_LLAMAS.CASE01.MEMBERS m
    left join total_gastado tg
        on tg.customer_id = m.customer_id
)

select * from clientes


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto Fernando, buen uso de las tablas CTEs!!

Para que la visualización del resultado quede perfecta, añadiría un CASE WHEN o IFNULL para que cuando el cliente D 
no cruce con ''total_gastado'', no muestre un NULL en la sumatoria, sino un 0. Me gusta que si una columna es de tipo númerico
y encima de importes, los nulos sean considerados como importe 0.

*/
