source .env
source .cloud

# Remove existing filebeat container
docker rm filebeat-cloud

# Start the container
docker run \
  --name=filebeat-cloud \
  --user=root \
  --volume="$(pwd)/bano-data:/bano-data:ro" \
  --volume="$(pwd)/filebeat-config/filebeat-cloud.yml:/usr/share/filebeat/filebeat.yml" \
  docker.elastic.co/beats/filebeat:$ELASTIC_VERSION filebeat -e -strict.perms=false -E cloud.id="$CLOUD_ID" -E cloud.auth="elastic:$CLOUD_PASSWORD"