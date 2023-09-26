#!/bin/bash

# Check if a directory was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir="$1"
id=1

# Create a temporary file to store base names that have been processed
temp_file=$(mktemp)

# Iterate over all files in the specified directory
for file in "$dir"/*; do
    # Extract just the filename from the full path
    filename=$(basename "$file")

    # Extract the base name (without extension)
    base_name=$(echo "$filename" | rev | cut -d'.' -f2- | rev)

    # Check if this base name has been processed before
    if ! grep -q "^$base_name$" "$temp_file"; then
        # Ensure the ID has 4 digits by padding with zeros
        padded_id=$(printf "%04d" $id)

        # Rename all files with this base name
        for matching_file in "$dir"/"$base_name".*; do
            matching_filename=$(basename "$matching_file")
            mv "$matching_file" "$dir/$padded_id"_"$matching_filename"
        done

        # Increment the ID for the next unique base name
        id=$((id+1))

        # Add the base name to the temp file to mark it as processed
        echo "$base_name" >> "$temp_file"
    fi
done

# Clean up the temporary file
rm "$temp_file"
