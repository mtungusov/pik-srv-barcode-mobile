#!/bin/bash
###
# Run: ./bin/start.sh
###

LIBPATH=("${HOME}"/opt/kafka_2.10-0.8.2.2/libs/*.jar)
for i in "${LIBPATH[@]}"
do
    CLASSPATH="$i:$CLASSPATH"
done

export CLASSPATH=$CLASSPATH
export BARCODE_MOBILE_ENV=development && ./bin/srv-start
