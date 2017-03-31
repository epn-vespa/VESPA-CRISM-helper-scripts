#!/bin/bash

echo "=============== Launching $0 ==============="

su - postgres -c "$PGBIN -c config_file=$PGCONF -c logging_collector=on" &

while [ $(service postgresql status | cut -d':' -f 2 | xargs) != "online" ];
do
	echo "Waiting until postgres is online..."
	echo -n "status: "
	service postgresql status
	sleep 1
done
echo "Postgres is now online."

echo "Creating user..."
su postgres -c "createuser -s dachsroot"
echo "Creating database..."
su postgres -c "createdb gavo"

echo "Postgres is functional!"
echo "Displaying log file $PGLOG..."
tail -f $PGLOG
