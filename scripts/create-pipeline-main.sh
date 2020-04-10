#!/bin/bash
echo "Criando pipeline main para o Logstash..."
sleep 30
curl -u elastic:123456 -X PUT "http://localhost/api/logstash/pipeline/test" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d @create-pipeline-logstash.json
curl -u elastic:123456 -X PUT "http://localhost/api/logstash/pipeline/logging" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d @create-pipeline-logstash.json
#clear
echo "Criando pipeline main para o Logstash... OK!"
