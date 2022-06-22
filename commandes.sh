#!/bin/bash

# Configuration du master
psql -p 5433 -d paasdb -c \
'CREATE EXTENSION postgres_fdw;'

psql -p 5433 -d paasdb -c \
'GRANT USAGE ON FOREIGN DATA WRAPPER postgres_fdw TO dbuser;'

psql -p 5433 -d paasdb -c \
"CREATE SERVER slave01 FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (dbname 'paasdb', host 'localhost', port '5434');"

psql -p 5433 -d paasdb -c \
"CREATE USER MAPPING FOR dbuser SERVER slave01 OPTIONS (user 'dbuser', password 'kalimba');"

psql -p 5433 -d paasdb -c \
"CREATE SERVER slave02 FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (dbname 'paasdb', host 'localhost', port '5435');"

psql -p 5433 -d paasdb -c \
"CREATE USER MAPPING FOR dbuser SERVER slave02 OPTIONS (user 'dbuser', password 'kalimba');"

# Creation des tables
psql -p 5433 -d paasdb -c \
"CREATE TABLE users(
  id integer,
  "user" json
) PARTITION BY RANGE(id);"

psql -p 5433 -d paasdb -c \
"CREATE TABLE apps(
	id integer,
	app json,
	userid integer
) PARTITION BY RANGE(userid);"

# Creation des tables etrangeres dans master
psql -p 5433 -d paasdb -c \
"CREATE FOREIGN TABLE users01 PARTITION OF users
      FOR VALUES FROM (100) TO (200)
      SERVER slave01;"

psql -p 5433 -d paasdb -c \
"CREATE FOREIGN TABLE apps01 PARTITION OF apps
    FOR VALUES FROM (100) TO (200)
    SERVER slave01;"

psql -p 5433 -d paasdb -c \
"CREATE FOREIGN TABLE users02 PARTITION OF users
      DEFAULT
      SERVER slave02;"

psql -p 5433 -d paasdb -c \
"CREATE FOREIGN TABLE apps02 PARTITION OF apps
    DEFAULT
    SERVER slave02;"

# Creation des tables dans slave01
psql -p 5434 -d paasdb -c \
"CREATE TABLE users(
  id integer PRIMARY KEY,
  \"user\" json
);"

psql -p 5434 -d paasdb -c \
"CREATE TABLE apps(
	id integer PRIMARY KEY,
	app json,
	userid integer REFERENCES users01(id)
);"

ALTER TABLE users RENAME TO users01;
ALTER TABLE apps RENAME TO apps01;

# Creation des tables dans slave02
psql -p 5435 -d paasdb -c \
"CREATE TABLE users01(
  id integer PRIMARY KEY,
  \"user\" json
);"

psql -p 5435 -d paasdb -c \
"CREATE TABLE apps01(
	id integer PRIMARY KEY,
	app json,
	userid integer REFERENCES users01(id)
);"