create temporary view russian_users_count_by_cohort as
select 
    date_trunc('month', created_at)::date as cohort,
    count(id) as registered_users
from case10.users as u
where
    exists(select uid from c10_russian_users_ids as rui where rui.uid =  u.id) 
group by cohort
order by cohort;
