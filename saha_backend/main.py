from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, Field
from sqlalchemy import text

from database import engine

from auth import (
    verifier_mot_de_passe,
    creer_token,
    obtenir_utilisateur_connecte,
    exiger_permission,
    password_hasher
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

class UtilisateurCreateRequest(BaseModel):
    nom_complet: str = Field(min_length=2, max_length=160)
    telephone: str = Field(min_length=1, max_length=30)
    email: str | None = None
    mot_de_passe: str = Field(min_length=8, max_length=128)
    role_id: int
    zone_id: int | None = None
    structure_id: int | None = None
    langue: str = "fr"



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

@app.post("/utilisateurs", status_code=201)
def creer_utilisateur(
    donnees: UtilisateurCreateRequest,
    utilisateur: dict = Depends(
        exiger_permission("UTILISATEURS_CREER")
    )
):
    organisation_id = utilisateur["organisation_id"]

    with engine.begin() as connexion:

        # 1. Vérifier que le rôle existe
        role = connexion.execute(
            text("""
                SELECT role_id, code_role
                FROM roles
                WHERE role_id = :role_id
            """),
            {"role_id": donnees.role_id}
        ).mappings().first()

        if role is None:
            raise HTTPException(
                status_code=404,
                detail="Rôle introuvable."
            )

        # 2. Seul un administrateur peut créer un autre administrateur
        if (
            role["code_role"] == "ADMIN"
            and utilisateur["code_role"] != "ADMIN"
        ):
            raise HTTPException(
                status_code=403,
                detail="Seul un administrateur peut attribuer ce rôle."
            )

        # 3. Vérifier la zone géographique
        zone_id_final = donnees.zone_id

        if donnees.zone_id is not None:
            zone = connexion.execute(
                text("""
                    SELECT zone_id
                    FROM zones
                    WHERE zone_id = :zone_id
                    AND actif = 1
                """),
                {"zone_id": donnees.zone_id}
            ).first()

            if zone is None:
                raise HTTPException(
                    status_code=404,
                    detail="Zone introuvable ou inactive."
                )

        # 4. Vérifier la structure
        if donnees.structure_id is not None:
            structure = connexion.execute(
                text("""
                    SELECT zone_id
                    FROM structures
                    WHERE structure_id = :structure_id
                    AND actif = 1
                """),
                {"structure_id": donnees.structure_id}
            ).mappings().first()

            if structure is None:
                raise HTTPException(
                    status_code=404,
                    detail="Structure introuvable ou inactive."
                )

            if (
                zone_id_final is not None
                and zone_id_final != structure["zone_id"]
            ):
                raise HTTPException(
                    status_code=400,
                    detail="La structure ne correspond pas à la zone choisie."
                )

            zone_id_final = structure["zone_id"]

        # 5. Vérifier que le téléphone n'existe pas déjà
        telephone_existant = connexion.execute(
            text("""
                SELECT utilisateur_id
                FROM utilisateurs
                WHERE organisation_id = :organisation_id
                AND telephone = :telephone
            """),
            {
                "organisation_id": organisation_id,
                "telephone": donnees.telephone
            }
        ).first()

        if telephone_existant:
            raise HTTPException(
                status_code=409,
                detail="Ce numéro de téléphone existe déjà."
            )

        # 6. Sécuriser le mot de passe
        mot_de_passe_hash = password_hasher.hash(
            donnees.mot_de_passe
        )

        # 7. Enregistrer le nouvel utilisateur
        resultat = connexion.execute(
            text("""
                INSERT INTO utilisateurs (
                    organisation_id,
                    zone_id,
                    structure_id,
                    role_id,
                    nom_complet,
                    telephone,
                    email,
                    mot_de_passe_hash,
                    langue,
                    actif
                )
                VALUES (
                    :organisation_id,
                    :zone_id,
                    :structure_id,
                    :role_id,
                    :nom_complet,
                    :telephone,
                    :email,
                    :mot_de_passe_hash,
                    :langue,
                    1
                )
            """),
            {
                "organisation_id": organisation_id,
                "zone_id": zone_id_final,
                "structure_id": donnees.structure_id,
                "role_id": donnees.role_id,
                "nom_complet": donnees.nom_complet,
                "telephone": donnees.telephone,
                "email": donnees.email,
                "mot_de_passe_hash": mot_de_passe_hash,
                "langue": donnees.langue
            }
        )

        nouvel_id = resultat.lastrowid

    return {
        "message": "Utilisateur créé avec succès.",
        "utilisateur": {
            "id": nouvel_id,
            "nom": donnees.nom_complet,
            "telephone": donnees.telephone,
            "role": role["code_role"],
            "organisation_id": organisation_id
        }
    }
