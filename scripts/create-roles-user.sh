#!/bin/bash
docker exec es01 /bin/bash -c "yum -y install expect && /usr/share/elasticsearch/scripts/set-pw-es.sh"
echo "Criando roles do Logstash..."
curl -u elastic:123456 -X POST http://localhost:9200/_xpack/security/role/logstash_writer -H "Content-type: application/json" -d @create-roles.json
curl -u elastic:123456 -X POST http://localhost:9200/_xpack/security/user/logstash_internal -H "Content-type: application/json" -d @create-user.json
echo ""
echo "Senhas e roles setada com sucesso!!!"
echo ""
echo ""
