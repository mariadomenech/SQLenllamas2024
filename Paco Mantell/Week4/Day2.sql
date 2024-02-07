
WITH CTE_CLEAN_DATA AS(
    /*Eliminamos duplicados*/
    SELECT DISTINCT * FROM sql_en_llamas.case04.sales
), CTE_DISTINCT_PRODS AS (
    /*Agrupo productos por transaccion, ordenando el array por la id de producto*/
    SELECT txn_id,
        LISTAGG(DISTINCT prod_id, ',') WITHIN GROUP (ORDER BY prod_id) prod_list
    FROM CTE_CLEAN_DATA
    GROUP BY 1
    HAVING COUNT(DISTINCT prod_id) >= 3
), CTE_MAX_COMB AS (
    /*Como tengo los arrays ordenados, puedo contar cuantos de ellos hay diferentes 
      y me quedo con el mayor de ellos*/
    SELECT DISTINCT TOP 1 prod_list,
        COUNT(prod_list) times_repeat
    FROM CTE_DISTINCT_PRODS
    GROUP BY 1
    ORDER BY 2 DESC
), CTE_SPLITTED AS(
/*Transformo el resultado para obtener los nombres de los productos*/
    SELECT C.value::VARCHAR product_id,
        times_repeat
    FROM CTE_MAX_COMB,
    LATERAL FLATTEN(input=>SPLIT(prod_list, ',')) C
)

SELECT B.product_name most_purchased_combination_by_transaction,
A.times_repeat
FROM CTE_SPLITTED A
JOIN sql_en_llamas.case04.product_details B
    ON A.product_id=B.product_id
