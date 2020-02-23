create temporary table c10_users_with_geoip as
with
    uid_ip as (  -- <1>
        select 
            id as uid, 
            last_sign_in_ip as ip_addr,
            last_sign_in_ip::inet - '0.0.0.0'::inet as int_addr -- <2>
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
   on int_addr between ip_from and ip_to; -- <3>