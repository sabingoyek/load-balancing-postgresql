CREATEDB paasdb;

CREATE TABLE users(
  id integer PRIMARY KEY,
  user json
);

CREATE TABLE apps(
	id integer PRIMARY KEY,
	app json,
	userid REFERENCES users(id)
);
