CREATE DATABASE saha_communautaires
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
SHOW DATABASES;
USE saha_communautaires;

SELECT DATABASE() AS base_active;
#Table des organisations

#Elle permettra d'enregistrer les ONG, associations et institutions qui utilisent SAHA.

CREATE TABLE organisations (
    organisation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(180) NOT NULL,
    sigle VARCHAR(40),
    type_organisation VARCHAR(60),
    telephone VARCHAR(30),
    email VARCHAR(150),
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
# Table des projets

#Elle permettra à chaque organisation de gérer ses différents projets humanitaires ou sanitaires.

CREATE TABLE projets (
    projet_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    organisation_id BIGINT UNSIGNED NOT NULL,
    nom VARCHAR(180) NOT NULL,
    code_projet VARCHAR(50),
    description TEXT,
    date_debut DATE,
    date_fin DATE,
    actif BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_projet_organisation
    FOREIGN KEY (organisation_id)
    REFERENCES organisations(organisation_id)
) ENGINE=InnoDB;

#Table des zones géographiques

#Elle permettra d'organiser les données selon le découpage administratif mauritanien.

CREATE TABLE zones (
    zone_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parent_zone_id BIGINT UNSIGNED NULL,
    code_zone VARCHAR(30) NOT NULL UNIQUE,
    nom_zone VARCHAR(150) NOT NULL,

    niveau ENUM(
        'WILAYA',
        'MOUGHATAA',
        'COMMUNE',
        'LOCALITE'
    ) NOT NULL,

    actif BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_zone_parent
    FOREIGN KEY (parent_zone_id)
    REFERENCES zones(zone_id)
) ENGINE=InnoDB;
# verification des trois table
SHOW TABLES;
SELECT
    TABLE_NAME,
    ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'saha_communautaires';

#gerer les structures sanitaires
USE saha_communautaires;

CREATE TABLE structures (
    structure_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    zone_id BIGINT UNSIGNED NOT NULL,
    nom VARCHAR(180) NOT NULL,
    type_structure VARCHAR(80) NOT NULL,
    adresse VARCHAR(255),
    telephone VARCHAR(30),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    actif BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_structure_zone
    FOREIGN KEY (zone_id)
    REFERENCES zones(zone_id)
) ENGINE=InnoDB;

# creer un roles des utilisateurs
CREATE TABLE roles (
    role_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code_role VARCHAR(40) NOT NULL UNIQUE,
    libelle VARCHAR(100) NOT NULL
) ENGINE=InnoDB;
INSERT INTO roles (code_role, libelle) VALUES
('ADMIN', 'Administrateur'),
('COORDINATEUR', 'Coordinateur'),
('SUPERVISEUR', 'Superviseur'),
('AGENT', 'Agent de terrain'),
('RELAIS', 'Relais communautaire'),
('LECTEUR', 'Consultation des rapports');

#les comptes utilisateur 
CREATE TABLE utilisateurs (
    utilisateur_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    organisation_id BIGINT UNSIGNED NOT NULL,
    zone_id BIGINT UNSIGNED,
    structure_id BIGINT UNSIGNED,
    role_id SMALLINT UNSIGNED NOT NULL,

    nom_complet VARCHAR(160) NOT NULL,
    telephone VARCHAR(30) NOT NULL,
    email VARCHAR(150),
    mot_de_passe_hash VARCHAR(255) NOT NULL,

    langue VARCHAR(10) DEFAULT 'fr', 
    actif BOOLEAN DEFAULT TRUE,
    derniere_connexion DATETIME,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_organisation
    FOREIGN KEY (organisation_id)
    REFERENCES organisations(organisation_id),

    CONSTRAINT fk_user_zone
    FOREIGN KEY (zone_id)
    REFERENCES zones(zone_id),

    CONSTRAINT fk_user_structure
    FOREIGN KEY (structure_id)
    REFERENCES structures(structure_id),

    CONSTRAINT fk_user_role
    FOREIGN KEY (role_id)
    REFERENCES roles(role_id),

    UNIQUE KEY uq_user_telephone (organisation_id, telephone)
) ENGINE=InnoDB;

#les profils des relais communautaires
CREATE TABLE relais_communautaires (
    relais_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id BIGINT UNSIGNED NOT NULL,
    zone_id BIGINT UNSIGNED NOT NULL,
    code_relais VARCHAR(50) NOT NULL UNIQUE,
    date_debut_activite DATE,

    statut ENUM(
        'ACTIF',
        'INACTIF',
        'SUSPENDU'
    ) DEFAULT 'ACTIF',

    CONSTRAINT fk_relais_utilisateur
    FOREIGN KEY (utilisateur_id)
    REFERENCES utilisateurs(utilisateur_id),

    CONSTRAINT fk_relais_zone
    FOREIGN KEY (zone_id)
    REFERENCES zones(zone_id),

    UNIQUE KEY uq_relais_utilisateur (utilisateur_id)
) ENGINE=InnoDB;

# je verifie les tables 
SHOW TABLES;
SELECT
    TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'saha_communautaires'
ORDER BY TABLE_NAME;

# creer la table des menages
USE saha_communautaires;

CREATE TABLE IF NOT EXISTS menages (
    menage_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    organisation_id BIGINT UNSIGNED NOT NULL,
    projet_id BIGINT UNSIGNED,
    zone_id BIGINT UNSIGNED NOT NULL,

    code_menage VARCHAR(60) NOT NULL,
    nom_chef_menage VARCHAR(160),
    telephone VARCHAR(30),
    sexe_chef_menage ENUM('M','F'),
    nombre_membres INT UNSIGNED DEFAULT 1,
    adresse VARCHAR(255),

    date_enregistrement DATE NOT NULL,
    actif BOOLEAN DEFAULT TRUE,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_menage_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_menage_projet
        FOREIGN KEY (projet_id)
        REFERENCES projets(projet_id),

    CONSTRAINT fk_menage_zone
        FOREIGN KEY (zone_id)
        REFERENCES zones(zone_id),

    UNIQUE KEY uq_menage_code (organisation_id, code_menage)
) ENGINE=InnoDB;
#la table des membres des ménages
CREATE TABLE IF NOT EXISTS membres_menages (
    membre_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    menage_id BIGINT UNSIGNED NOT NULL,

    code_membre VARCHAR(60),
    nom_complet VARCHAR(160),
    sexe ENUM('M','F'),
    date_naissance DATE,
    lien_avec_chef VARCHAR(80),

    femme_enceinte BOOLEAN DEFAULT FALSE,
    femme_allaitante BOOLEAN DEFAULT FALSE,

    date_enregistrement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_membre_menage
        FOREIGN KEY (menage_id)
        REFERENCES menages(menage_id)
) ENGINE=InnoDB;
# table des visites à domicile
CREATE TABLE IF NOT EXISTS visites_domicile (
    visite_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    menage_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED NOT NULL,
    date_visite DATETIME NOT NULL,

    motif_visite VARCHAR(150),
    observations TEXT,
    conseils_donnes TEXT,

    statut ENUM(
        'REALISEE',
        'PARTIELLE',
        'NON_REALISEE'
    ) DEFAULT 'REALISEE',

    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_visite_menage
        FOREIGN KEY (menage_id)
        REFERENCES menages(menage_id),

    CONSTRAINT fk_visite_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id)
) ENGINE=InnoDB;
# table des dépistages nutritionnels
CREATE TABLE IF NOT EXISTS depistages_nutritionnels (
    depistage_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    membre_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED NOT NULL,
    visite_id BIGINT UNSIGNED,

    date_depistage DATETIME NOT NULL,

    poids_kg DECIMAL(5,2),
    taille_cm DECIMAL(5,2),
    muac_mm DECIMAL(5,2),

    oedeme_bilateral BOOLEAN DEFAULT FALSE,

    resultat ENUM(
        'NORMAL',
        'RISQUE',
        'MAM_MODEREE',
        'MAS_SEVERE',
        'A_EVALUER'
    ) DEFAULT 'A_EVALUER',

    observations TEXT,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_depistage_membre
        FOREIGN KEY (membre_id)
        REFERENCES membres_menages(membre_id),

    CONSTRAINT fk_depistage_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id),

    CONSTRAINT fk_depistage_visite
        FOREIGN KEY (visite_id)
        REFERENCES visites_domicile(visite_id)
) ENGINE=InnoDB;
# je verifie 
SHOW TABLES;
SELECT
    TABLE_NAME,
    ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'saha_communautaires'
