#!/bin/bash

if [ -z $BRANCH -o -z $URL -o -z $PORT ]; then
    echo "please specify enviroments for repo URL, repo BRANCH, service PORT"
    exit
fi

mkdir -p /app
cd /app
git clone --depth=1 --branch $BRANCH $URL . ||  { echo "fatal: failed to clone branch '$BRANCH' at url '$URL'" && exit 1; }
git config pull.ff only
git pull ||  { echo "fatal: failed to pull branch '$BRANCH' at url '$URL'" && exit 1; }

echo "running: mvn spring-boot:run -Dspring-boot.run.profiles=docker -Dspring-boot.run.arguments=\"--management.server.port=$PORT --server.port=$PORT\""
exec mvn spring-boot:run -Dspring-boot.run.profiles=docker -Dspring-boot.run.arguments="--management.server.port=$PORT --server.port=$PORT"