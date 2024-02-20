-- Solución de Ángel

---------------------------------- DÍA 5 (USANDO UNPIVOT) ----------------------------------

use database sql_en_llamas;
use schema case02;


with pizzas_entregadas as (
    select 
          a.pizza_id
        , count(a.pizza_id) as pizzas_entrgadas
    from customer_orders a
        left join runner_orders b
            on a.order_id = b.order_id
    where upper(replace(ifnull(b.cancellation, ''), 'null', '')) not like '%CANCELLATION%'
    group by a.pizza_id
),

ingredientes_base as (
    select 
          pizza_id
        , split(toppings, ', ') as split
        , split[0]::int as ingrediente_1
        , split[1]::int as ingrediente_2
        , split[2]::int as ingrediente_3
        , split[3]::int as ingrediente_4
        , split[4]::int as ingrediente_5
        , split[5]::int as ingrediente_6
        , split[6]::int as ingrediente_7
        , split[7]::int as ingrediente_8
    from pizza_recipes
),

ingredientes_extra as (
    select
          a.pizza_id
        , split(decode(a.extras, '', null, 'null', null, a.extras), ', ') as split_extras
        , split_extras[0]::int as extra_1
        , split_extras[1]::int as extra_2
    from customer_orders a
        left join runner_orders b
            on a.order_id = b.order_id
    where upper(replace(ifnull(b.cancellation, ''), 'null', '')) not like '%CANCELLATION%'
),

ingredientes_excluidos as (
    select
          a.pizza_id
        , split(decode(a.exclusions, '', null, 'null', null, 'beef', '3', a.exclusions), ', ') as split_exclusions
        , split_exclusions[0]::int as exclusion_1
        , split_exclusions[1]::int as exclusion_2
    from customer_orders a
        left join runner_orders b
            on a.order_id = b.order_id
    where upper(replace(ifnull(b.cancellation, ''), 'null', '')) not like '%CANCELLATION%'
),

unpivot_ingredientes_base as (
    select
          pizza_id
        , ingrediente
        , count(ingrediente) as veces_utilizado
    from ingredientes_base
        unpivot (ingrediente for num_ingrediente in (ingrediente_1, ingrediente_2, ingrediente_3, ingrediente_4, ingrediente_5, ingrediente_6, ingrediente_7, ingrediente_8))
    group by pizza_id, ingrediente
),

unpivot_ingredientes_extra as (
    select
          pizza_id
        , ingrediente
        , count(ingrediente) as "veces_añadido"
    from ingredientes_extra
        unpivot (ingrediente for num_ingrediente in (extra_1, extra_2))
    group by pizza_id, ingrediente
),

unpivot_ingredientes_excluidos as (
    select
          pizza_id
        , ingrediente
        , count(ingrediente) as veces_excluido
    from ingredientes_excluidos
        unpivot (ingrediente for num_ingrediente in (exclusion_1, exclusion_2))
    group by pizza_id, ingrediente
),

union_unpivots as (
    select
          a.pizza_id
        , a.ingrediente
        , a.veces_utilizado*b.pizzas_entrgadas as veces_utilizado
        , 0 as "veces_añadido"
        , 0 as veces_excluido
    from unpivot_ingredientes_base a
        right join pizzas_entregadas b
            on a.pizza_id = b.pizza_id
    union
    select
          pizza_id
        , ingrediente
        , 0 as veces_utilizado
        , ifnull("veces_añadido", 0) as "veces_añadido"
        , 0 as veces_excluido
    from unpivot_ingredientes_extra
    union
    select
          pizza_id
        , ingrediente
        , 0 as veces_utilizado
        , 0 as "veces_añadido"
        , ifnull(veces_excluido, 0) as veces_excluido
    from unpivot_ingredientes_excluidos
),

agrupacion as (
    select
          pizza_id
        , ingrediente
        , sum(veces_utilizado) as veces_utilizado
        , sum("veces_añadido") as "veces_añadido"
        , sum(veces_excluido) as veces_excluido
    from union_unpivots
    group by pizza_id, ingrediente
    order by ingrediente asc
),

calculo as (
    select
          pizza_id
        , ingrediente
        , veces_utilizado+"veces_añadido"-veces_excluido as veces_utilizado_total
    from agrupacion
),

resultado as (
    select
          b.topping_name
        , sum(veces_utilizado_total) as veces_utilizado_total
        , rank() over (order by sum(veces_utilizado_total) desc) as ranking
    from calculo a
        right join pizza_toppings b
            on a.ingrediente = b.topping_id
    group by b.topping_name
    order by ranking asc
)

select
      ranking
    , veces_utilizado_total
    , listagg(distinct topping_name, ', ') as ingredientes
from resultado
group by ranking, veces_utilizado_total
order by ranking asc;