ORDER BY TABLE_NAME;

# je verifie les relations 
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'saha_communautaires'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;
#des sensibilisations communautaires
USE saha_communautaires;

CREATE TABLE IF NOT EXISTS sensibilisations (
    sensibilisation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    organisation_id BIGINT UNSIGNED NOT NULL,
    projet_id BIGINT UNSIGNED,
    zone_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED NOT NULL,

    theme VARCHAR(180) NOT NULL,
    type_activite VARCHAR(100),
    date_activite DATETIME NOT NULL,
    lieu VARCHAR(180),

    nombre_participants INT UNSIGNED DEFAULT 0,
    nombre_femmes INT UNSIGNED DEFAULT 0,
    nombre_hommes INT UNSIGNED DEFAULT 0,
    nombre_enfants INT UNSIGNED DEFAULT 0,

    methodologie TEXT,
    observations TEXT,

    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sens_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_sens_projet
        FOREIGN KEY (projet_id)
        REFERENCES projets(projet_id),

    CONSTRAINT fk_sens_zone
        FOREIGN KEY (zone_id)
        REFERENCES zones(zone_id),

    CONSTRAINT fk_sens_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id)
) ENGINE=InnoDB;

#table de referencement
CREATE TABLE IF NOT EXISTS referencements (
    referencement_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    membre_id BIGINT UNSIGNED NOT NULL,
    depistage_id BIGINT UNSIGNED,
    structure_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED NOT NULL,

    date_referencement DATETIME NOT NULL,
    motif TEXT NOT NULL,

    niveau_urgence ENUM(
        'NORMAL',
        'URGENT',
        'TRES_URGENT'
    ) DEFAULT 'NORMAL',

    statut ENUM(
        'EN_ATTENTE',
        'ORIENTE',
        'PRIS_EN_CHARGE',
        'NON_ABOUTI',
        'CLOTURE'
    ) DEFAULT 'EN_ATTENTE',

    date_suivi DATE,
    resultat_suivi TEXT,
    observations TEXT,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ref_membre
        FOREIGN KEY (membre_id)
        REFERENCES membres_menages(membre_id),

    CONSTRAINT fk_ref_depistage
        FOREIGN KEY (depistage_id)
        REFERENCES depistages_nutritionnels(depistage_id),

    CONSTRAINT fk_ref_structure
        FOREIGN KEY (structure_id)
        REFERENCES structures(structure_id),

    CONSTRAINT fk_ref_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id)
) ENGINE=InnoDB;

#table des supervisions
CREATE TABLE IF NOT EXISTS supervisions (
    supervision_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    organisation_id BIGINT UNSIGNED NOT NULL,
    projet_id BIGINT UNSIGNED,
    relais_id BIGINT UNSIGNED NOT NULL,
    superviseur_id BIGINT UNSIGNED NOT NULL,
    zone_id BIGINT UNSIGNED NOT NULL,

    date_supervision DATETIME NOT NULL,
    type_supervision ENUM(
        'TERRAIN',
        'BUREAU',
        'DISTANCE'
    ) DEFAULT 'TERRAIN',

    score_performance DECIMAL(5,2),

    points_forts TEXT,
    difficultes TEXT,
    recommandations TEXT,
    plan_action TEXT,

    date_prochaine_supervision DATE,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sup_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_sup_projet
        FOREIGN KEY (projet_id)
        REFERENCES projets(projet_id),

    CONSTRAINT fk_sup_relais
        FOREIGN KEY (relais_id)
        REFERENCES relais_communautaires(relais_id),

    CONSTRAINT fk_sup_superviseur
        FOREIGN KEY (superviseur_id)
        REFERENCES utilisateurs(utilisateur_id),

    CONSTRAINT fk_sup_zone
        FOREIGN KEY (zone_id)
        REFERENCES zones(zone_id)
) ENGINE=InnoDB;
# je verifie 
SHOW TABLES;
SELECT
    TABLE_NAME,
    ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'saha_communautaires'
