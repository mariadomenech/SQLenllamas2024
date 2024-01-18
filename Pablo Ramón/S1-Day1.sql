USE SQL_EN_LLAMAS;

SELECT  
        --IDs
        S.CUSTOMER_ID

        --Metricas
        ,SUM(M.PRICE) AS PRICE

FROM CASE01.SALES S
LEFT JOIN CASE01.MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 1;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
El Código no es del todo correcto, pues tú resultado omite un cliente que está en la tabla de clientes MEMBERS, 
pero que no está en la de pedidos SALES, es decir, no ha hecho ningún pedido (un ejemplo puede ser alguien que se
registra en la web, pero luego no llegó a realizar ningún pedido).
        
Para que la solución del todo correcta, debes usar la tabla MEMBERS, y está debiera estar en el FROM (no obligatoriamente,
pero si recomendable) teniendo está en el FROM, cruzas con SALES por medio de un LEFT JOIN y esta con MENU por medio de 
otro LEFT JOIN. 
               
Con estos cambios, ten cuenta que CUSTOMER_ID no puede venir de la tabla SALES ¿te animas a decirme por qué? :D
        
Por último, para el cliente que no ha tenido ningún pedido va a salirte un gasto NULL, pero visualmente Josep prefiere 
ver un 0 en vez de un NULL, para ello hay un algunas funciones que puedes usar: NVL() y IFNULL() por ejemplo, échales
un ojo si no las conoces.

Por último, en la SELECT has dejado algunos saltos de línea, no es recomendable eso dentro de una misma consulta, 
en algunos entornos de desarrollo podría no ejecutar. En cuanto a una línea extra para comentar los campos de la SELECT,
si quieres ponerlo para explicar algo de ese campo, yo lo pondría al final, es decir: 
    SELECT  S.CUSTOMER_ID --IDs,
            SUM(M.PRICE) AS PRICE --Metricas
    FROM .....
simplemente para tener menos lineas de código. Pero bueno esto último es una opinión completamente subjetiva. 

Te animo a que rehagas el código a continuación de este comentario. Cualquier duda no dudes en contactar.
*/

/*********************************/
/*****    COMENTARIO PABLO   *****/
/*********************************/

/*
Buenos días, código corregido.
Respecto de la pregunta "Con estos cambios, ten cuenta que CUSTOMER_ID no puede venir de la tabla SALES ¿te animas a decirme por qué? :D"
No tiene sentido cogerlo desde SALES porque solo tendremos en cuenta a los clientes que hayan realizado compras y no al total de cliente 
registrados.
Gracias!
*/

USE SQL_EN_LLAMAS;

SELECT  M.CUSTOMER_ID
        ,IFNULL((SUM(Me.PRICE)),0) AS GASTO_TOTAL 
FROM CASE01.MEMBERS M
LEFT JOIN CASE01.SALES S
    ON S.CUSTOMER_ID = M.CUSTOMER_ID
LEFT JOIN CASE01.MENU Me
    ON S.PRODUCT_ID = Me.PRODUCT_ID

GROUP BY 1;
