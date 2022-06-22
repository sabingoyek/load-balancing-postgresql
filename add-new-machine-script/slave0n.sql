CREATE TABLE users0n(
  id integer PRIMARY KEY,
  user json
);

CREATE TABLE apps0n(
	id integer PRIMARY KEY,
	app json,
	userid REFERENCES users(id)
);