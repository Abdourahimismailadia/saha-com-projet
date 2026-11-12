# 🌍 SAHA Communautaires

### Plateforme numérique intégrée de santé communautaire en Mauritanie

**SAHA Communautaires** est une solution numérique conçue pour renforcer les systèmes de santé communautaire en Mauritanie à travers la digitalisation des activités de terrain, la collecte des données, le suivi des interventions et l'amélioration de la prise de décision.

L'application ambitionne de mettre à la disposition des relais communautaires, agents de santé, superviseurs, coordinateurs de projets et organisations humanitaires un outil moderne, accessible et adapté aux réalités du terrain.

---

## 🎯 1. Vision du projet

Contribuer à l'amélioration de la santé des populations en développant un écosystème numérique capable de rapprocher les services de santé des communautés, de faciliter le travail des acteurs de terrain et de renforcer la qualité des données sanitaires.

## 🎯 2. Objectifs spécifiques

- Digitaliser les activités de santé communautaire.
- Faciliter la collecte et la centralisation des données sanitaires.
- Renforcer le suivi nutritionnel des enfants et des populations vulnérables.
- Améliorer la supervision des relais communautaires.
- Faciliter le suivi et l'évaluation des interventions.
- Produire des données fiables pour orienter les décisions.
- Renforcer la coordination entre les acteurs communautaires et les structures sanitaires.

## 🏥 3. Principaux modules envisagés

| Module | Fonctionnalités |
|---|---|
| Gestion des utilisateurs | Comptes, authentification et profils |
| Gestion des rôles | Administrateur, coordinateur, superviseur, agent et relais |
| Santé communautaire | Enregistrement et suivi des activités |
| Nutrition | Dépistage et suivi nutritionnel |
| Sensibilisation | Planification et suivi des séances communautaires |
| Collecte des données | Enregistrement et centralisation des informations |
| Supervision | Suivi des agents et relais communautaires |
| Géolocalisation | Référentiel géographique des interventions |
| Rapports | Indicateurs, statistiques et tableaux de bord |
| Administration | Gestion des permissions et paramètres |

*Ces modules constituent la vision fonctionnelle du projet ; leur développement sera progressif.*

## 🛠️ 4. Technologies utilisées

### Backend
- Python
- FastAPI
- SQLAlchemy
- PyMySQL

### Base de données
- MySQL
- MySQL Workbench

### Documentation et tests API
- Swagger UI
- OpenAPI

### Outils de développement
- Visual Studio Code
- Git
- GitHub
- R / RStudio (analyse statistique et exploitation des données)

## 🏗️ 5. Architecture du projet

SAHA Communautaires repose sur une architecture évolutive organisée autour de plusieurs composantes :

```text
SAHA-COMMUNAUTAIRES/
│
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── database.py
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── routers/
│   │   ├── services/
│   │   └── security/
│   │
│   ├── requirements.txt
│   └── .env
│
├── database/
│   └── saha_database.sql
│
├── documentation/
│
├── tests/
│
├── .gitignore
└── README.md
```

*Cette arborescence représente l'organisation cible du projet et sera ajustée selon l'évolution du développement.*

## 🔐 6. Sécurité et gestion des accès

La plateforme prévoit un système de gestion des accès basé sur les rôles et les permissions.

Les profils envisagés sont :

1. ADMIN : Administrateur général.
2. COORDINATEUR : Coordination des projets.
3. SUPERVISEUR : Supervision des activités de terrain.
4. AGENT : Agent communautaire.
5. RELAIS : Relais communautaire.
6. LECTEUR : Consultation des informations autorisées.

La sécurité des données, la confidentialité des informations sanitaires et la protection des utilisateurs constituent des priorités du développement.

## 🇲🇷 7. Une solution adaptée à la Mauritanie

SAHA Communautaires est pensé pour répondre aux besoins du système de santé communautaire mauritanien.

Le projet ambitionne notamment de prendre en compte :

- Le découpage administratif de la Mauritanie.
- Les wilayas, moughataas et communes.
- Les localités et villages.
- Les réalités opérationnelles des organisations humanitaires.
- Les contraintes de connectivité dans les zones rurales.
- Les besoins des relais communautaires et des équipes de supervision.

## 🚀 8. État d'avancement

<details>
<summary>Développement technique en cours</summary>

- [x] Initialisation du projet backend.
- [x] Mise en place de l'API avec FastAPI.
- [x] Connexion à la base de données MySQL.
- [x] Première structure des tables de données.
- [x] Mise en place des rôles utilisateurs.
- [x] Documentation interactive avec Swagger.
- [ ] Finalisation du système de permissions.
- [ ] Développement des modules fonctionnels.
- [ ] Mise en place de l'interface utilisateur.
- [ ] Développement de l'application mobile Android.
- [ ] Tests fonctionnels et sécuritaires.
- [ ] Déploiement de la plateforme.

</details>

## 🔭 9. Perspectives de développement

À terme, SAHA Communautaires ambitionne de devenir une plateforme intégrée comprenant :

- Une application mobile Android pour les relais communautaires.
- Une interface web pour les superviseurs et coordinateurs.
- Un système de collecte de données hors connexion avec synchronisation.
- Des tableaux de bord dynamiques.
- Des outils d'analyse statistique.
- Un système de suivi-évaluation des projets.
- Des fonctionnalités de cartographie sanitaire.

## 🤝 10. Contribution

SAHA Communautaires est un projet en cours de développement.

Les contributions, suggestions techniques et collaborations susceptibles de renforcer la qualité et l'utilité de la plateforme sont les bienvenues.

## 👨‍💻 11. Auteur et porteur du projet

**Abdourahim Dia**  
Nutritionniste – Santé publique  
Développement numérique et santé communautaire

Projet : **SAHA Communautaires**  
Pays : 🇲🇷 Mauritanie

## 📜 12. Licence

Le choix de la licence sera défini avant la première diffusion publique du projet.

---

### « La technologie au service des communautés, la donnée au service de la santé, et l'innovation au service du développement humain. »

**SAHA Communautaires – Construire aujourd'hui la santé communautaire de demain.**
