source .env.sh

FILEBEAT_SELECTORS="$1"
FILEBEAT_CONFIG_SUFFIX="$2"

# Remove existing filebeat container
docker rm filebeat

# Start the container
if [ -z "$CLOUD_ID" ] ; then
	# Running Locally
	docker run \
	  --name=filebeat \
	  --user=root \
	  --volume="$(pwd)/bano-data:/bano-data:ro" \
	  --volume="$(pwd)/filebeat-config/filebeat$FILEBEAT_CONFIG_SUFFIX.yml:/usr/share/filebeat/filebeat.yml" \
	  --network=demo_stack \
	  -p 8000:8000 \
	  docker.elastic.co/beats/filebeat:$ELASTIC_VERSION filebeat -e -strict.perms=false -d "$FILEBEAT_SELECTORS" -E output.elasticsearch.hosts=["http://elasticsearch:9200"] -E output.elasticsearch.username="elastic" -E output.elasticsearch.password="$ELASTIC_PASSWORD"
else
	# Running on Cloud
	docker run \
	  --name=filebeat \
	  --user=root \
	  --volume="$(pwd)/bano-data:/bano-data:ro" \
	  --volume="$(pwd)/filebeat-config/filebeat$FILEBEAT_CONFIG_SUFFIX.yml:/usr/share/filebeat/filebeat.yml" \
	  -p 8000:8000 \
	  docker.elastic.co/beats/filebeat:$ELASTIC_VERSION filebeat -e -strict.perms=false -d "$FILEBEAT_SELECTORS" -E cloud.id="$CLOUD_ID" -E cloud.auth="elastic:$ELASTIC_PASSWORD"
fi

