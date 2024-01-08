# README

Questo progetto utilizza GitHub come fonte di dati e richiede un token con accesso in lettura. Seguire questi passaggi per configurare il progetto:

## Genera un token con accesso in lettura su GitHub
1. Vai alla pagina delle impostazioni di GitHub facendo clic sulla tua immagine del profilo nell'angolo in alto a destra della pagina e selezionando "Impostazioni" (Settings).
2. Nella barra laterale di sinistra, fai clic su "Impostazioni sviluppatore" (Developer settings).
3. Nel menu in alto, fai clic su "Token di accesso personali" (Personal access tokens).
4. Fare clic su Genera nuovo token (Personal Access Token).
5. Nel campo Note, inserire un nome descrittivo per il token, ad esempio "Token di progetto" (Project Token).
6. Seleziona la casella sotto la voce `project` -> `read:project` e seleziona anche la casella accanto a `repo` e accanto a `workflow`.
7. Fare clic su Genera token.
8. Copia il token generato, ti servirà nel passaggio successivo.

## Configura il file .env
1. Compilare il file ".env" sostituendo i placeholder <username> e <token> con le informazioni raccolte nei passaggi precedenti
2. Salvare e chiudere il file.

## Esegui il file Docker
1. Aprire una finestra di terminale nella root della directory di progetto.
2. Esegui il comando seguente per creare l'immagine Docker e avviare il container:

`docker compose -f "docker-compose-prov.yml" up -d --build`

3. Attendere l'avvio del container.

Il progetto ora dovrebbe essere in esecuzione e utilizzare i dati di GitHub.

>Nota: assicurati di avere Docker installato sulla tua macchina prima di eseguire il comando `docker-compose up`