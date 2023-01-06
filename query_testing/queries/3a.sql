select count(e.id), f.referencedentityprimarykey
from t_facet f
         inner join (
    select distinct e.id
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
        from hier
    )
) as e on f.entityid = e.id
group by f.referencedentityprimarykey;
