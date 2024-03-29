
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


/*
COMENTARIOS JUANPE:
Bien resuelto y correcto los resultados. Un par de cosillas, si metes mal el nombre de la tabla estaría bien que te diera un mensaje de error tipo "la tabla no existe" en lugar de fallar el proceso.
Aunque es correcto lo has resuelto en exclusividad para este esquema si alguna vez necesitas, los gestores de bbdd suelen tener una tabla intrinseca donde hay información de las tablas y los campos de la tablas
que existen: 
FROM INFORMATION_SCHEMA.COLUMNS
FROM INFORMATION_SCHEMA.TABLES
sueles ser útiles para estos casos y te ayudan a hacer cosas más genericas.
*/
