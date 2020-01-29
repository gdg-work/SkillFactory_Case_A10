psql -U skillfactory -h 84.201.134.129 skillfactory <<-EOF
\copy case10.users to '/tmp/case10/users.csv' DELIMITER ',' CSV HEADER
\copy case10.addresses to '/tmp/case10/addresses.csv' DELIMITER ',' CSV HEADER
\copy case10.cities to '/tmp/case10/cities.csv' DELIMITER ',' CSV HEADER
\copy case10.regions to '/tmp/case10/regions.csv' DELIMITER ',' CSV HEADER
\copy case10.countries to '/tmp/case10/countries.csv' DELIMITER ',' CSV HEADER
\copy case10.ip2location_db1 to '/tmp/case10/ip2location_db1.csv' DELIMITER ',' CSV HEADER
\copy case10.carts to '/tmp/case10/carts.csv' DELIMITER ',' CSV HEADER
EOF
