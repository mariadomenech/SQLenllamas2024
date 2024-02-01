USE SQL_EN_LLAMAS; 
USE SCHEMA CASE03;

CREATE OR REPLACE PROCEDURE MNievesPerez_compras_por_cliente_mes (cliente INT, mes INT)
RETURNS VARCHAR 
LANGUAGE SQL
AS
DECLARE 
    mensaje VARCHAR;
BEGIN

    SELECT 
        concat('El cliente ', cliente, ' se ha gastado un total de ', total_euros, ' EUR en compras de productos en el mes de ', nombre_mes, '.') INTO mensaje
    FROM
    (
        SELECT 
            DISTINCT customer_id AS cliente,
            month (txn_date)::int AS mes,
            CASE 
                WHEN (month (txn_date)::int) = 1 THEN 'Enero'
                WHEN (month (txn_date)::int) = 2 THEN 'Febrero'
                WHEN (month (txn_date)::int) = 3 THEN 'Marzo'
                WHEN (month (txn_date)::int) = 4 THEN 'Abril' END AS nombre_mes,
            sum(txn_amount) AS total_euros
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
        WHERE txn_TYPE = 'purchase' AND EXTRACT (MONTH FROM txn_date) = CAST (mes AS INT)
        GROUP BY cliente, mes
        ORDER BY cliente, mes
    )
    WHERE cliente = :cliente AND mes = :mes;
    
    RETURN mensaje;

END;


CALL MNievesPerez_compras_por_cliente_mes (6,3);
