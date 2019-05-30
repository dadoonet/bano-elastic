source .env

# Remove existing filebeat container
docker rm filebeat

# Start the container
docker run \
  --name=filebeat \
  --user=root \
  --network=demo_stack \
  --volume="$(pwd)/bano-data:/bano-data:ro" \
  --volume="$(pwd)/filebeat-config/filebeat.yml:/usr/share/filebeat/filebeat.yml" \
  docker.elastic.co/beats/filebeat:$ELASTIC_VERSION filebeat -e -strict.perms=false
