-- Création de la table Personne
CREATE TABLE Personne (
    NAS VARCHAR(20) PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    address_ID INT,
    CONSTRAINT fk_address_personne FOREIGN KEY (address_ID) REFERENCES Address(address_ID)
);

-- Création de la table Hotel
CREATE TABLE Hotel (
    hotel_ID INT PRIMARY KEY,
    chaine_ID INT,
    gestionnaire_ID VARCHAR(20),
    address_ID INT,
    nom_hotel VARCHAR(100) UNIQUE,
    rating FLOAT CHECK (rating BETWEEN 1 AND 5),
    tele_num INT,
    email VARCHAR(100) UNIQUE,
    chambre_num INT,
    chambre_ID INT,
    CONSTRAINT fk_chaine_hotel FOREIGN KEY (chaine_ID) REFERENCES Chaine(chaine_ID),
    CONSTRAINT fk_gestionnaire_hotel FOREIGN KEY (gestionnaire_ID) REFERENCES Employe(NAS),
    CONSTRAINT fk_address_hotel FOREIGN KEY (address_ID) REFERENCES Address(address_ID)
);

-- Création de la table Address
CREATE TABLE Address (
    address_ID INT PRIMARY KEY,
    num VARCHAR(20),
    street VARCHAR(100),
    city VARCHAR(50),
    province VARCHAR(50),
    country VARCHAR(50),
    code_post VARCHAR(10) CHECK (LENGTH(code_post) >= 5)
);

-- Création de la table Chaine
CREATE TABLE Chaine (
    chaine_ID INT PRIMARY KEY,
    nom_chaine VARCHAR(100) UNIQUE,
    email VARCHAR(100) UNIQUE,
    tele_num INT,
    hotel_ID INT,
    CONSTRAINT fk_hotel_ID FOREIGN KEY (hotel_ID) REFERENCES Hotel(hotel_ID)
);

-- Création de la table Chambre
CREATE TABLE Chambre (
    chambrel_ID INT PRIMARY KEY,
    hotel_ID INT,
    capacity INT,
    vue VARCHAR(100),
    extension VARCHAR(100),
    com_ID INT,
    problem_ID INT,
    prix INT,
    CONSTRAINT fk_hotel_chambre FOREIGN KEY (hotel_ID) REFERENCES Hotel(hotel_ID),
    CONSTRAINT fk_com_chambre FOREIGN KEY (com_ID) REFERENCES Commodite(com_ID),
    CONSTRAINT fk_problem_chambre FOREIGN KEY (problem_ID) REFERENCES Problem(ID)
);

-- Création de la table Commodite
CREATE TABLE Commodite (
    com_ID INT PRIMARY KEY,
    nom_com VARCHAR(100) UNIQUE
);

-- Création de la table Problem
CREATE TABLE Problem (
    ID INT PRIMARY KEY,
    description TEXT
);

-- Création de la table Reservation
CREATE TABLE Reservation (
    reserve_ID INT PRIMARY KEY,
    client_ID INT,
    chambre_ID INT,
    date_start DATE,
    date_end DATE,
    statut VARCHAR(100),
    paiement_statut VARCHAR(100),
    CONSTRAINT fk_client_reservation FOREIGN KEY (client_ID) REFERENCES Client(ID),
    CONSTRAINT fk_chambre_reservation FOREIGN KEY (chambre_ID) REFERENCES Chambre(chambrel_ID)
);

-- Création de la table Role
CREATE TABLE Role (
    role_ID INT PRIMARY KEY,
    nom_role VARCHAR(100) UNIQUE
);

-- Création de la table Client
CREATE TABLE Client (
    ID INT PRIMARY KEY,
    NAS VARCHAR(20) UNIQUE,
    role_ID INT,
    date_enrg DATE,
    CONSTRAINT fk_role_client FOREIGN KEY (role_ID) REFERENCES Role(role_ID),
    CONSTRAINT fk_NAS FOREIGN KEY (NAS) REFERENCES Personne(NAS)
    
);

