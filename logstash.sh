source .env.sh

# Start the container
if [ -z "$CLOUD_ID" ] ; then
	# Running Locally
	docker run \
	  --name=logstash \
	  --network=bano_default \
	  --rm -it \
	  -v $(pwd)/logstash-config/query/search-by-geo.json:/usr/share/logstash/config/search-by-geo.json \
	  -v $(pwd)/logstash-config/pipeline/:/usr/share/logstash/pipeline/ \
	  -e XPACK_MONITORING_ENABLED=false \
	  -e ELASTICSEARCH_URL="https://es01:9200" \
	  -e ELASTIC_PASSWORD="$ELASTIC_PASSWORD" \
	  -p 9600:9600 \
	  docker.elastic.co/logstash/logstash:$STACK_VERSION
else
	# Running on Cloud
	docker run \
	  --name=logstash \
	  --rm -it \
	  -v $(pwd)/logstash-config/query/search-by-geo.json:/usr/share/logstash/config/search-by-geo.json \
	  -v $(pwd)/logstash-config/pipeline/:/usr/share/logstash/pipeline/ \
	  -e XPACK_MONITORING_ENABLED=false \
	  -e ELASTICSEARCH_URL="$ELASTICSEARCH_URL" \
	  -e ELASTIC_PASSWORD="$ELASTIC_PASSWORD" \
	  -p 9600:9600 \
	  docker.elastic.co/logstash/logstash:$STACK_VERSION
fi


