#!/bin/bash

echo "Starting"

collections_folder=var/lib/mongo/data

mongoimport --db "fse" --collection "schema" --file "$collections_folder/schema.json" --jsonArray
mongoimport --db "fse" --collection "schematron" --file "$collections_folder/schematron.json" --jsonArray
mongoimport --db "fse" --collection "terminology" --file "$collections_folder/terminology.json" --jsonArray
mongoimport --db "fse" --collection "transform" --file "$collections_folder/transform.json" --jsonArray
mongoimport --db "fse" --collection "dictionary" --file "$collections_folder/dictionary.json" --jsonArray

mongoimport --db "fse" --collection "schema_eds" --file "$collections_folder/schema.json" --jsonArray
mongoimport --db "fse" --collection "schematron_eds" --file "$collections_folder/schematron.json" --jsonArray
mongoimport --db "fse" --collection "terminology_eds" --file "$collections_folder/terminology.json" --jsonArray
mongoimport --db "fse" --collection "transform_eds" --file "$collections_folder/transform.json" --jsonArray

echo "Done"