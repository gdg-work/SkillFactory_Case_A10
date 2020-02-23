with 
    cohorts_2017 as (
        select  -- <1>
            cohort,
            openness,
            to_char(cohort, 'MM')::int as month
        from c10_openness_2017_2018
        where to_char(cohort,'YYYY') = '2017'
            and  to_char(cohort, 'MM')::int < 7
    ),
    cohorts_2018 as (
        select -- <2>
            cohort,
            openness,
            to_char(cohort, 'MM')::int as month
        from c10_openness_2017_2018
        where to_char(cohort,'YYYY') = '2018'
            and  to_char(cohort, 'MM')::int < 7
    ),
    diffs_17_18 as (
        select
            month,
            (yr18.openness - yr17.openness) as open_diff -- <3>
        from
            cohorts_2017 as yr17  -- <4>
            join
            cohorts_2018 as yr18
            using (month)
        order by month
    )
select round(avg(open_diff),2) as avg_growth from diffs_17_18;
