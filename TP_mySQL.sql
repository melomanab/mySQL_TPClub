-- Exercise: creer la base de donnes correpondante au
-- système Conseiller - Client - Login - CLub
-- Diagramme UML sur: https://drive.google.com/file/d/1qK_S0Iz0JxPxr8hscACRsTn6aBCoiFS-/view?usp=sharing

-- ########################################################
-- Sintaxe basique de LDD: Langage de Definition de Données
-- ########################################################
-- Creer nouvelle database
CREATE DATABASE bdd;

-- Effacer database
-- DROP DATABASE bdd;

-- Creer table
-- !!! Click dans la bdd pour se situer a l'interieur de la bdd
-- !!! Click dans la fenetre SQL
-- Declarer la clé primaire
-- creer 
-- pour visuealiser, creer sur Structure
CREATE TABLE conseiller(
	idConseiller INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100),
	prenom VARCHAR(100),
	email VARCHAR(255)
)ENGINE = INNOBD; 

CREATE TABLE login(
	idLogin INT PRIMARY KEY NOT NULL,
	login VARCHAR(255),
	mdp VARCHAR(255),
	idClient INTEGER	
)ENGINE = INNOBD; 

CREATE TABLE client(
	idClient INT PRIMARY KEY NOT NULL,
	nom VARCHAR(255),
	prenom VARCHAR(255),
	age INTEGER,
	idConseiller INTEGER	
)ENGINE = INNOBD; 

CREATE TABLE Club(
	idClub INTEGER PRIMARY KEY NOT NULL,
	nom VARCHAR(100)
)ENGINE = INNOBD; 

CREATE TABLE ClientClub(
	idClient INTEGER,
	idClub INTEGER,
	tarif  DOUBLE, 
	dateInscription DATE
	)ENGINE = INNOBD; 
	
CREATE TABLE ClientClub(
	idClient INTEGER,
	idClub INTEGER,
	tarif  DOUBLE, 
	dateInscription DATE
	)ENGINE = INNOBD; -- Active les contraintes rajoutées
	
-- Modifier les tables déjà creés: rajouter colonne
ALTER TABLE club
ADD performance VARCHAR(100),
ADD niveau VARCHAR(100),
ADD typeClub VARCHAR(100),

ALTER TABLE ClientClub DROP tarif 

ALTER TABLE ClientClub ADD tarif DECIMAL(5,2) 

-- Renommer un colonne (obligation repeter le type)
ALTER TABLE ClientClub CHANGE tarif tarifInscription DECIMAL(5,2)

-- Modifier le type
ALTER TABLE ClientClub MODIFY tarif DECIMAL(5,2)

-- Rajouter une contrainte/Declarer clé étrangère
ALTER TABLE Client 
ADD CONSTRAINT fkConseiller FOREIGN KEY (idConseiller) REFERENCES Conseiller(idConseiller)

ALTER TABLE Login 
ADD CONSTRAINT fkClient FOREIGN KEY (idClient) REFERENCES Client(idClient)

-- Declarer clé étrangère composée
ALTER TABLE ClientClub 
ADD CONSTRAINT fkClientClub_Client FOREIGN KEY (idClient) REFERENCES Client(idClient);

ALTER TABLE ClientClub
ADD CONSTRAINT fkClientClub_Club FOREIGN KEY (idClub) REFERENCES Club(idClub);

ALTER TABLE ClientClub
ADD CONSTRAINT pkClientClub PRIMARY KEY (idClient, idClub);

-- Tout au meme temps
ALTER TABLE ClientClub
ADD CONSTRAINT fkClientClub_Club FOREIGN KEY (idClub) REFERENCES Club(idClub),
ADD KEY fkClientClub_Client (idClient),
ADD KEY fkClientClub_Club (idClub),
ADD CONSTRAINT fkClientClub_Client FOREIGN KEY (idClient) REFERENCES Client(idClient),
ADD CONSTRAINT pkClientClub PRIMARY KEY (idClient, idClub);


-- ##########################################################
-- Sintaxe basique de LMD: Langage de Modification de Données
-- ##########################################################
-- Requete de données

-- Fonctions d'aggregation et aliasing
SELECT COUNT(*) AS nbConseillers FROM conseiller

-- Tarif payé pour chaque client
SELECT idClient, SUM(tarifInscription) as TOTAL
FROM `clientclub` 
GROUP BY idClient;

-- Cotisations recues par chaque club
SELECT idClub, SUM(tarifInscription) 
FROM clientclub
GROUP BY idClub

-- Cotisation maximal par club/pour l'ensemble de clubs
SELECT idClub, MAX(tarifInscription) AS cotisationMax
FROM clientclub
-- GROUP by idClub

-- Age minimum des clients/Client le plus jeune
SELECT idClient, MIN(age)
FROM client
-- GROUP BY idClient

-- Moyenne des cotisations
SELECT idClub, AVG(tarifInscription)
FROM clientclub
GROUP by idClub

