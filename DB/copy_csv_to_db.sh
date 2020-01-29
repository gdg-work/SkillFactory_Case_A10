psql -U dgolub -h 172.17.0.2 dgolub <<-EOF
\copy case10.users           from '/tmp/case10/users.csv'           DELIMITER ',' CSV HEADER
\copy case10.addresses       from '/tmp/case10/addresses.csv'       DELIMITER ',' CSV HEADER
\copy case10.cities          from '/tmp/case10/cities.csv'          DELIMITER ',' CSV HEADER
\copy case10.regions         from '/tmp/case10/regions.csv'         DELIMITER ',' CSV HEADER
\copy case10.countries       from '/tmp/case10/countries.csv'       DELIMITER ',' CSV HEADER
\copy case10.ip2location_db1 from '/tmp/case10/ip2location_db1.csv' DELIMITER ',' CSV HEADER
\copy case10.carts           from '/tmp/case10/carts.csv'           DELIMITER ',' CSV HEADER
EOF