ORDER BY TABLE_NAME;
# je verifie la relations de tables 
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'saha_communautaires'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

#table des enquêtes
USE saha_communautaires;

CREATE TABLE IF NOT EXISTS enquetes (
    enquete_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    organisation_id BIGINT UNSIGNED NOT NULL,
    projet_id BIGINT UNSIGNED,
    zone_id BIGINT UNSIGNED,

    titre VARCHAR(200) NOT NULL,
    code_enquete VARCHAR(60) NOT NULL,
    description TEXT,

    date_debut DATE,
    date_fin DATE,

    statut ENUM(
        'BROUILLON',
        'ACTIVE',
        'SUSPENDUE',
        'TERMINEE'
    ) DEFAULT 'BROUILLON',

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_enquete_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_enquete_projet
        FOREIGN KEY (projet_id)
        REFERENCES projets(projet_id),

    CONSTRAINT fk_enquete_zone
        FOREIGN KEY (zone_id)
        REFERENCES zones(zone_id),

    UNIQUE KEY uq_enquete_code (organisation_id, code_enquete)
) ENGINE=InnoDB;

#table des questionnaires
CREATE TABLE IF NOT EXISTS questionnaires (
    questionnaire_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    enquete_id BIGINT UNSIGNED NOT NULL,

    titre VARCHAR(200) NOT NULL,
    version VARCHAR(20) DEFAULT '1.0',
    description TEXT,

    statut ENUM(
        'BROUILLON',
        'PUBLIE',
        'ARCHIVE'
    ) DEFAULT 'BROUILLON',

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_questionnaire_enquete
        FOREIGN KEY (enquete_id)
        REFERENCES enquetes(enquete_id)
) ENGINE=InnoDB;

#table des questions
CREATE TABLE IF NOT EXISTS questions (
    question_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    questionnaire_id BIGINT UNSIGNED NOT NULL,

    libelle TEXT NOT NULL,

    type_question ENUM(
        'TEXTE',
        'NOMBRE',
        'DATE',
        'OUI_NON',
        'CHOIX_UNIQUE',
        'CHOIX_MULTIPLE',
        'DECIMAL',
        'PHOTO',
        'GEOLOCALISATION'
    ) NOT NULL,

    obligatoire BOOLEAN DEFAULT FALSE,
    ordre_affichage INT DEFAULT 1,

    unite VARCHAR(30),
    aide_saisie TEXT,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_question_questionnaire
        FOREIGN KEY (questionnaire_id)
        REFERENCES questionnaires(questionnaire_id)
) ENGINE=InnoDB;

#table des réponses
CREATE TABLE IF NOT EXISTS reponses (
    reponse_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    question_id BIGINT UNSIGNED NOT NULL,
    enquete_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED NOT NULL,
    menage_id BIGINT UNSIGNED,

    code_repondant VARCHAR(80),

    valeur_texte TEXT,
    valeur_nombre DECIMAL(15,4),
    valeur_date DATE,

    date_reponse DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reponse_question
        FOREIGN KEY (question_id)
        REFERENCES questions(question_id),

    CONSTRAINT fk_reponse_enquete
        FOREIGN KEY (enquete_id)
        REFERENCES enquetes(enquete_id),

    CONSTRAINT fk_reponse_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id),

    CONSTRAINT fk_reponse_menage
        FOREIGN KEY (menage_id)
        REFERENCES menages(menage_id)
) ENGINE=InnoDB;
# je verifie 
SHOW TABLES;
SELECT
    TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'saha_communautaires'
ORDER BY TABLE_NAME;
# verifie la relations
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'saha_communautaires'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

#table des formations
USE saha_communautaires;

CREATE TABLE IF NOT EXISTS formations (
    formation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    organisation_id BIGINT UNSIGNED NOT NULL,
    projet_id BIGINT UNSIGNED,

    titre VARCHAR(200) NOT NULL,
    theme VARCHAR(180) NOT NULL,
    description TEXT,

    lieu VARCHAR(180),
    date_debut DATE NOT NULL,
    date_fin DATE,

    formateur VARCHAR(160),
    nombre_participants_prevu INT UNSIGNED DEFAULT 0,

    statut ENUM(
        'PLANIFIEE',
        'EN_COURS',
        'TERMINEE',
        'ANNULEE'
    ) DEFAULT 'PLANIFIEE',

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_formation_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_formation_projet
        FOREIGN KEY (projet_id)
        REFERENCES projets(projet_id)
) ENGINE=InnoDB;

#participants aux formations
CREATE TABLE IF NOT EXISTS formation_participants (
    participation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    formation_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED NOT NULL,

    statut_participation ENUM(
        'INSCRIT',
        'PRESENT',
        'ABSENT',
        'PARTIEL'
    ) DEFAULT 'INSCRIT',

    resultat_evaluation DECIMAL(5,2),
    certificat_delivre BOOLEAN DEFAULT FALSE,
    observations TEXT,

    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_participation_formation
        FOREIGN KEY (formation_id)
        REFERENCES formations(formation_id),

    CONSTRAINT fk_participation_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id),

    UNIQUE KEY uq_formation_participant
        (formation_id, utilisateur_id)
) ENGINE=InnoDB;

