
/*
create or replace temporary table especialidad_sql_bronze_db_beacruz.reto.tabla_global as   
con esa consulta me sale que no tengo permisos así que he tenido que crear la tabla así:
*/

-- Tabla
create or replace temp table tabla_global as -- la he borrado para que no haya problemas
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
    iff(txn_type = 'deposit',txn_amount,0) as deposit,
    iff(txn_type = 'purchase',txn_amount,0) as purchase,
    iff(txn_type = 'withdrawal',txn_amount,0) as withdrawal
from customer_transactions;
--drop table tabla_global

-- Function -> BALANCE

create or replace function sql_en_llamas.case03.bcm_balance (cliente int, num_mes int)
returns number  
as
$$

    select 
        (zeroifnull(sum(deposit)) - zeroifnull(sum(purchase)) - zeroifnull(sum(withdrawal))) as balance
    from tabla_global
    where customer_id = cliente
        and mes = num_mes

$$
;

-- Function -> DEPOSITADO

create or replace function sql_en_llamas.case03.bcm_depositado (cliente int, num_mes int)
returns number  
as
$$

    select 
        zeroifnull(sum(deposit)) as total_depositado
    from tabla_global
    where customer_id = cliente
        and mes = num_mes

$$
;

-- Function -> COMPRAS

create or replace function sql_en_llamas.case03.bcm_compras (cliente int, num_mes int)
returns number  
as
$$

    select 
        zeroifnull(sum(purchase)) as total_compras
    from tabla_global
    where customer_id = cliente
        and mes = num_mes

$$
;

-- Function -> RETIROS

create or replace function sql_en_llamas.case03.bcm_retiros (cliente int, num_mes int)
returns number  
as
$$

    select 
        zeroifnull(sum(withdrawal)) as total_retiros
    from tabla_global
    where customer_id = cliente
        and mes = num_mes

$$
;

-- Procedure

create or replace procedure bcm_funcion_por_cust_mes(cliente int,mes int,tipo_calculo char(10))
returns varchar
language sql
as
declare 
    balance int;
    total_depositado int;
    total_compras int;
    total_retiros int;
    nombre_mes char(10);
    customer int;
  
begin 
    
    select
        distinct customer_id
    into customer
    from tabla_global
    where customer_id = :cliente;

    select 
        distinct nom_mes
    into nombre_mes
    from tabla_global
    where mes = :mes;

    select sql_en_llamas.case03.bcm_balance (:cliente,:mes)
    into balance;

    select sql_en_llamas.case03.bcm_depositado (:cliente,:mes)
    into total_depositado;

    select sql_en_llamas.case03.bcm_compras (:cliente,:mes)
    into total_compras;

    select sql_en_llamas.case03.bcm_retiros (:cliente,:mes)
    into total_retiros;
    
    case
        when customer is null
            then return 'El cliente '||cliente||' no existe.';
            
        when customer is not null and nombre_mes is not null and tipo_calculo = 'balance' and balance != 0
            then return 'El cliente '||cliente||' tiene un balance de '||:balance||' eur en el mes de '||:nombre_mes||'.';
        when customer is not null and nombre_mes is not null and tipo_calculo = 'balance' and balance = 0
            then return 'El cliente '||cliente||' no tiene balance en el mes de '||:nombre_mes||'.';
            
        when customer is not null and nombre_mes is not null and tipo_calculo = 'deposito' and total_depositado != 0
            then return 'El cliente '||cliente||' ha depositado un total de '||:total_depositado||' eur en el mes de '||:nombre_mes||'.';
        when customer is not null and nombre_mes is not null and tipo_calculo = 'deposito' and total_depositado = 0
            then return 'El cliente '||cliente||' no ha depositado nada en el mes de '||:nombre_mes||'.';

        when customer is not null and nombre_mes is not null and tipo_calculo = 'compras' and total_compras != 0
            then return 'El cliente '||cliente||' ha gastado un total de '||:total_compras||' eur en compras de productos en el mes de '||:nombre_mes||'.';
        when customer is not null and nombre_mes is not null and tipo_calculo = 'compras' and total_compras = 0
            then return 'El cliente '||cliente||' no se ha gastado nada en compras de productos en el mes de '||:nombre_mes||'.';

        when customer is not null and nombre_mes is not null and tipo_calculo = 'retiros' and total_retiros != 0
            then return 'El cliente '||cliente||' ha retirado un total de '||:total_retiros||' eur en el mes de '||:nombre_mes||'.';
        when customer is not null and nombre_mes is not null and tipo_calculo = 'retiros' and total_retiros = 0
            then return 'El cliente '||cliente||' no ha retirado nada en el mes de '||:nombre_mes||'.';
        
        else return 'Error';
    end case;

end;

-- Pruebas

call bcm_funcion_por_cust_mes(429,1,'balance');
call bcm_funcion_por_cust_mes(0,1,'balance');
call bcm_funcion_por_cust_mes(1,3,'balance');

call bcm_funcion_por_cust_mes(429,1,'deposito');
call bcm_funcion_por_cust_mes(0,1,'deposito');
call bcm_funcion_por_cust_mes(1,3,'deposito');

call bcm_funcion_por_cust_mes(429,1,'compras');
call bcm_funcion_por_cust_mes(0,1,'compras');
call bcm_funcion_por_cust_mes(1,3,'compras');

call bcm_funcion_por_cust_mes(429,1,'retiros');
call bcm_funcion_por_cust_mes(0,1,'retiros');
call bcm_funcion_por_cust_mes(1,3,'retiros');

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. 

*/
