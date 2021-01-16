#!/bin/zsh

if [ $# -ne 1 ]; then
	echo "arg1 : filename for monitoring
(Usage : ./reminder.sh [filename])"
	exit 1
fi

echo "Monitoring : $1"

INTERVAL=300

LAST=`openssl sha256 -r $1`

while true;
do
	sleep $INTERVAL
	CURRENT=`openssl sha256 -r $1`
	if [ "$LAST" != "$CURRENT" ]; then
		xeyes &
		wait $!
		echo "$1 was updated!"
		LAST=`openssl sha256 -r $1`
	fi
done

