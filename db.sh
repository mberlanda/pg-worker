#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

DB_NAME=${DB_NAME:-worker_test}

function help_msg {
  echo "You can use the following flags"
  echo "--create |-c Create a schema ${DB_NAME}"
  echo "--drop   |-d Drop the schema ${DB_NAME}"
  echo "--migrate|-m Create the demo tables"
  echo "--seeds  |-s Add some seeds"
  echo "--help   |-h Display this message"
}

function create_database {
  psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
    CREATE DATABASE ${DB_NAME};
EOSQL
}

function drop_database {
  psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
    DROP DATABASE ${DB_NAME};
EOSQL
}

function migrate {
  psql -v ON_ERROR_STOP=1 --username postgres ${DB_NAME} <<-EOSQL
  CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    age INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email TEXT
  );
EOSQL
}

function seeds {
  psql -v ON_ERROR_STOP=1 --username postgres ${DB_NAME} <<-EOSQL
  INSERT INTO users (age, email, first_name, last_name) VALUES
    (22, 'floxy@msn.com', 'floxy', 'msn'),
    (49, 'eidac@comcast.net', 'eidac', 'comcast'),
    (47, 'temmink@mac.com', 'temmink', 'mac'),
    (16, 'gward@live.com', 'gward', 'live'),
    (33, 'gastown@icloud.com', 'gastown', 'icloud'),
    (20, 'tellis@yahoo.ca', 'tellis', 'yahoo'),
    (12, 'firstpr@verizon.net', 'firstpr', 'verizon'),
    (21, 'jfreedma@optonline.net', 'jfreedma', 'optonline'),
    (23, 'suresh@hotmail.com', 'suresh', 'hotmail'),
    (32, 'lukka@mac.com', 'lukka', 'mac'),
    (34, 'seano@hotmail.com', 'seano', 'hotmail'),
    (43, 'zilla@outlook.com', 'zilla', 'outlook');
EOSQL
}

if [ $# -ne 1 ]; then
  echo "You should pass exactly one argument"
  help_msg
  exit 1
fi

case "$1" in
  --create|-c)
    create_database
    ;;
  --drop|-d)
    drop_database
    ;;
  --migrate|-m)
    migrate
    ;;
  --seeds|-s)
    seeds
    ;;
  --help|-h)
    help_msg
    ;;
  *)
    echo "$1 is not a recognized flag!"
    help_msg
    ;;
esac
