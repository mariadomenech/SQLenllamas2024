
-- Procedure

create or replace procedure bcm_duplicidades(tabla char(20))
returns varchar
language sql
execute as owner
as
declare 
    conteo int;
    list_variables varchar;
    query string;
    
begin 

    select listagg(column_name,',')
    into list_variables
    from information_schema.columns
    where lower(table_catalog) = 'sql_en_llamas'
        and lower(table_schema) = 'case04'
        and lower(table_name) = :tabla;

    query := '
        select 
            count(*) as conteo
        from (
            select '||list_variables||'
            ,count(*) as conteo
            from '||:tabla||'
            group by '||list_variables||'
            having count(*) > 1
            )';

    execute immediate query; 

    conteo := (select conteo from table(result_scan(last_query_id())));
    
    case
        when conteo != 0
            then return 'Hay '||conteo||' registros duplicados en la tabla '||upper(:tabla)||'.';
        
        else return 'No hay ningún registro duplicado en la tabla '||upper(:tabla)||'.';
    end case;

end;

-- Pruebas

call bcm_duplicidades('product_details');
call bcm_duplicidades('sales');
