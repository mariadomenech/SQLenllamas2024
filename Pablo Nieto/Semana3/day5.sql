--Calculamos el importe total depositado por el usuario indicado en el mes escogido.
CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE03.importe_depositado_pnieto(cliente INT, mes INT)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
    SELECT
        NVL(SUM(txn_amount), 0)
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE customer_id = cliente
      AND EXTRACT(MONTH FROM txn_date) = mes
      AND txn_type = 'deposit'
$$
;

--Calculamos el importe total gastado en compras por el usuario indicado en el mes escogido.
CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE03.importe_compras_pnieto(cliente INT, mes INT)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
    SELECT
        NVL(SUM(txn_amount), 0)
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE customer_id = cliente
      AND EXTRACT(MONTH FROM txn_date) = mes
      AND txn_type = 'purchase'
$$
;

--Calculamos el importe total retirado por el usuario indicado en el mes escogido.
CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE03.importe_retirado_pnieto(cliente INT, mes INT)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
    SELECT
        NVL(SUM(txn_amount), 0)
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE customer_id = cliente
      AND EXTRACT(MONTH FROM txn_date) = mes
      AND txn_type = 'withdrawal'
$$
;

--Calculamos el balance del usuario indicado en el mes escogido.
CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE03.importe_balance_pnieto(cliente INT, mes INT)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
    SELECT
        (SELECT NVL(SUM(txn_amount), 0)
         FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
         WHERE customer_id = cliente
           AND EXTRACT(MONTH FROM txn_date) = mes
           AND txn_type = 'deposit')
        -
        (SELECT NVL(SUM(txn_amount), 0)
         FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
         WHERE customer_id = cliente
           AND EXTRACT(MONTH FROM txn_date) = mes
           AND txn_type = 'purchase')
        -
        (SELECT NVL(SUM(txn_amount), 0)
         FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
         WHERE customer_id = cliente
           AND EXTRACT(MONTH FROM txn_date) = mes
           AND txn_type = 'withdrawal')
$$
;
    

CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE03.movimientos_cliente_pnieto(cliente INT, mes INT, movimiento INT)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    importe NUMBER;
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
            --Escribimos el mes correspondiente al número asociado insertado como parámetro de entrada.
            SELECT DECODE(:mes, 1, 'enero', 2, 'febrero', 3, 'marzo', 4, 'abril', 5, 'mayo', 6, 'junio', 7, 'julio', 8, 'agosto', 9, 'septiembre', 10, 'octubre', 11, 'noviembre', 12, 'diciembre') INTO mes_escrito;

            --Devolvemos el importe correspondiente a la opción indicada en el parámetro de entrada.
            CASE
                WHEN :movimiento = 1 THEN
                    SELECT SQL_EN_LLAMAS.CASE03.importe_balance_pnieto(:cliente, :mes) INTO importe;
                    RETURN ('El cliente ' || :cliente || ' cuenta con un balance de ' || importe || ' euros en el mes de ' || mes_escrito || '.');
                WHEN :movimiento = 2 THEN
                    SELECT SQL_EN_LLAMAS.CASE03.importe_depositado_pnieto(:cliente, :mes) INTO importe;
                    RETURN ('El cliente ' || :cliente || ' ha depositado un total de ' || importe || ' euros en el mes de ' || mes_escrito || '.');
                WHEN :movimiento = 3 THEN
                    SELECT SQL_EN_LLAMAS.CASE03.importe_compras_pnieto(:cliente, :mes) INTO importe;
                    RETURN ('El cliente ' || :cliente || ' se ha gastado un total de ' || importe || ' euros en compras de productos en el mes de ' || mes_escrito || '.');
                WHEN :movimiento = 4 THEN
                    SELECT SQL_EN_LLAMAS.CASE03.importe_retirado_pnieto(:cliente, :mes) INTO importe;
                    RETURN ('El cliente ' || :cliente || ' ha retirado un total de ' || importe || ' euros en el mes de ' || mes_escrito || '.');
                ELSE
                    RETURN('Opción inválida. Por favor, escoja 1 para conocer el balance, 2 para saber el total depositado, 3 para obtener el total gastado en compras o 4 si desea saber el importe total en retiradas.');
            END;
    END;
END;

CALL SQL_EN_LLAMAS.CASE03.movimientos_cliente_pnieto(1, 3, 1);

--DROP FUNCTION SQL_EN_LLAMAS.CASE03.importe_depositado_pnieto(INT, INT);
--DROP FUNCTION SQL_EN_LLAMAS.CASE03.importe_compras_pnieto(INT, INT);
--DROP FUNCTION SQL_EN_LLAMAS.CASE03.importe_retirado_pnieto(INT, INT);
--DROP FUNCTION SQL_EN_LLAMAS.CASE03.importe_balance_pnieto(INT, INT);
--DROP PROCEDURE SQL_EN_LLAMAS.CASE03.movimientos_cliente_pnieto(INT, INT, INT);
/*COMENTARIOS JUANPE: TODO CORRECTO*/
