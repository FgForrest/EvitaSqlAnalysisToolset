select e.id, a.rangevalue, a.id
from (select distinct on (e.id) e.id, e.type
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
      )) e,
     t_attribute a
where a.entityid = e.id
  and a.name = 'validity'
  and a.rangevalue @> 1000::int8;