-- Création de la table Check_in
CREATE TABLE Check_in (
    reserve_ID INT,
    employe_ID VARCHAR(20),
    CONSTRAINT fk_reserve_checkin FOREIGN KEY (reserve_ID) REFERENCES Reservation(reserve_ID),
    CONSTRAINT fk_employe_checkin FOREIGN KEY (employe_ID) REFERENCES Employe(NAS)
);

-- Création de la table Employe
CREATE TABLE Employe (
    NAS VARCHAR(20) PRIMARY KEY,
    hotel_ID INT,
    role_ID INT,
    CONSTRAINT fk_hotel_employe FOREIGN KEY (hotel_ID) REFERENCES Hotel(hotel_ID),
    CONSTRAINT fk_role_employe FOREIGN KEY (role_ID) REFERENCES Role(role_ID)
);






-- Insertion des données dans la table Adress
INSERT INTO Address (num, street, city, province, country, code_post)
VALUES ('123', 'Rue de la Paix', 'Paris', 'Île-de-France', 'France', '75001'),
       ('456', 'Main Street', 'New York', 'NY', 'USA', '10001'),
       ('789', 'Alexanderplatz', 'Berlin', NULL, 'Germany', '10178'),
       ('10', 'Maple Avenue', 'Toronto', 'Ontario', 'Canada', 'M1R 2N5'),
('20', 'Oak Street', 'Vancouver', 'British Columbia', 'Canada', 'V6B 2N2'),
('30', 'Elm Street', 'Montreal', 'Quebec', 'Canada', 'H2Y 1H1'),
('40', 'Birch Boulevard', 'Calgary', 'Alberta', 'Canada', 'T2P 2G8'),
('50', 'Cedar Road', 'Ottawa', 'Ontario', 'Canada', 'K1P 1J1'),
('60', 'Pine Street', 'Edmonton', 'Alberta', 'Canada', 'T5J 1Y2'),
('70', 'Spruce Avenue', 'Quebec City', 'Quebec', 'Canada', 'G1R 1A2'),
('80', 'Hemlock Lane', 'Winnipeg', 'Manitoba', 'Canada', 'R3C 0B6'),
('90', 'Balsam Street', 'Halifax', 'Nova Scotia', 'Canada', 'B3K 4X2'),
('100', 'Willow Street', 'Victoria', 'British Columbia', 'Canada', 'V8W 1P6'),
('110', 'Poplar Road', 'Regina', 'Saskatchewan', 'Canada', 'S4P 3Y2'),
('120', 'Sycamore Street', 'Fredericton', 'New Brunswick', 'Canada', 'E3B 1E1'),
('130', 'Juniper Lane', 'Charlottetown', 'Prince Edward Island', 'Canada', 'C1A 1A2'),
('200', 'Baker Street', 'London', NULL, 'United Kingdom', 'W1U 6TY'),
('300', 'Champs-Élysées', 'Paris', 'Île-de-France', 'France', '75008'),
('400', 'Alexanderplatz', 'Berlin', NULL, 'Germany', '10178'),
('500', 'Piazza San Marco', 'Venice', 'Veneto', 'Italy', '30124'),
('600', 'Gran Vía', 'Madrid', NULL, 'Spain', '28013'),
('700', 'Rue de la Loi', 'Brussels', NULL, 'Belgium', '1000'),
('800', 'Karl Johans gate', 'Oslo', NULL, 'Norway', '0154'),
('900', 'Kungsträdgården', 'Stockholm', NULL, 'Sweden', '111 47'),
('1000', 'Princes Street', 'Edinburgh', NULL, 'United Kingdom', 'EH2 2EQ'),
('1100', 'Syntagma Square', 'Athens', NULL, 'Greece', '105 63'),
('1200', 'Dam Square', 'Amsterdam', NULL, 'Netherlands', '1012'),
('1300', 'Karlplatz', 'Vienna', NULL, 'Austria', '1010'),
('1400', 'Andrássy út', 'Budapest', NULL, 'Hungary', '1061'),
('1500', 'Plac Zamkowy', 'Warsaw', NULL, 'Poland', '00-001'),
('1600', 'Prague Castle', 'Prague', NULL, 'Czech Republic', '119 08'),
('1700', 'Stortorget', 'Stockholm', NULL, 'Sweden', '111 29'),
('1800', 'Plaza Mayor', 'Madrid', NULL, 'Spain', '28012'),
('1900', 'Brandenburger Tor', 'Berlin', NULL, 'Germany', '10117'),
('2000', 'Tivoli Gardens', 'Copenhagen', NULL, 'Denmark', '1630'),
('2100', 'Schloss Neuschwanstein', 'Füssen', 'Bavaria', 'Germany', '87645'),
('2200', 'The Alhambra', 'Granada', 'Andalusia', 'Spain', '18009'),
('2300', 'Red Square', 'Moscow', NULL, 'Russia', '109012'),
('2400', 'The Acropolis', 'Athens', NULL, 'Greece', '105 58');


