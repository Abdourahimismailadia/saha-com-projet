from fastapi import FastAPI

app = FastAPI(
    title="SAHA Communautaires API",
    description="Plateforme de santé communautaire en Mauritanie",
    version="1.0.0"
)

@app.get("/")
def accueil():
    return {
        "application": "SAHA Communautaires",
        "message": "Bienvenue sur l'API SAHA",
        "statut": "operationnel"
    }

@app.get("/sante")
def verifier_sante():
    return {
        "statut": "OK",
        "serveur": "SAHA communautaires"
    }