#les documents et les pièces jointes
CREATE TABLE IF NOT EXISTS pieces_jointes (
    piece_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    organisation_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED NOT NULL,

    type_document VARCHAR(80) NOT NULL,
    nom_fichier VARCHAR(255) NOT NULL,
    chemin_fichier VARCHAR(500) NOT NULL,
    format_fichier VARCHAR(30),
    taille_octets BIGINT UNSIGNED,

    type_entite VARCHAR(80),
    entite_id BIGINT UNSIGNED,

    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_piece_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_piece_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id)
) ENGINE=InnoDB;

#la synchronisation hors connexion
CREATE TABLE IF NOT EXISTS synchronisations (
    synchronisation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    utilisateur_id BIGINT UNSIGNED NOT NULL,

    identifiant_operation VARCHAR(100) NOT NULL,
    type_operation ENUM(
        'INSERTION',
        'MODIFICATION',
        'SUPPRESSION'
    ) NOT NULL,

    nom_table VARCHAR(100) NOT NULL,
    identifiant_enregistrement VARCHAR(100),

    statut ENUM(
        'EN_ATTENTE',
        'TRANSMISE',
        'VALIDEE',
        'ERREUR'
    ) DEFAULT 'EN_ATTENTE',

    message_erreur TEXT,

    date_operation DATETIME NOT NULL,
    date_synchronisation DATETIME,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sync_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id),

    UNIQUE KEY uq_identifiant_operation
        (identifiant_operation)
) ENGINE=InnoDB;

#l'historique des opérations
CREATE TABLE IF NOT EXISTS journal_audit (
    audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    organisation_id BIGINT UNSIGNED NOT NULL,
    utilisateur_id BIGINT UNSIGNED,

    action VARCHAR(100) NOT NULL,
    nom_table VARCHAR(100),
    identifiant_enregistrement VARCHAR(100),

    anciennes_valeurs JSON,
    nouvelles_valeurs JSON,

    adresse_ip VARCHAR(45),
    date_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_audit_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(utilisateur_id)
) ENGINE=InnoDB;
#référentiel des indicateurs
CREATE TABLE IF NOT EXISTS indicateurs (
    indicateur_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    organisation_id BIGINT UNSIGNED NOT NULL,
    projet_id BIGINT UNSIGNED,

    code_indicateur VARCHAR(60) NOT NULL,
    nom_indicateur VARCHAR(200) NOT NULL,
    description TEXT,

    domaine VARCHAR(100),
    unite_mesure VARCHAR(50),

    frequence ENUM(
        'JOURNALIERE',
        'HEBDOMADAIRE',
        'MENSUELLE',
        'TRIMESTRIELLE',
        'ANNUELLE'
    ) DEFAULT 'MENSUELLE',

    methode_calcul TEXT,
    actif BOOLEAN DEFAULT TRUE,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_indicateur_organisation
        FOREIGN KEY (organisation_id)
        REFERENCES organisations(organisation_id),

    CONSTRAINT fk_indicateur_projet
        FOREIGN KEY (projet_id)
        REFERENCES projets(projet_id),

    UNIQUE KEY uq_indicateur_code
        (organisation_id, code_indicateur)
) ENGINE=InnoDB;
#Vérification générale
SELECT
    COUNT(*) AS nombre_tables
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'saha_communautaires'
AND TABLE_TYPE = 'BASE TABLE';
SHOW TABLES;
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'saha_communautaires'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

# verifier la table geographique 
USE saha_communautaires;

DESCRIBE zones;
#Enregistrer les 15 wilayas
INSERT INTO zones (
    parent_zone_id,
    code_zone,
    nom_zone,
    niveau,
    actif
)
VALUES
(NULL, 'W01', 'Adrar', 'WILAYA', TRUE),
(NULL, 'W02', 'Assaba', 'WILAYA', TRUE),
(NULL, 'W03', 'Brakna', 'WILAYA', TRUE),
(NULL, 'W04', 'Dakhlet Nouadhibou', 'WILAYA', TRUE),
(NULL, 'W05', 'Gorgol', 'WILAYA', TRUE),
(NULL, 'W06', 'Guidimagha', 'WILAYA', TRUE),
(NULL, 'W07', 'Hodh Chargui', 'WILAYA', TRUE),
(NULL, 'W08', 'Hodh El Gharbi', 'WILAYA', TRUE),
(NULL, 'W09', 'Inchiri', 'WILAYA', TRUE),
(NULL, 'W10', 'Nouakchott Nord', 'WILAYA', TRUE),
(NULL, 'W11', 'Nouakchott Ouest', 'WILAYA', TRUE),
(NULL, 'W12', 'Nouakchott Sud', 'WILAYA', TRUE),
(NULL, 'W13', 'Tagant', 'WILAYA', TRUE),
(NULL, 'W14', 'Tiris Zemmour', 'WILAYA', TRUE),
(NULL, 'W15', 'Trarza', 'WILAYA', TRUE)
ON DUPLICATE KEY UPDATE
    nom_zone = VALUES(nom_zone),
    niveau = VALUES(niveau);
    SELECT
    zone_id,
    code_zone,
    nom_zone,
    niveau
FROM zones
WHERE niveau = 'WILAYA'
ORDER BY code_zone;
SELECT COUNT(*) AS nombre_wilayas
FROM zones
WHERE niveau = 'WILAYA';

#Vérifier les wilayas enregistrées
USE saha_communautaires;

SELECT
    zone_id,
    code_zone,
    nom_zone,
    niveau
FROM zones
WHERE niveau = 'WILAYA'
ORDER BY code_zone;
SELECT COUNT(*) AS nombre_wilayas
FROM zones
WHERE niveau = 'WILAYA';
#Insérer les 63 moughataas
USE saha_communautaires;

INSERT INTO zones (
    parent_zone_id,
    code_zone,
    nom_zone,
    niveau,
    actif
)
SELECT
    w.zone_id,
    m.code_zone,
    m.nom_zone,
    'MOUGHATAA',
    TRUE
