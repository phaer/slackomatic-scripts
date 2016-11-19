#!/bin/bash

declare -i VOLUME=`./get_volume.sh`
declare -i STEP=$1

declare -i NEW_VOLUME=${VOLUME}+${STEP}
#echo "volume: ${VOLUME}, step: ${STEP} -> newVolume: ${NEW_VOLUME}"

cat vol_template | sed "s/NEW_VOLUME/${NEW_VOLUME}/g" | ./send.sh - 
