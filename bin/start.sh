#!/bin/bash
###
# Run: ./bin/start.sh
###

if [ "x$RUN_ENV" = "x" ]
then
  RUN_ENV="development"
fi

LIBPATH=("${HOME}"/opt/kafka_2.11-0.9.0.0/libs/*.jar)
for i in "${LIBPATH[@]}"
do
    CLASSPATH="$i:$CLASSPATH"
done

export CLASSPATH=$CLASSPATH
export BARCODE_MOBILE_ENV=$RUN_ENV && ./bin/srv-start
