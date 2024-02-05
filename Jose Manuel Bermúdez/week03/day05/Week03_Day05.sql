USE SQL_EN_LLAMAS;
USE SCHEMA case03;

CREATE OR REPLACE FUNCTION JMBA_CALCULATE_EXIST_USER (custom_id INTEGER)
RETURNS INTEGER
AS
$$
	SELECT count(*) FROM customer_transactions WHERE customer_id = custom_id
$$
;

CREATE OR REPLACE FUNCTION JMBA_CALCULATE_SUM_AMOUNT_OPERATION_BY_CUSTOMERID_MONTH (custom_id INTEGER, month INTEGER, operation VARCHAR)
RETURNS NUMBER
AS
$$
	SELECT CEIL(SUM(txn_amount), 0) AS total
	FROM customer_transactions
	WHERE customer_id = custom_id AND
		month(txn_date) = month AND
		txn_type = operation
$$
;

CREATE OR REPLACE FUNCTION JMBA_CALCULATE_SUM_AMOUNT_BALANCE_BY_CUSTOMERID_MONTH (custom_id INTEGER, month INTEGER)
RETURNS NUMBER
AS
$$
	SELECT CEIL(SUM(CASE WHEN txn_type='deposit' THEN txn_amount ELSE -txn_amount END), 0) AS total
	FROM customer_transactions
	WHERE customer_id = custom_id AND
		month(txn_date) = month
$$
;

CREATE OR REPLACE PROCEDURE JMBA_CALCULATE_PURCHASES_BY_CUSTOMERID_MONTH_AND_OP_FUNCTIONS (customer_id INTEGER, month INTEGER, operation INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    message_ret VARCHAR;
	num_ocur_user INTEGER DEFAULT 0;
    total INTEGER DEFAULT 0;
BEGIN
    SELECT JMBA_CALCULATE_EXIST_USER (:customer_id) INTO :num_ocur_user;

    IF (num_ocur_user > 0) THEN
        IF (month > 0 AND month < 13) THEN
			IF (operation > 0 AND operation < 5) THEN
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

				let literal_operation varchar := decode(operation,
													1, 'balance',
													2, 'deposit',
													3, 'purchase',
													4, 'withdrawal');

				let num_op_user int :=	CASE
											WHEN operation = 1 THEN
												(SELECT count(*)
													FROM customer_transactions
													WHERE customer_id = :customer_id AND
															month(txn_date) = :month)
											WHEN operation in (2, 3, 4) THEN
												(SELECT count(*)
													FROM customer_transactions
													WHERE customer_id = :customer_id AND
															month(txn_date) = :month AND
															txn_type = :literal_operation)
										END;

				IF (num_op_user > 0) THEN
					CASE
						WHEN operation = 1 THEN
							SELECT JMBA_CALCULATE_SUM_AMOUNT_BALANCE_BY_CUSTOMERID_MONTH (:customer_id, :month) INTO :total;
						WHEN operation in (2, 3, 4) THEN
							SELECT JMBA_CALCULATE_SUM_AMOUNT_OPERATION_BY_CUSTOMERID_MONTH (:customer_id, :month, :literal_operation) INTO :total;
					END;
													
					CASE operation
						WHEN 1 THEN
							message_ret := 'El cliente ' || customer_id || ' tiene un balance total de ' || total || ' EUR en el mes de ' || literal_month || '.';
						WHEN 2 THEN
							message_ret := 'El cliente ' || customer_id || ' ha hecho depósitos por un total de ' || total || ' EUR en el mes de ' || literal_month || '.';
						WHEN 3 THEN
							message_ret := 'El cliente ' || customer_id || ' se ha gastado un total de ' || total || ' EUR en compras de productos en el mes de ' || literal_month || '.';
						WHEN 4 THEN
							message_ret := 'El cliente ' || customer_id || ' ha retirado un total de ' || total || ' EUR en el mes de ' || literal_month || '.';
						ELSE
							message_ret := '¡La operación (' || operation || ') indicada en la llamada al procedimiento almacenado no es válida (VALORES VÁLIDOS: 1-4)!';
					END;
						
				ELSE
					message_ret := '¡El cliente ' || customer_id || ' no ha realizado ninguna compra en el mes de ' || literal_month || '!';
				END IF;
			ELSE
				message_ret := '¡La operación (' || operation || ') indicada en la llamada al procedimiento almacenado no es válido (VALORES VÁLIDOS: 1-4) (1: Balance, 2: Depósitos (deposit), 3: Compras (purchase), 4: Retiros (withdrawal)))!';
			END IF;
        ELSE
            message_ret := '¡El mes (' || month || ') indicado en la llamada al procedimiento almacenado no es válido (VALORES VÁLIDOS: 1-12)!';
        END IF;
    ELSE
        message_ret := '¡El identificador del usuario (' || customer_id || ') indicado en la llamada al procedimiento almacenado no existe en la BD!';
    END IF;

    RETURN message_ret;
END;

CALL JMBA_CALCULATE_PURCHASES_BY_CUSTOMERID_MONTH_AND_OP_FUNCTIONS(429, 2, 1);
