/* Day 5
    Guarda el cálculo del balance, total depositado, total de compras y total de retiros en distintas funciones y aplícalas
    en el procendimiento de ayer.
    Recordatorio: El procedimiento debe dejarnos elegir la operación, el mes y cliente.
*/

CREATE OR REPLACE FUNCTION aas_get_total_purchase(c_id INT, mes INT)
    RETURNS INT
    LANGUAGE SQL
    AS
    $$
        (SELECT 
            (NVL(SUM(txn_amount),0))
        FROM customer_transactions
        WHERE customer_id = c_id 
            AND MONTH(txn_date) = mes
            AND txn_type = 'purchase')

    $$
;

CREATE OR REPLACE FUNCTION aas_get_total_deposit(c_id INT, mes INT)
    RETURNS INT
    LANGUAGE SQL
    AS
    $$
        (SELECT 
            NVL(SUM(txn_amount),0)
        FROM customer_transactions
        WHERE customer_id = c_id 
            AND MONTH(txn_date) = mes
            AND txn_type = 'deposit')

    $$
;

CREATE OR REPLACE FUNCTION aas_get_total_withdrawal(c_id INT, mes INT)
    RETURNS INT
    LANGUAGE SQL
    AS
    $$
        (SELECT 
            NVL(SUM(txn_amount),0)
        FROM customer_transactions
        WHERE customer_id = c_id 
            AND MONTH(txn_date) = mes
            AND txn_type = 'withdrawal')

    $$
;


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

    -- Puede estar mejor si en vez de calcular siempre los 3 valores y luego mostrar lo que se pide se calculara sólo lo necesario dependiendo del caso
    -- metiendo las llamadas a las funciones en un CASE dependiendo del valor de "tipo"
            
    total_purchase  := aas_get_total_purchase(c_id, mes);
    total_deposit := aas_get_total_deposit(c_id, mes);
    total_withdrawal := aas_get_total_withdrawal(c_id, mes);
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

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

*/
