FROM debian:buster

RUN apt update && apt install -y alien
RUN curl https://dist.apache.org/repos/dist/release/madlib/1.20.0/apache-madlib-1.20.0-CentOS7.rpm -o /apache-madlib-1.20.0-CentOS7.rpm
RUN alien apache-madlib-1.20.0-CentOS7.rpm --scripts

FROM timescale/timescaledb-ha:pg11-latest
USER root

COPY --from=0 /madlib_1.20.0-2_amd64.deb /

RUN cp /usr/share/postgresql/11/postgresql.conf.sample /usr/share/postgresql/11/postgresql.conf.sample.old
RUN apt update && apt install -y -f python2.7 postgresql-plpython-11 m4
RUN cp /usr/share/postgresql/11/postgresql.conf.sample.old /usr/share/postgresql/11/postgresql.conf.sample
RUN dpkg -i /madlib_1.20.0-2_amd64.deb

COPY entrypoint-override.sh /
RUN chmod a+x /entrypoint-override.sh
ENTRYPOINT [ "/entrypoint-override.sh" ]

USER postgres