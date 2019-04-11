source .env
echo Installation script for BANO demo with Elastic $ELASTIC_VERSION

echo Kibana must be available. If not, run:
echo docker-compose down -v
echo docker-compose up
echo -ne "Waiting for kibana"

until curl -s "http://localhost:5601/login" | grep "Loading Kibana" > /dev/null; do
	  sleep 1
		echo -ne '.'
done

echo -ne '\n'
echo Kibana is now up.

INJECTOR_VERSION="7.0"
INJECTOR_FILE="injector-$INJECTOR_VERSION.jar"
INJECTOR_DOWNLOAD_URL="https://download.elastic.co/workshops/basic-kibana/injector/$INJECTOR_FILE"

echo Download person injector
if [ ! -e injector/$INJECTOR_FILE ] ; then
  cd injector
  wget --no-check-certificate $INJECTOR_DOWNLOAD_URL
  cd -
fi

echo Configuring default Logstash demo pipelines
cd logstash-config/pipeline
./load_pipeline.sh beats
./load_pipeline.sh http
./load_pipeline.sh bano
cd -

echo Removing existing bano template
curl -XDELETE http://localhost:9200/_template/bano -u elastic:$ELASTIC_PASSWORD ; echo

echo Removing existing bano data
curl -XDELETE http://localhost:9200/bano -u elastic:$ELASTIC_PASSWORD ; echo
curl -XDELETE http://localhost:9200/banotest -u elastic:$ELASTIC_PASSWORD ; echo

echo Removing existing person data
curl -XDELETE http://localhost:9200/person -u elastic:$ELASTIC_PASSWORD ; echo

echo Injecting person dataset
injector/injector.sh

echo Pull filebeat docker image
docker pull docker.elastic.co/beats/filebeat:$ELASTIC_VERSION


