source .env
source .cloud

echo Installation script for BANO demo with Elastic Cloud $ELASTIC_VERSION

echo Elasticsearch $ELASTIC_VERSION must be available on $CLOUD_URL
echo -ne "Waiting for elasticsearch"

until curl -u elastic:$CLOUD_PASSWORD -s "$CLOUD_URL" | grep "\"number\" : \"$ELASTIC_VERSION\"" > /dev/null; do
	  sleep 1
		echo -ne '.'
done

echo -ne '\n'
echo Elasticsearch is now up.

echo Defining bano ingest pipeline
curl -XPUT "$CLOUD_URL/_ingest/pipeline/bano" -u elastic:$CLOUD_PASSWORD -H 'Content-Type: application/json' -d'@cloud/ingest-bano.json' ; echo

echo Defining bano index template
curl -XPUT "$CLOUD_URL/_template/bano" -u elastic:$CLOUD_PASSWORD -H 'Content-Type: application/json' -d'@cloud/template-bano.json' ; echo

