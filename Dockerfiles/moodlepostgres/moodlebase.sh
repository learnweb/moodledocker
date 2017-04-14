#!/bin/bash
# Create `$MOODLE_DBUSER' role and corresponding db for use by the Moodle installation.
set -e
createuser --username "$POSTGRES_USER" "$MOODLE_DBUSER"
createdb --username "$POSTGRES_USER" -O "$MOODLE_DBUSER" "$MOODLE_DBUSER"
psql -c "ALTER USER $MOODLE_DBUSER WITH PASSWORD '$MOODLE_DBPASS';"
