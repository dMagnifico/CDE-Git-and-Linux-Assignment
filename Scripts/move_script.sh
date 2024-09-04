#!/bin/bash

# Define environment variables
CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
RAW_FOLDER="raw"
TRANSFORMED_FOLDER="Transformed"
GOLD_FOLDER="Gold"
RAW_FILE="${RAW_FOLDER}/data.csv"
TRANSFORMED_FILE="${TRANSFORMED_FOLDER}/2023_year_finance.csv"

# Create folders if they don't exist
mkdir -p "${RAW_FOLDER}"
mkdir -p "${TRANSFORMED_FOLDER}"
mkdir -p "${GOLD_FOLDER}"

# Step 1: Extract - Download the CSV file
echo "Starting the ETL process..."

echo "Downloading the CSV file..."
curl -o "${RAW_FILE}" "${CSV_URL}"

# Check if the file was downloaded successfully
if [ -f "${RAW_FILE}" ]; then
    echo "CSV file downloaded and saved into the ${RAW_FOLDER} folder."
else
    echo "Failed to download the CSV file."
    exit 1
fi

# Step 2: Transform - Process the CSV file
echo "Transforming the data..."

# Use awk to rename the column and select the required columns
awk -F, '
    BEGIN {
        OFS = ",";
        header_printed = 0;
    }
    NR == 1 {
        # Rename the column and print the new header
        for (i = 1; i <= NF; i++) {
            if ($i == "Variable_code") {
                col_var_code = i;
                $i = "variable_code";
            }
        }
        header_printed = 1;
        print "year", "Value", "Units", "variable_code";
    }
    NR > 1 {
        # Print only the selected columns
        print $1, $3, $4, $col_var_code;
    }
' "${RAW_FILE}" > "${TRANSFORMED_FILE}"

# Check if the transformed file was created successfully
if [ -f "${TRANSFORMED_FILE}" ]; then
    echo "Transformed data saved into the ${TRANSFORMED_FOLDER} folder."
else
    echo "Failed to create the transformed file."
    exit 1
fi

# Step 3: Load - Move the transformed file to the Gold folder
echo "Loading the transformed data into the Gold folder..."

mv "${TRANSFORMED_FILE}" "${GOLD_FOLDER}/"

# Check if the file was moved successfully
if [ -f "${GOLD_FOLDER}/2023_year_finance.csv" ]; then
    echo "Transformed data has been moved to the ${GOLD_FOLDER} folder."
else
    echo "Failed to move the transformed file."
    exit 1
fi

echo "ETL process completed successfully."
