USE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT M.CUSTOMER_ID, COUNT(DISTINCT S.ORDER_DATE) AS NUM_VISITS 
    FROM MEMBERS M 
    LEFT JOIN SALES S
        ON M.CUSTOMER_ID = S.CUSTOMER_ID
    GROUP BY M.CUSTOMER_ID;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Perfecto Javi, resultado correcto, joins bien montados y el hecho de especificar base de datos y esquema es un ejemplo de buenas prácticas.

Me repito quizás en el tema de las tabulaciones, a mí me resulta más fácil leer las columnas tabuladas tras cada ',', es decir, expandiría la lista de columnas a mostrar.

*/
	
