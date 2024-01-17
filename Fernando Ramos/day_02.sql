SELECT 
      CUSTOMER_ID
    , COUNT (DISTINCT(order_date)) as Visitas_al_Restaurante
FROM SQL_EN_LLAMAS.CASE01.SALES
GROUP BY 1

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* Mismo comentario que día 01. El código es correcto, pero, ¿y si Josep considera la tabla de members como tabla maestra de clientes?

En ese caso estamos filtrando información, en concreto, el cliente D, que aunque no haya hecho ninguna compra, forma parte del conjunto de datos.

Te propongo, añadir como base (FROM) la tabla de members, y a través de LEFT JOIN añadir el resto de tablas, el uso de LEFT JOIN en vez de INNER JOIN es simplemente
para  asegurarnos de traer clientes que no tengan pedidos. Cuando se tienen modelos tan sencillos con 3 clientes y no más de 10 pedidos, es fácil ver a ojo si algo no cruza, 
pero cuando contamos con millones de registros debemos hacer uso de LEFT JOIN o RIGHT JOIN.

*/

--PROPUESTA
SELECT A.customer_id
	,COUNT(DISTINCT(S.order_date)) AS Visitas_al_Restaurante
FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES S 
    ON A.customer_id = S.customer_id
GROUP BY 1;