-- Moyenne des cotisations superieures à 10 euros
SELECT idClub, AVG(tarifInscription)
FROM clientclub
GROUP by idClub
HAVING AVG(tarifInscription) > 10

-- Age minimun des clients dont l'id est compris entre 1 et 2
-- et l'age minimun est 30
SELECT idClient, MIN(age)
FROM client
-- GROUP by idClient 
WHERE idClient BETWEEN 1 and 2
HAVING MIN(age)>=30

-- ORDER bySELECT *
SELECT * FROM client ORDER BY nom

-- LIMIT (limite le nombre des resultats)
SELECT * FROM client ORDER BY nom LIMIT 3

-- JOINTURES (requetes sur plus d'une table)
--------------------------------------------
-- PB -- idConseiller pas declaré comme clé étrangère
ALTER TABLE Client
ADD CONSTRAINT fkClient_idConseiller FOREIGN KEY (idConseiller) REFERENCES conseiller(idConseiller)

-- INNER JOIN  (intersection)
SELECT * FROM client 
INNER JOIN conseiller
ON conseiller.idConseiller=client.idConseiller 
ORDER BY client.nom

-- LEFT JOIN
--- ex. Tous les clients, meme ceux qui n'ont pas de conseiller
SELECT * FROM client 
LEFT JOIN conseiller
ON client.idConseiller=conseiller.idConseiller

-- RIGHT JOIN
-- conseillers meme sans client
SELECT * FROM client 
RIGHT JOIN conseiller
ON client.idConseiller=conseiller.idConseiller

-- FULL JOIN (union)
-- conseillers sans clients et clients sans conseiller
SELECT * FROM client 
LEFT JOIN conseiller
ON client.idConseiller=conseiller.idConseiller
UNION
SELECT * FROM client 
RIGHT JOIN conseiller
ON client.idConseiller=conseiller.idConseiller

-- SELF JOINT
-- Selection conseillers qui ont des managers
---1/ rajouter foreign key idManager
ALTER table conseiller 
ADD idManager INTEGER

ALTER table conseiller 
ADD CONSTRAINT fk_idManager FOREIGN KEY(idManager) REFERENCES conseiller(idConseiller)

---1/ faire requete interne
SELECT * FROM
conseiller as cons1 INNER JOIN conseiller as cons2
ON cons1.idConseiller = cons2.idManager

-- Nom, prenom, date inscription des clients et nom club des clubs associés
-- besoin de paser à travers un table intermediaire clientclub
SELECT
  nom, prenom, club.mon, clientclub.dateInscription
FROM client 
INNER JOIN clientclub ON client.idClient=clientclub.idClient
INNER JOIN club ON clientClub.idClub=club.idClub 

-- Nom, prenom, conseiller et login des clients 
SELECT
  client.nom, client.prenom, login.login, conseiller.nom, conseiller.prenom 
FROM login
INNER JOIN client ON login.idClient=client.idClient
INNER JOIN conseiller ON client.idConseiller=conseiller.idConseiller
 
-- INDEX: pour acces rapide à une table
-- Creer index sur nom du client
CREATE INDEX idx_nom ON client(nom)

-- UNICITE: pour empecher les doublons
ALTER TABLE login 
	ADD UNIQUE (login)
	
-- CHECK: restreindre des valeurs
ALTER TABLE client 
	ADD CONSTRAINT check_age CHECK(age>=18) --marche pas
	
-- DEFAULT:
ALTER TABLE club
	ALTER discriminateur SET DEFAULT 'SPORT';
	
--AUTOINCREMENTS:
ALTER TABLE `login` 
	CHANGE `idLogin` `idLogin` INT(11) NOT NULL AUTO_INCREMENT; 
	
-- dès la création de la table
CREATE TABLE conseillerSecurise(
	idConseiller int NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nom varchar(255) NOT NULL,
	prenom varchar(255) DEFAULT 'Pas renseigné',
	age int,
	ville varchar(255),
	telephone varchar(255),
	CONSTRAINT CHK_age CHECK (age >=18),
	UNIQUE(telephone)
)ENGINE = INNOBD;

CREATE TABLE clientSecurise(
	idClient int NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nom varchar(255) NOT NULL,
	prenom varchar(255) DEFAULT 'Pas renseigné',
	age int,
	ville varchar(255),
	telephone varchar(255),
	idConseiller int
)ENGINE = INNOBD;

-- ON DELETE -- quoi faire si la table est supprimée?
-- ON DELETE CASCADE
-- Supprimer la table et les tables qui la referencent
ALTER TABLE clientSecurise
	ADD CONSTRAINT fkConseillerSecurise FOREIGN KEY (idConseiller) 
	REFERENCES conseillerSecurise(idConseiller)
	ON DELETE CASCADE;
-- ON DELETE SET NULL
-- 
ALTER TABLE clientSecurise
	ADD CONSTRAINT fkConseillerSecurise FOREIGN KEY (idConseiller) 
	REFERENCES conseillerSecurise(idConseiller)
	ON DELETE SET NULL;

