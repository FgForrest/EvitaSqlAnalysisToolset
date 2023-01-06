select e.id, p.id, p.pricewithvat, p.priority, p.currency, p.pricelist
from (select distinct e.id
    from (
             select e.id
             from (
                      select e.id
                      from (select distinct on (e.id) e.id
                            from t_entity e,
                                 t_facet f
                            where f.entityid = e.id
                              and e.type = 'product'
                              and f.referencedentityprimarykey in (
                                with recursive hier(primaryKey, parentEntityPrimaryKey) as (
                                    select primaryKey, parententityprimarykey
                                    from t_entity
                                    where "type" = 'category'
                                      and primarykey = 266
                                    union all
                                    select e.primaryKey, e.parentEntityPrimaryKey
                                    from t_entity e,
                                         hier pe
                                    where pe.primarykey = e.parentEntityPrimaryKey
                                      and e.type = 'category'
                                )
                                select primaryKey
                                from hier)) e,
                           t_attribute a
                      where a.entityid = e.id
                        and a.name = 'validity'
                        and a.rangevalue @> 1000::int8
                  ) e, t_attribute a
             where a.entityId = e.id
               and ((a.name = 'visibility' and a.floatvalueprecision = 106) or
                    (a.name = 'status' and a.intvalue = 5) or (a.name = 'alias' and a.intvalue = 223))
             group by e.id
             having count(e.id) = 3
             ) e, t_attribute a
            where a.entityId = e.id and a.locale = 'cze'
     ) e
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
where p.pricewithvat between 3000 and 10000;
