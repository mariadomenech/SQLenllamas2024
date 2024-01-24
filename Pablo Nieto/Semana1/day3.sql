/*Primer día que visita cada cliente el restaurante*/
WITH first_visit AS (
    SELECT
        mb.customer_id,
        nvl(MIN(s.order_date), '01/01/0001') AS first_day
    FROM SQL_EN_LLAMAS.CASE01.MEMBERS mb
    LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES s
           ON s.customer_id = mb.customer_id
    GROUP BY 1
),
/*Primer/os producto/s que ha pedido cada cliente*/
first_product AS (
    SELECT 
        fv.customer_id,
        nvl(mn.product_name, 'sin pedidos') AS first_product
    FROM first_visit fv
    LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES s
           ON fv.customer_id = s.customer_id
          AND fv.first_day = s.order_date
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU mn
           ON s.product_id = mn.product_id
)
SELECT * FROM first_product;

/*No sé cómo mostrar una única fila por usuario (supongo que habría que usar PIVOT) pero entonces, si pienso en un conjunto con muchos datos,
debo saber el número exacto de productos, ¿no? Si lo supiera, tendría una columna por producto más una al final que se llame "Sin pedidos" o algo
por el estilo pero, ¿no sería tedioso ir mirando si has pedido o no un producto concreto?*/


/*
JUANPE: Sí un pivot aquí sería muy tedioso pero si que hay una función que te permite agrupar en una única fila, la función LISTAGG.

LISTAGG(nvl(mn.product_name, 'sin pedidos'),', ') y como está es una función de agregación necesitas GROUP BY fv.customer_id.

Esta función te agrupa por los campos que pidas en el GROUP BY. Y la función a parte del campo que queremos que ponga en una lista 
te permite opcionalmente ponerle un separado, por eso la coma entre comillas también te admite un distinct de esta forma 
LISTAGG(DISTINCT campo, 'separador') pero en este caso si usas el distinct perderiamos la información de que el cliente C, pidió dos ramen.

Esta era la función que buscabamos en este ejercio, espero que a partir de ahora no se te olvide :)

Adicionalmente los resultados se pueden mostrar de una forma "más rebuscada" si tienes interés en esto no dudes en preguntarme.
*/
