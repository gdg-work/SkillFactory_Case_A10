select
    date_trunc('month', u.created_at)::date as cohort, 
    months_between(c.purchased_at::date, u.created_at::date) as lifetime,
    user_id as uid,
    purchased_at
from
    case10.carts as c
    join case10.users as u on c.user_id = u.id
    join c10_russian_users_ids as rui on c.user_id = rui.uid
where
    c.state = 'successful';
