-- Напишите запрос, который по ip-адресу последнего входа определит, из России
-- пользователь или нет. Какой функцией вы будете пользоваться для перевода ip-адреса
-- в десятичный формат?

select id as user_id, last_sign_in_ip as last_ip from case10.users limit 20;

-- dgolub=> select id as user_id, last_sign_in_ip as last_ip from case10.users limit 5;
--  user_id |     last_ip     
-- ---------+-----------------
--  1886022 | 89.169.72.78
--  2403464 | 37.98.248.114
--   367821 | 128.73.199.169
--  2019421 | 62.133.162.163
--  1987320 | 217.118.83.176

-- А у всех ли пользователей есть IP последнего входа?

-- dgolub=> select count(last_sign_in_ip) from case10.users;
--  count 
-- -------
--  49913

-- Смотрим на таблицу с адресами

-- dgolub=> select * from case10.ip2location_db1 limit 5;
--  ip_from  |  ip_to   | country_code | country_name  
-- ----------+----------+--------------+---------------
--         0 | 16777215 | -            | -
--  16777216 | 16777471 | US           | United States
--  16777472 | 16778239 | CN           | China
--  16778240 | 16779263 | AU           | Australia
--  16779264 | 16781311 | CN           | China

-- Много ли адресов в таблице диапазонов:

-- dgolub=> select count(*) from case10.ip2location_db1;
--  count  
-- --------
--  185126

-- Учитывая, что в каждом диапазоне два адреса, выгоднее преобразоывать адрес
-- последнего входа пользователя (их меньше 50 тыс), чем адреса в `ip2location`.

-- Для того, чтобы сэкономить время на поиск адресов, построю для них индексы.

CREATE INDEX ip2loc_from_idx ON case10.ip2location_db1 (ip_from);
CREATE INDEX ip2loc_to_idx ON case10.ip2location_db1 (ip_to);

-- Первая итерация -- просто преобразуем IP адреса в числа:

-- ```
select 
    u.id as uid, 
    u.last_sign_in_ip as ip_addr,
    u.last_sign_in_ip::inet - 0.0.0.0::inet as int_addr
from 
   case10.users
limit 20;

-- ```

-- Результат:
-- 
-- ```
--    uid   |     ip_addr     |  int_addr  
-- ---------+-----------------+------------
--  1886022 | 89.169.72.78    | 1504266318
--  2403464 | 37.98.248.114   |  627243122
--   367821 | 128.73.199.169  | 2152318889
--  2019421 | 62.133.162.163  | 1048945315
--  1987320 | 217.118.83.176  | 3648410544
--  2405910 | 188.232.111.86  | 3169349462
--  1696250 | 81.4.253.65     | 1359281473
--  2283296 | 116.36.201.154  | 1948567962
-- ```

-- Преобразуем запрос в CTE и используем его при джойне:

with
    uid_ip as (
        select 
            id as uid, 
            last_sign_in_ip as ip_addr,
            last_sign_in_ip::inet - '0.0.0.0'::inet as int_addr
        from 
           case10.users
    )
select
   u.uid, u.ip_addr, u.int_addr,
   geoip.ip_from, geoip.ip_to, geoip.country_name 
from
   uid_ip as u
   join
   case10.ip2location_db1  as geoip
   on int_addr between ip_from and ip_to
limit 20;

-- Создаю представление и временную таблицу (чтобы не делать одну и ту же выборку снова и снова)

create view users_geo_from_ip as ...

create temporary table t_users_geo_from_ip as ...

-- dgolub=> create temporary table t_users_geo_from_ip as
-- with
--     uid_ip as (
--         select 
--             id as uid, 
--             last_sign_in_ip as ip_addr,
--             last_sign_in_ip::inet - '0.0.0.0'::inet as int_addr
--         from 
--            case10.users
--     )
-- select
--    u.uid, u.ip_addr, u.int_addr,
--    geoip.ip_from, geoip.ip_to, geoip.country_name 
-- from
--    uid_ip as u
--    join
--    case10.ip2location_db1  as geoip
--    on int_addr between ip_from and ip_to;
-- SELECT 49913

И выбираем пользователей по странам, сортируем и т.п.

-- dgolub=> select country_name, count(uid) from t_users_geo_from_ip group by country_name order by count(uid) desc limit 10;
--      country_name     | count 
-- ----------------------+-------
--  Russian Federation   | 45311
--  Ukraine              |  1563
--  Kazakhstan           |   951
--  Belarus              |   602
--  United States        |   260
--  Moldova, Republic of |   151
--  Kyrgyzstan           |   137
--  Uzbekistan           |    79
--  United Kingdom       |    73
--  Germany              |    65

-- Теперь следующая задача: определить, какой пользователь хотя бы по одному признаку определяется, как пользователь из России.