-- Insertion dans la table Commodite
INSERT INTO Commodite (nom_com)
VALUES ('WiFi'),
       ('TV'),
       ('Climatisation'),
       ('Minibar'),
       ('Service en chambre');

-- Insertion des données dans la table Chaine
INSERT INTO Chaine (nom_chaine, email, tele_num)
VALUES ('ChaineA', 'chaineA@example.com', 1234567890),
       ('ChaineB', 'chaineB@example.com', 0987654321),
       ('ChaineC', 'chaineC@example.com', 1357924680),
       ('ChaineD', 'chaineD@example.com', 2468013579),
       ('ChaineE', 'chaineE@example.com', 9876543210);


-- Insertion des données pour la Chaîne 1
INSERT INTO Chaine (nom_chaine, email, tele_num)
VALUES ('Chaine_A', 'chaine_a@example.com', 1234567890);

-- Insertion des hôtels pour la Chaîne 1
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (1, 'Gestionnaire_A', 1, 'Hotel_1A', 4.5, 1234567891, 'hotel1a@example.com', 10, 1),
       (1, 'Gestionnaire_B', 2, 'Hotel_2A', 4.2, 1234567892, 'hotel2a@example.com', 8, 2),
       (1, 'GestionnaireC', 3, 'Hôtel 3A', 4.0, 1234567893, 'hotel3A@example.com', 12, 3),
       (1, 'GestionnaireD', 4, 'Hôtel 4A', 4.7, 1234567894, 'hotel4A@example.com', 9, 4),
       (1, 'GestionnaireE', 5, 'Hôtel 5A', 4.9, 1234567895, 'hotel5A@example.com', 11, 5),
       (1, 'GestionnaireF', 6, 'Hôtel 6A', 4.3, 1234567896, 'hotel6A@example.com', 10, 6),
       (1, 'GestionnaireG', 7, 'Hôtel 7A', 4.6, 1234567897, 'hotel7A@example.com', 8, 7),
       (1, 'GestionnaireH', 8, 'Hôtel 8A', 4.8, 1234567898, 'hotel8A@example.com', 9, 8);

-- Insertion des chambres pour les hôtels de la Chaîne 1
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix)
VALUES (1, 2, 'Vue_ville', NULL, 1, 1, 100),
       (1, 4, 'Vue_mer', NULL, 2, 2, 150),
       (2, 3, 'Vue sur la montagne', NULL, 3, 3, 120),
       (2, 2, 'Vue sur le jardin', NULL, 4, 4, 110),
       (3, 1, 'Sans vue', NULL, 5, 5, 80),
       (3, 5, 'Vue panoramique', NULL, 1, 2, 200),
       (4, 4, 'Vue sur le lac', NULL, 2, 3, 140),
       (4, 3, 'Vue sur la rivière', NULL, 3, 4, 130),
       (5, 2, 'Vue sur la plage', NULL, 4, 5, 100),
       (5, 5, 'Vue sur le parc', NULL, 5, 1, 180),
       (6, 3, 'Vue sur la forêt', NULL, 1, 2, 120),
       (6, 4, 'Vue sur la piscine', NULL, 2, 3, 150),
       (7, 2, 'Vue sur le port', NULL, 3, 4, 110),
       (7, 5, 'Vue sur la montagne', NULL, 4, 5, 170),
       (8, 4, 'Vue sur le lac', NULL, 5, 1, 160),
       (8, 3, 'Vue sur la rivière', NULL, 1, 2, 130);

