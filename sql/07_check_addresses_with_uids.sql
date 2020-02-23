select * from c10_users_with_addresses as a where not exists (
    select uid from c10_russian_users_ids as ru  where a.uid=ru.uid
)
limit 10;
