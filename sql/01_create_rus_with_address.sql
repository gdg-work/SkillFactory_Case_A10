create temporary table c10_users_with_addresses as
    select 
        u.id as uid, c.name as city, r.name as region, s.name as country 
    from 
        case10.users as u  
        join case10.addresses as a on u.id         = a.addressable_id 
        join case10.cities    as c on a.city_id    = c.id 
        join case10.regions   as r on c.region_id  = r.id
        join case10.countries as s on r.country_id = s.id;
