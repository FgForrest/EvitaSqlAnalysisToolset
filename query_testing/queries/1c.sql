select e.id, a.rangevalue
from t_entity e,
     t_attribute a
where a.entityid = e.id
  and a.name = 'validity'
  and a.rangevalue @> 1000::int8;
