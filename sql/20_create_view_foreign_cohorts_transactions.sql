create temporary view foreign_cohorts_transactions as
with 
    buyers_with_cohort_and_date as (  -- <1>
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
            not exists (select uid from c10_russian_users_ids as rui where c.user_id = rui.uid)
    ),
    clients_first_buy as ( -- <2>
        select
            cohort,
            min(lifetime) as lifetime,
            uid,
            min(purchased_at) as first_buy,
            count(purchased_at) as transactions_count
        from buyers_with_cohort_and_date
        group by cohort,uid
    ),
    transactions_by_cohort as ( -- <3>
        select
            cohort,
            lifetime,
            count(distinct uid) as buyers, 
            sum(transactions_count) as transactions 
        from
            clients_first_buy
        group by cohort, lifetime
    )
select -- <4>
    tbc.cohort, 
    uc.registered_users,
    lifetime,
    buyers,
    transactions,
    transactions*1.0/buyers as apc,  -- <5>
    buyers*1.0/uc.registered_users as conversion
from 
    transactions_by_cohort as tbc
    join foreign_users_count_by_cohort as uc using (cohort)
order by cohort, lifetime;
