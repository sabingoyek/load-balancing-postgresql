CREATE SERVER remoteserver0n FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (dbname 'passdb', host 'remoteserver0n', port '5432');
CREATE USER MAPPING FOR dbuser SERVER remoteserver0n
  OPTIONS (user 'fdwuser', password 'kalimba');

-- Step 3: Define foreign tables

CREATE FOREIGN TABLE users0n PARTITION OF users
    DEFAULT
    SERVER remoteserver0n;

CREATE FOREIGN TABLE apps0n PARTITION OF apps
    DEFAULT
    SERVER remoteserver0n;