-- Insertion des données pour la Chaîne 2
INSERT INTO Chaine (nom_chaine, email, tele_num)
VALUES ('Chaine_B', 'chaine_b@example.com', 2345678901);

-- Insertion des hôtels pour la Chaîne 2
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (2, 'Gestionnaire_A', 9, 'Hotel_1B', 4.4, 2345678902, 'hotel1b@example.com', 10, 3),
       (2, 'Gestionnaire_B', 10, 'Hotel_2B', 4.1, 2345678903, 'hotel2b@example.com', 8, 4),
       (2, 'GestionnaireC', 11, 'Hôtel 3B', 4.6, 2345678904, 'hotel3B@example.com', 12, 11),
       (2, 'GestionnaireD', 12, 'Hôtel 4B', 4.8, 2345678905, 'hotel4B@example.com', 9, 12),
       (2, 'GestionnaireE', 13, 'Hôtel 5B', 4.3, 2345678906, 'hotel5B@example.com', 11, 13),
       (2, 'GestionnaireF', 14, 'Hôtel 6B', 4.9, 2345678907, 'hotel6B@example.com', 10, 14),
       (2, 'GestionnaireG', 15, 'Hôtel 7B', 4.7, 2345678908, 'hotel7B@example.com', 8, 15),
       (2, 'GestionnaireH', 16, 'Hôtel 8B', 4.5, 2345678909, 'hotel8B@example.com', 9, 16);

-- Insertion des chambres pour les hôtels de la Chaîne 2
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix)
VALUES (9, 2, 'Vue sur la ville', NULL, 1, 1, 100),
       (9, 4, 'Vue sur la mer', NULL, 2, 2, 150),
       (10, 3, 'Vue sur la montagne', NULL, 3, 3, 120),
       (10, 2, 'Vue sur le jardin', NULL, 4, 4, 110),
       (11, 1, 'Sans vue', NULL, 5, 5, 80),
       (11, 5, 'Vue panoramique', NULL, 1, 2, 200),
       (12, 4, 'Vue sur le lac', NULL, 2, 3, 140),
       (12, 3, 'Vue sur la rivière', NULL, 3, 4, 130),
       (13, 2, 'Vue sur la plage', NULL, 4, 5, 100),
       (13, 5, 'Vue sur le parc', NULL, 5, 1, 180),
       (14, 3, 'Vue sur la forêt', NULL, 1, 2, 120),
       (14, 4, 'Vue sur la piscine', NULL, 2, 3, 150),
       (15, 2, 'Vue sur le port', NULL, 3, 4, 110),
       (15, 5, 'Vue sur la montagne', NULL, 4, 5, 170),
       (16, 4, 'Vue sur le lac', NULL, 5, 1, 160),
       (16, 3, 'Vue sur la rivière', NULL, 1, 2, 130);

-- Insertion des données pour la Chaîne 3
INSERT INTO Chaine (nom_chaine, email, tele_num)
VALUES ('Chaine_C', 'chaine_c@example.com', 3456789012);

-- Insertion des hôtels pour la Chaîne 3
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (3, 'GestionnaireA', 17, 'Hôtel 1C', 4.2, 3456789013, 'hotel1C@example.com', 10, 17),
       (3, 'GestionnaireB', 18, 'Hôtel 2C', 4.7, 3456789014, 'hotel2C@example.com', 8, 18),
       (3, 'GestionnaireC', 19, 'Hôtel 3C', 4.4, 3456789015, 'hotel3C@example.com', 12, 19),
       (3, 'GestionnaireD', 20, 'Hôtel 4C', 4.9, 3456789016, 'hotel4C@example.com', 9, 20),
       (3, 'GestionnaireE', 21, 'Hôtel 5C', 4.3, 3456789017, 'hotel5C@example.com', 11, 21),
       (3, 'GestionnaireF', 22, 'Hôtel 6C', 4.6, 3456789018, 'hotel6C@example.com', 10, 22),
       (3, 'GestionnaireG', 23, 'Hôtel 7C', 4.8, 3456789019, 'hotel7C@example.com', 8, 23),
       (3, 'GestionnaireH', 24, 'Hôtel 8C', 4.5, 3456789020, 'hotel8C@example.com', 9, 24);

