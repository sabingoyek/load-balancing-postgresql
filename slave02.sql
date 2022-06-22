CREATEDB paasdb;

CREATE TABLE users02(
  id integer PRIMARY KEY,
  user json
);

CREATE TABLE apps02(
	id integer PRIMARY KEY,
	app json,
	userid REFERENCES users(id)
);