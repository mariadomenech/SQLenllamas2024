USE SQL_EN_LLAMAS;
USE SCHEMA case04;

WITH get_most_repeated_combination AS (
	SELECT sal1.prod_id AS product1,
			sal2.prod_id AS product2,
			sal3.prod_id AS product3,
			COUNT(*) AS num_ocur
	FROM sales sal1
	JOIN sales sal2
		ON sal2.txn_id = sal1.txn_id AND
			sal1.prod_id < sal2.prod_id
	JOIN sales sal3
		ON sal3.txn_id = sal1.txn_id AND
			sal2.prod_id < sal3.prod_id
	GROUP BY product1, product2, product3
	ORDER BY num_ocur DESC
	LIMIT 1
)

SELECT listagg(pd.product_name, ', ') AS "Combinación productos distintos más repetida en una sola transacción",
		gmrc.num_ocur AS "Número de ocurrencias"
FROM get_most_repeated_combination gmrc
JOIN product_details pd
	ON gmrc.product1 = pd.product_id OR
		gmrc.product2 = pd.product_id OR
		gmrc.product3 = pd.product_id
GROUP BY gmrc.num_ocur;



/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Creo que la interpretación de la pregunta no ha quedado del todo clara. No se preguntaba cuál era la combinación de 3 productos más repetida, sino qué combinación (transacción completa)
de al menos 3 producto es la que más se repite.

La combinación más repetida es, un total de 5 veces:
-Black Straight Jeans - Womens
- Cream Relaxed Jeans - Womens
- Grey Fashion Jacket - Womens
- Navy Oversized Jeans - Womens
- Navy Solid Socks - Mens
- Pink Fluro Polkadot Socks - Mens
- Teal Button Up Shirt - Mens
- White Tee Shirt - Mens


Por otro lado, ten cuidado con el uso del LIMIT para sacar un TOP1, en caso de empate, solo sacas una combianción.

*/
