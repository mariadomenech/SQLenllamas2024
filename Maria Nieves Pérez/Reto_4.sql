SELECT 
    product_name AS "Producto más vendido",
    COUNT(a.product_id) AS "Cantidad"
    
FROM SQL_EN_LLAMAS.CASE01.SALES a
    INNER JOIN SQL_EN_LLAMAS.CASE01.MENU b
        ON a.product_id=b.product_id
WHERE a.product_id = (
    SELECT max(product_id) 
    FROM SQL_EN_LLAMAS.CASE01.SALES
    )
GROUP BY product_name;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
No es correcto, aunque te ha salido bien el resultado no es cierto que la subselect que usas en el where te de el producto más repetido,
tu lo que estas sacando es el maximo de los id, al ser el id 3 el ramen te sale el ramen porque 1 y 2 que son los otros id son menores.
Hay dos formas de hacerlo, una es parecido a como lo haces usando una subselect en el where pero donde te quedas con el ramen porque es el más repetido
no porque sea el del product_id más alto. La otra opción es la función ventana RANK. El uso de funciones como ROW_NUBMER, LIMIT, TOP, te darían bien el resultado
pero en caso de empate solo te sacarian uno en vez de todos. Te animo a que repitas el ejercicio. ¡Cualquier cosa que no sepas como no dudes en contactar!
*/

/*********************************/
/********** CORRECCIÓN ***********/
/*********************************/
    SELECT 
        TOP 1 product_id,
        COUNT(product_id) as cantidad
    FROM SQL_EN_LLAMAS.CASE01.SALES
    GROUP BY product_id
    ORDER BY cantidad desc;

