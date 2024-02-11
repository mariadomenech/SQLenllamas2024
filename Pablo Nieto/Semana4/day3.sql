USE SCHEMA SQL_EN_LLAMAS.CASE04;

/*
Renombramos las columnas para que sean iguales que las de la tabla de PRODUCT_DETAILS. 
La clave en este ejercicio reside en realizar varios cruces con la tabla de PRODUCTS_HIERARCHY 
haciendo coincidir el parent_id de la primera tabla con el id de la segunda y así obtener toda 
la información necesaria.
*/
SELECT
    pp.product_id,
    pp.price,
    CONCAT(ph1.level_text || ' ' || ph2.level_text || ' - ' || ph3.level_text) AS product_name,
    ph2.parent_id AS category_id,
    ph1.parent_id AS segment_id,
    ph1.id AS style_id,
    ph3.level_text AS category_name,
    ph2.level_text AS segment_name,
    ph1.level_text AS style_name
FROM PRODUCT_HIERARCHY ph1
JOIN PRODUCT_PRICES pp USING (id)
JOIN PRODUCT_HIERARCHY ph2
  ON ph1.parent_id = ph2.id
JOIN PRODUCT_HIERARCHY ph3
  ON ph2.parent_id = ph3.id;
