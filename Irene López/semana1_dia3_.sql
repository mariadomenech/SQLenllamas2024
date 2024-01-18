-- ¿Cuál es el primer producto que ha pedido cada cliente?

WITH CTE AS(
    SELECT
          DISTINCT ME.CUSTOMER_ID CLIENTE
        , M.PRODUCT_NAME 
        , S.ORDER_DATE 
        , ROW_NUMBER() OVER(PARTITION BY ME.CUSTOMER_ID ORDER BY S.ORDER_DATE) AS SEQ
    FROM SALES S
        JOIN MENU M
            ON S.PRODUCT_ID = M.PRODUCT_ID
        FULL JOIN MEMBERS ME
            ON ME.CUSTOMER_ID = S.CUSTOMER_ID
    ORDER BY CLIENTE,SEQ
) 

SELECT 
     CLIENTE
    , IFNULL(PRODUCT_NAME,'No ha pedido nada aún') AS "PRIMER PRODUCTO QUE HA PEDIDO"
FROM CTE
WHERE SEQ = 1
;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Se me saltan las lagrimillas cuando alguien usa las tablas CTES! Muy bien.

Por otro lado, aparte de mis comentarios sobre los FULL JOIN (sin querer repetirme), tu caso me sirve de ejemplo para explicar la diferencia entre
las funciones RANK() y ROW_NUMBER(), al principio parecen hacer la misma acción, pero se diferencian ligeramente en algo que te cambia el resultado.

La función ROW_NUMBER() devuelve un número contiguo y ÚNICO para cada fila dentro de una partición de ventana.
Sin embargo la función RANK(), si para una misma partición, si dos valores son iguales al ordenarlos, tienen el mismo rango o número, 
por lo que el número que devuelve RANK() no tiene por qué ser único para la partición.

Al utilizar ROW_NUMBER, hay que tener cuidado en que el orden sea único, si no fuera así nos numeraría aleatoriamente los registros, que cumplan el mismo orden.

Ahora vamos al caso del cliente A, para un mismo día, pidió CURRY y SUSHI, pero con los campos disponibles es imposible saber si uno fue antes que otro.
Queremos mostrar ambos, en este caso tenemos que hacer uso de la función de ventana RANK() ya que al revisar la columna de ordenación ORDER_DATE, 
no va a ver diferencia y va a asignar el mismo rango a ambos platos.

Por último tabulaciones, en snowflake no ocurre, pero en otros gestores como ORACLE, hay que tener cuidado con los saltos de línea entre código.
Me refiero a la línea 16. Si ejecutas este código en producción te dará error porque al encontrar el salto de línea es como que hace una pausa para leer
y cree que la estructura del WITH termina en la línea 16 y no está completa.

*/
