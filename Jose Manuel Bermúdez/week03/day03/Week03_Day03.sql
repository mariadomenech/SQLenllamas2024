USE SQL_EN_LLAMAS;
USE SCHEMA case03;

CREATE OR REPLACE PROCEDURE JMBA_CALCULATE_PURCHASES_BY_CUSTOMERID_AND_MONTH (customer_id INTEGER, month INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    message_ret VARCHAR;
    total INTEGER DEFAULT 0;
BEGIN
    let num_ocur_user int := (SELECT count(*) FROM customer_transactions WHERE customer_id = :customer_id);

    IF (num_ocur_user > 0) THEN
        IF (month > 0 AND month < 13) THEN
            let literal_month varchar := decode(month,
                                                1, 'Enero',
                                                2, 'Febrero',
                                                3, 'Marzo',
                                                4, 'Abril',
                                                5, 'Mayo',
                                                6, 'Junio',
                                                7, 'Julio',
                                                8, 'Agosto',
                                                9, 'Septiembre',
                                                10, 'Octubre',
                                                11, 'Noviembre',
                                                12, 'Diciembre');
        
            let num_purch_user int := (SELECT count(*)
                                        FROM customer_transactions
                                        WHERE customer_id = :customer_id AND
                                                txn_type = 'purchase' AND
                                                month(txn_date) = :month);

            IF (num_purch_user > 0) THEN
                SELECT sum(txn_amount) INTO total
                FROM customer_transactions
                WHERE customer_id = :customer_id AND
                        txn_type = 'purchase' AND
                        month(txn_date) = :month;
                    
                message_ret := 'El cliente ' || customer_id || ' se ha gastado un total de ' || total || ' EUR en compras de productos en el mes de ' || literal_month || '.';
            ELSE
                message_ret := '¡El cliente ' || customer_id || ' no ha realizado ninguna compra en el mes de ' || literal_month || '!';
            END IF;
        ELSE
            message_ret := '¡El mes (' || month || ') indicado en la llamada al procedimiento almacenado no es válido (VALORES VÁLIDOS: 1-12)!';
        END IF;
    ELSE
        message_ret := '¡El identificador del usuario (' || customer_id || ') indicado en la llamada al procedimiento almacenado no existe en la BD!';
    END IF;

    RETURN message_ret;
END;

CALL JMBA_CALCULATE_PURCHASES_BY_CUSTOMERID_AND_MONTH(429, 2);