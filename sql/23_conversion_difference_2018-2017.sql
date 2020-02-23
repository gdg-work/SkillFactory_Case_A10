with 
    cohorts_2017 as (
        select  -- <1>
            cohort,
            openness,
            to_char(cohort, 'MM')::int as month
        from c10_openness_2017_2018
        where to_char(cohort,'YYYY') = '2017'
    ),
    cohorts_2018 as (
        select -- <2>
            cohort,
            openness,
            to_char(cohort, 'MM')::int as month
        from c10_openness_2017_2018
        where to_char(cohort,'YYYY') = '2018'
    )
select
    month,
    (yr18.openness - yr17.openness) as open_diff -- <3>
from
    cohorts_2017 as yr17  -- <4>
    join
    cohorts_2018 as yr18
    using (month)
order by month;
