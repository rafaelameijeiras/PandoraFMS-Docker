#!/bin/sh
# Bootstrap gotty container.
# Rafael Ameijeiras 2019

# Default values
GOTTY="/app/gotty"
CREDENTIALS="pandora:pandora"
WRITE="-w"
PORT="8080"
CMD="ssh"


function help {
	echo -e "RUN GOTTY WHIT ARGUMENTS" 
	echo -e "Syntax:" 
	echo -e "entrypoint.sh [-c <user:pass> -a <bind_address> -p <port>] -r <ssh or telnet>"
	echo -e "by default the credentials are pandora:pandora, the bind_address is 0.0.0.0, the port is 8080 and the run app is SSH"
	exit
}

# Main parsing code

while getopts ":h:a:c:p:r:" optname
  do
    case "$optname" in
      "h")
	        help
		;;
      "a")
	        BIND="-a $OPTARG"
        ;;
      "c")
		    CREDENTIALS=$OPTARG
        ;;
      "p")
		    PORT=$OPTARG
        ;;
      "r")                 
		    CMD=$OPTARG
         ;;      
        ?)
		help
		;;
      default) 
		help
	;;
     
    esac
done

if [ -z "$CREDENTIALS" ]
then
	help
fi

# Main
echo "Runing: $GOTTY -c SECRET --permit-arguments -w $BIND --port $PORT $CMD"
$GOTTY -c $CREDENTIALS --permit-arguments -w $BIND --port $PORT $CMD