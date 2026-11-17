# Fascicolo Sanitario 2.0

# _it-fse-gtw-container-full_

`docker-compose` per avviare in locale un'istanza **completa** di **Gateway** ed **EDS** di FSE 2.0.

## Requisiti

* Docker (con Compose v2) **oppure** Podman con `docker-compose`
* ~20 GiB di RAM assegnati a Docker/Podman per l'intero stack (limiti per container: `FSE_*_MEM_LIMIT`); con meno RAM avviare i profili `gtw` ed `eds` separatamente
* git con accesso ai repository `ministero-salute` (alcuni sono privati)

Non serve Python né Maven sull'host.

## Avvio rapido

```bash
./setup-repos.sh             # clona i repository mancanti accanto a it-fse-gtw-test-container
cp .env-sample .env          # opzionale: tutte le variabili hanno un default
docker compose up -d --build
docker compose ps            # attendere che i servizi siano "healthy"
```

Le immagini vengono compilate **dai repository locali** (`FSE_SRC_DIR`, default `../..`,
cioè la cartella che contiene `it-fse-gtw-test-container`), usando il branch in checkout
in ciascun repository. Le modifiche locali sono quindi incluse nella build.

Struttura attesa:

```
FSE2/
├── it-fse-gtw-test-container/it-fse-gtw-container-full/   <- qui
├── it-fse-gtw-config/
├── it-fse-gtw-dispatcher/
└── ...
```

La prima build richiede tempo (download delle dipendenze Maven). La cache Maven è condivisa
tra tutte le build, quindi le successive sono molto più rapide; un servizio non modificato
non viene ricompilato.

Al primo avvio vengono anche:
1. scaricati i dump da [it-fse-catalogs](https://github.com/ministero-salute/it-fse-catalogs) in `../mongo-dump` (servizio `mongo-dump`)
2. importati in `FSE_GTW` (servizio `mongo-seed`, eseguito una sola volta)

## Architettura

| Componente | Descrizione |
|---|---|
| `builder/Dockerfile` | Immagine unica per tutti i microservizi: build multi-stage (`mvn package` dai sorgenti locali), runtime JRE 21, utente non-root |
| `setup-repos.sh` | Clona i repository mancanti (`BRANCH=...`, `--pull` per aggiornarli) |
| `config/application-container.properties` | Profilo Spring `container` montato in `/app/config`: sostituisce i `localhost` del profilo `dev` con i nomi dei servizi |
| `mongo/download.sh`, `mongo/seed.sh` | Download e import dei dump MongoDB |

Ogni microservizio gira con `SPRING_PROFILES_ACTIVE=dev,container` e `SERVER_PORT`; l'health-check usa `/status`.

## Servizi

### Infrastruttura

| Servizio | Porta host |
|---|---|
| mongo | 27888 |
| kafka (KRaft, senza Zookeeper) | 29092 |
| kafka-ui | [8090](http://localhost:8090) |

### Gateway (profilo `gtw`)

| Servizio | Porta | Servizio | Porta |
|---|---|---|---|
| it-fse-gtw-config | 8018 | it-fse-gtw-ini-client | 8020 |
| it-fse-gtw-dispatcher | 8010 | it-fse-gtw-eds-client | 8021 |
| it-fse-gtw-validator | 8012 | it-fse-gtw-fhir-mapping-engine | 8022 |
| it-fse-gtw-status-manager | 8013 | it-fse-gtw-notifier | 8084 |
| it-fse-gtw-indexer | 8015 | it-fse-gtw-log-collector | 9025 |
| it-fse-gtw-publisher | 8016 | it-fse-gtw-fhir-validator | 9099 |
| it-fse-gtw-status-check | 8017 | it-fse-srv-log-ingestion | 9097 |
| it-fse-gtw-garbage | 8019 | | |

I microservizi gateway partono dopo che `it-fse-gtw-config` è healthy.

### EDS (profilo `eds`)

| Servizio | Porta | Servizio | Porta |
|---|---|---|---|
| it-fse-datarepo-uar-fhir-server-1 | 8081 | it-fse-datarepo-uar-data-quality | 9013 |
| it-fse-ana-validator | 9008 | it-fse-srv-uar-query | 9014 |
| it-fse-srv-broker | 9009 | it-fse-uar-srv-notifier | 9015 |
| it-fse-srv-uar-dispatcher | 9010 | it-fse-eds-garbage | 9016 |
| it-fse-srv-uar-ingestion | 9011 | it-fse-srv-data-protection | 10001 |
| it-fse-datarepo-uar-data-processor | 9012 | it-fse-udp-fhir-facade *(profilo `facade`)* | 9080 |

`it-fse-udp-fhir-facade` richiede Hive/Kerberos/S3 e per questo è escluso di default.

Esclusi volutamente: catalogs, accreditation, rules-manager, semantic/syntax rules manager, terminology server, uat, support.

## Uso

```bash
COMPOSE_PROFILES=gtw docker compose up -d --build     # solo gateway
COMPOSE_PROFILES=eds docker compose up -d --build     # solo EDS
docker compose up -d --build it-fse-gtw-dispatcher    # un servizio e le sue dipendenze
docker compose up -d --build it-fse-gtw-validator    # ricompila dopo una modifica al codice
./setup-repos.sh --pull                               # aggiorna tutti i repository
docker compose logs -f it-fse-gtw-dispatcher
docker compose down                                   # stop, i dati restano
docker compose down -v                                # stop e cancella Mongo/Kafka
```

Endpoint principale: http://localhost:8010 (dispatcher).

### Variabili (`.env`)

| Variabile | Default | Descrizione |
|---|---|---|
| `COMPOSE_PROFILES` | `gtw,eds` | gruppi da avviare (`gtw`, `eds`, `facade`) |
| `FSE_SRC_DIR` | `../..` | cartella con i repository dei microservizi |
| `MONGO_DUMP_URL` | catalogs `main/mongo-dump` | origine dei dump |
| `MONGO_SEED_COLLECTIONS` | `schema schematron terminology transform engines config_data` | collection importate |
| `MONGO_DUMP_REFRESH` | `false` | `true` riscarica i dump |
| `MONGO_SEED_FORCE` | `false` | `true` reimporta le collection |
| `COMPOSE_PARALLEL_LIMIT` | `2` | build/avvii in parallelo (ogni build Maven usa ~1.5 GiB) |
| `FSE_MS_MEM_LIMIT` / `FSE_FHIR_MEM_LIMIT` / `FSE_MAPPING_MEM_LIMIT` | `768m` / `1536m` / `1536m` | limite di memoria per container |

Per aggiornare i dati Mongo: `MONGO_DUMP_REFRESH=true MONGO_SEED_FORCE=true docker compose up mongo-seed`.

## Note

* Le porte host coincidono con quelle del profilo `dev`: fermare i microservizi avviati da IDE e altri Mongo/Kafka locali su 27888/29092 prima dell'avvio.
* `it-fse-gtw-log-collector` è esposto su **9025** (nel profilo dev usa 9015, che collide con `it-fse-uar-srv-notifier`).
* L'SSL verso INI è disabilitato (`ini.client.enable-ssl=false`) perché il certificato di autenticazione non è nei repository.

## Troubleshooting

```bash
docker compose ps -a                       # stato e health
docker compose logs --tail=200 <servizio>  # errori di avvio
docker compose up mongo-seed               # rieseguire il seed
```

Una build terminata con `exit status 137` è stata interrotta per memoria insufficiente: ridurre `COMPOSE_PARALLEL_LIMIT` o aumentare la RAM della VM Docker/Podman.

Pulizia completa: `docker compose down -v --rmi local`.
