 #!/bin/bash

# Define variables
DB_NAME="posey" 
CSV_DIR="to_use"  # Change this to your actual CSV files directory

# Iterate over all CSV files in the specified directory
for csv_file in "$CSV_DIR"/*.csv; do
    # Check if the file exists
    if [[ -f "$csv_file" ]]; then
        # Copy the CSV file into the PostgreSQL database
        echo "Importing $csv_file into PostgreSQL database $DB_NAME..."
        psql -U dmagnifico -d "$DB_NAME" -c "\copy your_table_name FROM '$csv_file' WITH (FORMAT csv, HEADER true)"
    else
        echo "No CSV files found in $CSV_DIR"
    fi
done
