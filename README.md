# Elastic Stack Basic License Scripts
## Passo a Passo - Montagem de infra Elastic Stack

## Pré Requisitos
Para Montagem da infra é necessário os seguintes serviços instalados:

- CentOS 7/Redhat 7
- Repositório EPEL
- Docker CE 1.8 ou superior
- Docker-compose

## Passo 1 - Preparando o SO instalando repositório EPEL e dependências
```
# yum upgrade -y
# vi /etc/sysconfig/selinux
SELINUX=disabled
# vi /etc/sysctl.conf
vm.max_map_count=262144
# reboot
```
ou
```
# sysctl -w vm.max_map_count=262144
# setenforce 0
```
Se Centos 7
```
# yum install epel-release -y
# yum install -y yum-utils device-mapper-persistent-data lvm2 git vim htop net-tools lsof 
```
Se RedHat7
```
# yum install python-devel openldap-devel
# yum groupinstall "Development tools"
# yum-config-manager --enable rhel-7-server-extras-rpms
# yum install -y yum-utils device-mapper-persistent-data lvm2 git vim htop net-tools lsof
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# yum repolist
```
## Passo 2 - Instalando o repositorio do Docker CE e instalando o Docker CE
```
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum install docker-ce python-pip -y
# pip install --upgrade pip
# systemctl enable docker.service
# systemctl start docker.service
```
## Passo 3 - Instalando o docker-compose
```
# pip install docker-compose
```
## Passo 4 - Liberando portas do Elasticsearch, Logstash e Kibana no FirewallD (CentOS/RHCE7)
```
# firewall-cmd --zone=public --permanent --add-port=9200/tcp
# firewall-cmd --zone=public --permanent --add-port=8200/tcp
# firewall-cmd --zone=public --permanent --add-port=5601/tcp
# firewall-cmd --zone=public --permanent --add-port=9600/tcp
# firewall-cmd --zone=public --permanent --add-port=5044/tcp
# firewall-cmd --reload
```
## Passo 5 - Clonando os scripts Elastic Stack
```
# cd /opt/ 
# git clone https://github.com/gleberrl/elastic.git
```
## Passo 6 - Subindo as instancias de Elasticsearch, Kibana e Logstash com docker-compose
**OBS:** Após realizado o clone do repositório você perceberá que dentro da pasta elastic possui o arquivo do docker-compose.yml e arquivos de configuração da pilha.

Subindo o docker-compose.
```
# cd elatic
# docker-compose up -d
```
Verificado se o container subiu e se as portas estão operacional
```
# docker ps
```
Abaixo o resultado esperado de exemplo:
```
CONTAINER ID        IMAGE                                                 COMMAND                  CREATED             STATUS              PORTS                                            NAMES
4179a0588b63        docker.elastic.co/apm/apm-server:7.6.2                "/usr/local/bin/dock…"   14 minutes ago      Up 14 minutes       0.0.0.0:8200->8200/tcp                           apm-server
7985514745c7        docker.elastic.co/kibana/kibana:7.6.2                 "/usr/local/bin/dumb…"   14 minutes ago      Up 14 minutes       0.0.0.0:5601->5601/tcp                           kb01
83707824ecab        docker.elastic.co/logstash/logstash:7.6.2             "/usr/local/bin/dock…"   14 minutes ago      Up 11 minutes       0.0.0.0:5044->5044/tcp, 0.0.0.0:9600->9600/tcp   ls01
0f3d8d2d07af        docker.elastic.co/elasticsearch/elasticsearch:7.6.2   "/usr/local/bin/dock…"   14 minutes ago      Up 14 minutes       9200/tcp, 9300/tcp                               es03
72ef5976c3be        docker.elastic.co/elasticsearch/elasticsearch:7.6.2   "/usr/local/bin/dock…"   14 minutes ago      Up 14 minutes       9200/tcp, 9300/tcp                               es02
675512fc627b        docker.elastic.co/elasticsearch/elasticsearch:7.6.2   "/usr/local/bin/dock…"   14 minutes ago      Up 14 minutes       0.0.0.0:9200->9200/tcp, 9300/tcp                 es01
```
Aguarde em torno de 2 minutos até que o elasticsearch esteja no ar e obtenha o retorno abaixo para o comando:
```
# curl -XGET http://localhost:9200 -u elastic:123456
```
```
{
  "name" : "es01",
  "cluster_name" : "elastic-docker",
  "cluster_uuid" : "Lygb8XmFSnmB4oqFBAJXww",
  "version" : {
    "number" : "7.6.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "2f90bbf7b93631e52bafb59b3b049cb44ec25e96",
    "build_date" : "2019-10-28T20:40:44.881551Z",
    "build_snapshot" : false,
    "lucene_version" : "8.2.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
OBS: Caso o passo 5 não tenha sido concluído com sucesso, repetir os passos anteriores.

## Passo 7 - Definindo senhas para os serviços da Stack(Kibana, Elasticsearch, Beats, Logstash e APM Server)

Digite o comando abaixo para cadastrar as senhas do keystore e iniciar o pipeline do logstash.
```
# ./start.sh
```
Resultado esperado:
```
Iniciando...
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: linorg.usp.br
 * extras: linorg.usp.br
 * updates: linorg.usp.br
