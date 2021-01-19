# v1.1

#!/bin/zsh

if [ $# -ne 1 ]; then
	echo "arg1 : filename for monitoring
(Usage : ./reminder.sh [filename])"
	exit 1
fi

INTERVAL=300

if [ -e $1 ]; then
	LAST=`openssl sha256 -r $1`
else
	echo "$1 is not exists now. Do you continue to monitoring? [y/n]"
	read input
	if [ $input != 'y' ]; then
		echo "exiting..."
		exit 1
	fi
	LAST=0
fi

echo "Monitoring : $1"

while true;
do
	sleep $INTERVAL
	if [ -e $1 ]; then
		CURRENT=`openssl sha256 -r $1`
		if [ "$LAST" != "$CURRENT" ]; then
			xeyes &
			wait $!
			echo "$1 was updated!"
			LAST=`openssl sha256 -r $1`
		fi
	fi
done

