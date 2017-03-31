#!/bin/bash

echo "=============== Launching $0 ==============="
if [ $# != 1 ]; then
  echo "usage: $0 <service_name>"
  exit
fi

SERVICE_NAME=$1
SERVICE_DIR=/services/$SERVICE_NAME
INPUT_DIR=/var/gavo/inputs/$SERVICE_NAME

# If needed, you can get the gavoadmin password:
# PGPASSWORD=$(grep "password = " /var/gavo/etc/feed | cut -d'=' -f 2 | xargs)

echo "Replacing q.rd ..."
rm -rf $INPUT_DIR && mkdir $INPUT_DIR
ln -s $SERVICE_DIR/${SERVICE_NAME}_q.rd $INPUT_DIR/q.rd
ln -s $SERVICE_DIR/${SERVICE_NAME}_pub.py $INPUT_DIR/${SERVICE_NAME}_pub.py

echo "gavo imp..."
gavo imp $SERVICE_NAME/q

# echo "Executing ${SERVICE}_db.sql in gavo database..."
# psql -U gavoadmin -h postgres -w gavo < $SERVICE_DIR/${SERVICE_NAME}_db.sql
# echo "Executing ${SERVICE}_view.sql in gavo database..."
# psql -U gavoadmin -h postgres -w gavo < $SERVICE_DIR/${SERVICE_NAME}_view.sql
# echo "gavo imp..."
# gavo imp -m $INPUT_DIR/q.rd

echo "restating gavo..."
gavo serve restart
echo "Done. Service is updated"
