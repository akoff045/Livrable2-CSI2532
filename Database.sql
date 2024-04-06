-- Création de la table Address
CREATE TABLE Address (
    address_ID SERIAL PRIMARY KEY,
    num VARCHAR(20),
    street VARCHAR(100),
    city VARCHAR(50),
    province VARCHAR(50),
    country VARCHAR(50),
    code_post VARCHAR(10) CHECK (LENGTH(code_post) >= 4)
);

-- Création de la table Personne
CREATE TABLE Personne (
    NAS VARCHAR(20) PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    address_ID INT,
    CONSTRAINT fk_address_personne FOREIGN KEY (address_ID) REFERENCES Address(address_ID)
);

-- Création de la table Chaine
CREATE TABLE Chaine (
    chaine_ID SERIAL PRIMARY KEY,
    nom_chaine VARCHAR(100) UNIQUE,
    email VARCHAR(100) UNIQUE,
    tele_num BIGINT,
    hotel_ID INT
);

-- Création de la table Hotel
CREATE TABLE Hotel (
    hotel_ID SERIAL PRIMARY KEY,
    chaine_ID INT,
    gestionnaire_ID VARCHAR(20),
    address_ID INT,
    nom_hotel VARCHAR(100) UNIQUE,
    rating FLOAT CHECK (rating BETWEEN 1 AND 5),
    tele_num BIGINT,
    email VARCHAR(100) UNIQUE,
    chambre_num INT,
    chambre_ID INT,
    CONSTRAINT fk_chaine_hotel FOREIGN KEY (chaine_ID) REFERENCES Chaine(chaine_ID),
    CONSTRAINT fk_address_hotel FOREIGN KEY (address_ID) REFERENCES Address(address_ID)
);

ALTER TABLE Chaine ADD CONSTRAINT fk_hotel_ID FOREIGN KEY (hotel_ID) REFERENCES Hotel(hotel_ID);

-- Création de la table Role
CREATE TABLE Role (
    role_ID INT PRIMARY KEY,
    nom_role VARCHAR(100) UNIQUE
);

-- Création de la table Employe
CREATE TABLE Employe (
    NAS VARCHAR(20) PRIMARY KEY,
    hotel_ID INT,
    role_ID INT,
    username VARCHAR(20) UNIQUE,
    password VARCHAR,
    CONSTRAINT fk_hotel_employe FOREIGN KEY (hotel_ID) REFERENCES Hotel(hotel_ID),
    CONSTRAINT fk_role_employe FOREIGN KEY (role_ID) REFERENCES Role(role_ID)
);


-- Création de la table Commodite
CREATE TABLE Commodite (
    com_ID SERIAL PRIMARY KEY,
    nom_com VARCHAR(100) UNIQUE
);

-- Création de la table Problem
CREATE TABLE Problem (
    ID INT PRIMARY KEY,
    description TEXT
);

-- Création de la table Chambre
CREATE TABLE Chambre (
    chambrel_ID SERIAL PRIMARY KEY,
    hotel_ID INT,
    capacity INT,
    vue VARCHAR(100),
    extension VARCHAR(100),
    com_ID INT,
    problem_ID INT,
    prix INT,
    superficie INT,
    CONSTRAINT fk_hotel_chambre FOREIGN KEY (hotel_ID) REFERENCES Hotel(hotel_ID),
    CONSTRAINT fk_com_chambre FOREIGN KEY (com_ID) REFERENCES Commodite(com_ID),
    CONSTRAINT fk_problem_chambre FOREIGN KEY (problem_ID) REFERENCES Problem(ID)
);

-- Création de la table Client
CREATE TABLE Client (
    ID SERIAL PRIMARY KEY,
    NAS VARCHAR(20) UNIQUE,
    username VARCHAR(20) UNIQUE,
    password VARCHAR,
    date_enrg DATE,
    CONSTRAINT fk_NAS FOREIGN KEY (NAS) REFERENCES Personne(NAS)
    
);

-- Création de la table Reservation
CREATE TABLE Reservation (
    reserve_ID SERIAL PRIMARY KEY,
    client_ID INT,
    chambre_ID INT,
    date_start DATE,
    date_end DATE,
    statut VARCHAR(100),
    paiement_statut VARCHAR(100),
    CONSTRAINT fk_client_reservation FOREIGN KEY (client_ID) REFERENCES Client(ID),
    CONSTRAINT fk_chambre_reservation FOREIGN KEY (chambre_ID) REFERENCES Chambre(chambrel_ID)
);

