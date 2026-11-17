#!/bin/bash
# Importa i dump JSON in MongoDB (database FSE_GTW).
# L'import viene eseguito solo al primo avvio (o se MONGO_SEED_FORCE=true):
# lo stato è registrato nella collection FSE_SEED.status.
set -euo pipefail

: "${MONGO_SEED_COLLECTIONS:?MONGO_SEED_COLLECTIONS non impostata}"
URI="mongodb://${MONGO_HOST:-mongo:27017}"
DB="${MONGO_SEED_DB:-FSE_GTW}"
DUMP_DIR=/dump

seeded=$(mongosh "$URI/FSE_SEED" --quiet --eval "db.status.countDocuments({_id: '$DB'})")
if [ "$seeded" != "0" ] && [ "${MONGO_SEED_FORCE:-false}" != "true" ]; then
  echo "[seed] $DB già popolato, skip (MONGO_SEED_FORCE=true per reimportare)"
  exit 0
fi

for c in $MONGO_SEED_COLLECTIONS; do
  echo "[seed] import $DB.$c"
  mongoimport --uri "$URI" --db "$DB" --collection "$c" --drop --jsonArray \
    --numInsertionWorkers 4 --quiet --file "$DUMP_DIR/$c.json"
done

mongosh "$URI/FSE_SEED" --quiet --eval "
  void db.status.replaceOne({_id: '$DB'},
    {_id: '$DB', collections: '$MONGO_SEED_COLLECTIONS'.split(' '), at: new Date()},
    {upsert: true})"

echo "[seed] completato"
