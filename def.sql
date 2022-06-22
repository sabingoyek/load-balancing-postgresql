-- ON MASTER

CREATE SERVER slave01 FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (dbname 'paasdb', host 'localhost', port '5434');

CREATE SERVER slave02 FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (dbname 'paasdb', host 'localhost', port '5434');

CREATE USER MAPPING FOR dbuser SERVER slave01
    OPTIONS (user 'postgres', password 'kalimba');

CREATE USER MAPPING FOR dbuser SERVER slave02
    OPTIONS (user 'postgres', password 'kalimba');


CREATE TABLE users(
  id integer ,
  "user" json
) PARTITION BY RANGE(id);

CREATE TABLE apps(
	id integer,
	app json,
	userid integer
) PARTITION BY RANGE(id);

CREATE FOREIGN TABLE users02 PARTITION OF users
      FOR VALUES FROM (100) TO (200)
      SERVER slave02;

CREATE FOREIGN TABLE apps02 PARTITION OF apps
    FOR VALUES FROM (100) TO (200)
    SERVER slave02;

CREATE FOREIGN TABLE users01 PARTITION OF users
    DEFAULT
    SERVER slave01;

CREATE FOREIGN TABLE apps01 PARTITION OF apps
    DEFAULT
    SERVER slave01;

----------------------------------
-- ON slaves