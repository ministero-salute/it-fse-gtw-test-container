#!/bin/bash

echo "Starting"

collections_folder=$(pwd)/docker-entrypoint-initdb.d/collections

mongoimport --db "fse" --collection schema --file "$collections_folder/schema.json" --jsonArray
mongoimport --db "fse" --collection schematron --file "$collections_folder/schematron.json" --jsonArray
mongoimport --db "fse" --collection terminology --file "$collections_folder/terminology.json" --jsonArray
mongoimport --db "fse" --collection dictionary --file "$collections_folder/dictionary.json" --jsonArray
mongoimport --db "fse" --collection transform --file "$collections_folder/transform.json" --jsonArray

echo "Done"