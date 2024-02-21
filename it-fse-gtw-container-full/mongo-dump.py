from os import getenv, path, mkdir
from shutil import rmtree
from urllib.request import urlopen
from dotenv import load_dotenv

load_dotenv()

# VARIABLES
MONGO_DUMP_URL = getenv("MONGO_DUMP_URL")
FILES = ["schema.json", "schematron.json", "terminology.json", "transform.json"]
SCRIPT_DIR = path.dirname(path.abspath(__file__))
FOLDER = path.join(SCRIPT_DIR, "../mongo-dump")

if MONGO_DUMP_URL is None:
    raise ValueError("MONGO_DUMP_URL environment variable is not set in .env")

# CHECK if folder already exists, if yes it will be deleted
if(path.exists(FOLDER)):
    rmtree(FOLDER)
    print(" - mongo-dump folder already exists. It will be deleted and recreated.")

# CREATE mongo folder
mkdir(FOLDER)
print(" - mongo-dump folder has been created.")

for file in FILES:

    url = f"{MONGO_DUMP_URL}/{file}"

    # REQUEST the file on GitHub
    print(f"{file}".upper())
    print(f" - HTTP request for {file} is starting: {url}")
    contents = urlopen(url)
    print(f" - {file} is downloaded.")

    # OPEN the file e write on it
    with open(f"{FOLDER}/{file}", "wb") as f:

        print(f" - {file} in writing...")
        f.write(contents.read())
        print(f" - {file} is written on disk.")
        f.close()