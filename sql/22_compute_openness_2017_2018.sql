create temporary view c10_openness_2017_2018 as
with
add_cohort_lt_month as (
    select  -- <1>
        cohort, 
        lifetime, 
        conversion,
        to_char(cohort, 'YYYY') as year,
        to_char(cohort, 'YYYY') || '-12-01' as december, -- <2>
        to_char(cohort + (lifetime || ' months')::interval, 'YYYY-MM-DD') as lt_month
    from ru_cohorts_transactions
    where cohort between '2017-01-01'::date and '2018-12-01'::date
)
select
    cohort,
    sum(conversion) as openness -- <3>
from add_cohort_lt_month
where lt_month <= december -- <4>
group by cohort -- <5>
order by cohort