-- Création de la table Check_in
CREATE TABLE Check_in (
    reserve_ID INT,
    employe_ID VARCHAR(20),
    CONSTRAINT fk_reserve_checkin FOREIGN KEY (reserve_ID) REFERENCES Reservation(reserve_ID),
    CONSTRAINT fk_employe_checkin FOREIGN KEY (employe_ID) REFERENCES Employe(NAS)
);

-- Trigger pour code postal en Address
CREATE OR REPLACE FUNCTION validate_postal_code()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.code_post IS NOT NULL AND LENGTH(NEW.code_post) < 4 THEN
        RAISE EXCEPTION 'Postal code must be at least 4 characters long';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER address_code_post_trigger
BEFORE INSERT OR UPDATE ON Address
FOR EACH ROW
EXECUTE FUNCTION validate_postal_code();

-- Trigger pour rating en Hotel
CREATE OR REPLACE FUNCTION validate_hotel_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rating IS NOT NULL AND (NEW.rating < 1 OR NEW.rating > 5) THEN
        RAISE EXCEPTION 'Rating must be between 1 and 5';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER hotel_rating_trigger
BEFORE INSERT OR UPDATE ON Hotel
FOR EACH ROW
EXECUTE FUNCTION validate_hotel_rating();

-- Trigger pour NAS en Personne
CREATE OR REPLACE FUNCTION validate_nas_format()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.NAS IS NOT NULL AND NOT NEW.NAS ~ '^\d{9}$' THEN
        RAISE EXCEPTION 'Invalid NAS format';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER personne_nas_trigger
BEFORE INSERT OR UPDATE ON Personne
FOR EACH ROW
EXECUTE FUNCTION validate_nas_format();

