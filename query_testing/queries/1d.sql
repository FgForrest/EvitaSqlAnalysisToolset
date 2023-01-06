select e.id, p.id, p.pricewithvat, p.priority, p.currency, p.pricelist
from t_entity e
inner join (
    select distinct on (p.entityid) p.entityid,
                                    p.id,
                                    p.currency,
                                    p.pricewithvat,
                                    p.pricelist,
                                    p.priority,
                                    p.validrange
    from t_price as p
    where (p.pricelist = 1 or p.pricelist = 2 or p.pricelist = 3)
      and p.currency = 'usd'
      and (p.validrange @> '2020-12-01 00:00:00'::timestamp or p.validrange is null)
    order by p.entityid, p.priority desc, p.pricewithvat
) p on p.entityid = e.id
where e.type = 'product'
  and p.pricewithvat between 3000 and 3300;
