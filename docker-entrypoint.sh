#!/usr/bin/env bash

if [ "$1" = 'sqlservr' ]; then

	echo INFO: ${BASH_SOURCE}: The initialization single pause time: ${MSSQL_SLEEP_TIME:=1}

	# this is run in the background, 
	# waiting till server start
    # after server becomes accessible, execute the scripts
	( until sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "GO" 2>/dev/null; do echo "INFO: ${BASH_SOURCE}: waiting for ${MSSQL_SLEEP_TIME} seconds" && sleep ${MSSQL_SLEEP_TIME}; done &&  \
	  for f in /docker-entrypoint-initdb.d/*; do \
		case "$f" in \
			*.sql)    echo "INFO: ${BASH_SOURCE}: running $f"; /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i "$f"; echo ;; \
			*)        echo "INFO: ${BASH_SOURCE}: ignoring $f" ;; \
		esac \
	  done && \
	  echo "INFO: ${BASH_SOURCE} Database custom initialization completed" ) &

elif [ "$1" -ne 'sqlcmd' ]; then

	echo "WARN: ${BASH_SOURCE}: Supported commands are sqlservr (default) or sqlcmd"
fi

# the path to sqlcmd and sqlservr is assumed to have beed added to PATH in the Dockerfile
exec "$@"