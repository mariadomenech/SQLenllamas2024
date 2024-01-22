-- ¿Cuál es el producto más pedido del menú y cuantas veces ha sido pedido? -- 

-- 1ª FORMA MÁS ELABORADA CON RANKING--
SELECT 
     PRODUCTO AS PRODUCTO_MAS_PEDIDO
    ,NUMERO_PEDIDOS
FROM (
        SELECT 
             MENU.PRODUCT_NAME AS PRODUCTO
            ,NUMERO_PEDIDOS
            ,RANK() OVER (ORDER BY NUMERO_PEDIDOS DESC) AS RANKING_PEDIDOS  
        FROM(
            SELECT 
                 SALES.PRODUCT_ID
                ,COUNT(PRODUCT_ID) AS NUMERO_PEDIDOS
            FROM CASE01.SALES
            GROUP BY PRODUCT_ID)A
        LEFT JOIN CASE01.MENU 
               ON A.PRODUCT_ID = MENU.PRODUCT_ID)B
WHERE RANKING_PEDIDOS = 1;

-- 2ª FORMA MÁS DIRECTA CON ORDENACIÓN POR CANTIDAD DE PEDIDOS Y NOS QUEDAMOS CON LA PRIMERA FILA CON TOP 1--
SELECT 
     TOP 1
     MENU.PRODUCT_NAME AS PRODUCTO
    ,COUNT(SALES.PRODUCT_ID) AS NUMERO_PEDIDOS
FROM CASE01.SALES
LEFT JOIN CASE01.MENU 
       ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY 1
ORDER BY 2 DESC

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
CASI PERFECTO. La segunda forma es menos adeacuada que la primera, porque en caso de empate el top solo te saca uno y el rank te los saca todos, de la primera 
como información te puedes ahorrar una subconsulta ya que la función RANK() admite eso en el ORDER BY:
RANK() OVER (ORDER BY COUNT(PRODUCT_ID) DESC)
Por lo demás, ¡todo perfecto!
*/
