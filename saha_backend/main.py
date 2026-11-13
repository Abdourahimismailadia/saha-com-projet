
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, Field
from sqlalchemy import text

from database import engine

from auth import (
    verifier_mot_de_passe,
    creer_token,
    obtenir_utilisateur_connecte,
    exiger_permission
)

from database import engine
from auth import verifier_mot_de_passe, creer_token


app = FastAPI(
    title="SAHA Communautaires API",
    description="Plateforme de santé communautaire en Mauritanie",
    version="1.0.0"
)


class ConnexionRequest(BaseModel):
    telephone: str = Field(min_length=1, max_length=30)
    mot_de_passe: str = Field(min_length=1, max_length=128)


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
        "serveur": "SAHA Backend",
        "message": "Le serveur fonctionne correctement"
    }


@app.get("/informations")
def informations():
    return {
        "nom": "SAHA Communautaires",
        "version": "1.0.0",
        "plateforme": "Android",
        "backend": "Python FastAPI",
        "base_de_donnees": "MySQL",
        "pays": "Mauritanie"
    }


@app.post("/connexion")
def connexion(donnees: ConnexionRequest):

    with engine.connect() as connection:

        resultat = connection.execute(
            text("""
                SELECT
                    u.utilisateur_id,
                    u.organisation_id,
                    u.nom_complet,
                    u.telephone,
                    u.mot_de_passe_hash,
                    u.actif,
                    u.langue,
                    r.code_role,
                    r.libelle
                FROM utilisateurs u
                INNER JOIN roles r
                    ON u.role_id = r.role_id
                WHERE u.telephone = :telephone
                LIMIT 1
            """),
            {"telephone": donnees.telephone}
        )

        utilisateur = resultat.mappings().first()

    if utilisateur is None:
        raise HTTPException(
            status_code=401,
            detail="Identifiants incorrects."
        )

    if not utilisateur["actif"]:
        raise HTTPException(
            status_code=403,
            detail="Ce compte est désactivé."
        )

    if not verifier_mot_de_passe(
        donnees.mot_de_passe,
        utilisateur["mot_de_passe_hash"]
    ):
        raise HTTPException(
            status_code=401,
            detail="Identifiants incorrects."
        )

    token = creer_token(dict(utilisateur))

    return {
        "message": "Connexion réussie.",
        "access_token": token,
        "token_type": "bearer",
        "utilisateur": {
            "id": utilisateur["utilisateur_id"],
            "nom": utilisateur["nom_complet"],
            "telephone": utilisateur["telephone"],
            "role": utilisateur["code_role"],
            "organisation_id": utilisateur["organisation_id"],
            "langue": utilisateur["langue"]
        }
    }

@app.get("/profil")
def consulter_profil(
    utilisateur: dict = Depends(obtenir_utilisateur_connecte)
):
    return {
        "message": "Profil récupéré avec succès.",
        "utilisateur": {
            "id": utilisateur["utilisateur_id"],
            "nom": utilisateur["nom_complet"],
            "telephone": utilisateur["telephone"],
            "email": utilisateur["email"],
            "langue": utilisateur["langue"],
            "role": utilisateur["code_role"],
            "organisation_id": utilisateur["organisation_id"]
        }
    }
@app.get("/test-permission/menages")
def tester_permission_menages(
    utilisateur: dict = Depends(
        exiger_permission("MENAGES_CREER")
    )
):
    return {
        "message": "Autorisation accordée !",
        "utilisateur": utilisateur["nom_complet"],
        "role": utilisateur["code_role"],
        "permission": "MENAGES_CREER"
    }