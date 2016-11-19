#!/bin/bash

DESIRED_VOLUME="$1"
CURRENT_VOLUME=`printf "%s\n\r" '?V' | nc -w 1 10.20.30.47 8102 | grep "VOL" | head -n 1 | cut -c 4- | sed 's/000/ 0/' | sed 's/^0*//' | tr '\n' ' ' | tr '\r' ' ' | tr -d ' '`

if [[ -n $CURRENT_VOLUME ]]; then
	echo "got initial volume: ${CURRENT_VOLUME}"
else
	echo "initial volume failed, exiting"
	exit
fi

echo "initial state ${CURRENT_VOLUME}, desired state ${DESIRED_VOLUME}"

while (( CURRENT_VOLUME != DESIRED_VOLUME )); do
	echo "CUR: ${CURRENT_VOLUME} / DES: ${DESIRED_VOLUME}"

	if (( CURRENT_VOLUME > DESIRED_VOLUME )); then
		echo "down"
		printf "%s\r\n" 'VD' | nc 10.20.30.47 8102
	fi	

	if (( CURRENT_VOLUME < DESIRED_VOLUME )); then
		echo "up" 
		printf "%s\r\n" 'VU' | nc 10.20.30.47 8102
	fi

	perl -e "select(undef,undef,undef,0.1);" 2> /dev/null 
	CURRENT_VOLUME=`printf "%s\n\r" '?V' | nc -w 1 10.20.30.47 8102 | grep "VOL" | head -n 1 | cut -c 4- | sed 's/000/ 0/' | sed 's/^0*//' | tr '\n' ' ' | tr '\r' ' ' | tr -d ' '`

	if [[ -n $CURRENT_VOLUME ]]; then
		echo "got new volume: $CURRENT_VOLUME"
	else
		echo "failed to get new volume, aborting"
		CURRENT_VOLUME=$DESIRED_VOLUME;
	fi
	echo
done 
