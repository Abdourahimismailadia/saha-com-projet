from sqlalchemy import inspect
from database import engine

inspecteur = inspect(engine)

print("\n========== BASE DE DONNEES SAHA ==========")

tables = inspecteur.get_table_names()

print("\nTables disponibles :")

for table in tables:
    print(f"\n--- TABLE : {table} ---")

    colonnes = inspecteur.get_columns(table)

    for colonne in colonnes:
        print(
            colonne["name"],
            "| Type :", colonne["type"],
            "| Obligatoire :", not colonne["nullable"],
            "| Défaut :", colonne["default"]
        )

print("\n========== FIN DE L'INSPECTION ==========")