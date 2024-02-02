CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE03.compras_cliente_pnieto(cliente INTEGER, mes INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    importe_compras NUMBER;
    mes_escrito VARCHAR;
BEGIN
    CASE
        --Si el id del cliente no existe, devolvemos error.
        WHEN :cliente NOT IN (SELECT DISTINCT customer_id FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS) THEN
            RETURN ('El cliente con id ' || :cliente || ' no existe en la base de datos. Por favor, escoja un valor entre 1 y 500.');
        --Si el id del mes no existe, devolvemos error.
        WHEN :mes NOT BETWEEN 1 AND 12 THEN
            RETURN ('El mes con id ' || :mes || ' no existe. Por favor, escoja un valor entre 1 y 12.');
        ELSE
            --Calculamos el importe total gastado en compras por el usuario indicado en el mes escogido.
            SELECT
                NVL(SUM(txn_amount), 0) INTO importe_compras
            FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
            WHERE customer_id = :cliente
              AND EXTRACT(MONTH FROM txn_date) = :mes
              AND txn_type = 'purchase';
        
            --Escribimos el mes correspondiente al número asociado insertado como parámetro de entrada.
            SELECT DECODE(:mes, 1, 'enero', 2, 'febrero', 3, 'marzo', 4, 'abril', 5, 'mayo', 6, 'junio', 7, 'julio', 8, 'agosto', 9, 'septiembre', 10, 'octubre', 11, 'noviembre', 12, 'diciembre') INTO mes_escrito;
        
            RETURN ('El cliente ' || :cliente || ' se ha gastado un total de ' || importe_compras || ' euros en compras de productos en el mes de ' || mes_escrito || '.');
    END;
END;

--Probamos el proceso.
CALL SQL_EN_LLAMAS.CASE03.compras_cliente_pnieto(1, 3);

--Borramos el proceso.
--DROP PROCEDURE SQL_EN_LLAMAS.CASE03.compras_cliente_pnieto(INT, INT);
