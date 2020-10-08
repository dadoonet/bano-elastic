source .env

if [ -e .cloud ] ; then
	source .cloud

	if [ -z "$CLOUD_PASSWORD" ] || [ -z "$CLOUD_ID" ] ; then
    echo ".cloud file is incorrect. It must contain:"
    echo "CLOUD_ID=YOUR_CLOUD_ID"
    echo "CLOUD_PASSWORD=YOUR_CLOUD_PASSWORD"
	  echo "Falling back to local configuration."
		ELASTICSEARCH_URL=http://localhost:9200
		KIBANA_URL=http://localhost:5601
		ELASTIC_PASSWORD=changeme
	else
		# Decode CLOUD_ID
		DOMAIN=$(echo $CLOUD_ID | cut -d':' -f2 | base64 -d | cut -d'$' -f1)
		ES=$(echo $CLOUD_ID | cut -d':' -f2 | base64 -d | cut -d'$' -f2)
		KI=$(echo $CLOUD_ID | cut -d':' -f2 | base64 -d | cut -d'$' -f3)
		ELASTICSEARCH_URL=https://$ES.$DOMAIN:9243
		KIBANA_URL=https://$KI.$DOMAIN:9243
		ELASTIC_PASSWORD=$CLOUD_PASSWORD
	fi

else
  echo ".cloud file does not exist. Falling back to local configuration."
	ELASTICSEARCH_URL=http://localhost:9200
	KIBANA_URL=http://localhost:5601
	ELASTIC_PASSWORD=changeme
fi

LOGSTASH_URL=http://localhost:8080
