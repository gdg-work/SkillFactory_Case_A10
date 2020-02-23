select 
    cohort, registered_users, buyers, 
    round(conversion,3) as conversion,
    round(apc,3) as apc
from ru_cohorts_transactions as ct
where
    registered_users > 100
    and lifetime = 0
order by ct.conversion desc
limit 5;
