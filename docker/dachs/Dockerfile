FROM debian:jessie

# Dockerfile metadata
LABEL Description="DaCHS is a publishing infrastructure for the Virtual Observatory." \
      Author="Markus Demleitner" \
      URL="http://docs.g-vo.org/DaCHS" \
      Reference="http://arxiv.org/abs/1408.5733" \
      maintainer="Nathanael Jourdane <nathanael dot jourdane at irap.omp.eu>"

# Set environment variables
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND='noninteractive' \
    LOG_FILE=/var/gavo/logs/web.log \
    DACHS_TAG=beta

# Install generic dependencies
RUN apt-get update && \
    apt-get install -y wget locales

# Install DaCHS
RUN echo "deb http://vo.ari.uni-heidelberg.de/debian $DACHS_TAG main" > /etc/apt/sources.list.d/gavo.list && \
    wget -qO - http://docs.g-vo.org/archive-key.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y python-gavodachs && \
    apt-get clean && \
    # The file describing the epntap2 mixin. Used here only because the DaCHS mixin was obsolete.
    wget https://raw.githubusercontent.com/epn-vespa/DaCHS-for-VESPA/master/mixin-EPN-TAP-2.0/epntap2.rd-2.xml -O \
      /usr/lib/python2.7/dist-packages/gavo/resources/inputs/__system__/epntap2.rd

# Among other things, configure users and files access
RUN echo LANG="$LANG" > /etc/default/locale && \
    addgroup --system gavo && \
    adduser --system --ingroup gavo gavo && \
    adduser --disabled-password --gecos "" --ingroup gavo dachsroot && \
    adduser --quiet gavo gavo && \
    adduser --quiet dachsroot gavo && \
    mkdir -m 775 /var/gavo && \
    chown dachsroot /var/gavo

# Expose internal web port (actual port is defined by docker-compose)
EXPOSE 80

# USER gavo
# WORKDIR /home/gavo

# Update DaCHS config file and startup script on the container
COPY gavo.rc /etc/gavo.rc
COPY dachs_startup.sh dachs_startup.sh
COPY dachs_pub.sh dachs_pub.sh
RUN chmod u+x dachs_startup.sh dachs_pub.sh

# Run startup script
CMD ["./dachs_startup.sh"]
