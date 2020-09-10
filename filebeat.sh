source .cloud
source .env

FILEBEAT_SELECTORS="$1"

# Remove existing filebeat container
docker rm filebeat

# Start the container
docker run \
  --name=filebeat \
  --user=root \
  --volume="$(pwd)/bano-data:/bano-data:ro" \
  --volume="$(pwd)/filebeat-config/filebeat.yml:/usr/share/filebeat/filebeat.yml" \
  -p 8000:8000 \
  docker.elastic.co/beats/filebeat:$ELASTIC_VERSION filebeat -e -strict.perms=false -d "$FILEBEAT_SELECTORS" -E cloud.id="$CLOUD_ID" -E cloud.auth="elastic:$ELASTIC_PASSWORD"
