USE SQL_EN_LLAMAS;
USE SCHEMA case04;

CREATE OR REPLACE PROCEDURE JMBA_CALCULATE_NUM_POSSIBLE_DUPLICATES_TABLE (table_name VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    message_ret VARCHAR;
    num_duplicate_records INTEGER DEFAULT 0;
BEGIN
    let table_exist int :=  (SELECT COUNT(*)
								FROM INFORMATION_SCHEMA.TABLES
								WHERE table_catalog = 'SQL_EN_LLAMAS' AND
										table_schema = 'CASE04' AND
										table_name = upper(:table_name));

	IF (table_exist > 0) THEN
		let table_columns varchar := (SELECT listagg(column_name, ', ')
										FROM INFORMATION_SCHEMA.COLUMNS
										WHERE table_catalog = 'SQL_EN_LLAMAS' AND
										table_schema = 'CASE04' AND
										table_name = upper(:table_name));

        let query varchar := 'SELECT ' || table_columns || ',' ||
                                        ' COUNT(*)' ||
                                ' FROM ' || table_name ||
                                ' GROUP BY ' || table_columns ||
                                ' HAVING COUNT(*) > 1';

        EXECUTE IMMEDIATE query;

        SELECT count(*) INTO num_duplicate_records
		FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
        
		IF (num_duplicate_records > 0) THEN
			message_ret := 'La tabla \'' || :table_name || '\' contiene ' || num_duplicate_records || ' registros duplicados.';
		ELSE
			message_ret := 'La tabla \'' || :table_name || '\' no tiene ningún registro duplicado.';
		END IF;
	ELSE
		message_ret := 'La tabla \'' || :table_name || '\' no existe en la base de datos.';
	END IF;
	
	RETURN message_ret;
END;

CALL JMBA_CALCULATE_NUM_POSSIBLE_DUPLICATES_TABLE('sales');

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto!

*/
