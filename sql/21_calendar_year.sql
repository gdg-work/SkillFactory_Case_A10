select
    cohort, 
    lifetime, 
    conversion,
    to_char(cohort, 'YYYY') as year,
    to_char(cohort, 'YYYY') || '-12-01' as december,
    to_char(cohort + (lifetime || ' months')::interval, 'YYYY-MM-DD') as lt_month
from ru_cohorts_transactions
where cohort between '2017-01-01'::date and '2018-12-01'::date
order by cohort,lifetime
