with  buyers_with_cohort_and_date as (
select
    date_trunc('month', u.created_at)::date as cohort, 
    months_between(c.purchased_at::date, u.created_at::date) as lifetime,
    user_id as uid,
    purchased_at
from
    case10.carts as c
    join case10.users as u on c.user_id = u.id
where
    c.state = 'successful'
    and
    exists (select uid from c10_russian_users_ids as rui where c.user_id = rui.uid)
)
select
    cohort,
    lifetime,
    count(distinct uid) as buyers, 
    count(purchased_at) as transactions 
from
    buyers_with_cohort_and_date
group by cohort,lifetime
limit 5;
