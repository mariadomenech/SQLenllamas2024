
with id_imp as (
    select 
        txn_id,
        sum(price*(1-discount/100)*qty) as imp
    from (
        select distinct *
        from sales
        )
    group by txn_id
)
select 
    percentile_cont(0.25) within group (order by imp) as perc_25,
    percentile_cont(0.50) within group (order by imp) as perc_50,
    percentile_cont(0.75) within group (order by imp) as perc_75
from id_imp;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto.

*/
