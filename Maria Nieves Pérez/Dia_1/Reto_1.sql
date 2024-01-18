        
select 
    m."customer_id" as customer, 
    case when sum(mn."price") is null then 0
        else sum(mn."price") end as gasto_total
from SQL_EN_LLAMAS.CASE01.MEMBERS m
left join SQL_EN_LLAMAS.CASE01.sales s on s."customer_id"=m."customer_id"
left join SQL_EN_LLAMAS.CASE01.MENU mn on s."product_id"=mn."product_id"
group by m."customer_id"
order by gasto_total desc;
/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/* 
El resultado es el que se buscaba, y el código es totalmente correcto, pero tal vez no está del todo "limpio". 
Te comento varias cosas que yo haría, pero es cierto que son cosas con caracter más subjetivo:
    * Aunque es completamente correcto el uso del CASE WHEN para poner un valor cuando algo es nulo, hay funciones
      que hacen eso mismo, NVL(), IFNULL(), COALESCE()… como recomendación, si hay funciones integradas que te hagan 
      algo, úsalas, pues el código suele quedar más limpio (en rendimiento hasta donde yo sé no hay apenas diferencia).
    * Yo personalmente me gusta escribir todo el código en mayúscula, de hecho tengo un toc con eso. No por ello está
      un código más limpio o menos. Otra versión puede ser poner en mayúscula todo lo que son palabras reservadas: SELECT, 
      LEFT, GROUP, BY, JOIN, WHERE, WHEN, ELSE, AS, ON... y dejar en minúscula los nombres de las tablas, columnas,
      esquemas... o viceversa pero mezclar hace que el código no esté "limpio", por ejemplo las tablas MEMBERS y MENU están
      en mayúsculas y SALES en minuscula.
    * El ON que indica los campos a cruzar, a mi me gusta ponerlo debajo del JOIN ya que en una sola linea no lo veo limpio
      ya que a veces puedes llevar más condiciones de cruce, es decir un AND adicional, e incluso tu tabla del left puede 
      ser una subconsulta. Además de ponerlo debajo lo alineo concretametne a la derecha simplemente porque el ON yo lo veo
      como parte del JOIN, te pongo un ejemplo.
SELECT ....
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

Enhorabuena por el ejercicio, porque como te he dicho al inicio esta correcto tanto resultado como código y solo he podido
comentarte cosas de legiblidd de código que como te digo no deja de ser algo subjetivo.

Cualquier cosa no dudes en contactar.
*/
