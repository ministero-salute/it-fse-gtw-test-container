#!/bin/bash

echo "Starting"

collections_folder=var/lib/mongo/data

mongoimport --db "FSE_GTW" --collection "schema" --file "$collections_folder/schema.json" --jsonArray
mongoimport --db "FSE_GTW" --collection "schematron" --file "$collections_folder/schematron.json" --jsonArray
mongoimport --db "FSE_GTW" --collection "terminology" --file "$collections_folder/terminology.json" --jsonArray
mongoimport --db "FSE_GTW" --collection "transform" --file "$collections_folder/transform.json" --jsonArray
mongoimport --db "FSE_GTW" --collection "config_data" --file "$collections_folder/config_data.json" --jsonArray

echo "Done"