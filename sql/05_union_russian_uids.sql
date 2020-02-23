create temporary table c10_russian_users_ids as
   select  uid from c10_users_with_addresses where country = 'Russia'
   union
   select uid from c10_users_with_phone where country = 'Russia'
   union
   select uid from c10_users_with_geoip where country_name = 'Russian Federation'
   order by uid;
