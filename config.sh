#!/bin/bash
#sudo su postgres

# Creation des 3 clusters
pg_createcluster 13 master -p 5433 --start
pg_createcluster 13 slave01 -p 5434 --start
pg_createcluster 13 slave02 -p 5435 --start
echo "Clusters created"

# Creation des utilisateurs
createuser -p 5433 -S -D -R -P dbuser
createuser -p 5434 -S -D -R -P dbuser
createuser -p 5435 -S -D -R -P dbuser
echo "Users created"

# Creation des bases de donnees
createdb paasdb -O dbuser -p 5433
createdb paasdb -O dbuser -p 5434
createdb paasdb -O dbuser -p 5435
echo "Databases created"