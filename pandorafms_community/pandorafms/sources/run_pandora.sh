#!/bin/bash
#
#  Prepares environment and launchs Pandora FMS
#
# Global vars
#
PANDORA_CONSOLE=/var/www/html/pandora_console
PANDORA_SERVER_CONF=/etc/pandora/pandora_server.conf
PANDORA_SERVER_BIN=/usr/bin/pandora_server
PANDORA_HA_BIN=/usr/bin/pandora_ha
PANDORA_TABLES_MIN=160
#
# Check database
#
function db_check {
	# Check DB
	echo -n ">> Checking dbengine connection: "

	for i in `seq $RETRIES`; do 
		r=`echo 'select 1' | mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST -A`
		if [ $? -ne 0 ]; then
			echo -n "retriying DB conection in $SLEEP seconds: " 
			sleep $SLEEP
		else
			break
		fi
	done

	r=`echo 'select 1' | mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST -A`
	if [ $? -eq 0 ]; then
		echo "OK"
		echo -n ">> Checking database connection: "
		r=`echo 'select 1' | mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST -A $DBNAME`
		if [ $? -eq 0 ]; then
			echo "OK"
			return 0
		fi
		echo -n ">> Cannot connect to $DBNAME, trying to create: "
		r=`echo "create database $DBNAME" | mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST`
		if [ $? -eq 0 ]; then
			echo "OK"
			return 0
		fi
		echo "Cannot create database $DBNAME on $DBUSER@$DBHOST:$DBPORT"

		return 1
	fi

	if [ "$DEBUG" == "1" ]; then
		echo "Command: [echo 'select 1' | mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST -A $DBNAME]"
		echo "Output: [$r]"

		traceroute $DBHOST
		nmap $DBHOST -v -v -p $DBPORT
	fi


	return 1
}

# Load database
#
function db_load {
	# Load DB
	echo -n ">> Checking database state:"
	r=`mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST -A $DBNAME -s -e 'show tables'| wc -l`
	if [ "$DEBUG" == "1" ]; then
		echo "Command: [mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST -A $DBNAME -s -e 'show tables'| wc -l]"
		echo "Output: [$r]"
	fi

	if [ "$r" -ge "$PANDORA_TABLES_MIN" ]; then
		echo 'OK. Already exists, '$r' tables detected'
		return 0
	fi
	echo 'Empty database detected';

	# Needs to be loaded.
	echo -n "- Loading database schema: "
	r=`mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST $DBNAME < $PANDORA_CONSOLE/pandoradb.sql`
	if [ $? -ne 0 ]; then
		echo "mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST $DBNAME < $PANDORA_CONSOLE/pandoradb.sql"
		echo "ERROR"
		echo "$r"
		return 1;
	fi
	echo "OK"

	echo -n "- Loading database data: "
	r=`mysql -u$DBUSER -p$DBPASS -P$DBPORT -h$DBHOST $DBNAME < $PANDORA_CONSOLE/pandoradb_data.sql`
	if [ $? -ne 0 ]; then
		echo "ERROR"
		echo $r
		return 2;
	fi
	echo "OK"

	# Loaded.
	return 0
}


#
# Prepare & start Pandora FMS Console
#
function console_prepare {
	CONSOLE_PATH=/var/www/html/pandora_console

	echo ">> Preparing console"
	# Delete install and license files.
	rm -f $CONSOLE_PATH/install.php $CONSOLE_PATH/install.done
	
	# Configure console.
	cat > $CONSOLE_PATH/include/config.php << EO_CONFIG_F
<?php
\$config["dbtype"] = "mysql";
\$config["dbname"]="$DBNAME";
\$config["dbuser"]="$DBUSER";
\$config["dbpass"]="$DBPASS";
\$config["dbhost"]="$DBHOST";
\$config["homedir"]="/var/www/html/pandora_console";
\$config["homeurl"]="/pandora_console";	
error_reporting(0); 
\$ownDir = dirname(__FILE__) . '/';
include (\$ownDir . "config_process.php");

EO_CONFIG_F

	echo "- Fixing permissions"
	chmod 600 $CONSOLE_PATH/include/config.php	
	chown apache. $CONSOLE_PATH/include/config.php

	# prepare php.ini
	sed -i -e "s/^max_input_time.*/max_input_time = -1/g" /etc/php.ini
	sed -i -e "s/^max_execution_time.*/max_execution_time = 0/g" /etc/php.ini
	sed -i -e "s/^upload_max_filesize.*/upload_max_filesize = 800M/g" /etc/php.ini
	sed -i -e "s/^memory_limit.*/memory_limit = 500M/g" /etc/php.ini

	# Start httpd
	echo "- Starting apache"
	/tmp/run-httpd.sh &
}

# Prepare server configuration

function server_prepare {
	sed -i -e "s/^dbhost.*/dbhost $DBHOST/g" $PANDORA_SERVER_CONF
	sed -i -e "s/^dbname.*/dbname $DBNAME/g" $PANDORA_SERVER_CONF
	sed -i -e "s/^dbuser.*/dbuser $DBUSER/g" $PANDORA_SERVER_CONF
	sed -i -e "s|^dbpass.*|dbpass $DBPASS|g" $PANDORA_SERVER_CONF
	sed -i -e "s/^dbport.*/dbport $DBPORT/g" $PANDORA_SERVER_CONF
	sed -i -e "s/^#servername.*/servername $INSTANCE_NAME/g" $PANDORA_SERVER_CONF
	echo "pandora_service_cmd /etc/init.d/pandora_server" >> $PANDORA_SERVER_CONF
}

# Run Pandora server
#
function server_run {
	# Tail extra logs
	sleep 5 && tail -F /var/log/pandora/pandora_server.{error,log} /var/www/html/pandora_console/pandora_console.log /var/log/httpd/error_log &
	
	# Launch pandora_server
	$PANDORA_SERVER_BIN $PANDORA_SERVER_CONF
}

## MAIN
#
if [ "$DBUSER" == "" ] || [ "$DBPASS" == "" ] || [ "$DBNAME" == "" ] || [ "$DBHOST" == "" ]; then
	echo "Required environemntal variables DBUSER, DBPASS, DBNAME, DBHOST"
	exit 1
fi
if [ "$DBPORT" == "" ]; then
	DBPORT=3306
fi

# Start tentacle
echo -n ">> Starting tentacle: "
if [ `/etc/init.d/tentacle_serverd restart | grep "is now running with PID" | wc -l` -ne 1 ]; then
	echo "ERROR"
	exit 1
fi
echo "OK"

# Check and prepare
db_check && db_load && console_prepare

# Enable discovery
echo  ">> Enable discovery cron: "
while true ; do wget -q -O - --no-check-certificate http://localhost/pandora_console/enterprise/cron.php >> /var/www/html/pandora_console/pandora_console.log && sleep 60 ; done &

# Enable cron
echo  ">> Enable pandora_db cron: "
/usr/share/pandora_server/util/pandora_db.pl /etc/pandora/pandora_server.conf
while true ; do sleep 1h && /usr/share/pandora_server/util/pandora_db.pl /etc/pandora/pandora_server.conf; done &

# Check and launch server
echo  ">> Starting server: " Check and launch server
server_prepare && server_run
