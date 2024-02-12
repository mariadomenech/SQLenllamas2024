USE SCHEMA SQL_EN_LLAMAS.CASE04;

CREATE OR REPLACE FUNCTION producto_mas_vendido_pnieto(cat_id INT, seg_id INT)
RETURNS TABLE(product_name VARCHAR, cantidad_vendida INT)
LANGUAGE SQL
AS
$$
    /*
    Escogemos el nombre del producto más vendido para una categoría y segmento concretos 
    realizando un cruce de tablas por el id, la categoría y el segmento, y empleando la función de ventana RANK.
    */
    SELECT
        pd.product_name,
        SUM(s.qty) AS cantidad_vendida
    FROM SALES s
    JOIN product_details pd
      ON s.prod_id = pd.product_id
     AND pd.category_id = cat_id
     AND pd.segment_id = seg_id
    GROUP BY pd.product_name
    QUALIFY RANK() OVER (ORDER BY SUM(s.qty) DESC) = 1
$$;

SELECT * FROM TABLE(producto_mas_vendido_pnieto(2, 5));

--DROP FUNCTION producto_mas_vendido_pnieto(INT, INT);
