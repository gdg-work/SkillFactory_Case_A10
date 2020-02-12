--
-- Напишите запрос, который по указанному пользователем номеру телефона определит,
-- из России пользователь или нет. Пустые телефоны не должны учитываться. Сколько
-- таких пользователей не из России?
--


-- Всего пользователей 50к:
-- select count(id) from case10.users;
--   count
-- ---------
--   50000

-- codes from: https://jasmi.ru/telefonnye-kody-stran-mira
select id,phone
from case10.users
where 
    (phone::text ~ '^7..........$')    -- all 10-digit numbers with prefix '7'
    and (phone::text !~ '^7[67]')      -- except Kazakhstan
    and (phone::text !~ '^78[45]0')    -- except Abkhazia and South Osetia (SO)
    and (phone::text !~ '^7940')       -- except Abkhazia
    and (phone::text !~ '^7995344')    -- except SO (ცხინვალი)
    and (phone::text !~ '^79971')      -- SO
    and (phone::text !~ '^799744')     -- SO
    and (phone::text !~ '^79976')      -- SO


-- rewriting as CTE
russian_phones as (
    select id,phone
    from case10.users
    where 
        (phone::text ~ '^7[34589].........$')    -- all 10-digit numbers with prefix '7'
        and (phone::text !~ '^7[67]')      -- except Kazakhstan
        and (phone::text !~ '^78[45]0')    -- except Abkhazia and South Osetia (SO)
        and (phone::text !~ '^7940')       -- except Abkhazia
        and (phone::text !~ '^7995344')    -- except SO (ცხინვალი)
        and (phone::text !~ '^79971')      -- SO
        and (phone::text !~ '^799744')     -- SO
        and (phone::text !~ '^79976')      -- SO
)

with russian_phones as (
    select id,phone
    from case10.users
    where 
        (phone::text ~ '^7[34589].........$')    -- all 10-digit numbers with prefix 73, 74, 75, 78, 79
        and (phone::text !~ '^78[45]0')    -- except Abkhazia and South Osetia (SO)
        and (phone::text !~ '^7940')       -- except Abkhazia
        and (phone::text !~ '^7995344')    -- except SO (ცხინვალი)
        and (phone::text !~ '^79971')      -- SO
        and (phone::text !~ '^799744')     -- SO
        and (phone::text !~ '^79976')      -- SO
)
select u.id, u.phone
from 
    case10.users as u
    left join
    russian_phones as ru
    using (id)
where
    u.phone is not null 
    and ru.phone is null
;


-- Add country column for classification
create temporary table users_with_phone as
    with russian_phones as (
        select id,phone
        from case10.users
        where 
            (phone::text ~ '^7[34589].........$')    -- all 10-digit numbers with prefix 73, 74, 75, 78, 79
            and (phone::text !~ '^78[45]0')    -- except Abkhazia and South Osetia (SO)
            and (phone::text !~ '^7940')       -- except Abkhazia
            and (phone::text !~ '^7995344')    -- except SO (ცხინვალი)
            and (phone::text !~ '^79971')      -- SO
            and (phone::text !~ '^799744')     -- SO
            and (phone::text !~ '^79976')      -- SO
    )
    select 
        u.id, u.phone,
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


-- Авторы учебника использовали более простую классификацию номеров на российские и остальные,
-- учитывали только Казахстан.
with russian_phones as (
    select id,phone
    from case10.users
    where 
        (phone::text ~ '^7[3489].........$')    -- all 10-digit numbers with prefix '7'
        and (phone::text !~ '^7[67]')      -- except Kazakhstan
)
select u.id, u.phone
from 
    case10.users as u
    left join
    russian_phones as ru
    using id
where
    u.phone is not null 
    and ru.phone is null
;
