/* Day 4
    Evoluciona el procedimiento de ayer para que podamos elegir el tipo de cálculo que nos devuelva por mes y cliente:
    - Balance: depósito - compra - retiro
    - Total depositado
    - Total de compras
    - Total de retiros
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;

CREATE OR REPLACE PROCEDURE alejandroarco_gastos_cliente_mes_detalles (c_id INTEGER, mes INTEGER, tipo VARCHAR(10))
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    mensaje VARCHAR(200);
    total_purchase INTEGER;
    total_deposit INTEGER;
    total_withdrawal INTEGER;
    balance INTEGER;
    mes_texto VARCHAR(10);
BEGIN

    SELECT NVL(SUM(txn_amount),0) INTO total_purchase
    FROM customer_transactions
    WHERE customer_id = :c_id 
        AND MONTH(txn_date) = :mes
        AND txn_type = 'purchase';


    SELECT NVL(SUM(txn_amount),0) INTO total_deposit
    FROM customer_transactions
    WHERE customer_id = :c_id 
        AND MONTH(txn_date) = :mes
        AND txn_type = 'deposit';

    SELECT NVL(SUM(txn_amount),0) INTO total_withdrawal
    FROM customer_transactions
    WHERE customer_id = :c_id 
        AND MONTH(txn_date) = :mes
        AND txn_type = 'withdrawal';
            
    balance := total_deposit - total_purchase - total_withdrawal;
    
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
    
    SELECT CASE
        WHEN :tipo = 'purchase' 
            THEN 'El cliente ' || :c_id || ' se ha gastado un total de ' || :total_purchase || ' euros en compras de productos en el mes de ' || :mes_texto || '.'
        WHEN :tipo = 'deposit' 
            THEN 'El cliente ' || :c_id || ' ha depositado un total de ' || :total_deposit || ' euros en el mes de ' || :mes_texto || '.'
        WHEN :tipo = 'withdrawal' 
            THEN 'El cliente ' || :c_id || ' ha retirado un total de ' || :total_withdrawal || ' euros en el mes de ' || :mes_texto || '.'
        WHEN :tipo = 'balance' 
            THEN 'El cliente ' || :c_id || ' tiene un balance de ' || :balance || ' euros en el mes de ' || :mes_texto || '. Depósito: ' || :total_deposit ||
                ', gastos: ' || :total_purchase || ' y retirado: ' || :total_withdrawal
        ELSE 'Tipo incorrecto'
    END INTO mensaje;
    
RETURN mensaje;

END;

CALL alejandroarco_gastos_cliente_mes_detalles (1,03,'balance'); -- Ejemplo