FROM (
    SELECT 'W07' AS wilaya, 'M01' AS code_zone, 'Amourj' AS nom_zone
    UNION ALL SELECT 'W07', 'M02', 'Bassikounou'
    UNION ALL SELECT 'W07', 'M03', 'Djiguenni'
    UNION ALL SELECT 'W07', 'M04', 'Néma'
    UNION ALL SELECT 'W07', 'M05', 'Oualata'
    UNION ALL SELECT 'W07', 'M06', 'Timbédra'
    UNION ALL SELECT 'W07', 'M07', 'Dhhar'
    UNION ALL SELECT 'W07', 'M08', 'Adel Begrou'

    UNION ALL SELECT 'W08', 'M09', 'Aïoun'
    UNION ALL SELECT 'W08', 'M10', 'Kobonni'
    UNION ALL SELECT 'W08', 'M11', 'Tamchakett'
    UNION ALL SELECT 'W08', 'M12', 'Tintane'
    UNION ALL SELECT 'W08', 'M13', 'Touil'

    UNION ALL SELECT 'W02', 'M14', 'Barkéwol'
    UNION ALL SELECT 'W02', 'M15', 'Boumdeïd'
    UNION ALL SELECT 'W02', 'M16', 'Guérou'
    UNION ALL SELECT 'W02', 'M17', 'Kankoussa'
    UNION ALL SELECT 'W02', 'M18', 'Kiffa'

    UNION ALL SELECT 'W05', 'M19', 'Kaédi'
    UNION ALL SELECT 'W05', 'M20', 'Maghama'
    UNION ALL SELECT 'W05', 'M21', 'M’Bout'
    UNION ALL SELECT 'W05', 'M22', 'Monguel'
    UNION ALL SELECT 'W05', 'M23', 'Lexeiba'

    UNION ALL SELECT 'W03', 'M24', 'Aleg'
    UNION ALL SELECT 'W03', 'M25', 'Bababé'
    UNION ALL SELECT 'W03', 'M26', 'Boghé'
    UNION ALL SELECT 'W03', 'M27', 'Magta-Lahjar'
    UNION ALL SELECT 'W03', 'M28', 'M’Bagne'
    UNION ALL SELECT 'W03', 'M29', 'Maal'

    UNION ALL SELECT 'W15', 'M30', 'Boutilimit'
    UNION ALL SELECT 'W15', 'M31', 'Keur-Macène'
    UNION ALL SELECT 'W15', 'M32', 'Méderdra'
    UNION ALL SELECT 'W15', 'M33', 'Ouad-Naga'
    UNION ALL SELECT 'W15', 'M34', 'R’Kiz'
    UNION ALL SELECT 'W15', 'M35', 'Rosso'
    UNION ALL SELECT 'W15', 'M36', 'Tékane'

    UNION ALL SELECT 'W01', 'M37', 'Aoujeft'
    UNION ALL SELECT 'W01', 'M38', 'Atar'
    UNION ALL SELECT 'W01', 'M39', 'Chinguitti'
    UNION ALL SELECT 'W01', 'M40', 'Ouadane'

    UNION ALL SELECT 'W04', 'M41', 'Nouadhibou'
    UNION ALL SELECT 'W04', 'M42', 'Echamy'

    UNION ALL SELECT 'W13', 'M43', 'Moudjéria'
    UNION ALL SELECT 'W13', 'M44', 'Tichitt'
    UNION ALL SELECT 'W13', 'M45', 'Tidjikja'

    UNION ALL SELECT 'W06', 'M46', 'Ould-Yengé'
    UNION ALL SELECT 'W06', 'M47', 'Sélibaby'
    UNION ALL SELECT 'W06', 'M48', 'Ghabou'
    UNION ALL SELECT 'W06', 'M49', 'Wompou'

    UNION ALL SELECT 'W14', 'M50', 'Bir-Moghrein'
    UNION ALL SELECT 'W14', 'M51', 'F’Dérick'
    UNION ALL SELECT 'W14', 'M52', 'Zouérate'

    UNION ALL SELECT 'W09', 'M53', 'Akjoujt'
    UNION ALL SELECT 'W09', 'M54', 'Binichab'

    UNION ALL SELECT 'W11', 'M55', 'Ksar'
    UNION ALL SELECT 'W11', 'M56', 'Tavragh-Zeïna'
    UNION ALL SELECT 'W11', 'M57', 'Sebkha'

    UNION ALL SELECT 'W12', 'M58', 'Arafat'
    UNION ALL SELECT 'W12', 'M59', 'El Mina'
    UNION ALL SELECT 'W12', 'M60', 'Riyad'

    UNION ALL SELECT 'W10', 'M61', 'Toujounine'
    UNION ALL SELECT 'W10', 'M62', 'Dar Naïm'
    UNION ALL SELECT 'W10', 'M63', 'Teyarett'
) AS m
INNER JOIN zones AS w
    ON w.code_zone = m.wilaya
    AND w.niveau = 'WILAYA'
ON DUPLICATE KEY UPDATE
    nom_zone = VALUES(nom_zone),
    niveau = VALUES(niveau),
    parent_zone_id = VALUES(parent_zone_id);
    
    SELECT
    w.nom_zone AS wilaya,
    COUNT(m.zone_id) AS nombre_moughataas
FROM zones AS w
LEFT JOIN zones AS m
    ON m.parent_zone_id = w.zone_id
    AND m.niveau = 'MOUGHATAA'
WHERE w.niveau = 'WILAYA'
GROUP BY w.zone_id, w.nom_zone
ORDER BY w.code_zone;
SELECT COUNT(*) AS total_moughataas
FROM zones
WHERE niveau = 'MOUGHATAA';
#Contrôle des moughataas
SELECT COUNT(*) AS total_moughataas
FROM zones
WHERE niveau = 'MOUGHATAA';
SELECT
    w.nom_zone AS wilaya,
    m.code_zone,
    m.nom_zone AS moughataa
FROM zones AS m
INNER JOIN zones AS w
    ON m.parent_zone_id = w.zone_id
WHERE m.niveau = 'MOUGHATAA'
ORDER BY w.code_zone, m.code_zone;
#Préparer l'enregistrement des communes
USE saha_communautaires;

