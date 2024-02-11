
/*
create or replace temporary table especialidad_sql_bronze_db_beacruz.reto.tabla_global as   
con esa consulta me sale que no tengo permisos así que he tenido que crear la tabla así:
*/

--drop table beacruz
create or replace temp table beacruz as -- la he borrado para que no haya problemas
select
    customer_id,
    month(txn_date) as mes,
    decode(mes,
            1,'enero',
            2,'febrero',
            3,'marzo',
            4,'abril',
            5,'mayo',
            6,'junio',
            7,'julio',
            8,'agosto',
            9,'septiembre',
            10,'octubre',
            11,'noviembre',
            12,'diciembre') as nom_mes,
    zeroifnull(sum(txn_amount)) as total_compras
from customer_transactions
where txn_type = 'purchase'
group by customer_id,month(txn_date);

-- Procedure

create or replace procedure bcm_compras_por_cust_mes(cliente int,mes varchar)
returns varchar
language sql
as
declare 
    total_compras int;
    nombre_mes char(10);
    customer int;
  
begin 

    select
        distinct customer_id
    into customer
    from beacruz
    where customer_id = :cliente;

    select 
        distinct nom_mes
    into nombre_mes
    from beacruz
    where mes = :mes;

    select 
        total_compras
    into total_compras
    from beacruz
    where customer_id = :cliente
        and mes = :mes;
    
    case
        when customer is null
            then return 'El cliente '||cliente||' no existe.';
        when nombre_mes is null or (nombre_mes is not null and total_compras is null)
            then return 'El cliente '||cliente||' no se ha gastado nada en compras de productos en '||:nombre_mes||'.';
        when customer is not null and nombre_mes is not null and total_compras != 0
            then return 'El cliente '||cliente||' se ha gastado un total de '||:total_compras||' eur en compras de productos en el mes de '||:nombre_mes||'.';
        else return 'Error';
    end case;

end;

-- Pruebas

call bcm_compras_por_cust_mes(429,1);
call bcm_compras_por_cust_mes(0,1);
call bcm_compras_por_cust_mes(1,3);