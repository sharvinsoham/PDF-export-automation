# PDF Export Automation

This project automates the conversion of various document types (e.g., Jupyter notebooks, Markdown, DOCX, LaTeX, HTML) into PDFs. It also supports merging PDFs and optionally emailing or uploading them to cloud services.

## Features
- Convert `.ipynb`, `.md`, `.docx`, `.tex`, `.html`, `.rst`, `.csv`, `.txt`, and `.pdf` to PDF
- Merge individual PDFs into a single PDF
- Optionally email the output or upload to Google Drive/Dropbox
- Works via Makefile, shell script, or VS Code tasks

## Project Structure
```
project-root/
├── Makefile
├── README.md
├── requirements.txt
├── scripts/
│   ├── convert.py
│   ├── upload_and_email.py
├── output/                  # Contains generated PDFs
├── notebooks/               # Source files (.ipynb, .md, .docx, etc.)
├── .vscode/
│   └── tasks.json
└── .gitignore
```

## Installation
```bash
pip install -r requirements.txt
```

## Usage
### 1. Using Makefile
```bash
make convert     # Convert all supported files in notebooks/ to PDFs in output/
make merge       # Merge all PDFs into a single file
make email       # Email the PDFs
make upload      # Upload to Google Drive/Dropbox
make clean       # Remove generated PDFs
```

### 2. Using VS Code Tasks
Open the Command Palette → `Tasks: Run Task` → Choose from:
- Convert to PDF
- Merge PDFs
- Email PDF
- Upload to Drive/Dropbox

### 3. Using Shell
```bash
python3 scripts/convert.py notebooks output
python3 scripts/upload_and_email.py merge output
python3 scripts/upload_and_email.py email output
python3 scripts/upload_and_email.py upload output
```

## Configuration
- Place all your source files in the `notebooks/` directory
- Output files are placed in the `output/` directory
- Update `upload_and_email.py` with your SMTP or cloud API credentials

## Supported Formats
- Jupyter Notebooks (`.ipynb`)
- Markdown (`.md`)
- DOCX (`.docx`)
- LaTeX (`.tex`)
- HTML (`.html`)
- reStructuredText (`.rst`)
- CSV (`.csv`)
- TXT (`.txt`)
- PDF (`.pdf`)

## License
Apache License 2.0
