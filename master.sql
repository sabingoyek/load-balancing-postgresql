-- Step 1: Define global schema on the master
CREATEDB paasdb;

CREATE TABLE users(
  id integer PRIMARY KEY,
  "user" json
) PARTITION BY RANGE(id);

CREATE TABLE apps(
	id integer PRIMARY KEY,
	app json,
	userid integer REFERENCES users(id)
) PARTITION BY RANGE(id);

-- Step 2: loading extension
CREATE EXTENSION postgres_fdw;
GRANT USAGE ON FOREIGN DATA WRAPPER postgres_fdw TO dbuser;

-- SERVERS CREATION
CREATE SERVER slave01 FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (dbname 'paasdb', host 'slave01', port '5434');
CREATE USER MAPPING FOR dbuser SERVER slave01
  OPTIONS (user 'fdwuser', password 'kalimba');

CREATE SERVER slave02 FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (dbname 'paasdb', host 'slave02', port '5435');
CREATE USER MAPPING FOR dbuser SERVER slave02
  OPTIONS (user 'dbuser', password 'kalimba');


-- Step 3: Define foreign tables

CREATE FOREIGN TABLE users01 PARTITION OF users
    FOR VALUES FROM (1) TO (100)
    SERVER slave01;

CREATE FOREIGN TABLE apps01 PARTITION OF apps
    FOR VALUES FROM (1) TO (100)
    SERVER slave01;

CREATE FOREIGN TABLE users02 PARTITION OF users
    DEFAULT
    SERVER slave02;

CREATE FOREIGN TABLE apps02 PARTITION OF apps
    DEFAULT
    SERVER slave02;