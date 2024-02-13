select 
    a.runner_id,
    ifnull(b.distancia_acum_km,0) as distancia_acum_km,
    ifnull(b.vel_promedio_km_h,0) as vel_promedio_km_h
from runners a
left join (
    select 
        runner_id,
        sum(distancia_km) as distancia_acum_km,
        round(sum(distancia_km)/(sum(duracion_min)/60),2) as vel_promedio_km_h
    from (
        select 
            runner_id,
            order_id,
            distance,
            duration,
            iff(distance = 'null',null,REGEXP_REPLACE(distance, '[^0-9.]', '')) AS distancia_km,
            iff(distance = 'null',null,REGEXP_REPLACE(duration, '[^0-9.]', '')) as duracion_min
        from runner_orders
        order by runner_id
        )
    group by runner_id
    ) b
    on a.runner_id = b.runner_id

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto del todo, ya que la parte de la velocidad promedio no es correcta. Quitando ese detalle, todo esta correcto.
Esto se debe a que consideras que la velocidad promedio es la distancia promedio entre el tiempo promedio, pero no es así. (Reflexión de Juanpe)

*/
