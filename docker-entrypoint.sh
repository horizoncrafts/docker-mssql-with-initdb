#!/usr/bin/env bash

if [ "$1" = 'sqlservr' ]; then

	echo INFO: The server startup waiting time: ${MSSQL_SLEEP_TIME:=1}

	# this is run in the background, waiting till server start
	( while sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "GO"; do sleep ${MSSQL_SLEEP_TIME}; done &&  \
	  for f in /docker-entrypoint-initdb.d/*; do \
		case "$f" in \
			*.sql)    echo "$0: running $f"; /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i "$f"; echo ;; \
			*)        echo "$0: ignoring $f" ;; \
		esac \
	  done &&
	  echo "INFO: Database custom initialization completed" ) &

	# run the server
	/opt/mssql/bin/sqlservr

elif [ "$1" = 'sqlcmd' ]; then

	# the path to sqlcmd has beed set in the Dockerfile
	exec "$@"

else
	echo "Supported commands are sqlservr (default) or sqlcmd [parameters]"
fi