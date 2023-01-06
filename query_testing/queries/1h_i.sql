select e.id, ta.stringvalue, ta.locale
from t_entity e
         inner join t_attribute ta on e.id = ta.entityid
where e.type = 'product'
  and ta.name = 'name'
  and ta.locale = 'cze'
  and ta.stringvalue is not null
order by ta.stringvalue asc;
