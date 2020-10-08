source .env.sh

# Start the container
docker run \
  --name=logstash \
  --rm -it \
  -v $(pwd)/logstash-config/query/search-by-geo.json:/usr/share/logstash/config/search-by-geo.json \
  -v $(pwd)/logstash-config/pipeline/:/usr/share/logstash/pipeline/ \
  -e XPACK_MONITORING_ENABLED=false \
  -e ELASTICSEARCH_URL="$ELASTICSEARCH_URL" \
  -e ELASTIC_PASSWORD="$ELASTIC_PASSWORD" \
  -p 9600:9600 \
  docker.elastic.co/logstash/logstash:$ELASTIC_VERSION
