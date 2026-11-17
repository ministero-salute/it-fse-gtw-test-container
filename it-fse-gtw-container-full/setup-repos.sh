#!/usr/bin/env bash
# Clona (se mancanti) i repository dei microservizi nella cartella FSE_SRC_DIR,
# allo stesso livello di it-fse-gtw-test-container.
#
#   ./setup-repos.sh            # clona i mancanti sul branch "release"
#   BRANCH=develop ./setup-repos.sh
#   ./setup-repos.sh --pull     # aggiorna anche i repository già presenti (fast-forward)
#
# Alcuni repository sono privati: servono credenziali git valide per github.com.
set -euo pipefail

cd "$(dirname "$0")"
SRC_DIR="${FSE_SRC_DIR:-../..}"
BASE_URL="${REPO_BASE_URL:-https://github.com/ministero-salute}"
BRANCH="${BRANCH:-release}"
PULL=false; [ "${1:-}" = "--pull" ] && PULL=true

REPOS=(
  it-fse-gtw-config it-fse-gtw-dispatcher it-fse-gtw-validator it-fse-gtw-status-manager
  it-fse-gtw-indexer it-fse-gtw-publisher it-fse-gtw-status-check it-fse-gtw-garbage
  it-fse-gtw-ini-client it-fse-gtw-eds-client it-fse-gtw-fhir-mapping-engine it-fse-gtw-notifier
  it-fse-gtw-log-collector it-fse-gtw-fhir-validator it-fse-srv-log-ingestion
  it-fse-datarepo-uar-fhir-server-1 it-fse-ana-validator it-fse-srv-broker it-fse-srv-uar-dispatcher
  it-fse-srv-uar-ingestion it-fse-datarepo-uar-data-processor it-fse-datarepo-uar-data-quality
  it-fse-srv-uar-query it-fse-uar-srv-notifier it-fse-eds-garbage it-fse-srv-data-protection
  it-fse-udp-fhir-facade
)

for r in "${REPOS[@]}"; do
  dir="$SRC_DIR/$r"
  if [ -d "$dir/.git" ]; then
    if $PULL; then
      echo "[pull]  $r ($(git -C "$dir" rev-parse --abbrev-ref HEAD | sed "s/^HEAD$/detached/"))"
      git -C "$dir" pull --ff-only --quiet || echo "        ! pull non riuscito, verificare manualmente"
    else
      echo "[ok]    $r ($(git -C "$dir" rev-parse --abbrev-ref HEAD | sed "s/^HEAD$/detached/"))"
    fi
  else
    echo "[clone] $r @ $BRANCH"
    git clone --quiet --branch "$BRANCH" "$BASE_URL/$r.git" "$dir"
  fi
done
