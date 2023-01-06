select e.id
from t_entity e,
     t_attribute a
where a.entityId = e.id
  and ((a.name = 'visibility' and a.floatvalueprecision = 106) or
       (a.name = 'status' and a.intvalue = 5) or (a.name = 'alias' and a.intvalue = 223))
  and e.type = 'product'
group by e.id
having count(e.id) = 3;
