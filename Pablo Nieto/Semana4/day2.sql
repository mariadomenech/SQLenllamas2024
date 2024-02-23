USE SCHEMA SQL_EN_LLAMAS.CASE04;

--Limpiamos la tabla quitando los duplicados.
WITH quitar_duplicados AS (
    SELECT DISTINCT
        *
    FROM SALES
),
--Escogemos los distintos productos que se venden para asignarles un nuevo id útil para resolver el ejercicio.
productos_vendidos AS (
    SELECT DISTINCT
        prod_id
    FROM quitar_duplicados
),
/*
Utilizamos las potencias de un número base, en este caso el 2, para asignar nuevos ids a los productos y que dichos 
ids puedan ser sumados. Optamos por estos ids y no por numerarlos del 1 al 12 porque así garantizamos que la suma sea 
única para cualquier conjunto de exponentes. Por tanto, si se repite, quiere decir que estamos observando la misma 
combinación de productos.
*/
nuevo_prod_id AS (
    SELECT
        prod_id,
        POWER(2, ROW_NUMBER() OVER (ORDER BY prod_id) - 1) AS nuevo_id
    FROM productos_vendidos
),
/*
Sumo los nuevos ids para obtener un pseudo-id de la transacción, con la novedad de que este id sí se repite, lo que
usaremos para encontrar la combinación más repetida de productos diferentes. Además, eliminamos aquellas transacciones 
que contengan menos de 3 productos diferentes.
*/
combinacion_id AS (
    SELECT
        qd.prod_id,
        qd.txn_id,
        SUM(npi.nuevo_id) OVER (PARTITION BY txn_id) AS combinacion_id
    FROM quitar_duplicados qd
    JOIN nuevo_prod_id npi USING (prod_id)
    QUALIFY COUNT(9) OVER (PARTITION BY txn_id) > 2
),
/*
Encontramos la combinación más frecuente contando las apariciones de cada combinacion_id y quedándonos 
con la que más veces aparece gracias a RANK (basándonos en la corrección del día 4 semana 1).
*/
combinacion_mas_frecuente AS (
    SELECT
        combinacion_id,
        COUNT(combinacion_id) AS apariciones
    FROM (SELECT txn_id, combinacion_id FROM combinacion_id GROUP BY txn_id, combinacion_id)
    GROUP BY combinacion_id
    QUALIFY RANK() OVER (ORDER BY COUNT(combinacion_id) DESC) = 1
)
/*
Finalmente, realizamos los cruces necesarios para mostrar los nombres de los productos que se han comprado
conjuntamente más veces.
*/
SELECT
    LISTAGG(DISTINCT pd.product_name, '\n') WITHIN GROUP (ORDER BY pd.product_name) AS combinacion_mas_repetida,
    cmf.apariciones
FROM combinacion_mas_frecuente cmf
JOIN combinacion_id ci USING (combinacion_id)
LEFT JOIN PRODUCT_DETAILS pd
       ON ci.prod_id = pd.product_id
GROUP BY cmf.apariciones;


/*
COMENTARIOS JUANPE:
Me has dejado sin palabras. De hecho a pesar de ser un poco enrevesada la solución es genial. No solo es buena 
porque el resultado es correcto si no por la originialidad para resolverlo, a parte de demostrar un buen manejo 
de SQL has demostrado un buen manejo de procesos lógicos/matemáticos. Es cierto que por lo general suele buscar 
sencillas pero como te digo, me ha encantado! ¡chapó!
*/
