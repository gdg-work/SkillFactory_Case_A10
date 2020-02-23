select
    date_trunc('month', created_at)::date as cohort,
    count(id) as registered_users
from case10.users
group by cohort
order by cohort;
