-- ¿Cuántos días ha visitado el restaurante cada cliente?
SELECT 
    ME.CUSTOMER_ID CLIENTE,
    COUNT(DISTINCT ORDER_DATE) DIAS_VISITADOS
FROM
    SQL_EN_LLAMAS.CASE01.MEMBERS ME -- Dimensión principal de la que se parte. Luego sólo hace falta un LEFT JOIN
    LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES S
        ON ME.CUSTOMER_ID = S.CUSTOMER_ID
GROUP BY ME.CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

El resultado es completamente correcto pero tengo sentimientos encontrados con el FULL JOIN, como en el anterior ejercicio.

*/
