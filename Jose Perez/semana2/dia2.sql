with runner_orders_clean as (
    select 
        order_id,
        runner_id,
        case 
            when cancellation not in ('Restaurant Cancellation', 'Customer Cancellation') then null::string
            else cancellation
        end as cancellation,
        decode(pickup_time,'null',null,pickup_time) as pickup_time,
        decode(distance, 'null',null,trim(replace(distance, 'km', '')))::number(35,2) as distance,
        decode(duration, 'null',null,trim(regexp_replace(duration,'[A-z]',' ')))::number(35,2) as duration
        
        
    from SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS

)
select 
    runner_id,
    sum(distance) as total_distance,
    (sum(distance)/sum(duration))*60 as speed_kh
from runner_orders_clean
group by 
    runner_id
;




/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

No es del todo correcto el código, se pedía velocidad promedio. Una vez que calculas los km/hora de cada pedido, haz la media por runner.

Me gusta que hayas usado expresiones regulares para limpiar los campos, también podías haber usado: REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '')!

*/

