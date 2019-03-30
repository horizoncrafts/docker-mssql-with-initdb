# mssql-with-initdb
A Docker image based on Ms' with initdb feature

# About this image
A Docker image based on "Microsoft SQL Server" by Microsoft with initdb added.

# Usage
This Docker image is designed to do the same as the origianl SQL Server image (https://hub.docker.com/_/microsoft-mssql-server), additionaly enabling you to provide the database initialization scripts in a convenient manner.

Simply copy your sql files into /docker-entrypoing-initdb and they will be executed in lexicografical order during container startup (`docker run`), not during image build time!

```
 FROM horizoncrafts/mssql-with-initdb

 COPY mssql-init.sql /docker-entrypoint-initdb.d/
```

You can also just use this image and bind the sql scripts from the host:

```
docker run -v your-sql-init-folder:/docker-entrypoint-initdb.d/ -p 1433:1433 -d horizoncrafts/mssql-with-initdb
```

Or, in docker-compose yaml file:

```
mssql:
    image: horizoncrafts/mssql-with-initdb
    container_name: mssql
    ports:
      - "1433:1433"
    volumes:
      - type: bind
        source: your-sql-init-folder
        target: /docker-entrypoint-initdb.d/
      - type: bind
        source: your-persistent-database-data-folder
        target: /var/opt/mssql
    environment:
          ACCEPT_EULA: your-EULA-acceptance-Y-or-N
          SA_PASSWORD: aStrongPassword
```
this example additionally shows how to attain data persistency. However, note that this combination usually makes sens only for the first time when `your-persistent-database-data-folder` is not yet initialized. After that you would rather not put anything in `/docker-entrypoint-initdb.d`. 
When on macOS and mounting such a volume I usually add `consistency: delegated`. That - at least for me - increases the database performce at the expance of the speed of synchronisation between container and host. Read more: 
- https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-docker?view=sql-server-2017#persist
- https://docs.docker.com/docker-for-mac/osxfs-caching/ 

# Details

[Original documentation](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&pivots=cs1-bash)


## What additionally happens inside this image?

1. There are series of commands put to sleep for `$MSSQL_SLEEP_TIME` seconds. When eventually activated after the sleep, these commands run each sql file found in `/docker-entrypoint-initdb.d` against the database (preassumingly running after `$MSSQL_SLEEP_TIME`)
1. the sql server process is initiated immediately, so it can be ready for the sleeping commands.

# Configuration

## Requirement
Check original image at https://hub.docker.com/_/microsoft-mssql-server

## Environment Variables

The environment variables introduced by this instance:

- `MSSQL_SLEEP_TIME` - default value 20. 

Regarding the SQL Server specific variables, check https://hub.docker.com/_/microsoft-mssql-server

# Related Repos
This image is based on https://hub.docker.com/_/microsoft-mssql-server

# License
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

Check Microsoft license information. Start at https://hub.docker.com/_/microsoft-mssql-server and Microsoft's [End-User Licensing Agreement](https://go.microsoft.com/fwlink/?linkid=857698)
> By passing the value "Y" to the environment variable "ACCEPT_EULA", you are expressing that you have a valid and existing license for the edition and version of SQL Server that you intend to use. You also agree that your use of SQL Server software running in a Docker container image will be governed by the terms of your SQL Server license.