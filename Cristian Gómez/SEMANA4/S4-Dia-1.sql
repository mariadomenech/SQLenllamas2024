CREATE OR REPLACE PROCEDURE cristian_checkduplicados(TABLA STRING)
    RETURNS VARCHAR
    LANGUAGE SQL
    EXECUTE AS CALLER
AS
DECLARE
    MENSAJE STRING;
    DUPLICADOS INT;
BEGIN
    CASE 
        WHEN UPPER(TABLA) = 'SALES' THEN 
            SELECT COUNT(*) INTO DUPLICADOS
            FROM (
                SELECT * 
                FROM SALES
                GROUP BY 1,2,3,4,5,6,7  
                HAVING COUNT(*) > 1 
            );
            
        WHEN UPPER(TABLA) = 'PRODUCT_DETAILS' THEN 
            SELECT COUNT(*) INTO DUPLICADOS
            FROM (
                SELECT * 
                FROM PRODUCT_DETAILS 
                GROUP BY 1,2,3,4,5,6,7,8,9 -- 
                HAVING COUNT(*) > 1 
            );
            
        ELSE 
            DUPLICADOS := -5; -- negativo si no se encuentra ninguna tabla 
    END CASE;

    CASE 
        WHEN DUPLICADOS = -5 THEN 
            MENSAJE:= 'No se encuentran datos de esa tabla o el nombre es incorrecto';
        ELSE 
            MENSAJE := 'La cantidad de posibles duplicados 1 o más veces es ' ||DUPLICADOS||'.';
    END CASE;

    RETURN MENSAJE;
END;

CALL cristian_checkduplicados('Sales')
