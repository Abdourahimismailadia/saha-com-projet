from database import tester_connexion

print("Test de connexion SAHA...")

if tester_connexion():
    print("SUCCÈS : SAHA est connecté à MySQL !")
else:
    print("ÉCHEC : vérifiez les paramètres de connexion.")