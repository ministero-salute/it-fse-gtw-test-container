#!/bin/sh
# Scarica (solo se mancanti) i dump JSON delle collection da it-fse-catalogs
# nella cartella condivisa /dump (= ../mongo-dump sull'host).
#
#   MONGO_DUMP_URL        base URL dei file .json.gzip
#   MONGO_SEED_COLLECTIONS elenco collection separate da spazio
#   MONGO_DUMP_REFRESH    "true" per forzare il riscaricamento
set -eu

: "${MONGO_DUMP_URL:?MONGO_DUMP_URL non impostata}"
: "${MONGO_SEED_COLLECTIONS:?MONGO_SEED_COLLECTIONS non impostata}"
DUMP_DIR=/dump

mkdir -p "$DUMP_DIR"

for c in $MONGO_SEED_COLLECTIONS; do
  target="$DUMP_DIR/$c.json"
  if [ -s "$target" ] && [ "${MONGO_DUMP_REFRESH:-false}" != "true" ]; then
    echo "[dump] $c.json già presente, skip"
    continue
  fi
  echo "[dump] download $MONGO_DUMP_URL/$c.json.gzip"
  wget -q -O - "$MONGO_DUMP_URL/$c.json.gzip" | gunzip -c > "$target.tmp"
  mv "$target.tmp" "$target"
done

echo "[dump] completato"
