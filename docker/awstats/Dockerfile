FROM debian:jessie

LABEL Description="AWstats for DaCHS." \
      Author="Nathanael Jourdane"

# Install dependencies
RUN apt-get update && \
    apt-get install -y apache2 awstats cron

# Configure apache2
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i.bak "s/\tcreate.*/\tcreate 644 root adm/" /etc/logrotate.d/apache2 && \
    a2enmod cgid

# TODO: placer tout ça dans startup.sh
# Edit awstats config file
RUN sed -i.bak "s/LogFile=.*/LogFile=\"\/usr\/share\/awstats\/tools\/logresolvemerge.pl \/var\/log\/apache2\/access.log\* |\"/;\
                s/LogFormat=.*/LogFormat=1/;\
                s/SiteDomain=.*/SiteDomain=\"$SERVERNAME\.$DOMAIN\"/;\
                s/HostAliases=.*/HostAliases=\"localhost 127\.0\.0\.1 $DOMAIN\"/;\
                s/DNSLookup=.*/DNSLookup=2/;\
                s/AllowFullYearView=.*/AllowFullYearView=3/;\
                s/SkipHosts=.*/SkipHosts=\"145\.238\.187\.13 145\.238\.187\.29\"/" /etc/awstats/awstats.conf

# Edit dachs config file
RUN cp /etc/awstats/awstats.conf /etc/awstats/awstats.dachs.conf && \
    sed -i.bak "s/LogFile=.*/LogFile=\"\/usr\/share\/awstats\/tools\/logresolvemerge.pl \/var\/gavo\/logs\/web.log\* |\"/;\
                s/LogFormat=.*/LogFormat=\"%other %other %other %host %other %other %time1 %methodurl %code %bytesd %refererquot %uaquot\"/;\
                s/URLWithQuery=.*/URLWithQuery=1/" /etc/awstats/awstats.dachs.conf

RUN echo "#!/bin/bash\n\
/usr/bin/perl /usr/lib/cgi-bin/awstats.pl -config=dachs -update\n\
/usr/bin/perl /usr/lib/cgi-bin/awstats.pl -config=apache -update" > /usr/local/bin/run_awstats

# Set files access
RUN chmod 644 /var/log/apache2/access.log* && \
    chmod 755 /var/log/apache2 && \
    chmod 777 /usr/local/bin/run_awstats

# Expose internal web port (actual port is defined by docker-compose)
EXPOSE 80

# Put site config and startup script files
COPY site-awstats.conf /etc/apache2/sites-available/000-default.conf
COPY awstats_startup.sh awstats_startup.sh
RUN chmod u+x awstats_startup.sh

# All commands (ie. 'command' keyword in docker-compose) will be used as arguments of the startup script
ENTRYPOINT ["./awstats_startup.sh"]
