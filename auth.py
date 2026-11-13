
import os
from datetime import datetime, timedelta, timezone

from dotenv import load_dotenv
from jose import jwt
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError, VerificationError

load_dotenv()

JWT_SECRET = os.getenv("JWT_SECRET")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
JWT_EXPIRE_MINUTES = int(os.getenv("JWT_EXPIRE_MINUTES", "60"))

if not JWT_SECRET:
    raise RuntimeError("JWT_SECRET absent du fichier .env")

password_hasher = PasswordHasher()


def verifier_mot_de_passe(mot_de_passe: str, mot_de_passe_hash: str) -> bool:
    try:
        return password_hasher.verify(
            mot_de_passe_hash,
            mot_de_passe
        )
    except (VerifyMismatchError, VerificationError):
        return False


def creer_token(utilisateur: dict) -> str:
    expiration = datetime.now(timezone.utc) + timedelta(
        minutes=JWT_EXPIRE_MINUTES
    )

    donnees = {
        "sub": str(utilisateur["utilisateur_id"]),
        "telephone": utilisateur["telephone"],
        "role": utilisateur["code_role"],
        "organisation_id": utilisateur["organisation_id"],
        "exp": expiration
    }

    return jwt.encode(
        donnees,
        JWT_SECRET,
        algorithm=JWT_ALGORITHM
    )


from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError
from sqlalchemy import text

from database import engine

security = HTTPBearer()


def obtenir_utilisateur_connecte(
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    token = credentials.credentials

    try:
        donnees = jwt.decode(
            token,
            JWT_SECRET,
            algorithms=[JWT_ALGORITHM]
        )

        utilisateur_id = donnees.get("sub")

        if not utilisateur_id:
            raise HTTPException(
                status_code=401,
                detail="Jeton invalide."
            )

    except JWTError:
        raise HTTPException(
            status_code=401,
            detail="Jeton invalide ou expiré."
        )

    with engine.connect() as connexion:
        resultat = connexion.execute(
            text("""
                SELECT
                    u.utilisateur_id,
                    u.nom_complet,
                    u.telephone,
                    u.email,
                    u.langue,
                    u.organisation_id,
                    r.role_id,
                    r.code_role,
                    r.libelle
                FROM utilisateurs u
                INNER JOIN roles r ON u.role_id = r.role_id
                WHERE u.utilisateur_id = :id
                AND u.actif = 1
                LIMIT 1
            """),
            {"id": utilisateur_id}
        )

        utilisateur = resultat.mappings().first()

    if utilisateur is None:
        raise HTTPException(
            status_code=401,
            detail="Utilisateur introuvable ou désactivé."
        )

    return dict(utilisateur)
def exiger_permission(code_permission: str):

    def verifier_permission(
        utilisateur: dict = Depends(obtenir_utilisateur_connecte)
    ):
        with engine.connect() as connexion:

            resultat = connexion.execute(
                text("""
                    SELECT COUNT(*)
                    FROM role_permissions rp
                    INNER JOIN permissions p
                        ON rp.permission_id = p.permission_id
                    WHERE rp.role_id = :role_id
                    AND p.code_permission = :code_permission
                """),
                {
                    "role_id": utilisateur["role_id"],
                    "code_permission": code_permission
                }
            )

            autorisation = resultat.scalar()

        if autorisation == 0:
            raise HTTPException(
                status_code=403,
                detail="Accès refusé : vous ne possédez pas cette permission."
            )

        return utilisateur

    return verifier_permission