/* Day 3
    Crea un procedimiento almacenado que al introducir el identificador del cliente y el mes, calcule el total de compras (purchase) 
    y que te devuelva el siguiente mensaje:
    "El cliente 1 se ha gastado un total de 1276 euros en compras de producos en el mes de marzo"
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;

CREATE OR REPLACE PROCEDURE alejandroarco_gastos_cliente_mes (c_id INTEGER, mes INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE 
    total INTEGER;
    mes_texto VARCHAR(10);
BEGIN

    SELECT SUM(txn_amount) INTO total --INTO total
    FROM customer_transactions
    WHERE customer_id = :c_id 
        AND MONTH(txn_date) = :mes
        AND txn_type = 'purchase';

    -- Texto de los meses
    SELECT CASE
        WHEN :mes = 1 
            THEN 'enero'
        WHEN :mes = 2 
            THEN 'febrero'
        WHEN :mes = 3 
            THEN 'marzo'
        WHEN :mes = '4' 
            THEN 'abril'
        ELSE TO_VARCHAR(:mes)
    END INTO mes_texto;
        
RETURN 'El cliente ' || :c_id || ' se ha gastado un total de ' || total || ' euros en compras de productos en el mes de ' || :mes_texto || '.';

END;

CALL alejandroarco_gastos_cliente_mes (429,02); -- Ejemplo
