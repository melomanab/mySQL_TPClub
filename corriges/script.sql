-- CREATE DATABASE bdd;
-- ENGINE=INNODB => mise en place du système de stockage qui déclenche les algo du SGBD 
-- sinon les contraintes ne fonctionnent pas
DROP TABLE IF EXISTS clientclub;
DROP TABLE IF EXISTS login;
DROP TABLE IF EXISTS club;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS conseiller;

CREATE TABLE conseiller( 
	idConseiller integer PRIMARY KEY NOT NULL, 
	nom VARCHAR(255), 
	prenom VARCHAR(255) 
	)ENGINE=INNODB;
	
CREATE TABLE login (
    idLogin integer primary key not null,
    login varchar(255),
    mdp varchar(255),
    idClient integer
    ) ENGINE=INNODB;

CREATE TABLE Client (
    idClient integer PRIMARY KEY NOT NULL,
    nom varchar(255),
    prenom varchar(255),
    age integer
    ) ENGINE=INNODB;
	
CREATE TABLE club(
    idClub integer PRIMARY KEY not null,
    nom varchar(255),
    performance varchar(255),
    niveau integer,
    discriminateur varchar(255)
    ) ENGINE=INNODB;
	
create table clientclub(
    idClient integer,
    idClub integer,
    dateInscription date,
    tarif decimal(5,2)
    ) ENGINE=INNODB;
	
alter table client
	add idConseiller integer;
	
alter table client
	add CONSTRAINT fk_conseiller FOREIGN KEY (idConseiller) 
    REFERENCES Conseiller(idConseiller);
	
alter table login
	add CONSTRAINT fk_client FOREIGN KEY (idClient) 
    REFERENCES Client(idClient);
	
alter table clientclub
	add CONSTRAINT pk_clientclub PRIMARY KEY(idClient,idClub),
	ADD KEY fk_clientclub_club (idClub),
    ADD KEY fk_clientclub_client (idClient),
	add CONSTRAINT fk_clientclub_client FOREIGN KEY (idClient) 
    REFERENCES Client(idClient),
	add CONSTRAINT fk_clientclub_club FOREIGN KEY (idClub) 
    REFERENCES Club(idClub);
	
-- pour faire un leftjoin
ALTER table conseiller
	add idManager integer;
alter table conseiller
	add CONSTRAINT fk_manager FOREIGN KEY (idManager) 
    REFERENCES conseiller(idConseiller);

-- ajout index
CREATE INDEX index_nom ON client(nom);

-- ajout unique
ALTER TABLE login
	add UNIQUE(login);
	
-- ajout contrainte check
ALTER table client ADD CONSTRAINT chk_age CHECK(age >=18);
ALTER TABLE club ALTER discriminateur SET DEFAULT 'sportif';
ALTER TABLE login CHANGE idLogin idLogin INT(11) NOT NULL AUTO_INCREMENT; 

-- creation avec ajout de contrainte direct
create table conseillerSecurise(
    ID int NOT NULL PRIMARY KEY,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) DEFAULT 'toto',
    Age int,
    City varchar(255),
    CONSTRAINT CHK_Person CHECK (Age>=18),
    UNIQUE(LastName) 
  ) ENGINE=INNODB;
  
  create table clientsecurise(
     ID_cli int NOT NULL PRIMARY KEY,
     LastName varchar(255) NOT NULL,
     FirstName varchar(255),
     ID_CONS int   
)ENGINE=INNODB;

	
-- ajout du delete set null
alter table clientsecurise
	add CONSTRAINT fk_conseillersecurise FOREIGN KEY (ID_CONS) 
    REFERENCES conseillerSecurise(ID)
    ON DELETE SET null
	ON UPDATE CASCADE;
	
INSERT INTO `conseiller`(`idConseiller`, `nom`, `prenom`) VALUES (1,"ZEC","UNION");
INSERT INTO `conseiller`(`idConseiller`, `nom`, `prenom`) VALUES (2,"TOTO","TATA");
INSERT INTO `conseiller`(`idConseiller`, `nom`, `prenom`) VALUES (3,"ZEC","EDDY");
INSERT INTO `conseiller`(`idConseiller`, `nom`, `prenom`) VALUES (4,"UNION","ELISE");
INSERT INTO `conseiller`(`idConseiller`, `nom`, `prenom`) VALUES (5,"DUPONT","JIJI");
INSERT INTO `conseiller`(`idConseiller`, `nom`, `prenom`) VALUES (6,"MARCEL","BLAISE");

INSERT INTO `client`(`idClient`, `nom`, `prenom`, `age`, `idConseiller`) VALUES (1,"cons1","cons1",35,2);
INSERT INTO `client`(`idClient`, `nom`, `prenom`, `age`, `idConseiller`) VALUES (2,"cli2","cli2",25,4);
INSERT INTO `client`(`idClient`, `nom`, `prenom`, `age`, `idConseiller`) VALUES (3,"cli3","cli3",20,3);
INSERT INTO `client` (`idClient`, `nom`, `prenom`, `age`, `idConseiller`) VALUES ('4', 'sans', 'conseiller', '12', NULL); 
INSERT INTO `client` (`idClient`, `nom`, `prenom`, `age`, `idConseiller`) VALUES ('5', 'sans2', 'conseiller2', '18', NULL); 

INSERT INTO `login`(`idLogin`, `login`, `mdp`, `idClient`) VALUES (1,"login1","mdp1",1);
INSERT INTO `login`(`idLogin`, `login`, `mdp`, `idClient`) VALUES (2,"login2","mdp2",2);
INSERT INTO `login`(`idLogin`, `login`, `mdp`, `idClient`) VALUES (3,"login3","mdp3",3);

INSERT INTO `club`(`idClub`, `nom`, `performance`, `niveau`, `discriminateur`) VALUES (1,"football","très bien",null,"sportif");
INSERT INTO `club`(`idClub`, `nom`, `performance`, `niveau`, `discriminateur`) VALUES (2,"basketball","bien",null,"sportif");
INSERT INTO `club`(`idClub`, `nom`, `performance`, `niveau`, `discriminateur`) VALUES (3,"anglais",null,3,"langue");
INSERT INTO `club`(`idClub`, `nom`, `performance`, `niveau`, `discriminateur`) VALUES (4,"espagnol",null,2,"langue");

INSERT INTO `clientclub` (`idClient`, `idClub`, `dateInscription`, `tarif`) VALUES (1, 1, '2018-03-04', 25);
INSERT INTO `clientclub` (`idClient`, `idClub`, `dateInscription`, `tarif`) VALUES (1, 2, '2017-03-04', 25);
INSERT INTO `clientclub` (`idClient`, `idClub`, `dateInscription`, `tarif`) VALUES (2, 3, '2017-05-14', 15);
INSERT INTO `clientclub` (`idClient`, `idClub`, `dateInscription`, `tarif`) VALUES (3, 3, '2017-12-14', 5);
INSERT INTO `clientclub` (`idClient`, `idClub`, `dateInscription`, `tarif`) VALUES (3, 4, '2017-12-14', 35);
INSERT INTO `clientclub` (`idClient`, `idClub`, `dateInscription`, `tarif`) VALUES (3, 1, '2017-12-14', 45);

UPDATE `conseiller` SET `idManager` = '3' WHERE `conseiller`.`idConseiller` = 4;
UPDATE `conseiller` SET `idManager` = '3' WHERE `conseiller`.`idConseiller` = 6;