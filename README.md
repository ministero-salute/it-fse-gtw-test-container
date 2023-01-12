# Fascicolo Sanitario 2.0

# _it-fse-gtw-test-container_

In questo repository sono contenuti i container FSE che consentono di avviare istanze locali di **Gateway** ed **EDS** del Fascicolo Sanitario 2.0.

<br/>

Sono attualmente presenti i seguenti container

| TOOL | LINK | DESCRIPTION |
| :------------: | :------------: | ------------ |
| Versione *Lite* | [it-fse-container-lite](https://github.com/ministero-salute/it-fse-gtw-test-container/tree/main/it-fse-container-lite) | La seguente versione contiene il sottoinsieme minimo di microservizi necessari ad effettuare la validazione di un documento CDA2 e la sua trasformazione in Bundle FHIR |
| Versione *Full* | [it-fse-container-full](https://github.com/ministero-salute/it-fse-gtw-test-container/tree/main/it-fse-container-full) | La seguente versione contiene tutti i microservizi di **Gateway** ed **EDS** ad oggi sviluppati. |
|

<br/>

## Requisiti:
* docker
* docker-compose
* 16 GiB di RAM

<br/>

## Avvio:
Per avviare i container è sufficiente posizionarsi nella directory contenente il file `docker-compose.yaml` e lanciare il comando 

    docker-compose up

Fare riferimento al `readme.md` specifico dei singoli container per informazioni aggiuntive

<br/>

## Test:
All'interno della directory `tests` sono presenti alcuni test cases da poter  necessario:
* Visual Studio Code
* Estensione REST Client
* Creare un file `.env` copiando il contenuto del file `.env-sample` presente nella directory `tests` 
* Una versione *up&running* di `it-fse-container`

<br/>

Al termine dell'installazione di `REST Client` sarà possibile avviare i servizi di validazione e creazione (files .http) tramite il tasto `Send Request` che comparirà sopra ogni API.

<br/>

## Repos
- [*it-fse-support*](https://github.com/ministero-salute/it-fse-support) - Pagina di supporto FSE 2.0
- [*it-fse-landing*](https://github.com/ministero-salute/it-fse-landing) - Landing page dei repository FSE 2.0