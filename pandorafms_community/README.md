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
-ti projectsartica/projects_demos:server_734
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
-ti projectsartica/projects_demos:server_734
```

Under construction.
