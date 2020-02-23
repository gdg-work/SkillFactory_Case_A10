create temporary table c10_users_with_phone as
    with russian_phones as (
        select
            id,  phone
        from case10.users
        where 
            (phone::text ~ '^7[34589].........$')    -- all 10-digit numbers with prefix 73, 74, 75, 78, 79
            and (phone::text !~ '^78[45]0')    -- except Abkhazia and South Osetia (SO)
            and (phone::text !~ '^7940')       -- except Abkhazia
            and (phone::text !~ '^7995344')    -- except SO
            and (phone::text !~ '^79971')      -- SO
            and (phone::text !~ '^799744')     -- SO
            and (phone::text !~ '^79976')      -- SO
    )
    select 
        u.id as uid,  u.phone,
        case 
            when ru.phone is not null then 'Russia'
            else 'Foreign'
        end country
    from 
        case10.users as u
        left join
        russian_phones as ru
        using (id)
    where
        u.phone is not null 
;
