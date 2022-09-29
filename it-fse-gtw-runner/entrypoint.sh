#!/bin/bash

if [ -z $BRANCH -o -z $URL -o -z $PORT ]; then
    echo "please specify enviroments for repo URL, repo BRANCH, service PORT"
    exit
fi


mkdir -p /app
cd /app
git clone --depth=1 --branch $BRANCH $URL .
git config pull.ff only
git pull

exec mvn spring-boot:run -Dspring-boot.run.profiles=dev -Dspring-boot.run.arguments="--management.server.port=$PORT --server.port=$PORT"