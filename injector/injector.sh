#!/bin/sh
source .env.sh

java -jar injector/injector-7.0.jar \
	--es.host $ELASTICSEARCH_URL \
	--es.pass $ELASTIC_PASSWORD \
	--nb 100000
