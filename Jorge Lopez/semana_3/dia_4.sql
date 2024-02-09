/* Día 4 Evolucionar el procedimiento anterior para incluir balance y tres tipo de totales distintos por cliente y mes

La opción que más me ha costado, evidentemente, ha sido el balance. He descubierto el método COALESCE que convierte nulos en cero.
Sin su uso, había casos que se devolvían dos filas y me estaba dando error.
*/

SELECT * FROM CASE03.CUSTOMER_TRANSACTIONS;

USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;

CREATE OR REPLACE PROCEDURE jorgelopez_busca_cliente(cliente INTEGER)
    RETURNS INTEGER
    LANGUAGE SQL
AS
DECLARE 
    cliente_check INTEGER;
BEGIN
    SELECT
        DISTINCT C.CUSTOMER_ID INTO :cliente_check
    FROM 
        CASE03.CUSTOMER_TRANSACTIONS AS C
    WHERE 
        C.CUSTOMER_ID = :cliente;

    CASE 
        WHEN cliente_check IS NULL THEN cliente_check := -1;
    END CASE;
    RETURN cliente_check;
END;

CREATE OR REPLACE PROCEDURE jorgelopez_meses(mes INTEGER)
    RETURNS STRING
    LANGUAGE SQL
AS
DECLARE 
    nombre_mes STRING;
BEGIN
    nombre_mes := MONTHNAME(to_date('2020-' || mes || '-01'));
    CASE 
        WHEN nombre_mes = 'Jan' THEN nombre_mes := 'enero';
        WHEN nombre_mes = 'Feb' THEN nombre_mes := 'febrero';
        WHEN nombre_mes = 'Mar' THEN nombre_mes := 'marzo';
        WHEN nombre_mes = 'Apr' THEN nombre_mes := 'abril';
        WHEN nombre_mes = 'May' THEN nombre_mes := 'mayo';
        WHEN nombre_mes = 'Jun' THEN nombre_mes := 'junio';
        WHEN nombre_mes = 'Jul' THEN nombre_mes := 'julio';
        WHEN nombre_mes = 'Aug' THEN nombre_mes := 'agosto';
        WHEN nombre_mes = 'Sep' THEN nombre_mes := 'septiembre';
        WHEN nombre_mes = 'Oct' THEN nombre_mes := 'octubre';
        WHEN nombre_mes = 'Nov' THEN nombre_mes := 'noviembre';
        WHEN nombre_mes = 'Dec' THEN nombre_mes := 'diciembre';
        ELSE nombre_mes := CAST(mes AS STRING); 
    END CASE;
    RETURN nombre_mes;
END;

CREATE OR REPLACE PROCEDURE jorgelopez_cliente_compras(cliente INTEGER, mes INTEGER, tipo CHAR)
    RETURNS STRING
    LANGUAGE SQL
AS
DECLARE 
    primer_dia DATE;
    ultimo_dia DATE;
    total INTEGER;
    cliente_check INTEGER;
    resultado STRING;
    nombre_mes STRING;
