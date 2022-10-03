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
CONTAINER ID   NAMES                                                   IMAGE                              STATE
c167f6cd7cb9   it-fse-gtw-test-container-it-fse-gtw-status-check-1     it-fse-gtw-runner                  running
a20b11045cad   it-fse-gtw-test-container-it-fse-srv-log-ingestion-1    it-fse-gtw-runner                  running
a738e0865306   it-fse-gtw-test-container-it-fse-gtw-fhir-mapping-1     it-fse-gtw-runner                  running
e2a3c2762714   it-fse-gtw-test-container-it-fse-gtw-indexer-1          it-fse-gtw-runner                  running
a81b2b3dad3f   it-fse-gtw-test-container-it-fse-gtw-validator-1        it-fse-gtw-runner                  running
355dcc1f06d9   it-fse-gtw-test-container-it-fse-gtw-rules-manager-1    it-fse-gtw-runner                  running
eedbd46775c7   it-fse-gtw-test-container-it-fse-gtw-status-manager-1   it-fse-gtw-runner                  running
222d55dc513d   it-fse-gtw-test-container-it-fse-gtw-dispatcher-1       it-fse-gtw-runner                  running
22919d11b02a   it-fse-gtw-test-container-it-fse-gtw-publisher-1        it-fse-gtw-runner                  running
c38a34fc9ce4   it-fse-gtw-test-container-kafka-1                       confluentinc/cp-kafka:6.2.1        running
6b6d337ffa11   it-fse-gtw-test-container-zookeeper-1                   confluentinc/cp-zookeeper:latest   running
ec96faea0aa9   it-fse-gtw-test-container-mongo-1                       mongo:4.2                          running
074684d97713   it-fse-gtw-test-container-redis-1                       redis                              running
```

che tutti i container siano in stato **running**

**NB** il nome dei container è dipendente dal nome della directory in cui si trova il file docker-compose - in questo caso *it-fse-gtw-test-container*

Se un container non fosse in esecuzione (ad esempio a causa di un out of memory) è possibile farlo partire con il comando

    docker start NOME_CONTAINER

Una volta avviato sarà possibile utilizzare come endpoint di collegamento `http://localhost:8010` corrispondente all'indirizzo del microservizio dispatcher incaricato di esporre i servizi.