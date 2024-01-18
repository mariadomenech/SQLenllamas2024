--Día 1. ¿Cuánto ha gastado en total cada cliente en el restaurante?

select mem.customer_id, sum(price)
from members mem
left join sales s
on mem.customer_id=s.customer_id
left join menu men
on s.product_id=men.product_id
group by mem.customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

El resultado es correcto, enhorabuena. Pero tiene unos detallillos que yo mejoraría.

Al hacer la sumatoria de los precios, para que la visualización del resultado quede perfecta, añadiría un CASE WHEN para que cuando el cliente D 
no cruce con SALES porque no ha comprado realmente nada, no muestre un NULL en la sumatoria, sino un 0. Me gusta que si una columna es de tipo númerico
y encima de importes, los nulos sean considerados como importe 0.

Respecto a las tabulaciones, a mí me resulta más fácil leer las columnas tabuladas tras cada ',', es decir, expandiría la lista de columnas a mostrar.

Por último, dale un alias a la columna SUM(PRICE) y PERFECTO!
*/
