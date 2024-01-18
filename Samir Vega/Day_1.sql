SELECT
    C.CUSTOMER_ID,
    CASE
        WHEN SUM(PRICE)|| '€' IS NULL THEN 0|| '€'
         ELSE SUM(PRICE)|| '€'
    END AS GASTO_POR_CLIENTE
FROM SALES A
LEFT JOIN MENU B
    ON A.PRODUCT_ID = B.PRODUCT_ID
FULL JOIN MEMBERS C
    ON C.CUSTOMER_ID = A.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/* 
El resultado es el que se buscaba, pero el código tiene ciertas cosas que no son del todo correcto. Te las cuento:

    * Cuando llamas al campo PRICE no hay problema porque solo está en una tabla pero es una buena práctica que 
      ayuda a la lectura del código tanto ti como a un tercero, añadir el alias de la tabla en este caso B.PRICE.
    * Aunque es completamente correcto el uso del CASE WHEN para poner un valor cuando algo es nulo, hay funciones
      que hacen eso mismo, NVL(), IFNULL(), COALESCE()… como recomendación si hay funciones integradas que te hagan 
      algo, úsalas, pues el código suele quedar más limpio (en rendimiento hasta donde yo sé no hay apenas diferencia).
    * El símbolo de la moneda es muy original ponerlo, pero esto es algo que es mejor ponerlo en los cuadros de mando y 
      no en la salida ¿por qué? Muy simple en los cuadros de mando es una opción de visualización, pero en sql estás
      cambiando la naturaleza del campo, deja de ser numérico y pasa a ser alfanumérico, esto tiene dos consecuencias:
            - Si ordenas por el gasto no te saldrá bien, pues numéricamente 75<120 pero alfanuméricamente cuando se 
              hace un orden se hace alfabéticamente, eso hace que ‘120’<‘75’ pues el 1 va antes que el 7).
            - Si quisieras luego hacer más cálculos con esos importes tendrías que volver a pasar a número. 
            - Si te interesa poner las unidades ya sea €, kg, cm… siempre puedes ponérselo en la cabecera de la columna,
              algo así: AS "GASTO_POR_CLIENTE_€".

Todas estas anotaciones son más unos TIPS de visualización, pero si es importante el segundo cruce que realizas. 

Los FULL JOIN no son muy recomendables, en este caso no altera el resultado y además son pocos registros, pero en tablas
con miles de registros y en los que no sabes exactamente que tiene cada tabla puede ser un problema. Por ello sería más
correcto usar un RIGHT, o incluso partir en el FROM de la tabla MEMBERS, hacer LEFT JOIN con SALES, y de nuevo LEFT JOIN
con MENU.

Cualquier duda no dudes en contactar.
*/
