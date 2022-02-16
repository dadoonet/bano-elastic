#!/bin/sh
source .env.sh

java -jar injector/injector-$INJECTOR_VERSION.jar \
	--es.host $ELASTICSEARCH_URL \
	--es.pass $ELASTIC_PASSWORD \
	--nb 100000
