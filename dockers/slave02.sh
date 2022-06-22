psql -U postgres
create database paasdb;
create user dbuser with encrypted password 'kalimba';
grant all privileges on database paasdb to dbuser;

psql -U postgres -d paasdb
-- tables creation on slaves nodes
CREATE TABLE users02(
  id integer PRIMARY KEY,
  "user" json
);

CREATE TABLE apps02(
	id integer PRIMARY KEY,
	app json,
	userid integer REFERENCES users01(id)
);