SHOW COLUMNS FROM zones LIKE 'niveau';
enum('WILAYA','MOUGHATAA','COMMUNE','LOCALITE')
SELECT
    COUNT(*) AS total_wilayas
FROM zones
WHERE niveau = 'WILAYA';

SELECT
    COUNT(*) AS total_moughataas
FROM zones
WHERE niveau = 'MOUGHATAA';

SELECT
    COUNT(*) AS total_communes
FROM zones
WHERE niveau = 'COMMUNE';
#préparer l'intégration des communes.
USE saha_communautaires;

SELECT
    niveau,
    COUNT(*) AS total
FROM zones
GROUP BY niveau
ORDER BY niveau;
SELECT
    m.code_zone,
    m.nom_zone
FROM zones AS m
LEFT JOIN zones AS w
    ON m.parent_zone_id = w.zone_id
WHERE m.niveau = 'MOUGHATAA'
AND (w.zone_id IS NULL OR w.niveau <> 'WILAYA');
#Vérifier les relations géographiques
USE saha_communautaires;

SELECT
    zone_id,
    parent_zone_id,
    code_zone,
    nom_zone,
    niveau
FROM zones
ORDER BY
    FIELD(niveau, 'WILAYA', 'MOUGHATAA', 'COMMUNE', 'LOCALITE'),
    code_zone;
    SELECT
    code_zone,
    COUNT(*) AS nombre
FROM zones
GROUP BY code_zone
HAVING COUNT(*) > 1;

#Contrôler la hiérarchie administrative
USE saha_communautaires;

SELECT
    enfant.code_zone,
    enfant.nom_zone,
    enfant.niveau,
    parent.nom_zone AS zone_parent,
    parent.niveau AS niveau_parent
FROM zones AS enfant
LEFT JOIN zones AS parent
    ON enfant.parent_zone_id = parent.zone_id
WHERE
    (enfant.niveau = 'WILAYA'
        AND enfant.parent_zone_id IS NOT NULL)
    OR
    (enfant.niveau = 'MOUGHATAA'
        AND (parent.niveau IS NULL OR parent.niveau <> 'WILAYA'))
    OR
    (enfant.niveau = 'COMMUNE'
        AND (parent.niveau IS NULL OR parent.niveau <> 'MOUGHATAA'))
    OR
    (enfant.niveau = 'LOCALITE'
        AND (parent.niveau IS NULL OR parent.niveau <> 'COMMUNE'));
	
#Créer une vue géographique
USE saha_communautaires;

CREATE OR REPLACE VIEW vue_geographie_saha AS
SELECT
    w.zone_id AS wilaya_id,
    w.nom_zone AS wilaya,

    m.zone_id AS moughataa_id,
    m.nom_zone AS moughataa,

    c.zone_id AS commune_id,
    c.nom_zone AS commune,

    l.zone_id AS localite_id,
    l.nom_zone AS localite

FROM zones AS w

LEFT JOIN zones AS m
    ON m.parent_zone_id = w.zone_id
    AND m.niveau = 'MOUGHATAA'

LEFT JOIN zones AS c
    ON c.parent_zone_id = m.zone_id
    AND c.niveau = 'COMMUNE'

LEFT JOIN zones AS l
    ON l.parent_zone_id = c.zone_id
    AND l.niveau = 'LOCALITE'

WHERE w.niveau = 'WILAYA';

SELECT *
FROM vue_geographie_saha
LIMIT 20;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';
#table temporaire d'importation
USE saha_communautaires;

CREATE TABLE IF NOT EXISTS staging_communes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code_commune VARCHAR(20) NOT NULL,
    nom_commune VARCHAR(150) NOT NULL,
    code_moughataa VARCHAR(20) NOT NULL,
    source_donnees VARCHAR(255),
    statut_validation ENUM(
        'A_VERIFIER',
        'VALIDE',
        'REJETE'
    ) DEFAULT 'A_VERIFIER',
    date_importation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_code_commune (code_commune),
    INDEX idx_code_moughataa (code_moughataa)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
DESCRIBE staging_communes;

#Vérifier la table d'importation
USE saha_communautaires;

SHOW TABLES LIKE 'staging_communes';
DESCRIBE staging_communes;

SELECT COUNT(*) AS nombre_communes_importees
FROM staging_communes;

#Créer une vue de contrôle des communes
USE saha_communautaires;

CREATE OR REPLACE VIEW vue_controle_communes AS
SELECT
    s.id,
    s.code_commune,
    s.nom_commune,
    s.code_moughataa,
    m.nom_zone AS moughataa,
    w.nom_zone AS wilaya,
    s.statut_validation,
    CASE
        WHEN m.zone_id IS NULL
            THEN 'MOUGHATAA INTROUVABLE'
        WHEN m.niveau <> 'MOUGHATAA'
            THEN 'NIVEAU INCORRECT'
        ELSE 'RATTACHEMENT TROUVE'
    END AS resultat_controle
FROM staging_communes AS s
LEFT JOIN zones AS m
    ON m.code_zone = s.code_moughataa
LEFT JOIN zones AS w
    ON w.zone_id = m.parent_zone_id;
    
    SELECT *
FROM vue_controle_communes;


USE saha_communautaires;

SELECT
    code_zone,
    nom_zone
FROM zones
WHERE niveau = 'MOUGHATAA'
ORDER BY nom_zone;

SELECT
    COUNT(*) AS total_moughataas,
    COUNT(DISTINCT code_zone) AS codes_uniques
FROM zones
WHERE niveau = 'MOUGHATAA';

#l'intégration automatique des communes
USE saha_communautaires;

DELIMITER //

CREATE PROCEDURE integrer_communes_saha()
BEGIN

    INSERT INTO zones (
        parent_zone_id,
        code_zone,
        nom_zone,
        niveau,
        actif
    )
    SELECT
        m.zone_id,
        s.code_commune,
        s.nom_commune,
        'COMMUNE',
        TRUE
    FROM staging_communes AS s
    INNER JOIN zones AS m
        ON m.code_zone = s.code_moughataa
        AND m.niveau = 'MOUGHATAA'
    WHERE s.statut_validation = 'VALIDE'
      AND NOT EXISTS (
          SELECT 1
          FROM zones AS z
          WHERE z.code_zone = s.code_commune
      );

