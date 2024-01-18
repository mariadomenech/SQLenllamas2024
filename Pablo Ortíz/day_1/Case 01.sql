-- Hago un join con las 3 tablas y calculo la suma del precio del producto agrupada por cada cliente
Select  c.customer_id, sum(b.price) as "Gasto total" from sales as a
join menu as b
on a.product_id=b.product_id
join members as c
on a.customer_id=c.customer_id
group by c.customer_id;


/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
El Código no es del todo correcto, pues tú resultado omite un cliente que está en la tabla de clientes MEMBERS, 
pero que no está en la de pedidos SALES, es decir, no ha hecho ningún pedido (un ejemplo puede ser alguien que se
registra en la web, pero luego no llegó a realizar ningún pedido).
        
Para que la solución del todo correcta, debes usar la tabla MEMBERS, y está debiera estar en el FROM (no obligatoriamente,
pero si recomendable, podrías ponerla como está pero con un right join) teniendo está en el FROM, cruzas con SALES por medio de un 
LEFT JOIN y esta con MENU por medio de otro LEFT JOIN y no de un JOIN a secas (JOIN = INNER JOIN). 
        
Esto último no afecta al resultado en este caso, pero te lo comento para que lo tengas en cuenta. El problema de los INNER
es que puedes perder información, este caso es cierto que no ocurre pues son tablas de pocos datos y podemos ver fácilmente
que todo está “correcto” es decir, que cada producto en la tabla SALES está en la tabla MENU, pero cuando se trabaja con 
tablas de miles de registros y no podemos verlo a ojo, es por ello por lo que se recomienda usar el LEFT JOIN para conseguir 
detectar si tienes algo que no cuadra.
             
Por último, para el cliente que no ha tenido ningún pedido va a salirte un gasto NULL, pero visualmente Josep prefiere 
ver un 0 en vez de un NULL, para ello hay un algunas funciones que puedes usar: NVL() y IFNULL() por ejemplo, échales
un ojo si no las conoces. 
        
Te animo a que rehagas el código a continuación de este comentario. Cualquier duda no dudes en contactar.

En cuanto a la "limpieza" de código, no voy a centrarme mucho (pues hay muchos criterios según cada cual) pero si te 
recomiendo que el from esta en una fila distinta a las columnas de la select.
*/
