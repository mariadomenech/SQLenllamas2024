select 
    members.customer_id,
    case 
        when sum(menu.price) is null then 0
        else sum(menu.price)
    end as total_price
from
    members
left join
    sales
on members.customer_id = sales.customer_id
left join
    menu
on sales.product_id = menu.product_id
group by 
    members.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, el case funciona correctamente pero sería más óptimo utilizar la funcion IFNULL "SUM(IFNULL(menu.price, 0)) as total_price".

Mejoraría la legibilidad/visibilidad del código, esto es algo mas de gustos personales y hay varias formas de hacer más legible un código. Por mi parte lo formatería de la siguiente forma:

select 
      members.customer_id
    , case 
          when sum(menu.price) is null then 0
          else sum(menu.price)
      end as total_price
from members
left join sales
    on members.customer_id = sales.customer_id
left join menu
    on sales.product_id = menu.product_id
group by members.customer_id;

Las comas delante o detrás de las columnas del select es algo de gusto personal.
Lo que si es común es tabular los JOINs y sus ONs correspondientes, sin abusar de ello ya que se pierde legibilidad.

*/
