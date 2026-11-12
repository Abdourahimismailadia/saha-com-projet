USE saha_communautaires;

DESCRIBE utilisateurs;
USE saha_communautaires;

SHOW CREATE TABLE utilisateurs;
USE saha_communautaires;

-- 1. Organisations disponibles
SELECT organisation_id, nom, sigle, actif
FROM organisations;

-- 2. Rôles disponibles
SELECT role_id, code_role, libelle
FROM roles;

-- 3. Index et contraintes de la table utilisateurs
SHOW INDEX FROM utilisateurs;
SELECT role_id, code_role, libelle
FROM roles;

SELECT organisation_id, nom, sigle, actif
FROM organisations;

USE saha_communautaires;

SELECT 
    organisation_id,
    nom,
    sigle,
    actif
FROM organisations;

USE saha_communautaires;

INSERT INTO organisations (
    nom,
    sigle,
    type_organisation,
    actif
)
VALUES (
    'SAHA Communautaires',
    'SAHA',
    'Plateforme communautaire',
    1
);

SELECT organisation_id, nom, sigle, actif
FROM organisations;

USE saha_communautaires;

SHOW CREATE TABLE utilisateurs;

USE saha_communautaires;

SELECT
    utilisateur_id,
    nom_complet,
    telephone,
    role_id,
    actif
FROM utilisateurs
WHERE telephone = '48685250';

SELECT utilisateur_id, nom_complet, telephone, role_id, actif
FROM saha_communautaires.utilisateurs;

