#! /bin/bash
#sudo su postgres

#clean database
dropdb -p 5432 paasdb
dropdb -p 5433 paasdb
dropdb -p 5434 paasdb
echo "Databases cleaned"

#clean user
dropuser dbuser -p 5432
dropuser dbuser -p 5433
dropuser dbuser -p 5435
echo "Users cleaned"

# clean cluster
pg_dropcluster 13 master --stop
pg_dropcluster 13 slave01 --stop
pg_dropcluster 13 slave02 --stop
echo "Clusters cleaned"