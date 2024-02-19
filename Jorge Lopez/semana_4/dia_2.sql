/*Día 2: ¿Cuál es la combinación de productos distintos más repetida por cada compra? Mínimo tres productos por compra.

No tengo mucho que explicar. Me has ido enseñando y ayudando varios días durante todo el proceso.*/

SELECT *
FROM 
    (SELECT
        LISTADO,
        COUNT(*) AS PROD_REP,
        DENSE_RANK() OVER (ORDER BY PROD_REP DESC) AS RANKING
    FROM 
        (SELECT
            S.TXN_ID,
            COUNT(DISTINCT S.PROD_ID) AS DIFF_PRODUCT,
            LISTAGG(DISTINCT P.PRODUCT_NAME, ' || ') WITHIN GROUP (ORDER BY P.PRODUCT_NAME) AS LISTADO
        FROM
            CASE04.SALES AS S
            RIGHT JOIN CASE04.PRODUCT_DETAILS AS P ON S.PROD_ID = P.PRODUCT_ID
        GROUP BY
            S.TXN_ID
        HAVING
            DIFF_PRODUCT >= 3)
    GROUP BY
        LISTADO)
WHERE
    RANKING = 1;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto Jorge, pero ten cuidado!! estás trabajando con uan tabla con duplicados. No deberías de haberla limpiado primero? aún así el resultado es correcto.

*/
