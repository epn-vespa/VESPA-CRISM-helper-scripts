#!/bin/bash

echo "=============== Launching $0 ==============="

while ! su - postgres -c "psql -h postgres --quiet gavo -c 'SELECT 1' > /dev/null 2>&1";
do
	echo "Waiting for postgres to come up..."
	echo -n "response: "
	su - postgres -c "psql -h postgres --quiet gavo -c 'SELECT 1'"
	sleep 1
done

echo "gavo init..."
su dachsroot -c "gavo init -d 'host=postgres dbname=gavo'"
echo "starting DaCHS..."
gavo serve start

# Wait for the creation of the DaCHS log file
sleep 1

echo "DaCHS is running!"
echo "Displaying log file $LOG_FILE..."
tail -f $LOG_FILE

# Then:
# docker-compose up -d --build
# docker exec -it dachs_prod ./dachs_pub.sh illu67p
