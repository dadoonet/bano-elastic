#!/bin/sh
source .env
java -jar injector/injector-7.0.jar \
	--debug \
	--es.pass $ELASTIC_PASSWORD \
	--nb 100000
