#!/bin/bash

INPUT_DIR=$(realpath "$1")
OUTPUT_DIR=$(realpath "$2")

# Safeguard: prevent output to root or empty paths
# if [[ "$OUTPUT_DIR" == "/" || -z "$OUTPUT_DIR" ]]; then
#   echo "ERROR: Output directory is invalid: '$OUTPUT_DIR'"
#   exit 1
# fi

# Check if the input directory exists
if [ ! -d "$INPUT_DIR" ]; then
  echo "ERROR: Input directory does not exist: '$INPUT_DIR'"
  exit 1
fi

MODE=$3

if [ ! -d "$OUTPUT_DIR" ]; then
  mkdir -p "$OUTPUT_DIR"
fi

echo "Converting files from $INPUT_DIR to PDFs in $OUTPUT_DIR..."
echo "Mode: ${MODE:-default}"

for file in "$INPUT_DIR"/*; do
  filename=$(basename "$file")
  base="${filename%.*}"
  ext="${filename##*.}"
  output_file="$OUTPUT_DIR/$base.pdf"

  case "$ext" in
    ipynb)
      echo "Converting $filename (Jupyter Notebook)"
      jupyter nbconvert --to pdf "$file" --output-dir="$OUTPUT_DIR" --output="$base"      ;;
    md)
      echo "Converting $filename (Markdown)"
      pandoc "$file" -o "$output_file"
      ;;
    txt)
      echo "Converting $filename (Text)"
      pandoc "$file" -o "$output_file"
      ;;
    docx)
      echo "Converting $filename (Word)"
      pandoc "$file" -o "$output_file"
      ;;
    html)
      echo "Converting $filename (HTML)"
      pandoc "$file" -o "$output_file"
      ;;
    rst)
      echo "Converting $filename (reStructuredText)"
      pandoc "$file" -o "$output_file"
      ;;
    tex)
      echo "Converting $filename (LaTeX)"
      pdflatex -output-directory "$OUTPUT_DIR" "$file"
      ;;
    csv)
      echo "Converting $filename (CSV)"
      pandoc "$file" -o "$output_file"
      ;;
    *)
      echo "Unsupported file type: $filename"
      ;;
  esac
done

if [ "$MODE" == "merged-only" ]; then
  echo "Cleaning up individual PDFs after merging..."
  find "$OUTPUT_DIR" -type f -name '*.pdf' ! -name 'merged_output.pdf' -delete
fi