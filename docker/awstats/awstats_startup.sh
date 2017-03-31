#!/bin/bash

echo "=============== Launching $0 ==============="

CRONTAB=$1

echo "$CRONTAB www-data /usr/local/bin/run_awstats 2>/dev/null" | crontab -u $(id -u -n) -
service apache2 start
tail -f var/log/apache2/access.log
