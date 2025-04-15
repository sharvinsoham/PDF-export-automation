# Makefile: Convert various files in input/ to PDFs in output/
# Supports: .ipynb, .md, .txt, .docx, .html, .rst, .tex, .csv
# Merges PDFs into one final file if needed

INPUT_DIR := input
OUTPUT_DIR := output_pdf
SCRIPT_DIR := scripts
CONVERT_SCRIPT := $(SCRIPT_DIR)/convert.sh
MERGE_SCRIPT := $(SCRIPT_DIR)/upload_and_email.py

# List of all supported input file types (File patterns)
FILES := $(wildcard $(INPUT_DIR)/*)\
		 $(wildcard $(INPUT_DIR)/*.ipynb) \
         $(wildcard $(INPUT_DIR)/*.md) \
         $(wildcard $(INPUT_DIR)/*.txt) \
         $(wildcard $(INPUT_DIR)/*.docx)
		 
# Turn input files into corresponding PDFs in output/
PDFS := $(patsubst $(INPUT_DIR)/%, $(OUTPUT_DIR)/%.pdf, $(basename $(notdir $(FILES))))

.PHONY: all merged-only clean email upload

all: convert merge

convert:
	@chmod +x $(CONVERT_SCRIPT)
	@$(CONVERT_SCRIPT) $(INPUT_DIR) $(OUTPUT_DIR)
	@echo "Converting files in $(INPUT_DIR) to PDFs in $(OUTPUT_DIR)..."
	@echo "Conversion completed. Merging PDFs..."

merge:
	@echo "Merging PDFs in $(OUTPUT_DIR)..."
	python3 $(MERGE_SCRIPT) merge $(OUTPUT_DIR)
	@echo "Merging completed."
	@echo "All PDFs are converted and merged."

# Merged-only target for merging PDFs without converting
# This target is useful if you only want to merge existing PDFs
# in the output directory without converting any new files.
# It will skip the conversion step and directly merge the PDFs.
merged-only:
	@chmod +x $(CONVERT_SCRIPT)
	@$(CONVERT_SCRIPT) $(INPUT_DIR) $(OUTPUT_DIR) merged-only

validate:
	@python3 -c "from pypdf import PdfReader; import os; [PdfReader(os.path.join('output', f)) for f in os.listdir('output') if f.endswith('.pdf')]"
	@echo "All PDFs are valid."

email:
	@python3 $(MERGE_SCRIPT) email $(OUTPUT_DIR)

upload:
	@python3 $(MERGE_SCRIPT) upload $(OUTPUT_DIR)

clean:
	rm -rf $(OUTPUT_DIR)/*.pdf