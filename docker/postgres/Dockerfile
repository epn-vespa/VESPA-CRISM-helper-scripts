FROM debian:jessie

# Dockerfile metadata
LABEL Description="DaCHS is a publishing infrastructure for the Virtual Observatory." \
      Author="Markus Demleitner" \
      URL="http://docs.g-vo.org/DaCHS" \
      Reference="http://arxiv.org/abs/1408.5733" \
      maintainer="Nathanael Jourdane <nathanael dot jourdane at irap.omp.eu>"

# Set environment variables
ENV DEBIAN_FRONTEND='noninteractive' \
    LANG=C.UTF-8 \
    PG_VERSION=9.4 \
    DACHS_TAG=beta

# Set Postgres environment variables (which require $PG_VERSION)
ENV PGFILE=/etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
    PGDATA=/var/lib/postgresql/${PG_VERSION} \
    PGBIN=/usr/lib/postgresql/${PG_VERSION}/bin/postgres \
    PGCONF=/etc/postgresql/${PG_VERSION}/main/postgresql.conf \
    PGLOG=/var/log/postgresql/postgresql-${PG_VERSION}-main.log
# TODO: use LOG_FILE instead of PGLOG

# Install generic dependencies
RUN apt-get update && \
    apt-get install -y wget locales

# Install a specific postgresql version and its plugins
RUN echo "deb http://vo.ari.uni-heidelberg.de/debian $DACHS_TAG main" > /etc/apt/sources.list.d/gavo.list && \
    echo "deb-src http://vo.ari.uni-heidelberg.de/debian $DACHS_TAG main" >> /etc/apt/sources.list.d/gavo.list && \
    wget -qO - http://docs.g-vo.org/archive-key.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-$PG_VERSION postgresql-$PG_VERSION-pgsphere postgresql-$PG_VERSION-q3c && \
    apt-get clean

# PostgreSQL needs this directory for log files; then some commands to configure PostgreSQL
RUN mkdir -p -m 777 /var/run/postgresql/${PG_VERSION}-main.pg_stat_tmp/ \
    echo LANG="$LANG" > /etc/default/locale && \
    echo 'host  all  all  172.17.0.0/24  trust' >> $PGFILE && \
    echo "listen_addresses='*'" >> "${PGFILE%/*}/postgresql.conf"

# Expose internal psql port (actual port is defined by docker-compose)
EXPOSE 5432

# Update startup script
COPY postgres_startup.sh postgres_startup.sh
RUN chmod u+x postgres_startup.sh

# Run startup script
CMD ["./postgres_startup.sh"]

# Then just type:
# docker exec -it dachs_prod ./dachs_pub.sh <service_name>
