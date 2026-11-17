#!/usr/bin/env python3
"""
mongo-import.py
---------------
Scarica le ultime collection da GitHub (ministero-salute/it-fse-catalogs)
e le importa nel database MongoDB FSE_GTW, sovrascrivendo i dati esistenti.

Utilizzo:
    python3 mongo-import.py [--host HOST] [--port PORT] [--db DB_NAME]

Esempi:
    python3 mongo-import.py
    python3 mongo-import.py --host localhost --port 27888
    python3 mongo-import.py --host localhost --port 27888 --db FSE_GTW
"""

import argparse
import gzip
import sys
from io import BytesIO
from os import path, mkdir
from shutil import rmtree
from urllib.request import urlopen
from urllib.error import URLError

try:
    import pymongo
    from bson import json_util
except ImportError:
    print("[ERROR] pymongo non è installato. Eseguire: pip3 install pymongo")
    sys.exit(1)

# ---------------------------------------------------------------------------
# CONFIGURAZIONE
# ---------------------------------------------------------------------------

MONGO_DUMP_URL = (
    "https://raw.githubusercontent.com/ministero-salute/it-fse-catalogs/main/mongo-dump"
)

# file gzip -> nome collection in FSE_GTW
COLLECTIONS = {
    "schema":      "schema.json.gzip",
    "schematron":  "schematron.json.gzip",
    "terminology": "terminology.json.gzip",
    "transform":   "transform.json.gzip",
    "engines":     "engines.json.gzip",
    # "config_data": "config_data.json.gzip",  # commentato come nell'originale
}

SCRIPT_DIR = path.dirname(path.abspath(__file__))
DUMP_FOLDER = path.join(SCRIPT_DIR, "../mongo-dump")

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def parse_args():
    parser = argparse.ArgumentParser(
        description="Download e import delle collection FSE_GTW da GitHub."
    )
    parser.add_argument("--host", default="localhost", help="Host MongoDB (default: localhost)")
    parser.add_argument("--port", type=int, default=27888, help="Porta MongoDB (default: 27888)")
    parser.add_argument("--db",   default="FSE_GTW",    help="Nome database (default: FSE_GTW)")
    return parser.parse_args()

# ---------------------------------------------------------------------------
# STEP 1 — DOWNLOAD
# ---------------------------------------------------------------------------

def download_collections():
    """Scarica i file gzip da GitHub e li decomprime nella cartella mongo-dump."""

    if path.exists(DUMP_FOLDER):
        rmtree(DUMP_FOLDER)
        print(" - Cartella mongo-dump esistente rimossa.")

    mkdir(DUMP_FOLDER)
    print(" - Cartella mongo-dump creata.\n")

    for coll_name, filename in COLLECTIONS.items():
        url = f"{MONGO_DUMP_URL}/{filename}"
        print(f"[DOWNLOAD] {filename.upper()}")
        print(f"  -> {url}")

        try:
            response = urlopen(url, timeout=60)
        except URLError as e:
            print(f"  [ERROR] Download fallito: {e}")
            raise

        compressed_data = response.read()
        print(f"  -> Scaricato ({len(compressed_data):,} bytes compressi)")

        with gzip.GzipFile(fileobj=BytesIO(compressed_data)) as gz:
            decompressed = gz.read()

        output_file = filename.replace(".gzip", "")
        output_path = path.join(DUMP_FOLDER, output_file)

        with open(output_path, "wb") as f:
            f.write(decompressed)

        print(f"  -> Scritto su disco: {output_file} ({len(decompressed):,} bytes)\n")

    print(f"Download completato. File salvati in: {DUMP_FOLDER}\n")

# ---------------------------------------------------------------------------
# STEP 2 — IMPORT
# ---------------------------------------------------------------------------

def import_collections(host: str, port: int, db_name: str):
    """Sostituisce il contenuto di ogni collection con i dati scaricati."""

    mongo_uri = f"mongodb://{host}:{port}"
    print(f"[IMPORT] Connessione a {mongo_uri}, database: {db_name}")

    try:
        client = pymongo.MongoClient(mongo_uri, serverSelectionTimeoutMS=5000)
        client.server_info()  # verifica connessione
    except pymongo.errors.ServerSelectionTimeoutError as e:
        print(f"  [ERROR] Impossibile connettersi a MongoDB: {e}")
        raise

    print(f"  -> Connessione stabilita.\n")
    db = client[db_name]

    print(f"{'Collection':<14} {'Eliminati':>10} {'Inseriti':>10}")
    print("-" * 36)

    for coll_name, filename in COLLECTIONS.items():
        json_file = filename.replace(".gzip", "")
        filepath  = path.join(DUMP_FOLDER, json_file)

        with open(filepath, "r", encoding="utf-8") as f:
            # json_util gestisce correttamente $oid, $date, $binary, ecc.
            data = json_util.loads(f.read())

        if not isinstance(data, list):
            data = [data]

        coll    = db[coll_name]
        deleted = coll.delete_many({}).deleted_count
        result  = coll.insert_many(data)

        print(f"  {coll_name:<12} {deleted:>10} {len(result.inserted_ids):>10}")

    client.close()
    print("\nImport completato con successo.")

# ---------------------------------------------------------------------------
# VERIFICA FINALE
# ---------------------------------------------------------------------------

def verify_counts(host: str, port: int, db_name: str):
    """Stampa il conteggio finale dei documenti per ogni collection."""

    mongo_uri = f"mongodb://{host}:{port}"
    client = pymongo.MongoClient(mongo_uri, serverSelectionTimeoutMS=5000)
    db = client[db_name]

    print(f"\n[VERIFICA] Documenti nel database {db_name} su {mongo_uri}:")
    print(f"{'Collection':<14} {'Documenti':>10}")
    print("-" * 26)

    for coll_name in COLLECTIONS:
        count = db[coll_name].count_documents({})
        print(f"  {coll_name:<12} {count:>10,}")

    client.close()

# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    args = parse_args()

    print("=" * 50)
    print("  FSE-GTW MongoDB Import")
    print(f"  Target: {args.host}:{args.port} / {args.db}")
    print("=" * 50 + "\n")

    download_collections()
    import_collections(args.host, args.port, args.db)
    verify_counts(args.host, args.port, args.db)

    print("\nDone.")