END //

DELIMITER ;

SHOW PROCEDURE STATUS
WHERE Db = 'saha_communautaires'
AND Name = 'integrer_communes_saha';

#les rattachements des communes
USE saha_communautaires;

ALTER TABLE staging_communes
ADD CONSTRAINT fk_staging_communes_moughataa
FOREIGN KEY (code_moughataa)
REFERENCES zones(code_zone)
ON UPDATE CASCADE
ON DELETE RESTRICT;

SHOW CREATE TABLE staging_communes;

#Vérifier les rôles déjà créés
USE saha_communautaires;

SELECT *
FROM roles
ORDER BY role_id;

DESCRIBE utilisateurs;

#Vérifier les droits et les rôles
USE saha_communautaires;

INSERT INTO roles (code_role, libelle)
VALUES
('ADMIN', 'Administrateur général'),
('COORDINATEUR', 'Coordinateur de projet'),
('SUPERVISEUR', 'Superviseur terrain'),
('AGENT', 'Agent communautaire'),
('RELAIS', 'Relais communautaire'),
('LECTEUR', 'Utilisateur en consultation')
ON DUPLICATE KEY UPDATE
libelle = VALUES(libelle);
SELECT
    role_id,
    code_role,
    libelle
FROM roles
ORDER BY role_id;

#Vérifier la structure des comptes
USE saha_communautaires;

DESCRIBE utilisateurs;

#Vérifier les comptes existants
SELECT
    COUNT(*) AS nombre_utilisateurs
FROM utilisateurs;

#Préparer la création du compte administrateur
USE saha_communautaires;

SELECT
    role_id,
    code_role,
    libelle
FROM roles
WHERE code_role = 'ADMIN';

SELECT
    organisation_id,
    nom,
    sigle,
    actif
FROM organisations;

#Créer la table des permissions
USE saha_communautaires;

CREATE TABLE IF NOT EXISTS permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    code_permission VARCHAR(100) NOT NULL UNIQUE,
    libelle VARCHAR(150) NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
USE saha_communautaires;

SHOW CREATE TABLE roles;

SHOW CREATE TABLE permissions;



USE saha_communautaires;

SHOW COLUMNS FROM roles LIKE 'role_id';

