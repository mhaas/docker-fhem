FROM debian:stretch
LABEL maintainer="Michael Haas <haas@computerlinguist.org>"
EXPOSE 7072 8083 8084 8085
RUN apt-get update && \
    apt-get -y install \
        wget \
        gnupg2
RUN wget -qO - http://debian.fhem.de/archive.key | apt-key add -
RUN echo "deb http://debian.fhem.de/nightly/ /" >> /etc/apt/sources.list
# create /sbin/init or installation of FHEM will fail
RUN touch /sbin/init
RUN apt-get update && \
    apt-get install -y \
        fhem=5.8.15781
RUN rm /sbin/init
# Move the fhem.cfg to its own directory. This makes it easier to
# expose it as a volume: a copy of fhem.cfg will be placed in the
# volume. This is not possible with single-file volumes.
RUN mkdir /etc/fhem && \
    chown fhem:dialout /etc/fhem && \
    mv /opt/fhem/fhem.cfg /etc/fhem/ && \
    ln -s /etc/fhem/fhem.cfg /opt/fhem/fhem.cfg
VOLUME ["/etc/fhem/", "/opt/fhem/log/"]
# Now install MQTT libs
RUN apt-get install -y \
    cpanminus \
    libmodule-pluggable-perl \
    build-essential
RUN cpanm \
    Net::MQTT::Simple::SSL \
    Net::MQTT::Constants
USER fhem
WORKDIR /opt/fhem/
# -d prevents fhem from going to background.
# That switch also overrides the logfile, so that the
# logs go to stdout
# We could also set ENTRYPOINT to fhem.pl and give the args
# via CMD, thus making the image more easily usable as client
CMD ["/usr/bin/perl", "fhem.pl", "-d", "/etc/fhem/fhem.cfg"]
