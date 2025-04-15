# config_loader.py
from dotenv import load_dotenv
import os

# Load environment variables from the .env file
load_dotenv()

# Accessing environment variables
email_sender = os.getenv("EMAIL_SENDER")
email_password = os.getenv("EMAIL_PASSWORD")
email_receiver = os.getenv("EMAIL_RECEIVER")
smtp_server = os.getenv("SMTP_SERVER")
smtp_port = os.getenv("SMTP_PORT")

# Example usage in your application
print(f"Email Sender: {email_sender}")
print(f"SMTP Server: {smtp_server}")