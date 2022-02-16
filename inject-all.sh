source .env.sh

echo Define ingest pipelines with full options
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_ingest/pipeline/bano" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/ingest-bano.json' ; echo

echo Define bano component templates
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_component_template/bano-settings" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/component-bano-settings.json' ; echo
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_component_template/bano-mapping" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/component-bano-mapping.json' ; echo

echo Define the bano template
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_index_template/bano" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/index-template-bano.json' ; echo

echo Injecting the whole bano dataset into $ELASTICSEARCH_URL
./filebeat.sh "" "-all"

echo Define ingest pipelines empty
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_ingest/pipeline/bano" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/ingest-bano.json' ; echo

echo Remove existing bano template
curl $CURL_OPTION -XDELETE "$ELASTICSEARCH_URL/_index_template/bano" -u elastic:$ELASTIC_PASSWORD ; echo
