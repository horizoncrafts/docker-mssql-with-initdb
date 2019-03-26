#!/usr/bin/env bash

( sleep ${MSSQL_SLEEP_TIME:-20} &&  \
  for f in /docker-entrypoint-initdb.d/*; do \
	case "$f" in \
		*.sql)    echo "$0: running $f"; /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i "$f"; echo ;; \
		*)        echo "$0: ignoring $f" ;; \
	esac \
  done ) &

/opt/mssql/bin/sqlservr