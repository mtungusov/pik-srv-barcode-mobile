#!/usr/bin/env bash
###
# Run: ./bin/start-cns.sh
###

LIBPATH=("${HOME}"/opt/kafka_2.11-0.9.0.0/libs/*.jar)
for i in "${LIBPATH[@]}"
do
    CLASSPATH="$i:$CLASSPATH"
done

export CLASSPATH=$CLASSPATH
export BARCODE_MOBILE_ENV=development && ./bin/cns-start
