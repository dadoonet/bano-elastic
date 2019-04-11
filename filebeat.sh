# Remove existing filebeat container
docker rm filebeat

# Start the container
docker run \
  --name=filebeat \
  --user=root \
  --network=demo_stack \
  --volume="$(pwd)/bano-data:/bano-data:ro" \
  --volume="$(pwd)/filebeat-config/filebeat.yml:/usr/share/filebeat/filebeat.yml" \
  docker.elastic.co/beats/filebeat:7.0.0 filebeat -e -strict.perms=false
