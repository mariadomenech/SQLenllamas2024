CREATE OR REPLACE PROCEDURE DBM(customer_id INT, mes VARCHAR, tipo_calculo VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    total_compras FLOAT,
    total_depositado FLOAT,
    total_retiros FLOAT, 
    balance FLOAT;
BEGIN
    -- Calcular el total de compras
    SELECT
        SUM(a.txn_amount) INTO total_compras,
        SUM()
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS AS a
    WHERE a.customer_id = :customer_id AND
    MONTHNAME(a.txn_date) = :mes AND
    a.txn_type = 'purchase';
    
    -- Devolver el mensaje
    RETURN 'El cliente ' || :customer_id || ' se ha gastado un total de ' || total_compras || ' eur en compras de productos en el mes de ' || :mes;
END;
$$;
