FROM mcr.microsoft.com/mssql/server:2017-CU8-ubuntu

RUN mkdir /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]