-- Insertion des chambres pour les hôtels de la Chaîne 3
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix)
VALUES (17, 2, 'Vue sur la ville', NULL, 1, 1, 100),
       (17, 4, 'Vue sur la mer', NULL, 2, 2, 150),
       (18, 3, 'Vue sur la montagne', NULL, 3, 3, 120),
       (18, 2, 'Vue sur le jardin', NULL, 4, 4, 110),
       (19, 1, 'Sans vue', NULL, 5, 5, 80),
       (19, 5, 'Vue panoramique', NULL, 1, 2, 200),
       (20, 4, 'Vue sur le lac', NULL, 2, 3, 140),
       (20, 3, 'Vue sur la rivière', NULL, 3, 4, 130),
       (21, 2, 'Vue sur la plage', NULL, 4, 5, 100),
       (21, 5, 'Vue sur le parc', NULL, 5, 1, 180),
       (22, 3, 'Vue sur la forêt', NULL, 1, 2, 120),
       (22, 4, 'Vue sur la piscine', NULL, 2, 3, 150),
       (23, 2, 'Vue sur le port', NULL, 3, 4, 110),
       (23, 5, 'Vue sur la montagne', NULL, 4, 5, 170),
       (24, 4, 'Vue sur le lac', NULL, 5, 1, 160),
       (24, 3, 'Vue sur la rivière', NULL, 1, 2, 130);

-- Insertion des données pour la Chaîne 4
INSERT INTO Chaine (nom_chaine, email, tele_num)
VALUES ('Chaine_D', 'chaine_d@example.com', 4567890123);

-- Insertion des hôtels pour la Chaîne 4
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (4, 'GestionnaireA', 25, 'Hôtel 1D', 4.6, 4567890124, 'hotel1D@example.com', 10, 25),
       (4, 'GestionnaireB', 26, 'Hôtel 2D', 4.3, 4567890125, 'hotel2D@example.com', 8, 26),
       (4, 'GestionnaireC', 27, 'Hôtel 3D', 4.8, 4567890126, 'hotel3D@example.com', 12, 27),
       (4, 'GestionnaireD', 28, 'Hôtel 4D', 4.5, 4567890127, 'hotel4D@example.com', 9, 28),
       (4, 'GestionnaireE', 29, 'Hôtel 5D', 4.9, 4567890128, 'hotel5D@example.com', 11, 29),
       (4, 'GestionnaireF', 30, 'Hôtel 6D', 4.4, 4567890129, 'hotel6D@example.com', 10, 30),
       (4, 'GestionnaireG', 31, 'Hôtel 7D', 4.7, 4567890130, 'hotel7D@example.com', 8, 31),
       (4, 'GestionnaireH', 32, 'Hôtel 8D', 4.2, 4567890131, 'hotel8D@example.com', 9, 32);

-- Insertion des chambres pour les hôtels de la Chaîne 4
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix)
VALUES(25, 2, 'Vue_ville', NULL, 1, 1, 100),
       (25, 4, 'Vue_mer', NULL, 2, 2, 150),
       (26, 3, 'Vue_montagne', NULL, 3, 3, 120),
       (26, 2, 'Vue_jardin', NULL, 4, 4, 110),
       (27, 1, 'Sans_vue', NULL, 5, 5, 80),
       (27, 5, 'Vue_panoramique', NULL, 1, 2, 200),
       (28, 4, 'Vue_lac', NULL, 2, 3, 140),
       (28, 3, 'Vue_riviere', NULL, 3, 4, 130),
       (29, 2, 'Vue_plage', NULL, 4, 5, 100),
       (29, 5, 'Vue_parc', NULL, 5, 1, 180),
       (30, 3, 'Vue_foret', NULL, 1, 2, 120),
       (30, 4, 'Vue_piscine', NULL, 2, 3, 150),
       (31, 2, 'Vue_port', NULL, 3, 4, 110),
       (31, 5, 'Vue_montagne', NULL, 4, 5, 170),
       (32, 4, 'Vue_lac', NULL, 5, 1, 160),
       (32, 3, 'Vue_riviere', NULL, 1, 2, 130);

