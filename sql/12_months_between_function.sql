create function months_of(interval)
 returns int strict immutable language sql as $$
  select extract(years from $1)::int * 12 + extract(month from $1)::int
$$;

create function months_between(date, date)
 returns int strict immutable language sql as $$
   select abs(months_of(age($1, $2)))
$$;
