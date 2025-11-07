#!/bin/bash

echo "Starting"

collections_folder=var/lib/mongo/data

mongoimport --db "FSE_GTW" --collection "transform" --file "$collections_folder/transform.json" --jsonArray
mongoimport --db "FSE_GTW" --collection "engines" --file "$collections_folder/engines.json" --jsonArray

echo "Done"