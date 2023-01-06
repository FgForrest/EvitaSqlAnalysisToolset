with recursive hier(primaryKey, parentEntityPrimaryKey, depth, path) as (
        select primaryKey, parententityprimarykey, 1, ARRAY[primarykey]
        from t_entity
        where primaryKey = 266
    union all
        select e.primaryKey, e.parentEntityPrimaryKey, pe.depth + 1, pe.path || e.id
        from t_entity e, hier pe
        where pe.primarykey = e.parentEntityPrimaryKey
)
select * from hier order by path;
