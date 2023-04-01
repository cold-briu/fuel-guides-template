#!/bin/bash

# Set the input filename
input_file="GUIDE.md"

# Set the output directory name
output_dir="./docs"

# Create the output directory if it doesn't exist
if [ -d "$output_dir" ]; then
  rm -rf "$output_dir"
fi
mkdir -p "$output_dir"

# Initialize the filenames and headings list
filenames=()
headings=()

# Loop through each line in the input file
while read line; do
    # If the line starts with a heading and not with #[storage, create a new output file
    if [[ $line =~ ^# && ! $line =~ ^#\[(storage|STORAGE) ]]; then
        # Get the raw text of the heading and remove any leading/trailing whitespace
        raw_heading_text=$(echo "$line" | sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # Get the text of the heading without the '#' characters and remove any leading/trailing whitespace
        heading_text=$(echo "$raw_heading_text" | sed -E 's/^#+\s*//;s/\s*$//')

        # Get the root filename without extension
        root_filename=$(echo "$heading_text" | tr '[:upper:]' '[:lower:]' | sed 's/^ *//;s/ *$//;s/ /-/g')

        # Add the root filename to the filenames list
        filenames+=("$root_filename")
        headings+=("$(echo "$heading_text" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')")

        # Set the output file path
        output_file="$output_dir/$root_filename.mdx"

        # Add a section to the output file
        echo "---" >> "$output_file"
        echo "title: $heading_text" >> "$output_file"
        echo "---" >> "$output_file"
        echo "$raw_heading_text" >> "$output_file"
    else
        # Write the current line to the current output file
        echo "$line" >> "$output_file"
    fi
done < "$input_file"

# Create the output directory if it doesn't exist
output_constants_dir="./src/generatedConstants"
if [ -d "$output_constants_dir" ]; then
  rm -rf "$output_constants_dir"
fi
mkdir -p "$output_constants_dir"

# Write the filenames list as a JSON array to a new file
echo "$(printf '%s\n' "${filenames[@]}" | jq -R . | jq -s .)" > "$output_constants_dir/filenames.json"

# Write the headings list as a JSON array to a new file
echo "$(printf '%s\n' "${headings[@]}" | jq -R . | jq -s .)" > "$output_constants_dir/headings.json"

# Print the list of filenames
echo "Created filenames.json and headings.json in $output_constants_dir"