Resolving Dependencies
--> Running transaction check
---> Package expect.x86_64 0:5.45-14.el7_1 will be installed
--> Processing Dependency: libtcl8.5.so()(64bit) for package: expect-5.45-14.el7_1.x86_64
--> Running transaction check
---> Package tcl.x86_64 1:8.5.13-8.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package         Arch            Version                    Repository     Size
================================================================================
Installing:
 expect          x86_64          5.45-14.el7_1              base          262 k
Installing for dependencies:
 tcl             x86_64          1:8.5.13-8.el7             base          1.9 M

Transaction Summary
================================================================================
Install  1 Package (+1 Dependent package)

Total download size: 2.1 M
Installed size: 4.9 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                              1.2 MB/s | 2.1 MB  00:01
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 1:tcl-8.5.13-8.el7.x86_64                                    1/2
  Installing : expect-5.45-14.el7_1.x86_64                                  2/2
  Verifying  : 1:tcl-8.5.13-8.el7.x86_64                                    1/2
  Verifying  : expect-5.45-14.el7_1.x86_64                                  2/2

Installed:
  expect.x86_64 0:5.45-14.el7_1

Dependency Installed:
  tcl.x86_64 1:8.5.13-8.el7

Complete!
spawn /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
Initiating the setup of passwords for reserved users elastic,apm_system,kibana,logstash_system,beats_system,remote_monitoring_user.
You will be prompted to enter passwords as the process progresses.
Please confirm that you would like to continue [y/N]y


Enter password for [elastic]:
Reenter password for [elastic]:
Enter password for [apm_system]:
Reenter password for [apm_system]:
Enter password for [kibana]:
Reenter password for [kibana]:
Enter password for [logstash_system]:
Reenter password for [logstash_system]:
Enter password for [beats_system]:
Reenter password for [beats_system]:
Enter password for [remote_monitoring_user]:
Reenter password for [remote_monitoring_user]:
Changed password for user [apm_system]
Changed password for user [kibana]
Changed password for user [logstash_system]
Changed password for user [beats_system]
Changed password for user [remote_monitoring_user]
Changed password for user [elastic]
Criando roles do Logstash...
{"role":{"created":true}}{"created":true}
Senhas e roles setada com sucesso!!!


Criando pipeline main para o Logstash...
Criando pipeline main para o Logstash... OK!
```
Acesse o kibana via navegador

### http://<IP_DO_HOST>:5601

Se pedir login e senha use: elastic/123456 a senha esta definida no aquivo docker-compose.yml
