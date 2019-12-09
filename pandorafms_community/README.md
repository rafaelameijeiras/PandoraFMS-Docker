# Pandora FMS

```
docker run --name Pandora_new %container_name% --rm \
-p %local_httpd_port%:80 \
-p %local_tentacle_port%:41121 \
-e DBHOST=%Mysql_Server_IP% \
-e DBNAME=%database_name% \
-e DBUSER=%Mysql_user% \
-e DBPASS=%Mysql_pass% \
-e DBPORT=%Mysql_port% \
-e INSTANCE_NAME=%server name% \
-ti rameijeiras/pandorafms-community
```
Example:
```
docker run --name Pandora_new --rm \
-p 8081:80 \
-p 41125:41121 \
-e DBHOST=192.168.80.45 \
-e DBNAME=pandora_demos_1 \
-e DBUSER=pandora \
-e DBPASS=pandora \
-e DBPORT=3306 \
-e INSTANCE_NAME=pandora201 \
-ti rameijeiras/pandorafms-community
```

### Integrated database for PandoraFMS container
There is a preconfigured database image in this repo to connect the Pandora environment  so you can up the database and then point the pandora container to the database.

Example:
```
docker run --name Pandora_DB \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=pandora \
-e MYSQL_DATABASE=pandora \
-e MYSQL_USER=pandora \
-e MYSQL_PASSWORD=pandora \
-d rameijeiras/pandorafms-percona-base
```

This creates a Percona mysql docker and a database called Pandora with grants to the pandora user (optional) and the credentials for root user. 
In this example we expose the 3308 for database connection. 

Using this configuration (getting the container ip from percona ip) you can execute the next container pandora pointing to it:

```
docker run --name Pandora_new --rm \
-p 8081:80 \
-p 41125:41121 \
-e DBHOST=<percona container ip> \
-e DBNAME=pandora \
-e DBUSER=pandora \
-e DBPASS=pandora \
-e DBPORT=3306 \
-e INSTANCE_NAME=pandora_inst \
-ti rameijeiras/pandorafms-community
```

Under construction.