-- Insertion des données pour la Chaîne 5
INSERT INTO Chaine (nom_chaine, email, tele_num)
VALUES ('Chaine_E', 'chaine_e@example.com', 5678901234);

-- Insertion des hôtels pour la Chaîne 5
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES(5, 'Gestionnaire_C', 11, 'Hotel_3E', 4.6, 5678901237, 'hotel3e@example.com', 12, 33),
       (5, 'Gestionnaire_D', 12, 'Hotel_4E', 4.9, 5678901238, 'hotel4e@example.com', 9, 34),
       (5, 'Gestionnaire_E', 13, 'Hotel_5E', 4.2, 5678901239, 'hotel5e@example.com', 11, 35),
       (5, 'Gestionnaire_F', 14, 'Hotel_6E', 4.7, 5678901240, 'hotel6e@example.com', 10, 36),
       (5, 'Gestionnaire_G', 15, 'Hotel_7E', 4.3, 5678901241, 'hotel7e@example.com', 8, 37),
       (5, 'Gestionnaire_H', 16, 'Hotel_8E', 4.5, 5678901242, 'hotel8e@example.com', 9, 38),
       (5, 'Gestionnaire_I', 17, 'Hotel_9E', 4.8, 5678901243, 'hotel9e@example.com', 11, 39),
       (5, 'Gestionnaire_J', 18, 'Hotel_10E', 4.4, 5678901244, 'hotel10e@example.com', 10, 40);

-- Insertion des chambres pour les hôtels de la Chaîne 5
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix)
VALUES (33, 2, 'Vue sur la ville', NULL, 1, 1, 100),
       (33, 4, 'Vue sur la mer', NULL, 2, 2, 150),
       (34, 3, 'Vue sur la montagne', NULL, 3, 3, 120),
       (34, 2, 'Vue sur le jardin', NULL, 4, 4, 110),
       (35, 1, 'Sans vue', NULL, 5, 5, 80),
       (35, 5, 'Vue panoramique', NULL, 1, 2, 200),
       (36, 4, 'Vue sur le lac', NULL, 2, 3, 140),
       (36, 3, 'Vue sur la rivière', NULL, 3, 4, 130),
       (37, 2, 'Vue sur la plage', NULL, 4, 5, 100),
       (37, 5, 'Vue sur le parc', NULL, 5, 1, 180),
       (38, 3, 'Vue sur la forêt', NULL, 1, 2, 120),
       (38, 4, 'Vue sur la piscine', NULL, 2, 3, 150),
       (39, 2, 'Vue sur le port', NULL, 3, 4, 110),
       (39, 5, 'Vue sur la montagne', NULL, 4, 5, 170),
       (40, 4, 'Vue sur le lac', NULL, 5, 1, 160),
       (40, 3, 'Vue sur la rivière', NULL, 1, 2, 130);



--INDEXES

CREATE INDEX idx_nom_hotel ON Hotel (nom_hotel);--Index sur le nom de l'hôtel dans la table Hotel pour accélérer les recherches par nom d'hôtel
CREATE INDEX idx_date_start_reservation ON Reservation (date_start);-- Index sur la date de début de la réservation dans la table Reservation pour accélérer les recherches de réservations par date.
CREATE INDEX idx_NAS_client ON Client (NAS);--Index sur le NAS dans la table Client pour accélérer les recherches de réservations par client



-- Déclencheur pour assurer l'intégrité référentielle lors de l'insertion dans la table Hotel
CREATE OR REPLACE FUNCTION check_hotel_address()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Address WHERE address_ID = NEW.address_ID) THEN
        RAISE EXCEPTION 'Address does not exist';
    END IF;
    RETURN NEW;
END;



