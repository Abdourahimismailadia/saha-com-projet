# SAHA Communautaires 🇲🇷

### Plateforme numérique intégrée de santé communautaire, de nutrition et de suivi des interventions en Mauritanie

![Status](https://img.shields.io/badge/Status-Under%20Development-orange)
![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-API-009688?logo=fastapi)
![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?logo=mysql)
![GitHub](https://img.shields.io/badge/Version%20Control-GitHub-181717?logo=github)

---

## 1. Présentation du projet

**SAHA Communautaires** est un projet de développement d'une plateforme numérique intégrée destinée à renforcer les interventions de santé communautaire en Mauritanie.

La plateforme vise à mettre à disposition des organisations non gouvernementales, des programmes de santé, des superviseurs, des agents de terrain et des relais communautaires un outil centralisé permettant de planifier, documenter, suivre et analyser les activités communautaires.

Elle ambitionne de contribuer à l'amélioration de la qualité des interventions, à la disponibilité des données sanitaires et nutritionnelles et à la prise de décision fondée sur des données fiables.

SAHA Communautaires est conçu dans une logique évolutive, modulaire et adaptée aux réalités opérationnelles du contexte mauritanien.

**Vision :** contribuer à la transformation numérique de la santé communautaire en Mauritanie grâce à des données fiables, accessibles et exploitables.

## 2. Objectifs du projet

### Objectif général

Développer une plateforme numérique intégrée permettant d'améliorer la gestion, le suivi, la coordination et l'évaluation des interventions de santé communautaire en Mauritanie.

### Objectifs spécifiques

- Digitaliser la collecte des données communautaires.
- Améliorer le suivi des activités des relais communautaires.
- Renforcer la surveillance nutritionnelle et sanitaire.
- Faciliter la supervision des interventions sur le terrain.
- Centraliser les données des bénéficiaires et des activités.
- Produire des rapports statistiques et opérationnels.
- Faciliter le suivi des indicateurs de performance.
- Améliorer la coordination entre les acteurs communautaires et les structures de santé.
- Soutenir la planification et la prise de décision.

## 3. Publics cibles

La plateforme est destinée notamment aux :

- Administrateurs de la plateforme.
- Coordinateurs de projets et programmes.
- Responsables de santé et de nutrition.
- Superviseurs de terrain.
- Agents de santé communautaire.
- Relais communautaires.
- Organisations non gouvernementales.
- Programmes et partenaires du secteur de la santé.
- Structures sanitaires et acteurs institutionnels autorisés.

## 4. Modules fonctionnels envisagés

Le développement de SAHA Communautaires suivra une architecture modulaire.

### 4.1. Gestion des utilisateurs et des accès

- Création et gestion des comptes utilisateurs.
- Authentification sécurisée.
- Gestion des profils et des rôles.
- Attribution des permissions.
- Gestion des organisations et des équipes.
- Suivi des connexions et des activités des utilisateurs.

### 4.2. Référentiel géographique de la Mauritanie

- Gestion des régions (Wilayas).
- Gestion des départements (Moughataas).
- Gestion des communes.
- Gestion des localités et villages.
- Rattachement géographique des activités et des bénéficiaires.
- Possibilité de géolocalisation des interventions.

### 4.3. Gestion des bénéficiaires

- Enregistrement des bénéficiaires.
- Gestion des informations sociodémographiques.
- Identification des ménages.
- Suivi des bénéficiaires.
- Historique des interventions.
- Gestion des références vers les structures sanitaires.

### 4.4. Santé et nutrition communautaires

- Dépistage nutritionnel.
- Suivi de la malnutrition aiguë.
- Suivi de la croissance des enfants.
- Suivi des femmes enceintes et allaitantes.
- Sensibilisation à l'alimentation du nourrisson et du jeune enfant.
- Promotion de la diversité alimentaire.
- Suivi des interventions de prévention.
- Identification et référencement des cas nécessitant une prise en charge.

### 4.5. Sensibilisation communautaire

- Planification des séances de sensibilisation.
- Enregistrement des activités réalisées.
- Gestion des thèmes de sensibilisation.
- Suivi des participants.
- Suivi des relais communautaires.
- Évaluation de la couverture des activités.

### 4.6. Gestion des activités et des projets

- Planification opérationnelle.
- Gestion des activités.
- Suivi des réalisations.
- Suivi des indicateurs.
- Gestion des équipes.
- Suivi des objectifs et des résultats.
- Production des rapports d'activités.

### 4.7. Collecte et gestion des données

- Formulaires numériques.
- Contrôle de cohérence des données.
- Validation des enregistrements.
- Gestion des doublons.
- Historisation des modifications.
- Exportation des données.
- Préparation des données pour les analyses statistiques.

### 4.8. Tableaux de bord et analyse

- Indicateurs de santé communautaire.
- Indicateurs nutritionnels.
- Suivi des activités.
- Couverture géographique.
- Performance des équipes.
- Visualisation des tendances.
- Production de rapports périodiques.

### 4.9. Gestion des alertes et des notifications

- Alertes de suivi.
- Notifications aux superviseurs.
- Signalement des situations prioritaires.
- Rappels des activités.
- Suivi des références.

### 4.10. Fonctionnement hors connexion

Une fonctionnalité de fonctionnement hors connexion est envisagée afin de permettre aux agents communautaires de collecter des données dans les zones où la connexion Internet est limitée.

Les données seront synchronisées avec le serveur lorsque la connexion sera disponible.

## 5. Architecture technique

Le projet repose sur une architecture évolutive séparant la logique métier, les données, les interfaces et les services techniques.

### Backend

- Python : langage principal.
- FastAPI : développement de l'API REST.
- Pydantic : validation des données.
- SQLAlchemy : gestion des interactions avec la base de données.
- PyMySQL : connectivité MySQL.

### Base de données

- MySQL : stockage des données relationnelles.
- Gestion des relations entre les tables.
- Contraintes d'intégrité.
- Indexation et optimisation des requêtes.
- Gestion des sauvegardes.

### Outils de développement

- Visual Studio Code : environnement de développement.
- Git : gestion des versions.
- GitHub Desktop : gestion des modifications et synchronisation.
- GitHub : hébergement du code source.
- MySQL Workbench : administration de la base de données.
- RStudio : analyses statistiques et exploitation des données.

### Technologies complémentaires prévues

- Docker : conteneurisation des services.
- Redis : mise en cache, gestion de tâches et optimisation des performances.
- Power BI : analyse et visualisation avancée des données.
- Tests automatisés : validation de la qualité du code.
- Documentation technique : suivi de l'architecture et des fonctionnalités.

Ces technologies seront intégrées progressivement selon les besoins réels du projet.

## 6. Organisation des rôles et permissions

Le système prévoit plusieurs niveaux d'accès :

| Rôle | Responsabilité |
|---|---|
| ADMIN | Administration générale |
| COORDINATEUR | Coordination des projets |
| SUPERVISEUR | Supervision des activités |
| AGENT | Gestion des interventions de terrain |
| RELAIS | Collecte et sensibilisation communautaire |
| LECTEUR | Consultation des données autorisées |

L'accès aux fonctionnalités sera contrôlé par un système de rôles et de permissions (RBAC).

## 7. Structure technique du projet

La structure cible du projet sera organisée de manière modulaire :

```text
SAHA-Communautaires/
│
├── app/
│   ├── main.py
│   ├── core/
│   │   ├── config.py
│   │   ├── security.py
│   │   └── permissions.py
│   │
│   ├── database/
│   │   ├── connection.py
│   │   └── session.py
│   │
│   ├── models/
│   ├── schemas/
│   ├── crud/
│   ├── api/
│   │   └── v1/
│   ├── services/
│   └── utils/
│
├── tests/
│
├── migrations/
│
├── scripts/
│
├── docs/
│
├── .env.example
├── .gitignore
├── requirements.txt
├── README.md
└── Dockerfile
```

Cette organisation représente une structure cible qui sera adaptée au fur et à mesure du développement.

## 8. Installation et configuration

### Prérequis

- Python 3.
- MySQL Server.
- MySQL Workbench.
- Visual Studio Code.
- Git.
- GitHub Desktop.

### Récupération du projet

```bash
git https://github.com/Abdourahimismailadia/saha-com-projet/tree/main

cd SAHA-Communautaires
```

### Création de l'environnement virtuel

```bash
python -m venv venv
```

Activation sous Windows :

```powershell
.\venv\Scripts\Activate.ps1
```

### Installation des dépendances

```bash
pip install -r requirements.txt
```

### Configuration des variables d'environnement

Créer un fichier `.env` à partir du modèle `.env.example`.

Les variables nécessaires seront notamment :

```env
DATABASE_URL=
SECRET_KEY=
DEBUG=False
```

Ne jamais publier les véritables mots de passe ou clés secrètes sur GitHub.

### Lancement de l'application

```bash
uvicorn app.main:app --reload
```

L'API sera accessible localement à l'adresse :

http://127.0.0.1:8000

Documentation interactive :

http://127.0.0.1:8000/docs

Les commandes et chemins seront adaptés à la structure réellement mise en place dans le projet.

## 9. Sécurité et protection des données

La sécurité constitue un élément fondamental de SAHA Communautaires.

Les mesures à mettre en place comprennent :

- Authentification sécurisée.
- Gestion des rôles et permissions.
- Protection des mots de passe.
- Gestion sécurisée des sessions et des jetons.
- Validation des données entrantes.
- Protection contre les accès non autorisés.
- Journalisation des opérations sensibles.
- Sauvegardes régulières.
- Gestion des erreurs.
- Protection des informations personnelles et sanitaires.
- Politique de conservation et de suppression des données.

Les données sanitaires et personnelles devront être traitées conformément aux exigences applicables en matière de confidentialité et de protection des données en Mauritanie.

## 10. Tests et assurance qualité

Le projet intégrera progressivement une stratégie de tests comprenant :

- Tests unitaires.
- Tests d'intégration.
- Tests des API.
- Tests des permissions.
- Tests de cohérence de la base de données.
- Tests de sécurité.
- Tests de performance.
- Tests fonctionnels.

L'objectif est de garantir la fiabilité et la stabilité de la plateforme avant son déploiement opérationnel.

## 11. Feuille de route du développement

Le développement sera organisé en plusieurs phases.

| Phase | Activités principales |
|---|---|
| Phase 1 | Architecture générale et base de données |
| Phase 2 | Gestion des utilisateurs et permissions |
| Phase 3 | Référentiel géographique national |
| Phase 4 | Gestion des bénéficiaires et ménages |
| Phase 5 | Modules santé et nutrition |
| Phase 6 | Sensibilisation et activités communautaires |
| Phase 7 | Collecte et validation des données |
| Phase 8 | Tableaux de bord et rapports |
| Phase 9 | Notifications et tâches automatisées |
| Phase 10 | Application mobile et mode hors connexion |
| Phase 11 | Tests, sécurité et optimisation |
| Phase 12 | Déploiement, formation et maintenance |

Les phases seront réalisées progressivement, avec validation technique et fonctionnelle de chaque module.

## 12. Sauvegarde et gestion des versions

Le projet utilise Git et GitHub pour assurer le suivi des modifications du code source.

Les pratiques prévues sont :

- Commits réguliers.
- Messages de commit explicites.
- Utilisation de branches pour les développements importants.
- Synchronisation régulière avec GitHub.
- Gestion des versions.
- Sauvegarde indépendante de la base de données MySQL.

GitHub ne remplace pas les sauvegardes de la base de données.

## 13. Perspectives d'évolution

À terme, SAHA Communautaires ambitionne de devenir une plateforme intégrée capable de soutenir :

- La surveillance communautaire de la santé.
- Le suivi nutritionnel des populations vulnérables.
- La gestion des interventions humanitaires.
- La coordination des acteurs communautaires.
- La production d'indicateurs fiables.
- L'analyse des données pour la prise de décision.
- Le suivi des performances des programmes.
- L'interopérabilité avec d'autres systèmes d'information sanitaires, selon les possibilités techniques et institutionnelles.

## 14. Statut actuel du projet

SAHA Communautaires est actuellement en phase de développement.

Les travaux portent notamment sur :

- La mise en place de l'environnement technique.
- Le développement du backend avec Python et FastAPI.
- La conception de la base de données MySQL.
- La structuration des rôles et permissions.
- La préparation de l'architecture modulaire.
- La mise en place du contrôle de versions avec Git et GitHub.

Les fonctionnalités présentées dans ce document constituent la vision fonctionnelle et la feuille de route du projet. Elles ne sont pas toutes encore opérationnelles.

## 15. Contribution

Le projet a vocation à évoluer avec les contributions de développeurs, d'experts en santé publique, de nutritionnistes, de spécialistes des systèmes d'information sanitaires et d'acteurs de terrain.

Toute contribution devra respecter les principes de qualité du code, de sécurité, de documentation et de protection des données.

## 16. Licence

La licence du projet sera définie ultérieurement en fonction du statut institutionnel et des conditions de diffusion de SAHA Communautaires.

---

**SAHA Communautaires**

*Le numérique au service de la santé communautaire et du développement humain en Mauritanie.*

Projet en développement — Mauritanie 🇲🇷
