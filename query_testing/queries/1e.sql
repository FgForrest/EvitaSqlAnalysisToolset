select e.id
from t_entity e
         inner join t_attribute a on e.id = a.entityid
where a.locale = 'cze'
  and e.type = 'product'
group by e.id
order by e.id;
