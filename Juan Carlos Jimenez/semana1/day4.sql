SELECT TOP 1 PRODUCT_NAME,COUNT(*)
FROM SALES S
JOIN MENU M
ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 1
ORDER BY COUNT(*) DESC

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto Juanqui!!

*/
