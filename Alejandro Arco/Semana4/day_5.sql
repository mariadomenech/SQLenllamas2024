/* Day 5
    Crea una función que, introduciendo una categoría y segmento,
    muestre el producto más vendido de cada categoría y segmento.
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE04;

CREATE OR REPLACE FUNCTION producto_mas_vendido_aas(categoria STRING, segmento STRING)
    RETURNS TABLE (producto STRING, cantidad INT)
    AS
        $$
            SELECT TOP 1
                p.product_name AS nombre_producto,
                SUM(s.qty) AS cantidad_productos
            FROM sales as s
            LEFT JOIN product_details AS p
            ON s.prod_id = p.product_id
            WHERE category_name = categoria
                AND segment_name = segmento
            GROUP BY p.product_name
            ORDER BY SUM(s.qty) DESC
        $$
;

SELECT * FROM TABLE(producto_mas_vendido_aas('Mens', 'Shirt'));