-- Trigger pour email en Chaine
CREATE OR REPLACE FUNCTION validate_email_format() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Adresse e-mail invalide: %', NEW.email;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chaine_validate_email_format
BEFORE INSERT OR UPDATE ON Chaine
FOR EACH ROW EXECUTE FUNCTION validate_email_format();


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
('2400', 'The Acropolis', 'Athens', NULL, 'Greece', '105 58'),
('123', 'Rue de la République', 'Paris', 'Île-de-France', 'France', '75001'),
('456', 'Main Street', 'New York', 'New York', 'USA', '10001'),
('789', 'Unter den Linden', 'Berlin', 'Berlin', 'Germany', '10117'),
('101', 'Rue Sainte-Catherine', 'Montreal', 'Quebec', 'Canada', 'H2X 1L4'),
('202', 'Baker Street', 'London', 'England', 'United Kingdom', 'W1U 6TJ'),
('303', 'Via Roma', 'Rome', 'Lazio', 'Italy', '00100'),
('404', 'Calle Mayor', 'Madrid', 'Community of Madrid', 'Spain', '28013'),
('505', 'Rue Neuve', 'Brussels', 'Brussels Capital Region', 'Belgium', '1000'),
('606', 'Karl Johans gate', 'Oslo', 'Oslo', 'Norway', '0154'),
('707', 'Drottninggatan', 'Stockholm', 'Stockholm', 'Sweden', '111 51'),
('808', 'Leoforos Vouliagmenis', 'Athens', 'Attica', 'Greece', '117 41'),
('909', 'Dam Square', 'Amsterdam', 'North Holland', 'Netherlands', '1012'),
('111', 'Stephansplatz', 'Vienna', 'Vienna', 'Austria', '1010'),
('222', 'Váci utca', 'Budapest', 'Central Hungary', 'Hungary', '1052'),
('333', 'Krakowskie Przedmieście', 'Warsaw', 'Masovian Voivodeship', 'Poland', '00-071'),
('444', 'Wenceslas Square', 'Prague', 'Prague', 'Czech Republic', '110 00'),
('555', 'Strøget', 'Copenhagen', 'Capital Region of Denmark', 'Denmark', '1200'),
('666', 'Nevsky Prospect', 'St. Petersburg', 'St. Petersburg', 'Russia', '191186'),
('777', 'Champs-Élysées', 'Paris', 'Île-de-France', 'France', '75008'),
('888', 'Broadway', 'New York', 'New York', 'USA', '10007'),
('999', 'Kurfürstendamm', 'Berlin', 'Berlin', 'Germany', '10719'),
('1010', 'St. Catherine Street', 'Montreal', 'Quebec', 'Canada', 'H3B 1A6'),
('1111', 'Oxford Street', 'London', 'England', 'United Kingdom', 'W1D 1AH'),
('1212', 'Via del Corso', 'Rome', 'Lazio', 'Italy', '00186'),
('1313', 'Gran Vía', 'Madrid', 'Community of Madrid', 'Spain', '28013'),
('1414', 'Avenue Louise', 'Brussels', 'Brussels Capital Region', 'Belgium', '1050'),
('1515', 'Karl Johans gate', 'Oslo', 'Oslo', 'Norway', '0154'),
('1616', 'Drottninggatan', 'Stockholm', 'Stockholm', 'Sweden', '111 51'),
('1717', 'Leoforos Vouliagmenis', 'Athens', 'Attica', 'Greece', '117 41'),
('1818', 'Dam Square', 'Amsterdam', 'North Holland', 'Netherlands', '1012'),
('1919', 'Stephansplatz', 'Vienna', 'Vienna', 'Austria', '1010'),
('2020', 'Váci utca', 'Budapest', 'Central Hungary', 'Hungary', '1052'),
('2121', 'Krakowskie Przedmieście', 'Warsaw', 'Masovian Voivodeship', 'Poland', '00-071'),
('2222', 'Wenceslas Square', 'Prague', 'Prague', 'Czech Republic', '110 00'),
('2323', 'Strøget', 'Copenhagen', 'Capital Region of Denmark', 'Denmark', '1200'),
('2424', 'Nevsky Prospect', 'St. Petersburg', 'St. Petersburg', 'Russia', '191186'),
('2525', 'Champs-Élysées', 'Paris', 'Île-de-France', 'France', '75008'),
('2626', 'Broadway', 'New York', 'New York', 'USA', '10007'),
('2727', 'Kurfürstendamm', 'Berlin', 'Berlin', 'Germany', '10719'),
('2828', 'St. Catherine Street', 'Montreal', 'Quebec', 'Canada', 'H3B 1A6'),
('2929', 'Oxford Street', 'London', 'England', 'United Kingdom', 'W1D 1AH'),
('3030', 'Via del Corso', 'Rome', 'Lazio', 'Italy', '00186'),
('3131', 'Gran Vía', 'Madrid', 'Community of Madrid', 'Spain', '28013'),
('3232', 'Avenue Louise', 'Brussels', 'Brussels Capital Region', 'Belgium', '1050'),
('3333', 'Karl Johans gate', 'Oslo', 'Oslo', 'Norway', '0154'),
('3434', 'Drottninggatan', 'Stockholm', 'Stockholm', 'Sweden', '111 51'),
('3535', 'Leoforos Vouliagmenis', 'Athens', 'Attica', 'Greece', '117 41'),
('3636', 'Dam Square', 'Amsterdam', 'North Holland', 'Netherlands', '1012'),
('1000', 'La Rambla', 'Barcelona', 'Catalonia', 'Spain', '08002'),
('1001', 'Via Condotti', 'Rome', 'Lazio', 'Italy', '00187'),
('1002', 'Boulevard Saint-Germain', 'Paris', 'Île-de-France', 'France', '75005');

