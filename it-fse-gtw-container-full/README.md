# Fascicolo Sanitario 2.0

# _it-fse-gtw-test-container_

In questa directory è presente un file `docker-compose` che consente di avviare un'istanza locale *full* del **Gateway** e **EDS** di FSE 2.0.

La seguente versione contiene tutti i microservizi di **gateway** ed **eds** ad oggi sviluppati

[<img src="../img/container-full-gtw.png" width="75%" style="display: block; margin: 0 auto" />](container-full-gtw.png)

[<img src="../img/container-full-eds.png" width="75%" style="display: block; margin: 0 auto" />](container-full-eds.png)

<br/>

## Preparazione:

Per prima cosa è **necessario** creare un file `.env` copiando il file `.env-sample` presente nella directory corrente. 
Il file è opportunamente inizializzato con il `REPO_BASE_URL` e il `CURRENT_BRANCH` da cui scaricare il codice dei microservizi del gateway.

Ad esempio:

    REPO_BASE_URL="https://github.com/ministero-salute"
    CURRENT_BRANCH=main

<br/>

## Avvio:

Per avviare i container che compongono il Gateway è sufficiente posizionarsi da terminale nella directory contenente il file `docker-compose.yaml` e lanciare il comando 

    docker-compose up

Verranno create le immagini e messi in esecuzione i container che compongono il gateway.

<br/>


**N.B.** Il nome dei container generato è dipendente dal nome della directory in cui si trova il file docker-compose, in questo caso *it-fse-container-full*

Potrebbero essere necessari **alcuni minuti** perché il sistema sia pronto, durante il primo avvio in particolare vengono scaricati e compilati i sorgenti e le librerie delle dipendenze dei microservizi, questo può richiedere parecchio tempo.

<br/>

Una volta avviato sarà possibile utilizzare come endpoint di collegamento http://localhost:8010 corrispondente all'indirizzo del microservizio dispatcher incaricato di esporre i servizi. È possibile inoltre consultare lo swagger al seguente link http://localhost:8080/fhir/swagger-ui/.

<br/>

## Troubleshooting:

Assicurarsi che tutti i container siano instato **running** tramite GUI di `Docker Desktop` o tramite il comando
    
    docker ps -a --format="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.State}}"

L'output atteso dal seguente comando è il seguente:

| CONTAINER ID | NAMES | IMAGE | STATE |
|--------------|-------|-------|-------|
| 3b0d6d4cdfeb | it-fse-container-full-it-fse-gtw-dispatcher-1             | it-fse-ms-runner                  | running
| 3425ded08129 | it-fse-container-full-it-fse-gtw-indexer-1                | it-fse-ms-runner                  | running
| b6fe61f8793e | it-fse-container-full-it-fse-gtw-status-check-1           | it-fse-ms-runner                  | running
| dcd93eda8566 | it-fse-container-full-it-fse-gtw-publisher-1              | it-fse-ms-runner                  | running
| 68b458bfede1 | it-fse-container-full-it-fse-gtw-garbage-1                | it-fse-ms-runner                  | running
| 2a52e676ec95 | it-fse-container-full-it-fse-gtw-validator-1              | it-fse-ms-runner                  | running
| ebd5824bbf3f | it-fse-container-full-it-fse-gtw-ini-client-1             | it-fse-ms-runner                  | running
| 2d33e7f0b44f | it-fse-container-full-it-fse-gtw-status-manager-1         | it-fse-ms-runner                  | running
| b4c7863fbe97 | it-fse-container-full-it-fse-gtw-fhir-mapping-engine-1    | it-fse-ms-runner                  | running
| 50dba0237700 | it-fse-container-full-it-fse-gtw-fhir-mapping-1           | it-fse-ms-runner                  | running
| 877bdb4a2748 | it-fse-container-full-it-fse-gtw-eds-client-1             | it-fse-ms-runner                  | running
| d5f08febd5ba | it-fse-container-full-it-fse-gtw-config-1                 | it-fse-ms-runner                  | running
| 856930c725e4 | it-fse-container-full-it-fse-gtw-rules-manager-1          | it-fse-ms-runner                  | running
| d8ebacdb4f2e | it-fse-container-full-it-fse-datarepo-processor-1         | it-fse-ms-runner                  | running
| fbfc3acf7e16 | it-fse-container-full-it-fse-datarepo-data-quality-1      | it-fse-ms-runner                  | running
| a6601b8722bb | it-fse-container-full-it-fse-srv-ingestion-1              | it-fse-ms-runner                  | running
| f4a15cfc0439 | it-fse-container-full-it-fse-srv-dictionary-1             | it-fse-ms-runner                  | running
| ef7f953e30b8 | it-fse-container-full-it-fse-datarepo-fhir-server-1       | it-fse-ms-runner                  | running
| 3953607153d9 | it-fse-container-full-it-fse-srv-fhir-1                   | it-fse-ms-runner                  | running
| 4896820f5885 | it-fse-container-full-it-fse-srv-syntax-rules-manager-1   | it-fse-ms-runner                  | running
| f6c82592adfd | it-fse-container-full-it-fse-srv-semantic-rules-manager-1 | it-fse-ms-runner                  | running
| ccaaf49acd24 | it-fse-container-full-it-fse-srv-query-1                  | it-fse-ms-runner                  | running
| 6046edbee2c1 | it-fse-container-full-it-fse-srv-log-ingestion-1          | it-fse-ms-runner                  | running
| 434b96967cb2 | it-fse-container-full-kafka-ui-1                          | provectuslabs/kafka-ui            | running
| 8a493f0c40d1 | it-fse-container-full-mongo-1                             | mongo:4.2                         | running
| 06da0d6edf65 | it-fse-container-full-zookeeper-1                         | confluentinc/cp-zookeeper:latest  | running
| 72929eb90052 | it-fse-container-full-kafka-1                             | confluentinc/cp-kafka:latest      | running