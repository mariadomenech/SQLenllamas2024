USE SCHEMA SQL_EN_LLAMAS.CASE04;

CREATE OR REPLACE PROCEDURE num_duplicados_pnieto(nombre_tabla STRING)
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
    existe_tabla INT;
    num_duplicados INT;
    consulta STRING;
BEGIN
    --Comprobamos si existe la tabla
    consulta := 'SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = ''CASE04'' AND UPPER(TABLE_NAME) = UPPER(:1)';
    EXECUTE IMMEDIATE consulta USING (nombre_tabla);
    existe_tabla:= (SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())));

    -- Si no existe, devolvemos un mensaje de error.
    CASE WHEN :existe_tabla = 0 THEN
            RETURN('La tabla con nombre ' || :nombre_tabla || ' no existe.');
        ELSE
            -- Si existe, calculamos el número de tuplas que se repiten una o más veces.
            consulta := 'SELECT COUNT(*) FROM (SELECT * FROM ' || :nombre_tabla || ' GROUP BY ALL HAVING COUNT(9) > 1)';
            EXECUTE IMMEDIATE consulta USING (nombre_tabla);
            num_duplicados := (SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())));
            
            RETURN('En la tabla ' || UPPER(:nombre_tabla) || ' hay ' || num_duplicados || ' posibles duplicados.');
    END;
END;


CALL num_duplicados_pnieto('sales');

--DROP PROCEDURE num_duplicados_pnieto(STRING);
