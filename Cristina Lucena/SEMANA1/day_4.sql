SELECT TOP 1 B.PRODUCT_NAME, COUNT(A.PRODUCT_ID) AS CONTEO 
FROM SQL_EN_LLAMAS.CASE01.SALES A
INNER JOIN SQL_EN_LLAMAS.CASE01.MENU B
ON A.PRODUCT_ID = B.PRODUCT_ID
GROUP BY B.PRODUCT_NAME
ORDER BY CONTEO DESC;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto! Sería más preciso utilizar RANK para asi, en caso de empate, sacar ambos registros.

with ranking as (
    select
          b.product_name
        , count(a.product_id) as conteo
        , rank() over (order by conteo desc) as rk
    from sql_en_llamas.case01.sales a
        inner join sql_en_llamas.case01.menu b
            on a.product_id = b.product_id
    group by b.product_name
)

select * exclude rk
from ranking
where rk = 1;

*/
