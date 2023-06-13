#!/bin/bash

echo "Starting"

zstd_folder=$(pwd)/docker-entrypoint-initdb.d/mongo-dump/input
collections_folder=$(pwd)/docker-entrypoint-initdb.d/mongo-dump/output

echo "Input folder: $zstd_folder"

if [ ! -d "$collections_folder" ]; then
    echo "Output folder: - $collections_folder - does not exist...it will be created"
    mkdir $collections_folder || { echo "Failed to create folder $collections_folder"; exit 1; }
else
    echo "Collections folder already created..."
fi

echo "Decompressing files (.zstd)"

# Enter the target folder containing .zstd
cd $zstd_folder || { echo "Failed to enter folder ${zstd_folder}"; exit 1; }

files=$(ls)

# Iterate and extract
for file in $files
do
  filename="${file%%.*}"
  echo "Decompressing: $filename"
  zstd -d < $file > $collections_folder/$filename.json || { echo "Failed to decompress $file"; exit 1; }
done

# Save on mongo
echo "Importing collections on MongoDB"

mongoimport --db "fse" --collection "schema" --file "$collections_folder/schema.json" --jsonArray
mongoimport --db "fse" --collection "schematron" --file "$collections_folder/schematron.json" --jsonArray
mongoimport --db "fse" --collection "terminology" --file "$collections_folder/terminology.json" --jsonArray
mongoimport --db "fse" --collection "transform" --file "$collections_folder/transform.json" --jsonArray
mongoimport --db "fse" --collection "dictionary" --file "$collections_folder/dictionary.json" --jsonArray

mongoimport --db "fse" --collection "schema_eds" --file "$collections_folder/schema.json" --jsonArray
mongoimport --db "fse" --collection "schematron_eds" --file "$collections_folder/schematron.json" --jsonArray
mongoimport --db "fse" --collection "terminology_eds" --file "$collections_folder/terminology.json" --jsonArray
mongoimport --db "fse" --collection "transform_eds" --file "$collections_folder/transform.json" --jsonArray

echo "Removing working folder"

rm -rf $collections_folder || { echo "Failed to remove folder $collections_folder"; exit 1; }

echo "Done"