import os
import sys
import smtplib
import glob
from email.message import EmailMessage
#from PyPDF2 import PdfMerger
from pypdf import PdfWriter, PdfReader

# Configurable (you can move these to a config file or env variables)
MERGED_PDF_NAME = "merged_output.pdf"
EMAIL_FROM = "your_email@gmail.com"
EMAIL_TO = "recipient_email@example.com"
EMAIL_PASS = "your_app_password"  # Use App Password if using Gmail


def merge_pdfs(pdf_dir, output_filename="merged_output.pdf"):
    writer = PdfWriter()
    pdf_files = sorted(f for f in os.listdir(pdf_dir) if f.endswith(".pdf") and f != output_filename)

    if not pdf_files:
        print("No PDF files found to merge.")
        return

    for pdf in pdf_files:
        path = os.path.join(pdf_dir, pdf)
        if os.path.getsize(path) == 0:
            print(f"Skipping empty PDF: {pdf}")
            continue
        try:
            reader = PdfReader(path)
            for page in reader.pages:
                writer.add_page(page)
        except Exception as e:
            print(f"Error processing {pdf}: {e}")
            continue

    output_path = os.path.join(pdf_dir, output_filename)
    with open(output_path, "wb") as f_out:
        writer.write(f_out)

    print(f"Merged PDF created: {output_path}")

def email_pdf(output_dir):
    pdf_path = os.path.join(output_dir, MERGED_PDF_NAME)
    if not os.path.exists(pdf_path):
        print("Merged PDF not found. Run `make merge` first.")
        return

    msg = EmailMessage()
    msg["Subject"] = "Automated PDF Report"
    msg["From"] = EMAIL_FROM
    msg["To"] = EMAIL_TO
    msg.set_content("Attached is your PDF report.")

    with open(pdf_path, "rb") as f:
        msg.add_attachment(f.read(), maintype="application", subtype="pdf", filename=MERGED_PDF_NAME)

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
        smtp.login(EMAIL_FROM, EMAIL_PASS)
        smtp.send_message(msg)

    print("Email sent successfully.")

def upload_to_drive_or_dropbox(output_dir):
    print("This function is a placeholder.")
    print("You can integrate Google Drive or Dropbox SDKs here.")
    # Optional: Add upload logic here (e.g., using pydrive, dropbox, or google-api-python-client)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python upload_and_email.py [merge|email|upload] <output_dir>")
        sys.exit(1)

    command = sys.argv[1]
    output_dir = sys.argv[2]

    if command == "merge":
        merge_pdfs(output_dir)
    elif command == "email":
        email_pdf(output_dir)
    elif command == "upload":
        upload_to_drive_or_dropbox(output_dir)
    else:
        print("Unknown command.")