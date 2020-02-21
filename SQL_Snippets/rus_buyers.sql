create view c10_total_conversion_by_cohort as
with
    transactions_by_cohort as (
    select
        date_trunc('month', u.created_at)::date as cohort,
        count(distinct c.user_id) as buyers,
        count(purchased_at) as transactions
    from
        case10.carts as c
        join case10.users as u on c.user_id = u.id
        join c10_russian_users_ids as rui on c.user_id = rui.uid
    where c.state = 'successful'
    group by cohort
    ),
    conversion_by_cohort as (
    select
        cohort,
        uc.count as registered_users,
        buyers,
        transactions,
        round(buyers*1.0/uc.count,3) as conversion,
        round(transactions*1.0/buyers,3) as apc
    from
        transactions_by_cohort as tbc
        join case10.users_count_by_cohort as uc using (cohort)
    )
select sum(buyers) from conversion_by_cohort;
