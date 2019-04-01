FROM mcr.microsoft.com/mssql/server:2017-CU8-ubuntu

ENV PATH /opt/mssql-tools/bin:/opt/mssql/bin:$PATH

RUN mkdir /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["sqlservr"]