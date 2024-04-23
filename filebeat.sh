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
	  --volume="./bano-data:/bano-data:ro" \
	  --volume="./filebeat-config/filebeat$FILEBEAT_CONFIG_SUFFIX.yml:/usr/share/filebeat/filebeat.yml" \
	  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
	  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
	  --network=bano_default \
	  -p 8000:8000 \
	  docker.elastic.co/beats/filebeat:$STACK_VERSION filebeat -e -strict.perms=false -d "$FILEBEAT_SELECTORS" -E output.elasticsearch.ssl.verification_mode=none -E output.elasticsearch.hosts=["https://es01:9200"] -E output.elasticsearch.username="elastic" -E output.elasticsearch.password="$ELASTIC_PASSWORD"
else
	# Running on Cloud
	docker run \
	  --name=filebeat \
	  --user=root \
	  --volume="./bano-data:/bano-data:ro" \
	  --volume="./filebeat-config/filebeat$FILEBEAT_CONFIG_SUFFIX.yml:/usr/share/filebeat/filebeat.yml" \
	  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
	  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
	  -p 8000:8000 \
	  docker.elastic.co/beats/filebeat:$STACK_VERSION filebeat -e -strict.perms=false -d "$FILEBEAT_SELECTORS" -E cloud.id="$CLOUD_ID" -E cloud.auth="elastic:$ELASTIC_PASSWORD"
fi

