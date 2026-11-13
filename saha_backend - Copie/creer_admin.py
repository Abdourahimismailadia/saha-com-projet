
from getpass import getpass
from sqlalchemy import text
from database import engine
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

hasher = PasswordHasher()

print("\n===== CREATION DU PREMIER ADMINISTRATEUR SAHA =====")

nom = input("Nom complet : ").strip()
telephone = input("Numero de telephone : ").strip()
mot_de_passe = getpass("Creer un mot de passe : ")
confirmation = getpass("Confirmer le mot de passe : ")

if not nom or not telephone:
    print("ERREUR : le nom et le telephone sont obligatoires.")
    raise SystemExit

if len(mot_de_passe) < 12:
    print("ERREUR : utilisez au moins 12 caracteres.")
    raise SystemExit

if mot_de_passe != confirmation:
    print("ERREUR : les mots de passe ne correspondent pas.")
    raise SystemExit

mot_de_passe_hash = hasher.hash(mot_de_passe)

try:
    with engine.begin() as connexion:

        organisation = connexion.execute(
            text("""
                SELECT organisation_id
                FROM organisations
                WHERE sigle = 'SAHA'
                LIMIT 1
            """)
        ).scalar()

        role = connexion.execute(
            text("""
                SELECT role_id
                FROM roles
                WHERE code_role = 'ADMIN'
                LIMIT 1
            """)
        ).scalar()

        if organisation is None:
            raise Exception("Organisation SAHA introuvable.")

        if role is None:
            raise Exception("Role ADMIN introuvable.")

        existe = connexion.execute(
            text("""
                SELECT utilisateur_id
                FROM utilisateurs
                WHERE organisation_id = :organisation_id
                AND telephone = :telephone
            """),
            {
                "organisation_id": organisation,
                "telephone": telephone
            }
        ).scalar()

        if existe:
            raise Exception("Ce numero est deja utilise.")

        connexion.execute(
            text("""
                INSERT INTO utilisateurs (
                    organisation_id,
                    role_id,
                    nom_complet,
                    telephone,
                    mot_de_passe_hash,
                    langue,
                    actif
                )
                VALUES (
                    :organisation_id,
                    :role_id,
                    :nom,
                    :telephone,
                    :mot_de_passe_hash,
                    'fr',
                    1
                )
            """),
            {
                "organisation_id": organisation,
                "role_id": role,
                "nom": nom,
                "telephone": telephone,
                "mot_de_passe_hash": mot_de_passe_hash
            }
        )

    print("\nSUCCES : administrateur cree !")
    print("Organisation : SAHA")
    print("Role : ADMIN")
    print("Telephone :", telephone)

except Exception as erreur:
    print("\nERREUR :", erreur)
