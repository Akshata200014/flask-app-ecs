# You MUST import the app object from your app.py file
from app import app 

if __name__ == "__main__":
    # Ensure it stays on 8080
    app.run(host='0.0.0.0', port=8080)
