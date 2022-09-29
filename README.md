# FSE 2.0 GATEWAY TEST CONTAINER

In questo repository è presente un file `docker-compose` che consente di avviare un'istanza locale del **gateway** di FSE 2.0.

## Requisiti:
* docker
* docker-compose
* 16 GiB di RAM

## Preparazione:

Per prima cosa è **necessario** creare un file `.env` copiando il file `.env-sample`.

All'interno del file è necessario inizializzare il `BASE_URL` da dove scaricare il codice dei microservizi del gateway.
Ad esempio:

    BASE_URL="https://github.com/ministero-salute/"

## Avvio:

Per avviare i container che compongono il gateway è sufficiente dalla directory contenente il file `docker-compose.yaml` lanciare il comando 

    docker-compose up

Verranno create le immagini e messi in esecuzione i container che compongono il gateway.
Potrebbero essere necessari **alcuni minuti** perché il sistema sia pronto, durante il primo avvio in particolare vengono scaricati e compilati i sorgenti e le librerie delle dipendenze dei microservizi, questo può richiedere parecchio tempo.

Assicurarsi con il comando
    
    docker ps -a --format="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.State}}"

```
CONTAINER ID   NAMES                                                   IMAGE                                     STATE
bbf42ad19bcb   it-fse-gtw-test-container-it-fse-gtw-publisher-1        it-fse-gtw-runner                         running
3100722e97bb   it-fse-gtw-test-container-it-fse-gtw-status-manager-1   it-fse-gtw-runner                         running
923ce979ebb9   it-fse-gtw-test-container-it-fse-gtw-validator-1        it-fse-gtw-runner                         running
a790cb0908e7   it-fse-gtw-test-container-it-fse-gtw-dispatcher-1       it-fse-gtw-runner                         running
204959a22ab8   it-fse-gtw-test-container-it-fse-gtw-status-check-1     it-fse-gtw-runner                         running
a3c8cf2957cd   it-fse-gtw-test-container-it-fse-gtw-rules-manager-1    it-fse-gtw-runner                         running
9e39b156fb03   it-fse-gtw-test-container-it-fse-gtw-fhir-mapping-1     it-fse-gtw-runner                         running
1e7c0fc3b041   it-fse-gtw-test-container-kafka-1                       confluentinc/cp-kafka:6.2.1               running
eeb9e4988f33   it-fse-gtw-test-container-logstash-1                    it-fse-gtw-test-container-logstash        running
583bf4e3e4ab   it-fse-gtw-test-container-kibana-1                      it-fse-gtw-test-container-kibana          running
2a2f3e91f079   it-fse-gtw-test-container-mongo-1                       mongo:4.2                                 running
55d11910cc2e   it-fse-gtw-test-container-zookeeper-1                   confluentinc/cp-zookeeper:latest          running
c0a85d348e43   it-fse-gtw-test-container-setup-1                       it-fse-gtw-test-container-setup           exited
5d0f2ccc30ee   it-fse-gtw-test-container-elasticsearch-1               it-fse-gtw-test-container-elasticsearch   running
e4d9abe8f508   it-fse-gtw-test-container-redis-1                       redis                                     running
014c2d70660b   it-fse-gtw-test-container-it-fse-gtw-indexer-1          it-fse-gtw-runner                         running
```

che tutti i container siano in stato **running** ad eccezione del container *setup*

**NB** il nome dei container è dipendente dal nome della directory in cui si trova il file docker-compose - in questo caso *it-fse-gtw-test-container*

Se un container non fosse in esecuzione (ad esempio a causa di un out of memory) è possibile farlo partire con il comando

    docker start NOME_CONTAINER

Una volta avviato sarà possibile utilizzare come endpoint di collegamento `http://localhost:8010` corrispondente all'indirizzo del microservizio dispatcher incaricato di esporre i servizi.