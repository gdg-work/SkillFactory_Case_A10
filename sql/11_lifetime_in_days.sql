select 
    user_id, 
    date_trunc('month', u.created_at)::date as cohort, 
    purchased_at, 
    (c.purchased_at::date - u.created_at::date) as lifetime
from 
    case10.carts as c
    join case10.users as u on c.user_id = u.id
where exists (select uid from c10_russian_users_ids as rui where c.user_id = rui.uid)
limit 10;
