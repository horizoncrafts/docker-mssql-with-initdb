FROM mcr.microsoft.com/mssql/server:2017-CU8-ubuntu

#ENV MSSQL_SA_PASSWORD=Mssql123
#ENV ACCEPT_EULA=Y

RUN mkdir /docker-entrypoint-initdb.d

COPY create_repo_mssql.sql /docker-entrypoint-initdb.d/

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 1433

ENTRYPOINT ["./docker-entrypoint.sh"]