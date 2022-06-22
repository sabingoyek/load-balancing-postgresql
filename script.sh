#!/bin/bash

# create dbuser
sudo su postgres
createuser dbuser -p 5433 --interactive