#!/usr/bin/env bash

echo INFO: The server startup waiting time: ${MSSQL_SLEEP_TIME:=20}

( sleep ${MSSQL_SLEEP_TIME} &&  \
  for f in /docker-entrypoint-initdb.d/*; do \
	case "$f" in \
		*.sql)    echo "$0: running $f"; /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i "$f"; echo ;; \
		*)        echo "$0: ignoring $f" ;; \
	esac \
  done \
  echo INFO: Database custom initialization completed ) &

/opt/mssql/bin/sqlservr