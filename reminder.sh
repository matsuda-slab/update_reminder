# v1.1

#!/bin/zsh

if [ $# -ne 1 ]; then
	echo "arg1 : filename for monitoring
(Usage : ./reminder.sh [filename])"
	exit 1
fi

INTERVAL=300

# initialize
if [ -e $1 ]; then
	HASHSUM=""
	if [ -d $1 ]; then
		for filename in $(find $1 -maxdepth 1 -type f); do
			HASH[i]=$(openssl sha256 -r $filename | cut -d " " -f 1)
			HASHSUM=$HASHSUM${HASH[i]}
		done
	else
		HASHSUM=`openssl sha256 -r $1`
	fi
	LAST=$HASHSUM
else
	echo "$1 is not exists now. Do you continue to monitoring? [y/n]"
	read input
	if [ $input != 'y' ]; then
		echo "exiting..."
		exit 1
	fi
	LAST=""
fi

echo "Monitoring : $1"

# inspect loop
while true;
do
	HASHSUM=""
	sleep $INTERVAL
	if [ -e $1 ]; then
		if [ -d $1 ]; then
			for filename in $(find $1 -maxdepth 1 -type f); do
				HASH[i]=$(openssl sha256 -r $filename | cut -d " " -f 1)
				HASHSUM=$HASHSUM${HASH[i]}
			done
		else
			HASHSUM=`openssl sha256 -r $1`
		fi
		CURRENT=$HASHSUM
		if [ "$LAST" != "$CURRENT" ]; then
			updatedfile=$(ls -1t $1 | head -n 1)
			xeyes &
			wait $!
			echo "$1 was updated! (maybe $updatedfile...)"
			LAST=$CURRENT
		fi
	fi
done

