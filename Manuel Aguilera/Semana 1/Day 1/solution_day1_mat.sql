SELECT C.CUSTOMER_ID, SUM(NVL(PRICE,0)) AS GASTO_TOTAL  
FROM SQL_EN_LLAMAS.CASE01.MEMBERS C
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES A ON (C.CUSTOMER_ID=A.CUSTOMER_ID)
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU B ON (A.PRODUCT_ID = B.PRODUCT_ID)
GROUP BY C.CUSTOMER_ID;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/* 
El resultado es el que se buscaba, el código es correcto y muy limpio. La expliación en el archivo JSON
me parece perfecta, demuestra que controlas cada cosa que has puesto.

Una opinión más subjetiva, es que me gusta que esté todo en mayusucula, para mi punto de vista eso le 
da limpieza al código. Sin intención de padecer pedante buscando fallos que no hay, te muestro como tabularía
yo el código:
SELECT C.CUSTOMER_ID, 
       SUM(NVL(PRICE,0)) AS GASTO_TOTAL  
FROM SQL_EN_LLAMAS.CASE01.MEMBERS C
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES A 
       ON C.CUSTOMER_ID = A.CUSTOMER_ID
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU B 
       ON A.PRODUCT_ID = B.PRODUCT_ID
GROUP BY C.CUSTOMER_ID;

- Me gusta poner las columnas de la SELECT una por fila y alineadas entre ellas. 
- Me gusta poner el ON de los JOIN debajo ya que en una sola línea no lo veo limpio en casos que puedan existir
  más condiciones de cruce, es decir, un AND adicional, e incluso tu tabla del LEFT puede ser una subconsulta.
  Además de ponerlo debajo lo alineo concretamente a la derecha simplemente porque el ON yo lo veo como parte del JOIN, 
  te pongo un ejemplo.
SELECT ....
       ....
FROM  .... A
LEFT JOIN (SELECT ..... FROM .....) B
       ON .....
      AND .....
LEFT JOIN (SELECT ..... FROM .....) C
       ON .....
      AND .....
WHERE ....
  AND ....
GROUP BY ....
ORDER BY ....

Para este caso más simple considero que tu forma es absolutamente limpia y legible. Hay muchas formas de tabular un código,
la mía no es más correcta que otra, solo te la pongo como complemento a un comentario que hubiera sido muy escueto ya que 
como te he dicho antes no tengo nada que objetar de tú código en ningún aspecto. ¡ENHORABUENA!
*/
