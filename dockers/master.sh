docker run --name master --network pgnet -e POSTGRES_PASSWORD=kalimba -d postgres:13.3-alpine

docker run --name slave01 --network pgnet -e POSTGRES_PASSWORD=kalimba -d postgres:13.3-alpine

docker run --name slave02 --network pgnet -e POSTGRES_PASSWORD=kalimba -d postgres:13.3-alpine

docker exec -it master bash
psql -U postgres
create user dbuser with encrypted password 'kalimba';
create database paasdb -O dbuser;

psql -U dbuser -d paasdb

-- Step 2: loading extension
CREATE EXTENSION postgres_fdw;
GRANT USAGE ON FOREIGN DATA WRAPPER postgres_fdw TO dbuser;


CREATE SERVER slave01 FOREIGN DATA WRAPPER postgres_fdw options(dbname 'paasdb', host '172.19.0.3');

CREATE USER MAPPING FOR dbuser SERVER slave01
    OPTIONS (user 'dbuser', password 'kalimba');

drop user MAPPING FOR dbuser server slave02;


CREATE SERVER slave02 FOREIGN DATA WRAPPER postgres_fdw options(dbname 'paasdb', host '172.19.0.4');
CREATE USER MAPPING FOR dbuser SERVER slave02
    OPTIONS (user 'dbuser', password 'kalimba');
    
GRANT USAGE ON FOREIGN SERVER slave01 TO dbuser;
GRANT USAGE ON FOREIGN SERVER slave02 TO dbuser;

CREATE TABLE users(
  id integer ,
  "user" json
) PARTITION BY RANGE(id);

CREATE TABLE apps(
	id integer,
	app json,
	userid integer
) PARTITION BY RANGE(userid); --- change partition key to userid

-- Step 3: Define foreign tables

CREATE FOREIGN TABLE users01 PARTITION OF users
      FOR VALUES FROM (1) TO (10)
      SERVER slave01;

CREATE FOREIGN TABLE apps01 PARTITION OF apps
    FOR VALUES FROM (1) TO (10)
    SERVER slave01;

CREATE FOREIGN TABLE users02 PARTITION OF users
    DEFAULT
    SERVER slave02;

CREATE FOREIGN TABLE apps02 PARTITION OF apps
    DEFAULT
    SERVER slave02;
