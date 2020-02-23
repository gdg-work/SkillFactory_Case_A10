select * from c10_users_with_geoip where not exists (
    select uid from c10_russian_users_ids 
    where c10_users_with_geoip.uid=c10_russian_users_ids.uid
);