-- Insertion des données dans la table Personne
INSERT INTO Personne (NAS, nom, prenom, address_ID)
VALUES
    ('123456789', 'Doe', 'John', 1),
    ('987654321', 'Smith', 'Alice', 2),
    ('456789123', 'Johnson', 'Michael', 3),
    ('654321987', 'Brown', 'Emily', 4),
    ('789123456', 'Davis', 'James', 5),
    ('321987654', 'Wilson', 'Emma', 6),
    ('111111111', 'Martinez', 'David', 7),
    ('222222222', 'Anderson', 'Olivia', 8),
    ('333333333', 'Taylor', 'Daniel', 9),
    ('444444444', 'Thomas', 'Sophia', 10),
    ('555555555', 'Roberts', 'Matthew', 11),
    ('666666666', 'Jackson', 'Ava', 12),
    ('777777777', 'White', 'Logan', 13),
    ('888888888', 'Harris', 'Chloe', 14),
    ('999999999', 'Martin', 'Ethan', 15),
    ('000000000', 'Thompson', 'Isabella', 16),
    ('121212121', 'Garcia', 'Mia', 17),
    ('232323232', 'Lopez', 'Benjamin', 18),
    ('343434343', 'Lee', 'Amelia', 19),
    ('454545454', 'Walker', 'Liam', 20),
    ('565656565', 'Hall', 'Harper', 21),
    ('676767676', 'Young', 'Evelyn', 22),
    ('787878787', 'Allen', 'Alexander', 23),
    ('898989898', 'Wright', 'Abigail', 24),
    ('010101010', 'King', 'Elijah', 25),
    ('111111112', 'Green', 'Elizabeth', 26),
    ('222222223', 'Baker', 'David', 27),
    ('333333334', 'Adams', 'Victoria', 28),
    ('444444445', 'Nelson', 'Henry', 29),
    ('555555556', 'Hill', 'Grace', 30),
    ('666666667', 'Parker', 'Samuel', 31),
    ('777777778', 'Evans', 'Natalie', 32),
    ('888888889', 'Edwards', 'Christopher', 33),
    ('999999990', 'Collins', 'Addison', 34),
    ('000000001', 'Stewart', 'Lily', 35),
    ('121212122', 'Sanchez', 'Andrew', 36),
    ('232323233', 'Morris', 'Madison', 37),
    ('343434344', 'Rogers', 'David', 38),
    ('454545455', 'Reed', 'Zoe', 39),
    ('565656566', 'Cook', 'Joseph', 40),
    ('676767677', 'Morgan', 'Nora', 41),
    ('787878788', 'Bell', 'Gabriel', 42),
    ('898989899', 'Murphy', 'Samantha', 43),
    ('010101012', 'Bailey', 'Eva', 44),
    ('111111113', 'Rivera', 'Jackson', 45),
    ('222222224', 'Cooper', 'Avery', 46),
    ('333333335', 'Richardson', 'Sophie', 47),
    ('444444446', 'Long', 'Lucas', 48),
    ('555555557', 'Scott', 'Scarlett', 49),
    ('666666668', 'Kelly', 'Jason', 50);
	
INSERT INTO Role (role_id, nom_role)
VALUES (1, 'gestionnaire');

-- Insertion dans la table Commodite
INSERT INTO Commodite (nom_com)
VALUES ('WiFi'),
       ('TV'),
       ('Climatisation'),
       ('Minibar'),
       ('Service en chambre');
	   
-- Insertion dans la table Problem
INSERT INTO Problem (id, description)
VALUES (1, 'unreliable wifi'),
       (2, 'temperature is cold'),
       (3, 'temperature is warm'),
       (4, 'leaky faucet'),
       (5, 'dim lights');

-- Insertion des données dans la table Chaine
INSERT INTO Chaine (nom_chaine, email, tele_num)
VALUES ('ChaineA', 'chaineA@example.com', 1234567890),
       ('ChaineB', 'chaineB@example.com', 0987654321),
       ('ChaineC', 'chaineC@example.com', 1357924680),
       ('ChaineD', 'chaineD@example.com', 2468013579),
       ('ChaineE', 'chaineE@example.com', 9876543210);


-- Insertion des hôtels pour la Chaîne 1
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (1, '123456789', 51, 'Hotel_1A', 4.5, 1234567891, 'hotel1a@example.com', 10, 1),
       (1, '987654321', 52, 'Hotel_2A', 4.2, 1234567892, 'hotel2a@example.com', 8, 2),
       (1, '456789123', 53, 'Hôtel 3A', 4.0, 1234567893, 'hotel3A@example.com', 12, 3),
       (1, '654321987', 54, 'Hôtel 4A', 4.7, 1234567894, 'hotel4A@example.com', 9, 4),
       (1, '789123456', 55, 'Hôtel 5A', 4.9, 1234567895, 'hotel5A@example.com', 11, 5),
       (1, '321987654', 56, 'Hôtel 6A', 4.3, 1234567896, 'hotel6A@example.com', 10, 6),
       (1, '111111111', 57, 'Hôtel 7A', 4.6, 1234567897, 'hotel7A@example.com', 8, 7),
       (1, '222222222', 58, 'Hôtel 8A', 4.8, 1234567898, 'hotel8A@example.com', 9, 8);

