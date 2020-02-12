-- А10.1.3.1 Задание 1
-- Напишите запрос, который по указанному пользователем адресу определит, из России пользователь или нет.
-- Сколько таких пользователей из России?


-- Всего пользователей 50к:
-- select count(id) from case10.users;
--   count
-- ---------
--   50000

-- Хочу сделать общую таблицу 'uid', 'city_id', 'city_name', 'region_id', 'region_name', 'country_id', 'country_name'

SELECT 
    u.id AS user_id, c.name AS city, r.name AS region, s.name AS country 
FROM 
    case10.users AS u  
    JOIN case10.addresses AS a ON u.id         = a.addressable_id 
    JOIN case10.cities    AS c ON a.city_id    = c.id 
    JOIN case10.regions   AS r ON c.region_id  = r.id
    JOIN case10.countries AS s ON r.country_id = s.id  ;


-- Если записать это в виде View:

CREATE VIEW users_with_address AS 
    SELECT 
        u.id AS user_id, c.name AS city, r.name AS region, s.name AS country 
    FROM 
        case10.users AS u  
        JOIN case10.addresses AS a ON u.id         = a.addressable_id 
        JOIN case10.cities    AS c ON a.city_id    = c.id 
        JOIN case10.regions   AS r ON c.region_id  = r.id
        JOIN case10.countries AS s ON r.country_id = s.id  ;

-- или в виде CTE:

users_with_address as (
    SELECT 
        u.id AS user_id, c.name AS city, r.name AS region, s.name AS country 
    FROM 
        case10.users AS u  
        JOIN case10.addresses AS a ON u.id         = a.addressable_id 
        JOIN case10.cities    AS c ON a.city_id    = c.id 
        JOIN case10.regions   AS r ON c.region_id  = r.id
        JOIN case10.countries AS s ON r.country_id = s.id
)

-- О да, так гораздо лучше.
CREATE TEMPORARY TABLE users_with_addresses as
    SELECT 
        u.id AS user_id, c.name AS city, r.name AS region, s.name AS country 
    FROM 
        case10.users AS u  
        JOIN case10.addresses AS a ON u.id         = a.addressable_id 
        JOIN case10.cities    AS c ON a.city_id    = c.id 
        JOIN case10.regions   AS r ON c.region_id  = r.id
        JOIN case10.countries AS s ON r.country_id = s.id

