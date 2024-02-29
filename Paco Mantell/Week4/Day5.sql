



/* Funcion para el calculo del procuto mas vendido por segmento y categoria*/
CREATE OR REPLACE FUNCTION top_product_pmz(category VARCHAR, segment VARCHAR)
RETURNS TABLE(category VARCHAR, segment VARCHAR, product VARCHAR, amount NUMBER)
AS
$$
    WITH CTE_CLEAN_DATA AS(
        SELECT DISTINCT * FROM sql_en_llamas.case04.sales
    )
    
    SELECT TOP 1 B.category_name,
    B.segment_name,
    B.product_name,
    SUM((A.qty * A.price) - A.discount) sales
    FROM CTE_CLEAN_DATA A
    LEFT JOIN sql_en_llamas.case04.product_details B
        ON A.prod_id=B.product_id
    WHERE B.category_name=category
    AND B.segment_name = segment
    GROUP BY 1,2,3
    ORDER BY 2 DESC
$$
;

/*las columnas se categoria y segemento se añaden para mostrar el producto mas vendido para cada combinacion posible en un misma tabla*/
SELECT * FROM TABLE(top_product_pmz('Mens', 'Socks'))
UNION
SELECT * FROM TABLE(top_product_pmz('Mens', 'Shirt'))
UNION
SELECT * FROM TABLE(top_product_pmz('Womens', 'Jacket'))
UNION
SELECT * FROM TABLE(top_product_pmz('Womens', 'Jeans'))
/*COMENTARIOS JUANPE:
Incorrecto. Se pide la función por cantidad de productos vendides por tanto el campo sales
    SUM((A.qty * A.price) - A.discount) sales 
deberia ser:
    SUM(A.qty ) sales
y el order by deberia ser por este mismo campo que es el 4 en tu select
    ORDER BY 4 DESC
*/
