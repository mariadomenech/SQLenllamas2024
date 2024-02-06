
CREATE OR REPLACE PROCEDURE count_duplicates_pmz(tabla VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
    /*Variable para almacenar resultado final*/
    num_dup INTEGER;

    /*Montamos la query*/
    query VARCHAR := 'SELECT COUNT(*)  - (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM sql_en_llamas.case04.' || :tabla || ')) duplicates FROM sql_en_llamas.case04.'|| :tabla;

    /*Ejecutamos la query*/
    dup RESULTSET := (EXECUTE IMMEDIATE query);

    /*Guardamos la query en un cursor*/
    c_dup CURSOR FOR dup;
BEGIN
    /*Abrimos el cursor y lo asignamos a la variable de resultado*/
    OPEN c_dup;

    FETCH c_dup INTO num_dup;
    
    /*Devuelvo el resultado*/
    RETURN 'El numero de posibles duplicados de la tabla ' || :tabla || ' es ' || num_dup;
END;

/*Duplicados tabla sales*/
CALL count_duplicates_pmz('sales');

/*Duplicados tabla product_details*/
CALL count_duplicates_pmz('product_details');

/*Duplicados tabla product_hierarchy*/
CALL count_duplicates_pmz('product_hierarchy');

/*Duplicados tabla product_prices*/
CALL count_duplicates_pmz('product_prices');
