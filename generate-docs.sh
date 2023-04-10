#!/bin/bash

# TODO: prettier logs

# Check if an input file name and guide folder path were provided
if [ -z "$1" ]; then
  echo "Error: No input file path provided."
  exit 1
fi

# Function to convert a GUIDE.md file to MDX files
function convert_guide_to_mdx() {
  local input_file="$1"
  local output_dir="./docs"
  local output_constants_dir="./src/generatedConstants"
  local filenames=()
  local headings=()

  # Change directory to the guide folder
  echo "Input file: $input_file"

  # Create the output directory if it doesn't exist
  if [ -d "$output_dir" ]; then
    rm -rf "$output_dir"
  fi
  mkdir -p "$output_dir"

  # Loop through each line in the input file
  while read line; do
    # If the line starts with a heading and not with #[storage, create a new output file
    if [[ $line =~ ^# && ! $line =~ ^#\[(storage|STORAGE) ]]; then

      # Just for readability
      raw_heading_text=$line
      echo "raw_heading_text: [$raw_heading_text]"

      # Get the text of the heading without the '#' characters and remove any leading/trailing whitespace
      heading_text=$(echo "$raw_heading_text" | sed -E 's/^#+\s*//; s/^ +//')
      echo "   heading_text: [$heading_text]"

      # Removes non alphabetical, replaces spaces with hyphens, sets all to lowercase
      root_filename=$(echo "$heading_text" | sed -E 's/[^[:alpha:] ]//g; s/[[:space:]]+/-/g' | tr '[:upper:]' '[:lower:]')
      echo "   root_filename: [$root_filename]"


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

}

# Call the function with the input file name
convert_guide_to_mdx $1
