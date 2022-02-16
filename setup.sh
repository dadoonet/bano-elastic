source .env.sh

# Script properties
INJECTOR_FILE="injector-$INJECTOR_VERSION.jar"
INJECTOR_DOWNLOAD_URL="https://repo1.maven.org/maven2/fr/pilato/elasticsearch/injector/$INJECTOR_VERSION/$INJECTOR_FILE"

# Utility functions
check_service () {
	echo -ne '\n'
	echo $1 $STACK_VERSION must be available on $2
	echo -ne "Waiting for $1"

	until curl $CURL_OPTION -u elastic:$ELASTIC_PASSWORD -s "$2" | grep "$3" > /dev/null; do
		  sleep 1
			echo -ne '.'
	done

	echo -ne '\n'
	echo $1 is now up.
}

# Start of the script
echo Installation script for BANO demo with Elastic $STACK_VERSION

echo "##################"
echo "### Pre-checks ###"
echo "##################"

echo Pull filebeat $STACK_VERSION docker image
docker pull docker.elastic.co/beats/filebeat:$STACK_VERSION

echo Pull logstash $STACK_VERSION docker image
docker pull docker.elastic.co/logstash/logstash:$STACK_VERSION

if [ -z "$CLOUD_ID" ] ; then
	echo "We are running a local demo. If you did not start Elastic yet, please run:"
	echo "docker-compose up"
fi

check_service "Elasticsearch" "$ELASTICSEARCH_URL" "\"number\" : \"$STACK_VERSION\""
check_service "Kibana" "$KIBANA_URL/app/home#/" "<title>Elastic</title>"

echo -ne '\n'
echo "###############################"
echo "### Install Person Injector ###"
echo "###############################"
echo -ne '\n'

echo Download person injector
if [ ! -e injector/$INJECTOR_FILE ] ; then
  cd injector
  wget --no-check-certificate $INJECTOR_DOWNLOAD_URL
  cd -
fi

echo -ne '\n'
echo "################################"
echo "###      Reset Filebeat      ###"
echo "################################"
echo -ne '\n'

echo Replace filebeat configuration with the default one
cp filebeat-config/filebeat-origin.yml filebeat-config/filebeat.yml

echo -ne '\n'
echo "################################"
echo "### Configure Cloud Services ###"
echo "################################"
echo -ne '\n'

echo Remove existing bano template
curl $CURL_OPTION -XDELETE "$ELASTICSEARCH_URL/_index_template/bano" -u elastic:$ELASTIC_PASSWORD ; echo

echo Remove existing bano data
curl $CURL_OPTION -XDELETE "$ELASTICSEARCH_URL/banotest" -u elastic:$ELASTIC_PASSWORD ; echo

echo Remove existing person data
curl $CURL_OPTION -XDELETE "$ELASTICSEARCH_URL/person*" -u elastic:$ELASTIC_PASSWORD ; echo

echo Define ingest pipelines
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_ingest/pipeline/bano" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/ingest-bano-empty.json' ; echo

echo Define bano component templates
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_component_template/bano-settings" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/component-bano-settings.json' ; echo
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/_component_template/bano-mapping" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/component-bano-mapping.json' ; echo

echo Install Kibana Objects
curl $CURL_OPTION -XPOST "$KIBANA_URL/api/saved_objects/_import?overwrite=true" -H "kbn-xsrf: true" --form 'file=@kibana-config/bano.ndjson' -u elastic:$ELASTIC_PASSWORD ; echo

echo -ne '\n'
echo "#############################"
echo "### Inject Person Dataset ###"
echo "#############################"
echo -ne '\n'

echo Injecting person dataset
injector/injector.sh

echo -ne '\n'
echo "#####################"
echo "### Demo is ready ###"
echo "#####################"
echo -ne '\n'


echo "Open the conference page in the browser."

open https://speaker.pilato.fr/
open https://twitter.com/dadoonet
open https://www.elastic.co/elastic-stack
open https://github.com/dadoonet/bano-elastic
open https://cloud.elastic.co/
open https://bano.openstreetmap.fr/data/
open "$KIBANA_URL/app/management/ingest/ingest_pipelines/"
open "$KIBANA_URL/app/dev_tools#/console"

echo "Run in a terminal:"
echo "./filebeat.sh processors"