-- Insertion des chambres pour les hôtels de la Chaîne 1
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix, superficie)
VALUES (1, 2, 'Vue_ville', NULL, 1, 1, 100, 20),
       (1, 4, 'Vue_mer', NULL, 2, 2, 150, 30),
       (2, 3, 'Vue sur la montagne', NULL, 3, 3, 120, 25),
       (2, 5, 'Vue sur le jardin', NULL, 4, 4, 110, 28),
       (3, 1, 'Sans vue', NULL, 5, 5, 80, 15),
       (3, 8, 'Vue panoramique', NULL, 1, 2, 200, 35);

-- Insertion des hôtels pour la Chaîne 2
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (2, '333333333', 59, 'Hotel_1B', 4.4, 2345678902, 'hotel1b@example.com', 10, 3),
       (2, '444444444', 60, 'Hotel_2B', 4.1, 2345678903, 'hotel2b@example.com', 8, 4),
       (2, '555555555', 61, 'Hôtel 3B', 4.6, 2345678904, 'hotel3B@example.com', 12, 11),
       (2, '666666666', 62, 'Hôtel 4B', 4.8, 2345678905, 'hotel4B@example.com', 9, 12),
       (2, '777777777', 63, 'Hôtel 5B', 4.3, 2345678906, 'hotel5B@example.com', 11, 13),
       (2, '888888888', 64, 'Hôtel 6B', 4.9, 2345678907, 'hotel6B@example.com', 10, 14),
       (2, '999999999', 65, 'Hôtel 7B', 4.7, 2345678908, 'hotel7B@example.com', 8, 15),
       (2, '000000000', 66, 'Hôtel 8B', 4.5, 2345678909, 'hotel8B@example.com', 9, 16);

-- Insertion des chambres pour les hôtels de la Chaîne 2
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix, superficie)
VALUES (9, 2, 'Vue sur la ville', NULL, 1, 1, 100, 22),
       (9, 4, 'Vue sur la mer', NULL, 2, 2, 150, 32),
       (10, 3, 'Vue sur la montagne', NULL, 3, 3, 120, 27),
       (10, 2, 'Vue sur le jardin', NULL, 4, 4, 110, 26),
       (11, 1, 'Sans vue', NULL, 5, 5, 80, 18),
       (11, 5, 'Vue panoramique', NULL, 1, 2, 200, 36),
       (12, 4, 'Vue sur le lac', NULL, 2, 3, 140, 31),
       (12, 3, 'Vue sur la rivière', NULL, 3, 4, 130, 29),
       (13, 2, 'Vue sur la plage', NULL, 4, 5, 100, 24),
       (13, 5, 'Vue sur le parc', NULL, 5, 1, 180, 33),
       (14, 3, 'Vue sur la forêt', NULL, 1, 2, 120, 28),
       (14, 4, 'Vue sur la piscine', NULL, 2, 3, 150, 30),
       (15, 2, 'Vue sur le port', NULL, 3, 4, 110, 25),
       (15, 5, 'Vue sur la montagne', NULL, 4, 5, 170, 34),
       (16, 4, 'Vue sur le lac', NULL, 5, 1, 160, 32),
       (16, 3, 'Vue sur la rivière', NULL, 1, 2, 130, 29);

-- Insertion des hôtels pour la Chaîne 3
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (3, '121212121', 67, 'Hôtel 1C', 4.2, 3456789013, 'hotel1C@example.com', 10, 17),
       (3, '232323232', 68, 'Hôtel 2C', 4.7, 3456789014, 'hotel2C@example.com', 8, 18),
       (3, '343434343', 69, 'Hôtel 3C', 4.4, 3456789015, 'hotel3C@example.com', 12, 19),
       (3, '454545454', 70, 'Hôtel 4C', 4.9, 3456789016, 'hotel4C@example.com', 9, 20),
       (3, '565656565', 71, 'Hôtel 5C', 4.3, 3456789017, 'hotel5C@example.com', 11, 21),
       (3, '676767676', 72, 'Hôtel 6C', 4.6, 3456789018, 'hotel6C@example.com', 10, 22),
       (3, '787878787', 73, 'Hôtel 7C', 4.8, 3456789019, 'hotel7C@example.com', 8, 23),
       (3, '898989898', 74, 'Hôtel 8C', 4.5, 3456789020, 'hotel8C@example.com', 9, 24);

