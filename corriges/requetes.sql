SELECT * FROM conseiller;

SELECT * FROM `conseiller` ORDER BY nom DESC;

SELECT * FROM `client` LIMIT 2;

SELECT nom,prenom FROM conseiller;

SELECT nom FROM conseiller;

SELECT DISTINCT nom FROM conseiller;

SELECT * FROM client WHERE idConseiller=2;

SELECT * FROM client WHERE idConseiller=2 || idConseiller=3;

SELECT * FROM client WHERE idConseiller BETWEEN 2 AND 3;

SELECT * FROM conseiller WHERE prenom LIKE 'E%';

SELECT * FROM conseiller WHERE prenom LIKE 'E%'
ORDER BY nom DESC;

SELECT * FROM club WHERE discriminateur='sportif';

SELECT * FROM club WHERE  niveau is null;

UPDATE client SET nom="cli1",prenom="cli1" WHERE idClient=1;

UPDATE client SET idConseiller=6 WHERE idClient=3;

DELETE from conseiller where idConseiller=1;

-- nombre total de conseiller
SELECT COUNT(*) AS NB_CONS FROM conseiller;

-- somme des cotisations de chaque client
SELECT idClient, SUM(tarif) AS TOTAL
from clientclub
GROUP BY idClient;

-- somme des cotisations de chaque club
SELECT idClub, SUM(tarif) AS COTISATIONS
from clientclub
GROUP BY idClub;

-- cotisation maximale
SELECT `idClub`, MAX(tarif) AS MAX_COTISATION
from clientclub;

-- cotisation maximale par club
SELECT `idClub`, MAX(tarif) AS MAX_COTISATION_PAR_CLUB
from clientclub
GROUP BY idClub;

-- age minimum
SELECT `idClient`,MIN(age) AS AGE_MIN
from client;

-- moyenne des cotisations
SELECT idClub, AVG(tarif) AS MOYENNE
from clientclub;
-- cotisation maximale par club > 30
SELECT `idClub`, MAX(tarif) AS MAX_COTISATION_PAR_CLUB
from clientclub
GROUP BY idClub
HAVING MAX(tarif) > 30;
-- ou
SELECT `idClub`, MAX(tarif) AS MAX_COTISATION_PAR_CLUB
from clientclub
GROUP BY idClub
HAVING MAX_COTISATION_PAR_CLUB > 30;

-- ajout having
SELECT idClient, MIN(age) as AGE_MIN
from client
where idClient BETWEEN 1 AND 2
GROUP BY idClient
HAVING AGE_MIN >=30

-- ajout order by
SELECT idClient, MIN(age) as AGE_MIN
from client
where idClient BETWEEN 1 AND 2
GROUP BY idClient
HAVING AGE_MIN >=30
ORDER BY idClient;

-- ajout LIMIT 
SELECT idClient, MIN(age) as AGE_MIN
from client
where idClient BETWEEN 1 AND 2
GROUP BY idClient
HAVING AGE_MIN >=30
ORDER BY idClient
LIMIT 1;

-- EQUI JOINTURE, INNERJOIN AVEC ON (préférable)
SELECT * FROM
conseiller INNER JOIN client
ON conseiller.idConseiller = client.idConseiller;

-- EQUI JOINTURE, INNER JOIN AVEC WHERE
SELECT * FROM
conseiller INNER JOIN client
WHERE conseiller.idConseiller = client.idConseiller;

-- LEFT JOIN RAMENE TOUS LES ELEMENTS DE LA PREMIERE TABLE DE JOINTURE
SELECT * FROM
conseiller LEFT JOIN client
ON conseiller.idConseiller = client.idConseiller;

-- RIGHT JOIN TOUS LES ELEMENTS DE LA DEUXIEME TABLE DE JOINTURE
SELECT * FROM
conseiller RIGHT JOIN client
ON conseiller.idConseiller = client.idConseiller;

-- FULL JOIN (pour mysql on utilise UNION)
SELECT * FROM
conseiller LEFT JOIN client
ON conseiller.idConseiller = client.idConseiller
UNION
SELECT * FROM
conseiller RIGHT JOIN client
ON conseiller.idConseiller = client.idConseiller;

-- SELF JOIN
SELECT * FROM
conseiller as cons1
INNER JOIN
conseiller as cons2
ON cons1.idConseiller = cons2.idManager;

-- JOINTURES 
SELECT client.nom as NOM, 
	   client.prenom AS PRENOM, 
       club.nom AS CLUB ,
       clientclub.dateInscription AS dateInscription
	FROM client
    	INNER JOIN clientclub ON client.idClient=clientclub.idClient
        INNER JOIN club ON clientclub.idClub=club.idClub
-- autres JOINTURES		
select client.nom as nom, 
		client.prenom as prenom,
        conseiller.nom as conseiller,
        login.login as login
        FROM conseiller
        	INNER JOIN client ON conseiller.idConseiller = client.idConseiller
            INNER JOIN login ON login.idClient = client.idClient
			