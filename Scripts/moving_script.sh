#!/bin/bash

# Define source and destination directories
SOURCE_FOLDER="task_3"  # Replace with the actual source folder path
DESTINATION_FOLDER="json_and_CSV"

# Create the destination folder if it doesn't exist
mkdir -p "${DESTINATION_FOLDER}"

# Check if the source folder exists
if [ ! -d "${SOURCE_FOLDER}" ]; then
    echo "Source folder ${SOURCE_FOLDER} does not exist."
    exit 1
fi

# Move all CSV and JSON files from the source to the destination folder
echo "Moving CSV and JSON files from ${SOURCE_FOLDER} to ${DESTINATION_FOLDER}..."

# Move CSV files
find "${SOURCE_FOLDER}" -maxdepth 1 -type f -name "*.csv" -exec mv {} "${DESTINATION_FOLDER}/" \;

# Move JSON files
find "${SOURCE_FOLDER}" -maxdepth 1 -type f -name "*.json" -exec mv {} "${DESTINATION_FOLDER}/" \;

# Check if files were moved successfully
if [ $? -eq 0 ]; then
    echo "Files moved successfully."
else
    echo "Failed to move files."
    exit 1
fi
