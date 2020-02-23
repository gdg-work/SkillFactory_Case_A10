create temporary view c10_total_conversion_by_cohort as
with summed_by_cohort as (
    select
        cohort,
        max(ct.registered_users) as users,
        sum(ct.buyers) as buyers,
        sum(ct.transactions) as transactions,
        sum(ct.conversion) as openness
    from
        ru_cohorts_transactions as ct
    group by cohort
)
select
    cohort,
    users,
    buyers,
    transactions*1.0 / buyers as apc,
    buyers*1.0 / users as conversion,
    openness
from
    summed_by_cohort   
order by cohort;
