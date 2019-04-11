# Loading a pipeline. Launch with cat foo.json | ./load_pipeline.sh foo
echo "Loading $1 pipeline from $1.json"
IFS=''
while read data; do
    message="$message$data\n" 
done < $1.conf
message=$(echo $message | sed 's/"/\\"/g')

generate_data()
{
  cat <<EOF
{
  "pipeline": "$message"
}
EOF
}

curl -XPUT "http://localhost:5601/api/logstash/pipeline/$1" -u elastic:changeme -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d"$(generate_data)"

