CREATE OR REPLACE PROCEDURE sql_en_llamas.case03.dia3_jperez (customer_id INT, search_month int)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS 
DECLARE
    purchase_number NUMBER;
    MESSAGE VARCHAR;
BEGIN
    let exists_user int := (select count(*) from SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS where customer_id = :customer_id);
    
    
    if (exists_user = 0 ) then
        message := 'No existe el usuario con el id ' || :customer_id;
        
    elseif (search_month < 1 or search_month > 12) then
        message := 'El mes no es valido';
        
    else 
        select
            nvl(sum(txn_amount), 0) into purchase_number
        from 
            SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS 
        where 
            txn_type = 'purchase' 
            and customer_id = :customer_id 
            and split_part(txn_date,'-',2)::int = :search_month;
            
        let month_spanish varchar := decode(:search_month,
                                            1,'Enero',
                                            2,'Febrero',
                                            3,'Marzo',
                                            4,'Abril',
                                            5,'Mayo',
                                            6,'Junio',
                                            7,'Julio',
                                            8,'Agosto',
                                            9,'Septiembre',
                                            10,'Octubre',
                                            11,'Noviembre',
                                            12,'Diciembre'
                                        );  
        message := 'El cliente '|| :customer_id ||' se ha gastado un total de ' || :purchase_number || '€ en el mes de ' || :month_spanish ;
    end if;
    --if (purchase_number) 
    return message;
END;