-- Insertion des chambres pour les hôtels de la Chaîne 3
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix, superficie)
VALUES (17, 2, 'Vue sur la ville', NULL, 1, 1, 100, 22),
       (17, 3, 'Vue sur la mer', NULL, 2, 2, 150, 32),
       (18, 4, 'Vue sur la montagne', NULL, 3, 3, 120, 27),
       (18, 5, 'Vue sur le jardin', NULL, 4, 4, 110, 26),
       (19, 10, 'Sans vue', NULL, 5, 5, 80, 18);


-- Insertion des hôtels pour la Chaîne 4
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES (4, '010101010', 75, 'Hôtel 1D', 4.6, 4567890124, 'hotel1D@example.com', 10, 25),
       (4, '111111112', 76, 'Hôtel 2D', 4.3, 4567890125, 'hotel2D@example.com', 8, 26),
       (4, '222222223', 77, 'Hôtel 3D', 4.8, 4567890126, 'hotel3D@example.com', 12, 27),
       (4, '333333334', 78, 'Hôtel 4D', 4.5, 4567890127, 'hotel4D@example.com', 9, 28),
       (4, '444444445', 79, 'Hôtel 5D', 4.9, 4567890128, 'hotel5D@example.com', 11, 29),
       (4, '555555556', 80, 'Hôtel 6D', 4.4, 4567890129, 'hotel6D@example.com', 10, 30),
       (4, '666666667', 81, 'Hôtel 7D', 4.7, 4567890130, 'hotel7D@example.com', 8, 31),
       (4, '777777778', 82, 'Hôtel 8D', 4.2, 4567890131, 'hotel8D@example.com', 9, 32);

-- Insertion des chambres pour les hôtels de la Chaîne 4
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix, superficie)
VALUES (25, 2, 'Vue_ville', NULL, 1, 1, 100, 20),
       (25, 4, 'Vue_mer', NULL, 2, 2, 150, 30),
       (26, 6, 'Vue_montagne', NULL, 3, 3, 120, 29),
       (26, 1, 'Vue_jardin', NULL, 4, 4, 110, 28),
       (27, 5, 'Sans_vue', NULL, 5, 5, 80, 15);

-- Insertion des hôtels pour la Chaîne 5
INSERT INTO Hotel (chaine_ID, gestionnaire_ID, address_ID, nom_hotel, rating, tele_num, email, chambre_num, chambre_ID)
VALUES(5, '888888889', 83, 'Hotel_3E', 4.6, 5678901237, 'hotel3e@example.com', 12, 33),
       (5, '999999990', 84, 'Hotel_4E', 4.9, 5678901238, 'hotel4e@example.com', 9, 34),
       (5, '000000001', 85, 'Hotel_5E', 4.2, 5678901239, 'hotel5e@example.com', 11, 35),
       (5, '121212122', 86, 'Hotel_6E', 4.7, 5678901240, 'hotel6e@example.com', 10, 36),
       (5, '232323233', 87, 'Hotel_7E', 4.3, 5678901241, 'hotel7e@example.com', 8, 37),
       (5, '343434344', 88, 'Hotel_8E', 4.5, 5678901242, 'hotel8e@example.com', 9, 38),
       (5, '454545455', 89, 'Hotel_9E', 4.8, 5678901243, 'hotel9e@example.com', 11, 39),
       (5, '565656566', 90, 'Hotel_10E', 4.4, 5678901244, 'hotel10e@example.com', 10, 40);

-- Insertion des chambres pour les hôtels de la Chaîne 5
INSERT INTO Chambre (hotel_ID, capacity, vue, extension, com_ID, problem_ID, prix, superficie)
VALUES (33, 2, 'Vue sur la ville', NULL, 1, 1, 100, 22),
       (33, 1, 'Vue sur la mer', NULL, 2, 2, 150, 32),
       (34, 3, 'Vue sur la montagne', NULL, 3, 3, 120, 27),
       (34, 4, 'Vue sur le jardin', NULL, 4, 4, 110, 26),
       (35, 10, 'Sans vue', NULL, 5, 5, 80, 18),
       (35, 6, 'Vue panoramique', NULL, 1, 2, 200, 35);
       

