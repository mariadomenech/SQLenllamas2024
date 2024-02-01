CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE03.compras_cliente_pnieto(cliente INTEGER, mes INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    importe_compras NUMBER;
    mes_escrito VARCHAR;
BEGIN
    --Calculamos el importe total gastado en compras por el usuario indicado en el mes escogido.
    SELECT
        NVL(SUM(txn_amount), 0) INTO :importe_compras
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE customer_id = :cliente
      AND EXTRACT(MONTH FROM txn_date) = :mes
      AND txn_type = 'purchase';

    --Escribimos el mes correspondiente al número asociado insertado como parámetro de entrada.
    SELECT DECODE(:mes, 1, 'enero', 2, 'febrero', 3, 'marzo', 4, 'abril', 5, 'mayo', 6, 'junio', 7, 'julio', 8, 'agosto', 9, 'septiembre', 10, 'octubre', 11, 'noviembre', 12, 'diciembre') INTO mes_escrito;

    RETURN ('El cliente ' || :cliente || ' se ha gastado un total de ' || :importe_compras || ' eur en compras de productos en el mes de ' || :mes_escrito || '.');
END;