BEGIN
    CALL jorgelopez_busca_cliente(:cliente) INTO cliente_check;
    CASE 
        WHEN mes < 1 OR mes > 12 THEN 
			resultado := 'Número de mes incorrecto.';
        WHEN cliente_check = -1 THEN 
			resultado := 'Número de cliente desconocido.';
        ELSE
            primer_dia := DATEADD(MONTH, mes - 1, '2020-01-01');
            ultimo_dia := LAST_DAY(DATEADD(MONTH, mes - 1, '2020-01-01'));
            CALL jorgelopez_meses(:mes) INTO nombre_mes;
			
            CASE 
                WHEN tipo = 'B' THEN
                    SELECT 
                    	COALESCE(SUM(COALESCE(D, 0) - COALESCE(P, 0) - COALESCE(W, 0)), 0) INTO :total
                    FROM (
                    	SELECT
                    		COALESCE(SUM(CASE WHEN C.TXN_TYPE = 'deposit' THEN C.TXN_AMOUNT ELSE 0 END), 0) AS D,
                    		COALESCE(SUM(CASE WHEN C.TXN_TYPE = 'purchase' THEN C.TXN_AMOUNT ELSE 0 END), 0) AS P,
                    		COALESCE(SUM(CASE WHEN C.TXN_TYPE = 'withdrawal' THEN C.TXN_AMOUNT ELSE 0 END), 0) AS W
                    	FROM CASE03.CUSTOMER_TRANSACTIONS AS C
                    	WHERE C.CUSTOMER_ID = :cliente 
                        AND C.TXN_DATE BETWEEN :primer_dia AND :ultimo_dia
                    	GROUP BY C.TXN_TYPE);
                WHEN tipo = 'D' THEN
                    SELECT 
                        SUM(C.TXN_AMOUNT) INTO :total
                    FROM 
                        CASE03.CUSTOMER_TRANSACTIONS AS C
                    WHERE 
                        C.CUSTOMER_ID = :cliente AND
                        C.TXN_TYPE = 'deposit' AND
                        C.TXN_DATE BETWEEN :primer_dia AND :ultimo_dia;
                WHEN tipo = 'C'THEN
                    SELECT 
                        SUM(C.TXN_AMOUNT) INTO :total
                    FROM 
                        CASE03.CUSTOMER_TRANSACTIONS AS C
                    WHERE 
                        C.CUSTOMER_ID = :cliente AND
                        C.TXN_TYPE = 'purchase' AND
                        C.TXN_DATE BETWEEN :primer_dia AND :ultimo_dia;
                WHEN tipo = 'R' THEN
                    SELECT 
                        SUM(C.TXN_AMOUNT) INTO :total
                    FROM 
                        CASE03.CUSTOMER_TRANSACTIONS AS C
                    WHERE 
                        C.CUSTOMER_ID = :cliente AND
                        C.TXN_TYPE = 'withdrawal' AND
                        C.TXN_DATE BETWEEN :primer_dia AND :ultimo_dia;
            END CASE;
                                
            CASE
                WHEN tipo = 'B' AND total = 0 THEN resultado := 'El cliente '|| cliente || ' no tiene un balance para el mes de ' || nombre_mes ||'.';
                WHEN tipo = 'B' AND total IS NOT NULL THEN resultado := 'El cliente '|| cliente || ' tiene un balance de ' || total ||' EUR en el mes de ' || nombre_mes ||'.';
                
                WHEN tipo = 'D' AND total IS NULL THEN resultado := 'El cliente '|| cliente || ' no ha realizado depósitos durante el mes de ' || nombre_mes ||'.';
                WHEN tipo = 'D' AND total IS NOT NULL THEN  resultado := 'El cliente ' || cliente || ' ha realizado un total de ' || total || ' EUR en depósitos en el mes de ' || nombre_mes || '.';
            
                WHEN tipo = 'C' AND total IS NULL THEN resultado := 'El cliente '|| cliente || ' no ha realizado compras durante el mes de ' || nombre_mes ||'.';
                WHEN tipo = 'C' AND total IS NOT NULL THEN  resultado := 'El cliente ' || cliente || ' se ha gastado un total de ' || total || ' EUR en compras de productos en el mes de ' || nombre_mes || '.';

                WHEN tipo = 'R' AND total IS NULL THEN resultado := 'El cliente '|| cliente || ' no ha retirado durante el mes de ' || nombre_mes ||'.';
                WHEN tipo = 'R' AND total IS NOT NULL THEN  resultado := 'El cliente ' || cliente || ' ha retirado un total de ' || total || ' EUR en el mes de ' || nombre_mes || '.';

                ELSE resultado := 'Opción incorrecta';
                
            END CASE;
    END CASE;
    RETURN resultado;
END;

--EJEMPLOS:

CALL jorgelopez_cliente_compras(422342349,8,'B'); -- Número de cliente erróneo.
CALL jorgelopez_cliente_compras(429,15,'C'); -- Número de mes erróneo.
CALL jorgelopez_cliente_compras(429,1,'K'); -- Opción incorrecta.

CALL jorgelopez_cliente_compras(429,1,'B'); -- Con valor positivo en balance para un mes.
CALL jorgelopez_cliente_compras(429,3,'B'); -- Con valor negativo en balance para un mes.
CALL jorgelopez_cliente_compras(429,8,'B'); -- Sin valor en balance para un mes.

CALL jorgelopez_cliente_compras(429,2,'D'); -- Cliente con depositos para ese mes.
CALL jorgelopez_cliente_compras(429,8,'D'); -- Cliente sin depositos para ese mes.

CALL jorgelopez_cliente_compras(429,2,'C'); -- Cliente con compras para ese mes.
CALL jorgelopez_cliente_compras(429,8,'C'); -- Cliente sin compras para ese mes.

CALL jorgelopez_cliente_compras(429,3,'R'); -- Cliente con retiros para ese mes.
CALL jorgelopez_cliente_compras(429,8,'R'); -- Cliente sin retiros para ese mes.