INSERT INTO
    employe (NAS, role_id, hotel_id)
VALUES
    ('123456789', 1, 1),
    ('987654321', 1, 2),
    ('456789123', 1, 3),
    ('654321987', 1, 4),
    ('789123456', 1, 5),
    ('321987654', 1, 6),
    ('111111111', 1, 7),
    ('222222222', 1, 8),
    ('333333333', 1, 9),
    ('444444444', 1, 10),
    ('555555555', 1, 11),
    ('666666666', 1, 12),
    ('777777777', 1, 13),
    ('888888888', 1, 14),
    ('999999999', 1, 15),
    ('000000000', 1, 16),
    ('121212121', 1, 17),
    ('232323232', 1, 18),
    ('343434343', 1, 19),
    ('454545454', 1, 20),
    ('565656565', 1, 21),
    ('676767676', 1, 22),
    ('787878787', 1, 23),
    ('898989898', 1, 24),
    ('010101010', 1, 25),
    ('111111112', 1, 26),
    ('222222223', 1, 27),
    ('333333334', 1, 28),
    ('444444445', 1, 29),
    ('555555556', 1, 30),
    ('666666667', 1, 31),
    ('777777778', 1, 32),
    ('888888889', 1, 33),
    ('999999990', 1, 34),
    ('000000001', 1, 35),
    ('121212122', 1, 36),
    ('232323233', 1, 37),
    ('343434344', 1, 38),
    ('454545455', 1, 39),
    ('565656566', 1, 40),
    ('676767677', 1, NULL),
    ('787878788', 1, NULL),
    ('898989899', 1, NULL),
    ('010101012', 1, NULL),
    ('111111113', 1, NULL),
    ('222222224', 1, NULL),
    ('333333335', 1, NULL),
    ('444444446', 1, NULL),
    ('555555557', 1, NULL),
    ('666666668', 1, NULL);

ALTER TABLE Hotel ADD CONSTRAINT fk_gestionnaire_hotel FOREIGN KEY (gestionnaire_ID) REFERENCES Employe(NAS);



--INDEXES

CREATE INDEX idx_nom_hotel ON Hotel (nom_hotel);--Index sur le nom de l'hôtel dans la table Hotel pour accélérer les recherches par nom d'hôtel
CREATE INDEX idx_date_start_reservation ON Reservation (date_start);-- Index sur la date de début de la réservation dans la table Reservation pour accélérer les recherches de réservations par date.
CREATE INDEX idx_NAS_client ON Client (NAS);--Index sur le NAS dans la table Client pour accélérer les recherches de réservations par client


-- REQUÊTES


-- Création de la vue pour les chambres disponibles
CREATE VIEW Chambres_Disponibles AS 
SELECT 
    c.chambrel_ID,
    h.nom_hotel,
    c.capacity,
    c.prix
FROM 
    Chambre c
JOIN 
    Hotel h ON c.hotel_ID = h.hotel_ID
LEFT JOIN 
    Reservation r ON c.chambrel_ID = r.chambre_ID
WHERE 
    r.reserve_ID IS NULL;

-- Création de la vue pour les gestionnaires
CREATE VIEW gestionnaire_view AS
SELECT Hotel.hotel_ID, Hotel.nom_hotel, Personne.nom, Personne.prenom
FROM Hotel
JOIN Employe ON Hotel.hotel_ID = Employe.hotel_ID
JOIN Personne ON Employe.NAS = Personne.NAS
WHERE Employe.role_ID = 1;

-- Création de la vue pour le personnel de réception
CREATE VIEW reception_view AS
SELECT Chambre.chambrel_ID, Chambre.vue, Chambre.prix, Hotel.nom_hotel
FROM Chambre
JOIN Hotel ON Chambre.hotel_ID = Hotel.hotel_ID;

-- Création de la vue pour les clients
CREATE VIEW client_view AS
SELECT Reservation.reserve_ID, Client.username, Hotel.nom_hotel, Chambre.vue, Reservation.date_start, Reservation.date_end, Reservation.statut
FROM Reservation
JOIN Client ON Reservation.client_ID = Client.ID
JOIN Chambre ON Reservation.chambre_ID = Chambre.chambrel_ID
JOIN Hotel ON Chambre.hotel_ID = Hotel.hotel_ID;