SHOW COLUMNS FROM permissions LIKE 'permission_id';
CREATE TABLE IF NOT EXISTS role_permissions (
    role_permission_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    role_id INT UNSIGNED NOT NULL,
    permission_id INT UNSIGNED NOT NULL,

    autorise BOOLEAN DEFAULT TRUE,

    UNIQUE KEY uk_role_permission (
        role_id,
        permission_id
    ),

    CONSTRAINT fk_rp_role
        FOREIGN KEY (role_id)
        REFERENCES roles(role_id),

    CONSTRAINT fk_rp_permission
        FOREIGN KEY (permission_id)
        REFERENCES permissions(permission_id)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

USE saha_communautaires;

SHOW CREATE TABLE roles;

SHOW CREATE TABLE permissions;

SHOW FULL COLUMNS FROM roles;

SHOW FULL COLUMNS FROM permissions;

USE saha_communautaires;

CREATE TABLE role_permissions (
    role_permission_id INT AUTO_INCREMENT PRIMARY KEY,

    role_id SMALLINT UNSIGNED NOT NULL,
    permission_id INT NOT NULL,

    autorise BOOLEAN DEFAULT TRUE,

    UNIQUE KEY uk_role_permission (
        role_id,
        permission_id
    ),

    CONSTRAINT fk_rp_role
        FOREIGN KEY (role_id)
        REFERENCES roles(role_id),

    CONSTRAINT fk_rp_permission
        FOREIGN KEY (permission_id)
        REFERENCES permissions(permission_id)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

USE saha_communautaires;

INSERT INTO permissions (
    code_permission,
    libelle,
    description
)
VALUES
('UTILISATEURS_CREER', 'Créer des utilisateurs', 'Créer de nouveaux comptes utilisateurs'),
('UTILISATEURS_MODIFIER', 'Modifier les utilisateurs', 'Modifier les informations des comptes'),
('UTILISATEURS_DESACTIVER', 'Désactiver les utilisateurs', 'Activer ou désactiver des comptes'),

('MENAGES_CREER', 'Enregistrer des ménages', 'Créer des fiches ménages'),
('MENAGES_CONSULTER', 'Consulter les ménages', 'Consulter les informations des ménages'),
('MENAGES_MODIFIER', 'Modifier les ménages', 'Modifier les fiches ménages'),

('VISITES_CREER', 'Enregistrer des visites', 'Enregistrer les visites à domicile'),
('VISITES_CONSULTER', 'Consulter les visites', 'Consulter les visites réalisées'),

('DEPISTAGES_CREER', 'Enregistrer des dépistages', 'Enregistrer les dépistages nutritionnels'),
('DEPISTAGES_CONSULTER', 'Consulter les dépistages', 'Consulter les résultats des dépistages'),

('SENSIBILISATIONS_CREER', 'Enregistrer des sensibilisations', 'Enregistrer les activités communautaires'),
('SENSIBILISATIONS_CONSULTER', 'Consulter les sensibilisations', 'Consulter les activités réalisées'),

('REFERENCEMENTS_CREER', 'Créer des référencements', 'Orienter les personnes vers les structures sanitaires'),
('REFERENCEMENTS_CONSULTER', 'Consulter les référencements', 'Suivre les orientations sanitaires'),

('SUPERVISIONS_CREER', 'Créer des supervisions', 'Enregistrer les activités de supervision'),
('SUPERVISIONS_CONSULTER', 'Consulter les supervisions', 'Consulter les rapports de supervision'),

('RAPPORTS_CONSULTER', 'Consulter les rapports', 'Accéder aux rapports et statistiques'),
('PROJETS_GERER', 'Gérer les projets', 'Créer et gérer les projets'),
('ZONES_GERER', 'Gérer les zones', 'Gérer le découpage géographique'),
('PARAMETRES_GERER', 'Gérer les paramètres', 'Administrer les paramètres de la plateforme')

ON DUPLICATE KEY UPDATE
    libelle = VALUES(libelle),
    description = VALUES(description);
    
    SELECT
    permission_id,
    code_permission,
    libelle
FROM permissions
ORDER BY permission_id;

#verifier les permission 
USE saha_communautaires;

SELECT 
    COUNT(*) AS nombre_permissions
FROM permissions;
#Attribuer les permissions aux rôles
USE saha_communautaires;

INSERT INTO role_permissions (
    role_id,
    permission_id,
    autorise
)
SELECT
    r.role_id,
    p.permission_id,
    TRUE
FROM roles r
CROSS JOIN permissions p
WHERE
    r.code_role = 'ADMIN'

    OR (
        r.code_role = 'COORDINATEUR'
        AND p.code_permission IN (
            'MENAGES_CREER',
            'MENAGES_CONSULTER',
            'MENAGES_MODIFIER',
            'VISITES_CREER',
            'VISITES_CONSULTER',
            'DEPISTAGES_CREER',
            'DEPISTAGES_CONSULTER',
            'SENSIBILISATIONS_CREER',
            'SENSIBILISATIONS_CONSULTER',
            'REFERENCEMENTS_CREER',
            'REFERENCEMENTS_CONSULTER',
            'SUPERVISIONS_CREER',
            'SUPERVISIONS_CONSULTER',
            'RAPPORTS_CONSULTER',
            'PROJETS_GERER'
        )
    )

    OR (
        r.code_role = 'SUPERVISEUR'
        AND p.code_permission IN (
            'MENAGES_CONSULTER',
            'MENAGES_MODIFIER',
            'VISITES_CREER',
            'VISITES_CONSULTER',
            'DEPISTAGES_CREER',
            'DEPISTAGES_CONSULTER',
            'SENSIBILISATIONS_CREER',
            'SENSIBILISATIONS_CONSULTER',
            'REFERENCEMENTS_CREER',
            'REFERENCEMENTS_CONSULTER',
            'SUPERVISIONS_CREER',
            'SUPERVISIONS_CONSULTER',
            'RAPPORTS_CONSULTER'
        )
    )

    OR (
        r.code_role = 'AGENT'
        AND p.code_permission IN (
            'MENAGES_CREER',
            'MENAGES_CONSULTER',
            'MENAGES_MODIFIER',
            'VISITES_CREER',
            'VISITES_CONSULTER',
            'DEPISTAGES_CREER',
            'DEPISTAGES_CONSULTER',
            'SENSIBILISATIONS_CREER',
            'SENSIBILISATIONS_CONSULTER',
            'REFERENCEMENTS_CREER',
            'REFERENCEMENTS_CONSULTER'
        )
    )

    OR (
        r.code_role = 'RELAIS'
        AND p.code_permission IN (
            'MENAGES_CREER',
            'MENAGES_CONSULTER',
            'VISITES_CREER',
            'VISITES_CONSULTER',
            'DEPISTAGES_CREER',
            'SENSIBILISATIONS_CREER',
            'REFERENCEMENTS_CREER'
        )
    )

    OR (
        r.code_role = 'LECTEUR'
        AND p.code_permission IN (
            'MENAGES_CONSULTER',
            'VISITES_CONSULTER',
            'DEPISTAGES_CONSULTER',
            'SENSIBILISATIONS_CONSULTER',
            'REFERENCEMENTS_CONSULTER',
            'SUPERVISIONS_CONSULTER',
            'RAPPORTS_CONSULTER'
        )
    )

ON DUPLICATE KEY UPDATE
    autorise = TRUE;
    
    #Vérifier les attributions
    SELECT
    r.code_role,
    r.libelle,
    COUNT(rp.permission_id) AS nombre_permissions
FROM roles r
LEFT JOIN role_permissions rp
    ON r.role_id = rp.role_id
    AND rp.autorise = TRUE
GROUP BY r.role_id, r.code_role, r.libelle
ORDER BY r.role_id;
# verifier les struvtures des utilisateurs 
USE saha_communautaires;

-- 1. Vérifier les rôles
SELECT role_id, code_role, libelle
FROM roles
ORDER BY role_id;

-- 2. Vérifier les permissions enregistrées
SELECT COUNT(*) AS nombre_permissions
FROM permissions;

-- 3. Vérifier les permissions attribuées
SELECT
    r.code_role,
    COUNT(rp.permission_id) AS nombre_permissions
FROM roles r
LEFT JOIN role_permissions rp
    ON r.role_id = rp.role_id
    AND rp.autorise = TRUE
GROUP BY r.role_id, r.code_role
ORDER BY r.role_id;

-- 4. Examiner les colonnes de la table utilisateurs
SHOW FULL COLUMNS FROM utilisateurs;

-- 5. Vérifier les organisations enregistrées
SELECT * FROM organisations;

#Préparer le système d'authentification
USE saha_communautaires;

SHOW CREATE TABLE utilisateurs;
USE saha_communautaires;
# organisations et les utilisateurs
-- Vérifier les organisations
SELECT
    organisation_id,
    nom,
    sigle,
    actif
FROM organisations;

-- Vérifier les utilisateurs existants
SELECT
    COUNT(*) AS nombre_utilisateurs
FROM utilisateurs;

-- Vérifier les rôles
SELECT
    role_id,
    code_role,
    libelle
FROM roles;
SELECT
    permission_id,
    code_permission,
    libelle
FROM permissions
ORDER BY permission_id;

DESCRIBE permissions;

DESCRIBE role_permissions;

USE saha_communautaires;

DESCRIBE permissions;

DESCRIBE role_permissions;