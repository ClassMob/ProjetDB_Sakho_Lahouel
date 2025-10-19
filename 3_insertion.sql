USE perpleksitydb;

-- SQL Script for impactdb data generation (MySQL/perpleksitydb)
-- Date: 2025-10-19
-- Total tables: 24

-- Initialize row number for sequence generation workaround
SET @ROW_NUMBER = 0;

-- A helper table/view to generate a sequence of 210 rows (200 + some margin)
-- This is a standard MySQL workaround for the lack of GENERATE_SERIES.
DROP TEMPORARY TABLE IF EXISTS temp_series;
CREATE TEMPORARY TABLE temp_series (ROW_NUMBER INT);
INSERT INTO temp_series (ROW_NUMBER)
SELECT @ROW_NUMBER := @ROW_NUMBER + 1
FROM information_schema.tables AS t1, information_schema.tables AS t2
LIMIT 210;

-- Reset @ROW_NUMBER for subsequent sequential operations
SET @ROW_NUMBER = 0;

-- =================================================================================
-- 1. STATIC/LOOKUP DATA: COUNTRY, POSTAL_CODE, COMM_PREFERENCE_TYPE, BRAND, CATEGORY, DISCOUNT_CODE
-- =================================================================================

-- -------------------------------------------
-- TABLE: country (15 entries)
-- -------------------------------------------
INSERT INTO country (country_id, country_name) VALUES
(1, 'France'),
(2, 'Germany'),
(3, 'Spain'),
(4, 'Italy'),
(5, 'United Kingdom'),
(6, 'United States'),
(7, 'Japan'),
(8, 'Canada'),
(9, 'Australia'),
(10, 'Brazil'),
(11, 'Mexico'),
(12, 'South Korea'),
(13, 'China'),
(14, 'India'),
(15, 'Netherlands');

-- -------------------------------------------
-- TABLE: postal_code (60 entries)
-- -------------------------------------------
INSERT INTO postal_code (postal_code_id, postal_code, city, country_id) VALUES
-- France (ID 1)
(101, '75001', 'Paris', 1),
(102, '69007', 'Lyon', 1),
(103, '13008', 'Marseille', 1),
(104, '33000', 'Bordeaux', 1),
(105, '59000', 'Lille', 1),
(106, '31000', 'Toulouse', 1),

-- Germany (ID 2)
(201, '10115', 'Berlin', 2),
(202, '80331', 'Munich', 2),
(203, '20095', 'Hamburg', 2),
(204, '50667', 'Cologne', 2),
(205, '60311', 'Frankfurt', 2),
(206, '70173', 'Stuttgart', 2),

-- Spain (ID 3)
(301, '28001', 'Madrid', 3),
(302, '08001', 'Barcelona', 3),
(303, '41001', 'Seville', 3),
(304, '46001', 'Valencia', 3),

-- Italy (ID 4)
(401, '00100', 'Rome', 4),
(402, '20121', 'Milan', 4),
(403, '80121', 'Naples', 4),
(404, '50122', 'Florence', 4),

-- United Kingdom (ID 5)
(501, 'SW1A 0AA', 'London', 5),
(502, 'M1 1RG', 'Manchester', 5),
(503, 'EH1 1RE', 'Edinburgh', 5),
(504, 'CF10 1EP', 'Cardiff', 5),

-- United States (ID 6)
(601, '10001', 'New York', 6),
(602, '90001', 'Los Angeles', 6),
(603, '60601', 'Chicago', 6),
(604, '33101', 'Miami', 6),

-- Japan (ID 7)
(701, '100-0001', 'Tokyo', 7),
(702, '530-0001', 'Osaka', 7),
(703, '600-8000', 'Kyoto', 7),
(704, '220-0001', 'Yokohama', 7),

-- Canada (ID 8)
(801, 'H3A 2T6', 'Montreal', 8),
(802, 'M5J 2N8', 'Toronto', 8),
(803, 'V6C 3L8', 'Vancouver', 8),

-- Australia (ID 9)
(901, '2000', 'Sydney', 9),
(902, '3000', 'Melbourne', 9),
(903, '6000', 'Perth', 9),

-- Brazil (ID 10)
(1001, '20040-030', 'Rio de Janeiro', 10),
(1002, '01000-000', 'São Paulo', 10),

-- Mexico (ID 11)
(1101, '06000', 'Mexico City', 11),
(1102, '44100', 'Guadalajara', 11),

-- South Korea (ID 12)
(1201, '04524', 'Seoul', 12),
(1202, '48058', 'Busan', 12),

-- China (ID 13)
(1301, '100000', 'Beijing', 13),
(1302, '200000', 'Shanghai', 13),

-- India (ID 14)
(1401, '110001', 'New Delhi', 14),
(1402, '400001', 'Mumbai', 14),

-- Netherlands (ID 15)
(1501, '1012', 'Amsterdam', 15),
(1502, '3011', 'Rotterdam', 15);


-- -------------------------------------------
-- TABLE: comm_preference_type (4 entries)
-- -------------------------------------------
INSERT INTO comm_preference_type (type_id, label, description) VALUES
(1, 'Email Marketing', 'Promotional and sales emails'),
(2, 'SMS Alerts', 'Urgent order/shipping updates via text message'),
(3, 'Push Notifications', 'In-app notifications for new products and flash sales'),
(4, 'Physical Mail', 'Catalogue or postal mail offers');


-- -------------------------------------------
-- TABLE: brand (20 entries)
-- -------------------------------------------
INSERT INTO brand (brand_id, name) VALUES
(1, 'Adibas'),
(2, 'Nikéa'),
(3, 'Guccii'),
(4, 'Loui Vuittonne'),
(5, 'Cocacolaine'),
(6, 'Microsooft'),
(7, 'Appel'),
(8, 'Sunsung'),
(9, 'ManaBoost'),
(10, 'SlimeWear'),
(11, 'ElixirLabs'),
(12, 'ChocoDynamite'),
(13, 'ArcanaGear'),
(14, 'InfinityThreads'),
(15, 'QuantumKicks'),
(16, 'ShadowTech'),
(17, 'MythicMugs'),
(18, 'GamerFuel'),
(19, 'Kobayashi Cleaners'),
(20, 'Frieren Fabrics');


-- -------------------------------------------
-- TABLE: category (10 parents + 5 subcategories = 15 entries)
-- -------------------------------------------
INSERT INTO category (category_id, name, category_parent_id) VALUES
-- Main Categories (10)
(1, 'Apparel', NULL),
(2, 'Footwear', NULL),
(3, 'Electronics', NULL),
(4, 'Gaming', NULL),
(5, 'Food & Beverage', NULL),
(6, 'Home Goods', NULL),
(7, 'Accessories', NULL),
(8, 'Health & Wellness', NULL),
(9, 'Outdoor Gear', NULL),
(10, 'Collectibles', NULL),

-- Subcategories (5)
(11, 'T-Shirts', 1), -- Apparel
(12, 'Sneakers', 2), -- Footwear
(13, 'Laptops', 3), -- Electronics
(14, 'Energy Drinks', 5), -- Food & Beverage
(15, 'Mugs & Drinkware', 6); -- Home Goods


-- -------------------------------------------
-- TABLE: discount_code (12 entries)
-- -------------------------------------------
INSERT INTO discount_code (code_id, code, value, type, start_date, end_date) VALUES
('DSC0000001', 'SUMMER25', 25.00, 'PERCENT', '2025-06-01 00:00:00', '2025-08-31 23:59:59'),
('DSC0000002', 'WELCOME15', 15.00, 'PERCENT', '2025-01-01 00:00:00', '2026-01-01 00:00:00'),
('DSC0000003', 'FREEDEL', 0.00, 'FIXED', '2025-01-01 00:00:00', '2025-12-31 23:59:59'),
('DSC0000004', 'FIXED10', 10.00, 'FIXED', '2025-09-01 00:00:00', '2025-11-30 23:59:59'),
('DSC0000005', 'VIP50', 50.00, 'FIXED', '2025-10-15 00:00:00', '2025-10-31 23:59:59'),
('DSC0000006', 'TECH10', 10.00, 'PERCENT', '2025-10-01 00:00:00', '2025-12-31 23:59:59'),
('DSC0000007', 'APPAREL20', 20.00, 'PERCENT', '2025-10-10 00:00:00', '2025-11-10 23:59:59'),
('DSC0000008', 'GIFT5', 5.00, 'FIXED', '2025-01-01 00:00:00', '2026-01-01 00:00:00'),
('DSC0000009', 'TEST1', 1.00, 'PERCENT', '2025-10-18 00:00:00', '2025-10-20 23:59:59'), -- Short duration
('DSC0000010', 'TEST2', 1.00, 'FIXED', '2025-10-18 00:00:00', '2025-10-20 23:59:59'), -- Short duration
('DSC0000011', 'BLACKFRI15', 15.00, 'PERCENT', '2025-11-20 00:00:00', '2025-11-30 23:59:59'), -- Future
('DSC0000012', 'SHOES10', 10.00, 'PERCENT', '2025-01-01 00:00:00', '2025-12-31 23:59:59');


-- =================================================================================
-- 2. LOCATION & CLIENTS: LOCATION, WAREHOUSE, CLIENT, CLIENT_ADDRESS
-- =================================================================================

-- -------------------------------------------
-- TABLE: location (250 entries: 5 for warehouses, 245 for clients)
-- -------------------------------------------
-- 5 Warehouse Locations (in key cities)
INSERT INTO location (location_id, address_line, postal_code_id) VALUES
('LOCW0001', '10 Rue de l''Entrepôt', 101), -- Paris, France
('LOCW0002', '20 Lagerweg', 202), -- Munich, Germany
('LOCW0003', '30 Storage Road', 501), -- London, UK
('LOCW0004', '40 Distribution Ave', 601), -- New York, US
('LOCW0005', '50 Logistique Bld', 701); -- Tokyo, Japan

-- 245 Client Locations (randomly distributed among cities)
INSERT INTO location (location_id, address_line, postal_code_id) VALUES
('LOC00001', '15 Rue de l''Aventure', 101), -- Paris
('LOC00002', '22 Avenue des Mages', 102), -- Lyon
('LOC00003', '3 Dragon Street', 103), -- Marseille
('LOC00004', '42 Boulevard des Héros', 104), -- Bordeaux
('LOC00005', '5 Anime Lane', 105), -- Lille
('LOC00006', '12 Voisine Rue', 106), -- Toulouse
('LOC00007', '100 Fantasy Allee', 201), -- Berlin
('LOC00008', '20 Manga Str.', 202), -- Munich
('LOC00009', '33 Game Weg', 203), -- Hamburg
('LOC00010', '4 Sword Plaza', 204), -- Cologne
('LOC00011', '5 Magic Circle', 205), -- Frankfurt
('LOC00012', '6 Isekai Pfad', 206), -- Stuttgart
('LOC00013', '1 Calle del Héroe', 301), -- Madrid
('LOC00014', '2 Avenida de la Quest', 302), -- Barcelona
('LOC00015', '3 Plaza del Slime', 303), -- Seville
('LOC00016', '4 Ronda de la Fortuna', 304), -- Valencia
('LOC00017', '1 Via della Luce', 401), -- Rome
('LOC00018', '2 Corso della Magia', 402), -- Milan
('LOC00019', '3 Vico dei Sogni', 403), -- Naples
('LOC00020', '4 Piazza dell''Avventura', 404), -- Florence
('LOC00021', '10 Grimoire Gardens', 501), -- London
('LOC00022', '20 Quest Quarters', 502), -- Manchester
('LOC00023', '30 Dragon Docks', 503), -- Edinburgh
('LOC00024', '40 Bard Street', 504), -- Cardiff
('LOC00025', '1 Hero Towers', 601), -- New York
('LOC00026', '2 Mage Apartments', 602), -- Los Angeles
('LOC00027', '3 Warrior Flats', 603), -- Chicago
('LOC00028', '4 Witch Beach', 604), -- Miami
('LOC00029', '1 Chara-Oji', 701), -- Tokyo
('LOC00030', '2 Kami-Sama Dori', 702), -- Osaka
('LOC00031', '3 Gakuen-Mae', 703), -- Kyoto
('LOC00032', '4 Shonen Blvd', 704), -- Yokohama
('LOC00033', '1 Fandom Street', 801), -- Montreal
('LOC00034', '2 Cosplay Ave', 802), -- Toronto
('LOC00035', '3 Otaku Drive', 803), -- Vancouver
('LOC00036', '1 Dungeon Close', 901), -- Sydney
('LOC00037', '2 Guild Lane', 902), -- Melbourne
('LOC00038', '3 Raid Road', 903), -- Perth
('LOC00039', '1 Avenida Anime', 1001), -- Rio de Janeiro
('LOC00040', '2 Rua Isekai', 1002), -- São Paulo
('LOC00041', '1 Calle Manga', 1101), -- Mexico City
('LOC00042', '2 Paseo Héroe', 1102), -- Guadalajara
('LOC00043', '1 Seoul Tower Road', 1201), -- Seoul
('LOC00044', '2 Busan Beach Street', 1202), -- Busan
('LOC00045', '1 Beijing Hutong', 1301), -- Beijing
('LOC00046', '2 Shanghai Bund', 1302), -- Shanghai
('LOC00047', '1 Delhi Market', 1401), -- New Delhi
('LOC00048', '2 Mumbai Coast', 1402), -- Mumbai
('LOC00049', '1 Amsterdam Canal', 1501), -- Amsterdam
('LOC00050', '2 Rotterdam Port', 1502), -- Rotterdam
('LOC00051', '18 Rue des Amis', 101),
('LOC00052', '25 Avenue de la Potion', 102),
('LOC00053', '4 Vraie Maison Street', 103),
('LOC00054', '43 Boulevard des Héros', 104),
('LOC00055', '6 Geek Lane', 105),
('LOC00056', '13 TGS Rue', 106),
('LOC00057', '101 Fictional Allee', 201),
('LOC00058', '21 Anime Str.', 202),
('LOC00059', '34 Game Weg', 203),
('LOC00060', '4 Epee Plaza', 204),
('LOC00061', '6 Magie Circle', 205),
('LOC00062', '7 Real Life Pfad', 206),
('LOC00063', '2 Calle del Amigo', 301),
('LOC00064', '3 Avenida de la Victoria', 302),
('LOC00065', '4 Plaza del Lobo', 303),
('LOC00066', '5 Ronda de la Llama', 304),
('LOC00067', '2 Via della Pace', 401),
('LOC00068', '3 Corso della Vita', 402),
('LOC00069', '4 Vico dei Fiori', 403),
('LOC00070', '5 Piazza del Gioco', 404),
('LOC00071', '11 Mystery Gardens', 501),
('LOC00072', '21 Fantasy Quarters', 502),
('LOC00073', '31 Monster Docks', 503),
('LOC00074', '41 Mage Street', 504),
('LOC00075', '2 Hero Towers', 601),
('LOC00076', '3 Mage Apartments', 602),
('LOC00077', '4 Warrior Flats', 603),
('LOC00078', '5 Witch Beach', 604),
('LOC00079', '2 Chara-Oji', 701),
('LOC00080', '3 Kami-Sama Dori', 702),
('LOC00081', '4 Gakuen-Mae', 703),
('LOC00082', '5 Shonen Blvd', 704),
('LOC00083', '2 Fandom Street', 801),
('LOC00084', '3 Cosplay Ave', 802),
('LOC00085', '4 Otaku Drive', 803),
('LOC00086', '2 Dungeon Close', 901),
('LOC00087', '3 Guild Lane', 902),
('LOC00088', '4 Raid Road', 903),
('LOC00089', '2 Avenida Anime', 1001),
('LOC00090', '3 Rua Isekai', 1002),
('LOC00091', '2 Calle Manga', 1101),
('LOC00092', '3 Paseo Héroe', 1102),
('LOC00093', '2 Seoul Tower Road', 1201),
('LOC00094', '3 Busan Beach Street', 1202),
('LOC00095', '2 Beijing Hutong', 1301),
('LOC00096', '3 Shanghai Bund', 1302),
('LOC00097', '2 Delhi Market', 1401),
('LOC00098', '3 Mumbai Coast', 1402),
('LOC00099', '2 Amsterdam Canal', 1501),
('LOC00100', '3 Rotterdam Port', 1502),
('LOC00101', '19 Rue des Amis', 101),
('LOC00102', '26 Avenue de la Potion', 102),
('LOC00103', '5 Vraie Maison Street', 103),
('LOC00104', '44 Boulevard des Héros', 104),
('LOC00105', '7 Geek Lane', 105),
('LOC00106', '14 TGS Rue', 106),
('LOC00107', '102 Fictional Allee', 201),
('LOC00108', '22 Anime Str.', 202),
('LOC00109', '35 Game Weg', 203),
('LOC00110', '5 Epee Plaza', 204),
('LOC00111', '7 Magie Circle', 205),
('LOC00112', '8 Real Life Pfad', 206),
('LOC00113', '3 Calle del Amigo', 301),
('LOC00114', '4 Avenida de la Victoria', 302),
('LOC00115', '5 Plaza del Lobo', 303),
('LOC00116', '6 Ronda de la Llama', 304),
('LOC00117', '3 Via della Pace', 401),
('LOC00118', '4 Corso della Vita', 402),
('LOC00119', '5 Vico dei Fiori', 403),
('LOC00120', '6 Piazza del Gioco', 404),
('LOC00121', '12 Mystery Gardens', 501),
('LOC00122', '22 Fantasy Quarters', 502),
('LOC00123', '32 Monster Docks', 503),
('LOC00124', '42 Mage Street', 504),
('LOC00125', '3 Hero Towers', 601),
('LOC00126', '4 Mage Apartments', 602),
('LOC00127', '5 Warrior Flats', 603),
('LOC00128', '6 Witch Beach', 604),
('LOC00129', '3 Chara-Oji', 701),
('LOC00130', '4 Kami-Sama Dori', 702),
('LOC00131', '5 Gakuen-Mae', 703),
('LOC00132', '6 Shonen Blvd', 704),
('LOC00133', '3 Fandom Street', 801),
('LOC00134', '4 Cosplay Ave', 802),
('LOC00135', '5 Otaku Drive', 803),
('LOC00136', '3 Dungeon Close', 901),
('LOC00137', '4 Guild Lane', 902),
('LOC00138', '5 Raid Road', 903),
('LOC00139', '3 Avenida Anime', 1001),
('LOC00140', '4 Rua Isekai', 1002),
('LOC00141', '3 Calle Manga', 1101),
('LOC00142', '4 Paseo Héroe', 1102),
('LOC00143', '3 Seoul Tower Road', 1201),
('LOC00144', '4 Busan Beach Street', 1202),
('LOC00145', '3 Beijing Hutong', 1301),
('LOC00146', '4 Shanghai Bund', 1302),
('LOC00147', '3 Delhi Market', 1401),
('LOC00148', '4 Mumbai Coast', 1402),
('LOC00149', '3 Amsterdam Canal', 1501),
('LOC00150', '4 Rotterdam Port', 1502),
('LOC00151', '20 Rue des Amis', 101),
('LOC00152', '27 Avenue de la Potion', 102),
('LOC00153', '6 Vraie Maison Street', 103),
('LOC00154', '45 Boulevard des Héros', 104),
('LOC00155', '8 Geek Lane', 105),
('LOC00156', '15 TGS Rue', 106),
('LOC00157', '103 Fictional Allee', 201),
('LOC00158', '23 Anime Str.', 202),
('LOC00159', '36 Game Weg', 203),
('LOC00160', '6 Epee Plaza', 204),
('LOC00161', '8 Magie Circle', 205),
('LOC00162', '9 Real Life Pfad', 206),
('LOC00163', '4 Calle del Amigo', 301),
('LOC00164', '5 Avenida de la Victoria', 302),
('LOC00165', '6 Plaza del Lobo', 303),
('LOC00166', '7 Ronda de la Llama', 304),
('LOC00167', '4 Via della Pace', 401),
('LOC00168', '5 Corso della Vita', 402),
('LOC00169', '6 Vico dei Fiori', 403),
('LOC00170', '7 Piazza del Gioco', 404),
('LOC00171', '13 Mystery Gardens', 501),
('LOC00172', '23 Fantasy Quarters', 502),
('LOC00173', '33 Monster Docks', 503),
('LOC00174', '43 Mage Street', 504),
('LOC00175', '4 Hero Towers', 601),
('LOC00176', '5 Mage Apartments', 602),
('LOC00177', '6 Warrior Flats', 603),
('LOC00178', '7 Witch Beach', 604),
('LOC00179', '4 Chara-Oji', 701),
('LOC00180', '5 Kami-Sama Dori', 702),
('LOC00181', '6 Gakuen-Mae', 703),
('LOC00182', '7 Shonen Blvd', 704),
('LOC00183', '4 Fandom Street', 801),
('LOC00184', '5 Cosplay Ave', 802),
('LOC00185', '6 Otaku Drive', 803),
('LOC00186', '4 Dungeon Close', 901),
('LOC00187', '5 Guild Lane', 902),
('LOC00188', '6 Raid Road', 903),
('LOC00189', '4 Avenida Anime', 1001),
('LOC00190', '5 Rua Isekai', 1002),
('LOC00191', '4 Calle Manga', 1101),
('LOC00192', '5 Paseo Héroe', 1102),
('LOC00193', '4 Seoul Tower Road', 1201),
('LOC00194', '5 Busan Beach Street', 1202),
('LOC00195', '4 Beijing Hutong', 1301),
('LOC00196', '5 Shanghai Bund', 1302),
('LOC00197', '4 Delhi Market', 1401),
('LOC00198', '5 Mumbai Coast', 1402),
('LOC00199', '4 Amsterdam Canal', 1501),
('LOC00200', '5 Rotterdam Port', 1502),
('LOC00201', '21 Rue de l''Aventure', 101),
('LOC00202', '28 Avenue des Mages', 102),
('LOC00203', '7 Dragon Street', 103),
('LOC00204', '46 Boulevard des Héros', 104),
('LOC00205', '9 Anime Lane', 105),
('LOC00206', '16 Voisine Rue', 106),
('LOC00207', '104 Fantasy Allee', 201),
('LOC00208', '24 Manga Str.', 202),
('LOC00209', '37 Game Weg', 203),
('LOC00210', '7 Sword Plaza', 204),
('LOC00211', '9 Magic Circle', 205),
('LOC00212', '10 Isekai Pfad', 206),
('LOC00213', '5 Calle del Héroe', 301),
('LOC00214', '6 Avenida de la Quest', 302),
('LOC00215', '7 Plaza del Slime', 303),
('LOC00216', '8 Ronda de la Fortuna', 304),
('LOC00217', '5 Via della Luce', 401),
('LOC00218', '6 Corso della Magia', 402),
('LOC00219', '7 Vico dei Sogni', 403),
('LOC00220', '8 Piazza dell''Avventura', 404),
('LOC00221', '14 Grimmoire Gardens', 501),
('LOC00222', '24 Quest Quarters', 502),
('LOC00223', '34 Dragon Docks', 503),
('LOC00224', '44 Bard Street', 504),
('LOC00225', '5 Hero Towers', 601),
('LOC00226', '6 Mage Apartments', 602),
('LOC00227', '7 Warrior Flats', 603),
('LOC00228', '8 Witch Beach', 604),
('LOC00229', '5 Chara-Oji', 701),
('LOC00230', '6 Kami-Sama Dori', 702),
('LOC00231', '7 Gakuen-Mae', 703),
('LOC00232', '8 Shonen Blvd', 704),
('LOC00233', '5 Fandom Street', 801),
('LOC00234', '6 Cosplay Ave', 802),
('LOC00235', '7 Otaku Drive', 803),
('LOC00236', '5 Dungeon Close', 901),
('LOC00237', '6 Guild Lane', 902),
('LOC00238', '7 Raid Road', 903),
('LOC00239', '5 Avenida Anime', 1001),
('LOC00240', '6 Rua Isekai', 1002),
('LOC00241', '5 Calle Manga', 1101),
('LOC00242', '6 Paseo Héroe', 1102),
('LOC00243', '5 Seoul Tower Road', 1201),
('LOC00244', '6 Busan Beach Street', 1202),
('LOC00245', '5 Beijing Hutong', 1301),
('LOC00246', '6 Shanghai Bund', 1302),
('LOC00247', '5 Delhi Market', 1401),
('LOC00248', '6 Mumbai Coast', 1402),
('LOC00249', '5 Amsterdam Canal', 1501),
('LOC00250', '6 Rotterdam Port', 1502);

-- -------------------------------------------
-- TABLE: warehouse (5 entries)
-- -------------------------------------------
INSERT INTO warehouse (warehouse_id, name, location_id) VALUES
('WH000001', 'Europe Main Hub - Paris', 'LOCW0001'),
('WH000002', 'DACH Depot - Munich', 'LOCW0002'),
('WH000003', 'UK Distribution Centre - London', 'LOCW0003'),
('WH000004', 'North America Logistics - New York', 'LOCW0004'),
('WH000005', 'Asia Pacific Gate - Tokyo', 'LOCW0005');

-- -------------------------------------------
-- TABLE: client (105 entries)
-- -------------------------------------------
INSERT INTO client (client_id, email, first_name, last_name, phone_number, password, fidelity_status, subscribtion_date) VALUES
('C000000001', 'frieren@anime.com', 'Frieren', 'Fern', '+33612345678', 'hash_frieren123', 1, '2023-11-01 10:00:00'),
('C000000002', 'kazuma@isekai.net', 'Kazuma', 'Satou', '+491701234567', 'hash_kazuma456', 1, '2024-01-15 11:30:00'),
('C000000003', 'aqua@goddess.org', 'Aqua', 'Goddess', '+34600112233', 'hash_aqua789', 0, '2024-02-01 12:00:00'),
('C000000004', 'toru.k@dragon.jp', 'Toru', 'Kobayashi', '+819011112222', 'hash_kobayashi000', 1, '2023-12-05 15:45:00'),
('C000000005', 're_manga@life.co', 'Rem', 'Ram', '+447001122334', 'hash_remram111', 0, '2024-03-20 09:00:00'),
('C000000006', 'eren@scout.com', 'Eren', 'Jaeger', '+12123334444', 'hash_titan222', 1, '2023-10-10 14:00:00'),
('C000000007', 'levi.a@clean.net', 'Levi', 'Ackerman', '+33622334455', 'hash_cleaner333', 1, '2024-04-01 16:10:00'),
('C000000008', 'gon.freecss@hunter.com', 'Gon', 'Freecss', '+491505566778', 'hash_hunter444', 0, '2024-05-05 08:30:00'),
('C000000009', 'killua@zoldick.org', 'Killua', 'Zoldick', '+393334455667', 'hash_zoldick555', 1, '2023-09-20 17:00:00'),
('C000000010', 'usopp@strawhat.jp', 'Usopp', 'Sniper', '+819033334444', 'hash_sogeking666', 0, '2024-06-10 10:40:00'),
('C000000011', 'luffy@pirate.net', 'Monkey D.', 'Luffy', '+34655443322', 'hash_gear5', 1, '2023-08-01 12:00:00'),
('C000000012', 'zoro@swordsman.com', 'Roronoa', 'Zoro', '+13056677889', 'hash_three_swords', 0, '2024-01-25 14:20:00'),
('C000000013', 'nami@navigator.co', 'Nami', 'Thief', '+33788990011', 'hash_weatheria', 1, '2023-11-15 09:50:00'),
('C000000014', 'sanji@chef.fr', 'Sanji', 'Blackleg', '+447998877665', 'hash_vinsmoke', 0, '2024-02-14 13:00:00'),
('C000000015', 'chopper@doctor.net', 'Tony Tony', 'Chopper', '+33698765432', 'hash_rumble', 1, '2024-05-18 11:15:00'),
('C000000016', 'deku@hero.jp', 'Izuku', 'Midoriya', '+819055556666', 'hash_oneforall', 1, '2023-07-07 07:07:07'),
('C000000017', 'bakugo@dynamite.com', 'Katsuki', 'Bakugo', '+491609988776', 'hash_explosion', 0, '2024-01-01 00:00:00'),
('C000000018', 'todoroki@icefire.net', 'Shoto', 'Todoroki', '+393445566778', 'hash_halfhot', 1, '2024-03-03 10:20:00'),
('C000000019', 'allmight@symbol.org', 'Toshinori', 'Yagi', '+14045556677', 'hash_plusultra', 1, '2023-06-01 15:00:00'),
('C000000020', 'aizawa@eraser.co', 'Shota', 'Aizawa', '+33600112233', 'hash_sleepy', 0, '2024-04-20 14:30:00'),
('C000000021', 'saitama@hero.net', 'Saitama', 'Punch', '+819066667777', 'hash_onepunch', 1, '2023-10-25 11:00:00'),
('C000000022', 'gennosuke@ninja.jp', 'Gennosuke', 'Koga', '+33688776655', 'hash_basilisk', 1, '2024-05-10 13:05:00'),
('C000000023', 'subaru.n@re.zero', 'Subaru', 'Natsuki', '+491712345678', 'hash_returnbydeath', 0, '2024-02-29 18:00:00'),
('C000000024', 'albedo@succubus.com', 'Albedo', 'Overlord', '+34611223344', 'hash_ainz', 1, '2023-11-20 19:40:00'),
('C000000025', 'momonga@skele.net', 'Ainz', 'Ooal Gown', '+447112233445', 'hash_boneboi', 1, '2023-09-01 08:00:00'),
('C000000026', 'rimuru@slime.com', 'Rimuru', 'Tempest', '+819077778888', 'hash_greatsage', 1, '2024-01-05 10:10:00'),
('C000000027', 'shuna@ogre.net', 'Shuna', 'Ogre', '+12124445555', 'hash_textile', 0, '2024-04-15 15:00:00'),
('C000000028', 'shion@secretary.jp', 'Shion', 'Kijin', '+33600998877', 'hash_cooker', 1, '2023-12-10 17:30:00'),
('C000000029', 'guts@blacksword.com', 'Guts', 'Berserk', '+491723456789', 'hash_dragonslayer', 1, '2023-10-05 14:00:00'),
('C000000030', 'casca@band.net', 'Casca', 'Hawk', '+34622334455', 'hash_eclipse', 0, '2024-03-01 11:00:00'),
('C000000031', 'mifune@samurai.jp', 'Mifune', 'Samurai', '+819088889999', 'hash_katana', 1, '2024-06-01 10:00:00'),
('C000000032', 'mordred@knight.co', 'Mordred', 'Knight', '+447223344556', 'hash_clarent', 1, '2023-11-25 15:30:00'),
('C000000033', 'artoria@pendragon.net', 'Artoria', 'Pendragon', '+15551234567', 'hash_excalibur', 1, '2024-01-10 16:40:00'),
('C000000034', 'rin@magus.com', 'Rin', 'Tohsaka', '+33633445566', 'hash_gems', 0, '2024-02-05 09:15:00'),
('C000000035', 'shiro@emiya.jp', 'Shiro', 'Emiya', '+491734567890', 'hash_traceon', 0, '2023-12-15 13:00:00'),
('C000000036', 'hange@science.net', 'Hange', 'Zoe', '+34633445566', 'hash_titan_obsessed', 1, '2024-04-18 10:00:00'),
('C000000037', 'erwin@commander.com', 'Erwin', 'Smith', '+393556677889', 'hash_charge', 1, '2023-10-01 11:00:00'),
('C000000038', 'mikasa@loyalty.co', 'Mikasa', 'Ackerman', '+819099990000', 'hash_scarf', 1, '2024-05-22 12:30:00'),
('C000000039', 'hisoka@clown.net', 'Hisoka', 'Clown', '+447334455667', 'hash_bungeegum', 0, '2023-09-15 14:00:00'),
('C000000040', 'kurapika@revenge.jp', 'Kurapika', 'Chain User', '+16017778888', 'hash_judgement', 1, '2024-06-15 08:00:00'),
('C000000041', 'leorio@doctor.com', 'Leorio', 'Paladiknight', '+33644556677', 'hash_medstudent', 0, '2023-11-05 16:00:00'),
('C000000042', 'senku@science.net', 'Senku', 'Ishigami', '+491745678901', 'hash_kingdomofscience', 1, '2024-01-20 17:00:00'),
('C000000043', 'kohaku@tribe.jp', 'Kohaku', 'Tribe', '+34644556677', 'hash_strongest', 0, '2024-03-10 13:30:00'),
('C000000044', 'chrome@craftsman.co', 'Chrome', 'Craftsman', '+393667788990', 'hash_inventor', 1, '2023-10-30 14:45:00'),
('C000000045', 'asuna@lightning.com', 'Asuna', 'Yuuki', '+819012345678', 'hash_aido', 1, '2024-05-01 10:00:00'),
('C000000046', 'kirito@blacksword.net', 'Kirito', 'Kazuto', '+447445566778', 'hash_dualwield', 1, '2023-08-20 11:30:00'),
('C000000047', 'sinon@sniper.jp', 'Sinon', 'Asada', '+17028889999', 'hash_hecate', 0, '2024-02-20 15:00:00'),
('C000000048', 'spike@cowboy.com', 'Spike', 'Spiegel', '+33655667788', 'hash_jazz', 1, '2023-11-10 18:00:00'),
('C000000049', 'jet@black.net', 'Jet', 'Black', '+491756789012', 'hash_bounty', 0, '2024-04-05 12:45:00'),
('C000000050', 'faye@valentine.co', 'Faye', 'Valentine', '+34655667788', 'hash_gambler', 1, '2024-01-08 09:30:00'),
('C000000051', 'usagi@moon.jp', 'Usagi', 'Tsukino', '+819023456789', 'hash_sailormoon', 1, '2023-10-15 16:00:00'),
('C000000052', 'rei@mars.com', 'Rei', 'Hino', '+447556677889', 'hash_mars', 0, '2024-03-05 14:00:00'),
('C000000053', 'ami@mercury.net', 'Ami', 'Mizuno', '+18089990000', 'hash_mercury', 1, '2023-09-25 10:30:00'),
('C000000054', 'makoto@jupiter.jp', 'Makoto', 'Kino', '+33666778899', 'hash_jupiter', 0, '2024-05-25 11:50:00'),
('C000000055', 'minako@venus.co', 'Minako', 'Aino', '+491767890123', 'hash_venus', 1, '2023-12-25 19:00:00'),
('C000000056', 'ichigo@shinigami.com', 'Ichigo', 'Kurosaki', '+34666778899', 'hash_zangetsu', 1, '2024-01-12 10:00:00'),
('C000000057', 'rukia@soul.net', 'Rukia', 'Kuchiki', '+393778899001', 'hash_sode', 1, '2023-11-01 12:00:00'),
('C000000058', 'kon@lion.jp', 'Kon', 'Soul', '+819034567890', 'hash_modsoul', 0, '2024-04-25 15:30:00'),
('C000000059', 'naruto@ninja.com', 'Naruto', 'Uzumaki', '+447667788990', 'hash_rasengan', 1, '2023-07-20 09:00:00'),
('C000000060', 'sasuke@sharingan.net', 'Sasuke', 'Uchiha', '+19071112222', 'hash_chidori', 1, '2024-02-18 13:00:00'),
('C000000061', 'sakura@medic.jp', 'Sakura', 'Haruno', '+33677889900', 'hash_tsunade', 0, '2023-12-01 16:30:00'),
('C000000062', 'kakashi@copy.co', 'Kakashi', 'Hatake', '+491778901234', 'hash_raikiri', 1, '2024-05-12 14:10:00'),
('C000000063', 'goku@saiyan.com', 'Goku', 'Kakarot', '+34677889900', 'hash_kamehameha', 1, '2023-08-10 17:00:00'),
('C000000064', 'vegeta@prince.net', 'Vegeta', 'Saiyan', '+393889900112', 'hash_finalflash', 1, '2024-01-03 18:30:00'),
('C000000065', 'bulma@capsule.jp', 'Bulma', 'Briefs', '+819045678901', 'hash_genius', 0, '2023-10-20 09:40:00'),
('C000000066', 'piccolo@namek.co', 'Piccolo', 'Namekian', '+447778899001', 'hash_makankosappo', 0, '2024-03-25 11:00:00'),
('C000000067', 'gohan@scholar.com', 'Gohan', 'Saiyan', '+10001112222', 'hash_ultimate', 1, '2024-06-05 15:00:00'),
('C000000068', 'yusuke@spirit.net', 'Yusuke', 'Urameshi', '+33688990011', 'hash_reigun', 1, '2023-11-20 13:00:00'),
('C000000069', 'kuwabara@sword.jp', 'Kuwabara', 'Kazuma', '+491789012345', 'hash_spiritblade', 0, '2024-02-08 14:00:00'),
('C000000070', 'hiei@fire.co', 'Hiei', 'Jaganshi', '+34688990011', 'hash_jagan', 1, '2023-10-08 16:00:00'),
('C000000071', 'kurama@plant.com', 'Kurama', 'Yoko', '+393990011223', 'hash_rose', 1, '2024-04-10 10:00:00'),
('C000000072', 'kaito@detective.net', 'Kaito', 'Kid', '+819056789012', 'hash_phantom', 0, '2023-09-05 12:00:00'),
('C000000073', 'shinichi@conan.jp', 'Shinichi', 'Kudo', '+447889900112', 'hash_aptx', 1, '2024-05-08 15:30:00'),
('C000000074', 'ran@karate.co', 'Ran', 'Mouri', '+10003334444', 'hash_blackbelt', 1, '2023-11-29 11:00:00'),
('C000000075', 'aot@magi.com', 'Aladdin', 'Magi', '+33699001122', 'hash_djinn', 1, '2024-01-18 10:45:00'),
('C000000076', 'alibaba@prince.net', 'Alibaba', 'Saluga', '+491890123456', 'hash_amir', 0, '2024-03-08 14:30:00'),
('C000000077', 'morgiana@fan.jp', 'Morgiana', 'Fanalis', '+34699001122', 'hash_kick', 1, '2023-12-08 16:00:00'),
('C000000078', 'soma@chef.com', 'Soma', 'Yukihira', '+393001122334', 'hash_shokugeki', 1, '2024-02-25 17:00:00'),
('C000000079', 'erinas@elite.net', 'Erina', 'Nakiri', '+819067890123', 'hash_godtongue', 1, '2023-10-12 09:20:00'),
('C000000080', 'megumi@cook.co', 'Megumi', 'Tadokoro', '+447990011223', 'hash_comfort', 0, '2024-04-08 11:30:00'),
('C000000081', 'yato@god.com', 'Yato', 'Delivery', '+10005556666', 'hash_5yen', 1, '2023-09-08 18:00:00'),
('C000000082', 'yukine@regalia.net', 'Yukine', 'Regalia', '+33601122334', 'hash_sekki', 0, '2024-05-01 13:00:00'),
('C000000083', 'hiyori@phantom.jp', 'Hiyori', 'Iki', '+491012233445', 'hash_tail', 1, '2023-11-08 14:30:00'),
('C000000084', 'makise@time.com', 'Kurisu', 'Makise', '+346011223344', 'hash_zombie', 1, '2024-01-16 10:00:00'),
('C000000085', 'okabe@madscientist.net', 'Rintarou', 'Okabe', '+393012233445', 'hash_hououin', 1, '2023-10-02 12:00:00'),
('C000000086', 'mayuri@tutu.jp', 'Mayuri', 'Shiina', '+819078901234', 'hash_tutturu', 0, '2024-03-15 15:30:00'),
('C000000087', 'madoka@magical.com', 'Madoka', 'Kaname', '+447012233445', 'hash_godoka', 1, '2023-09-02 08:30:00'),
('C000000088', 'homura@akemi.net', 'Homura', 'Akemi', '+10007778888', 'hash_timeloop', 1, '2024-04-01 16:00:00'),
('C000000089', 'mami@tea.jp', 'Mami', 'Tomoe', '+33602233445', 'hash_tiro', 0, '2023-12-05 17:00:00'),
('C000000090', 'sayaka@knight.co', 'Sayaka', 'Miki', '+491023344556', 'hash_justice', 1, '2024-02-02 11:00:00'),
('C000000091', 'kyoko@snack.com', 'Kyoko', 'Sakura', '+346022334455', 'hash_pocky', 0, '2023-11-12 10:00:00'),
('C000000092', 'yui@music.net', 'Yui', 'Hirasawa', '+393023344556', 'hash_guitarlover', 1, '2024-05-15 12:00:00'),
('C000000093', 'mio@bass.jp', 'Mio', 'Akiyama', '+819089012345', 'hash_shy', 1, '2023-10-07 14:00:00'),
('C000000094', 'ritsu@drum.co', 'Ritsu', 'Tainaka', '+447023344556', 'hash_president', 0, '2024-06-08 16:00:00'),
('C000000095', 'azusa@junior.com', 'Azusa', 'Nakano', '+10009990000', 'hash_azunyan', 1, '2023-09-10 17:30:00'),
('C000000096', 'sora@gamer.net', 'Sora', 'Blank', '+33603344556', 'hash_nogamenolife', 1, '2024-01-07 09:00:00'),
('C000000097', 'shiro@gamer.jp', 'Shiro', 'Blank', '+491034455667', 'hash_logic', 1, '2023-12-18 13:00:00'),
('C000000098', 'jibril@angel.co', 'Jibril', 'Flügel', '+346033445566', 'hash_knowledge', 0, '2024-04-22 10:10:00'),
('C000000099', 'izuna@werebeast.com', 'Izuna', 'Hatsuse', '+393034455667', 'hash_desu', 1, '2023-11-07 15:00:00'),
('C000000100', 'tanjirou@demon.net', 'Tanjirou', 'Kamado', '+819090123456', 'hash_waterbreathing', 1, '2024-02-07 18:00:00'),
('C000000101', 'nezuko@demon.jp', 'Nezuko', 'Kamado', '+447034455667', 'hash_bambou', 0, '2023-10-28 11:45:00'),
('C000000102', 'zenitsu@thunder.co', 'Zenitsu', 'Agatsuma', '+10011112222', 'hash_oneform', 0, '2024-05-05 16:30:00'),
('C000000103', 'inosuke@pig.com', 'Inosuke', 'Hashibira', '+33604455667', 'hash_beastbreath', 1, '2023-09-04 14:00:00'),
('C000000104', 'giyu@hashira.net', 'Giyu', 'Tomioka', '+491045566778', 'hash_solitary', 1, '2024-01-19 19:00:00'),
('C000000105', 'shiraori@spider.jp', 'Shiraori', 'Kumo', '+346044556677', 'hash_web', 1, '2024-03-28 09:30:00');

-- -------------------------------------------
-- TABLE: client_address (210 entries, 2 per client on average, all linked to non-warehouse LOCs)
-- -------------------------------------------
-- Client 1 (Frieren) - France (Default) & Germany
INSERT INTO client_address (client_address_id, is_default, location_id, client_id) VALUES
('CA00000001', 1, 'LOC00001', 'C000000001'),
('CA00000002', 0, 'LOC00007', 'C000000001');

-- Client 2 (Kazuma) - Germany (Default) & UK
INSERT INTO client_address (client_address_id, is_default, location_id, client_id) VALUES
('CA00000003', 1, 'LOC00008', 'C000000002'),
('CA00000004', 0, 'LOC00021', 'C000000002');

-- Client 3 (Aqua) - Spain (Default) & Italy
INSERT INTO client_address (client_address_id, is_default, location_id, client_id) VALUES
('CA00000005', 1, 'LOC00013', 'C000000003'),
('CA00000006', 0, 'LOC00017', 'C000000003');

-- Client 4 (Toru) - Japan (Default) & US
INSERT INTO client_address (client_address_id, is_default, location_id, client_id) VALUES
('CA00000007', 1, 'LOC00029', 'C000000004'),
('CA00000008', 0, 'LOC00025', 'C000000004');

-- Client 5 (Rem) - UK (Default) & France
INSERT INTO client_address (client_address_id, is_default, location_id, client_id) VALUES
('CA00000009', 1, 'LOC00022', 'C000000005'),
('CA00000010', 0, 'LOC00002', 'C000000005');

-- Client 6 to 105 (rest of clients - 100 clients, 2 addresses each = 200 addresses)
-- Converted to MySQL syntax using the temporary series table and CONCAT
SET @ROW_NUMBER = 10;
INSERT INTO client_address (client_address_id, is_default, location_id, client_id)
SELECT
    CONCAT('CA', LPAD(t.ROW_NUMBER, 8, '0')),
    CASE WHEN ((t.ROW_NUMBER - 10) % 2) = 1 THEN 1 ELSE 0 END,
    CONCAT('LOC', LPAD(((t.ROW_NUMBER - 10) * 2) + 7, 5, '0')),
    CONCAT('C', LPAD(FLOOR(((t.ROW_NUMBER - 10) - 1) / 2) + 6, 9, '0'))
FROM
    temp_series t
WHERE t.ROW_NUMBER BETWEEN 11 AND 210;

-- Manually correct the default status for the second address of each client to FALSE (0)
UPDATE client_address
SET is_default = 0
WHERE client_address_id IN (
    SELECT client_address_id FROM (
        SELECT client_address_id, @rn := IF(@prev_client = client_id, @rn + 1, 1) AS rn, @prev_client := client_id
        FROM client_address
        JOIN (SELECT @rn := 0, @prev_client := '') AS init
        WHERE CAST(SUBSTRING(client_id, 2) AS UNSIGNED) >= 6
        ORDER BY client_id, client_address_id
    ) AS sub
    WHERE rn = 2
);

-- Manually correct the default status for the first address of each client to TRUE (1)
UPDATE client_address
SET is_default = 1
WHERE client_address_id IN (
    SELECT client_address_id FROM (
        SELECT client_address_id, @rn2 := IF(@prev_client2 = client_id, @rn2 + 1, 1) AS rn, @prev_client2 := client_id
        FROM client_address
        JOIN (SELECT @rn2 := 0, @prev_client2 := '') AS init2
        WHERE CAST(SUBSTRING(client_id, 2) AS UNSIGNED) >= 6
        ORDER BY client_id, client_address_id
    ) AS sub
    WHERE rn = 1
);


-- =================================================================================
-- 3. PRODUCTS & INVENTORY: PRODUCT, ARTICLE, PRICE, STOCK
-- =================================================================================

-- -------------------------------------------
-- TABLE: product (100 entries)
-- -------------------------------------------
INSERT INTO product (product_id, name, description, category_id, brand_id) VALUES
('PRD000000000001', 'Slime-Proof Jacket', 'A lightweight, durable jacket perfect for adventurers, resistant to most magical slimes. Available in multiple colors.', 1, 10),
('PRD000000000002', 'ManaBoost Energy Drink 12-Pack', 'High-potency energy drink, provides a +10 to Mana and Stamina for 6 hours. Zero crash effect.', 5, 9),
('PRD000000000003', 'Dragon Maid Tee - Classic Logo', 'Comfortable cotton T-shirt featuring the classic Dragon Maid service logo. True to size.', 11, 20),
('PRD000000000004', 'InfinityRun V1 Sneakers', 'High-performance running shoes with QuantumKicks kinetic-feedback sole technology. Excellent for long-distance running or escaping angry mobs.', 12, 15),
('PRD000000000005', 'ShadowTech Noise-Cancelling Headset', 'Immersive over-ear headset with crystal clear audio and deep noise cancellation. Perfect for in-game communication or avoiding real-life troubles.', 3, 16),
('PRD000000000006', 'Adibas 3-Stripe Track Pants', 'The classic tracksuit pants. Comfortable for training, lounging, or hiding in a barrel.', 1, 1),
('PRD000000000007', 'Guccii Logo Luxury Scarf', 'High-end knitted scarf with the iconic Guccii pattern. Pure Arcana silk blend.', 7, 3),
('PRD000000000008', 'Cocacolaine Zero Sugar - Case', 'The original taste, now with zero sugar. Extreme caffeine for late-night grinding sessions.', 5, 5),
('PRD000000000009', 'Appel iStone 15 Pro Max', 'The ultimate portable computing device. Faster than a flying cloud. Includes the new B15 chip.', 3, 7),
('PRD000000010001', 'Nikéa Air Max 90 Isekai', 'Limited edition sneakers designed for comfort in other worlds. Extreme grip on dungeons floors.', 12, 2);

-- 90 more product entries (simulated)
SET @ROW_NUMBER = 1;
INSERT INTO product (product_id, name, description, category_id, brand_id)
SELECT
    CONCAT('PRD', LPAD(t.ROW_NUMBER + 10001, 8, '0')),
    CONCAT('Product ', t.ROW_NUMBER, ' Name'),
    CONCAT('Description for product ', t.ROW_NUMBER, '. Generated for bulk data.'),
    (t.ROW_NUMBER % 10) + 1,
    (t.ROW_NUMBER % 15) + 6
FROM (
    SELECT @ROW_NUMBER := @ROW_NUMBER + 1 AS ROW_NUMBER
    FROM information_schema.tables AS t1, information_schema.tables AS t2
    LIMIT 90
) AS t;

-- -------------------------------------------
-- TABLE: article (200 entries minimum: ~2 per product)
-- -------------------------------------------
-- PRD000000000001: Slime-Proof Jacket (3 sizes, 2 colors)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000001', 'S', 'Green', 'PRD000000000001'),
('SKU000000000002', 'M', 'Green', 'PRD000000000001'),
('SKU000000000003', 'L', 'Green', 'PRD000000000001'),
('SKU000000000004', 'S', 'Blue', 'PRD000000000001'),
('SKU000000000005', 'M', 'Blue', 'PRD000000000001'),
('SKU000000000006', 'L', 'Blue', 'PRD000000000001');

-- PRD000000000002: ManaBoost (1 size, 2 "colors"/flavors)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000007', '12PK', 'Lemon', 'PRD000000000002'),
('SKU000000000008', '12PK', 'Berry', 'PRD000000000002');

-- PRD000000000003: Dragon Maid Tee (4 sizes, 3 colors)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000009', 'S', 'Black', 'PRD000000000003'),
('SKU000000000010', 'M', 'Black', 'PRD000000000003'),
('SKU000000000011', 'L', 'Black', 'PRD000000000003'),
('SKU000000000012', 'XL', 'Black', 'PRD000000000003'),
('SKU000000000013', 'S', 'White', 'PRD000000000003'),
('SKU000000000014', 'M', 'White', 'PRD000000000003'),
('SKU000000000015', 'L', 'White', 'PRD000000000003'),
('SKU000000000016', 'XL', 'White', 'PRD000000000003'),
('SKU000000000017', 'M', 'Red', 'PRD000000000003'),
('SKU000000000018', 'L', 'Red', 'PRD000000000003');

-- PRD000000000004: InfinityRun V1 Sneakers (2 colors, 3 sizes: 40, 42, 44)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000019', '40', 'Black', 'PRD000000000004'),
('SKU000000000020', '42', 'Black', 'PRD000000000004'),
('SKU000000000021', '44', 'Black', 'PRD000000000004'),
('SKU000000000022', '40', 'Grey', 'PRD000000000004'),
('SKU000000000023', '42', 'Grey', 'PRD000000000004'),
('SKU000000000024', '44', 'Grey', 'PRD000000000004');

-- PRD000000000005: ShadowTech Headset (2 colors)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000025', 'OS', 'Black', 'PRD000000000005'),
('SKU000000000026', 'OS', 'White', 'PRD000000000005');

-- PRD000000000006: Adibas Track Pants (3 sizes, 2 colors)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000027', 'S', 'Navy', 'PRD000000000006'),
('SKU000000000028', 'M', 'Navy', 'PRD000000000006'),
('SKU000000000029', 'L', 'Navy', 'PRD000000000006'),
('SKU000000000030', 'M', 'Red', 'PRD000000000006'),
('SKU000000000031', 'L', 'Red', 'PRD000000000006');

-- PRD000000000007: Guccii Scarf (1 size, 2 colors)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000032', 'OS', 'Beige', 'PRD000000000007'),
('SKU000000000033', 'OS', 'Gray', 'PRD000000000007');

-- PRD000000000008: Cocacolaine Case (1 size, 1 color)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000034', 'CASE', 'Original', 'PRD000000000008');

-- PRD000000000009: Appel iStone 15 Pro Max (1 size, 3 colors)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000035', 'OS', 'Black', 'PRD000000000009'),
('SKU000000000036', 'OS', 'Silver', 'PRD000000000009'),
('SKU000000000037', 'OS', 'Blue', 'PRD000000000009');

-- PRD000000010001: Nikéa Air Max 90 Isekai (2 colors, 3 sizes: 40, 42, 44)
INSERT INTO article (SKU_code, size, color, product_id) VALUES
('SKU000000000038', '40', 'White', 'PRD000000010001'),
('SKU000000000039', '42', 'White', 'PRD000000010001'),
('SKU000000000040', '44', 'White', 'PRD000000010001'),
('SKU000000000041', '40', 'Black', 'PRD000000010001'),
('SKU000000000042', '42', 'Black', 'PRD000000010001'),
('SKU000000000043', '44', 'Black', 'PRD000000010001');

-- 157 more article entries for the remaining 90 products (simulated: ~1.7 per product)
SET @ROW_NUMBER = 1;
INSERT INTO article (SKU_code, size, color, product_id)
SELECT
    CONCAT('SKU', LPAD(t.ROW_NUMBER + 43, 11, '0')),
    CASE WHEN (t.ROW_NUMBER % 3) = 0 THEN 'S' WHEN (t.ROW_NUMBER % 3) = 1 THEN 'M' ELSE 'OS' END,
    CASE WHEN (t.ROW_NUMBER % 3) = 0 THEN 'Red' WHEN (t.ROW_NUMBER % 3) = 1 THEN 'Green' ELSE 'Black' END,
    CONCAT('PRD', LPAD(FLOOR((t.ROW_NUMBER - 1) / 2) + 10001, 8, '0'))
FROM (
    SELECT @ROW_NUMBER := @ROW_NUMBER + 1 AS ROW_NUMBER
    FROM information_schema.tables AS t1, information_schema.tables AS t2
    LIMIT 157
) AS t;


-- -------------------------------------------
-- TABLE: price (200 entries: one current price for each SKU)
-- -------------------------------------------
-- Base prices for the 43 initial SKUs
INSERT INTO price (SKU_code, start_date, sale_price, end_date) VALUES
('SKU000000000001', '2024-01-01 00:00:00', 89.99, '9999-12-31 23:59:59'),
('SKU000000000002', '2024-01-01 00:00:00', 89.99, '9999-12-31 23:59:59'),
('SKU000000000003', '2024-01-01 00:00:00', 89.99, '9999-12-31 23:59:59'),
('SKU000000000004', '2024-01-01 00:00:00', 89.99, '9999-12-31 23:59:59'),
('SKU000000000005', '2024-01-01 00:00:00', 89.99, '9999-12-31 23:59:59'),
('SKU000000000006', '2024-01-01 00:00:00', 89.99, '9999-12-31 23:59:59'),
('SKU000000000007', '2024-03-01 00:00:00', 24.50, '9999-12-31 23:59:59'),
('SKU000000000008', '2024-03-01 00:00:00', 24.50, '9999-12-31 23:59:59'),
('SKU000000000009', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000010', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000011', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000012', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000013', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000014', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000015', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000016', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000017', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000018', '2024-01-01 00:00:00', 29.99, '9999-12-31 23:59:59'),
('SKU000000000019', '2024-04-01 00:00:00', 129.99, '9999-12-31 23:59:59'),
('SKU000000000020', '2024-04-01 00:00:00', 129.99, '9999-12-31 23:59:59'),
('SKU000000000021', '2024-04-01 00:00:00', 129.99, '9999-12-31 23:59:59'),
('SKU000000000022', '2024-04-01 00:00:00', 129.99, '9999-12-31 23:59:59'),
('SKU000000000023', '2024-04-01 00:00:00', 129.99, '9999-12-31 23:59:59'),
('SKU000000000024', '2024-04-01 00:00:00', 129.99, '9999-12-31 23:59:59'),
('SKU000000000025', '2024-02-01 00:00:00', 199.50, '9999-12-31 23:59:59'),
('SKU000000000026', '2024-02-01 00:00:00', 199.50, '9999-12-31 23:59:59'),
('SKU000000000027', '2024-01-01 00:00:00', 49.99, '9999-12-31 23:59:59'),
('SKU000000000028', '2024-01-01 00:00:00', 49.99, '9999-12-31 23:59:59'),
('SKU000000000029', '2024-01-01 00:00:00', 49.99, '9999-12-31 23:59:59'),
('SKU000000000030', '2024-01-01 00:00:00', 49.99, '9999-12-31 23:59:59'),
('SKU000000000031', '2024-01-01 00:00:00', 49.99, '9999-12-31 23:59:59'),
('SKU000000000032', '2024-01-01 00:00:00', 499.00, '9999-12-31 23:59:59'),
('SKU000000000033', '2024-01-01 00:00:00', 499.00, '9999-12-31 23:59:59'),
('SKU000000000034', '2024-03-01 00:00:00', 19.99, '9999-12-31 23:59:59'),
('SKU000000000035', '2024-09-15 00:00:00', 1299.00, '9999-12-31 23:59:59'),
('SKU000000000036', '2024-09-15 00:00:00', 1299.00, '9999-12-31 23:59:59'),
('SKU000000000037', '2024-09-15 00:00:00', 1299.00, '9999-12-31 23:59:59'),
('SKU000000000038', '2024-04-01 00:00:00', 109.99, '9999-12-31 23:59:59'),
('SKU000000000039', '2024-04-01 00:00:00', 109.99, '9999-12-31 23:59:59'),
('SKU000000000040', '2024-04-01 00:00:00', 109.99, '9999-12-31 23:59:59'),
('SKU000000000041', '2024-04-01 00:00:00', 109.99, '9999-12-31 23:59:59'),
('SKU000000000042', '2024-04-01 00:00:00', 109.99, '9999-12-31 23:59:59'),
('SKU000000000043', '2024-04-01 00:00:00', 109.99, '9999-12-31 23:59:59');

-- Price history for one product (SKU000000000025)
INSERT INTO price (SKU_code, start_date, sale_price, end_date) VALUES
('SKU000000000025', '2023-11-01 00:00:00', 249.99, '2024-01-31 23:59:59');

-- Remaining 157 SKUs (simulated with random-ish prices)
SET @ROW_NUMBER = 1;
INSERT INTO price (SKU_code, start_date, sale_price, end_date)
SELECT
    CONCAT('SKU', LPAD(t.ROW_NUMBER + 43, 11, '0')),
    '2024-05-01 00:00:00',
    ROUND(RAND() * 500 + 10, 2),
    '9999-12-31 23:59:59'
FROM (
    SELECT @ROW_NUMBER := @ROW_NUMBER + 1 AS ROW_NUMBER
    FROM information_schema.tables AS t1, information_schema.tables AS t2
    LIMIT 157
) AS t;

-- -------------------------------------------
-- TABLE: stock (200 SKUs * 5 warehouses = 1000 entries)
-- -------------------------------------------
INSERT INTO stock (SKU_code, warehouse_id, quantity)
SELECT
    a.SKU_code,
    w.warehouse_id,
    FLOOR(RAND() * 100 + 10) -- Quantity between 10 and 109
FROM
    article a
CROSS JOIN
    warehouse w;


-- =================================================================================
-- 4. CLIENT PREFERENCES: CLIENT_PREFERENCE
-- =================================================================================

-- -------------------------------------------
-- TABLE: client_preference (150 entries - ~1.4 per client)
-- -------------------------------------------
INSERT INTO client_preference (client_id, type_id) VALUES
('C000000001', 1), ('C000000001', 3),
('C000000002', 1), ('C000000002', 2),
('C000000003', 1),
('C000000004', 1), ('C000000004', 2), ('C000000004', 3),
('C000000005', 1),
('C000000006', 1), ('C000000006', 4),
('C000000007', 3),
('C000000008', 1), ('C000000008', 2),
('C000000009', 1), ('C000000009', 3),
('C000000010', 2),
('C000000011', 1), ('C000000011', 2), ('C000000011', 3), ('C000000011', 4),
('C000000012', 1), ('C000000012', 3),
('C000000013', 1), ('C000000013', 2),
('C000000014', 1),
('C000000015', 3), ('C000000015', 4),
('C000000016', 1), ('C000000016', 2), ('C000000016', 3),
('C000000017', 1),
('C000000018', 1), ('C000000018', 4),
('C000000019', 1), ('C000000019', 3),
('C000000020', 2),
('C000000021', 1), ('C000000021', 2),
('C000000022', 1), ('C000000022', 3), ('C000000022', 4),
('C000000023', 1),
('C000000024', 1), ('C000000024', 2),
('C000000025', 1), ('C000000025', 3),
('C000000026', 1), ('C000000026', 2), ('C000000026', 3),
('C000000027', 1),
('C000000028', 1), ('C000000028', 4),
('C000000029', 1), ('C000000029', 2),
('C000000030', 1),
('C000000031', 3), ('C000000031', 4),
('C000000032', 1), ('C000000032', 2), ('C000000032', 3),
('C000000033', 1), ('C000000033', 3),
('C000000034', 1),
('C000000035', 1), ('C000000035', 2), ('C000000035', 3), ('C000000035', 4),
('C000000036', 1), ('C000000036', 3),
('C000000037', 1), ('C000000037', 2),
('C000000038', 1),
('C000000039', 1), ('C000000039', 4),
('C000000040', 1), ('C000000040', 2), ('C000000040', 3),
('C000000041', 1),
('C000000042', 1), ('C000000042', 3),
('C000000043', 1), ('C000000043', 2),
('C000000044', 1), ('C000000044', 3), ('C000000044', 4),
('C000000045', 1),
('C000000046', 1), ('C000000046', 2), ('C000000046', 3),
('C000000047', 1),
('C000000048', 1), ('C000000048', 3),
('C000000049', 1), ('C000000049', 2),
('C000000050', 1), ('C000000050', 3), ('C000000050', 4),
('C000000051', 1),
('C000000052', 1), ('C000000052', 2),
('C000000053', 1), ('C000000053', 3),
('C000000054', 1), ('C000000054', 2), ('C000000054', 3), ('C000000054', 4),
('C000000055', 1),
('C000000056', 1), ('C000000056', 3),
('C000000057', 1), ('C000000057', 2),
('C000000058', 1),
('C000000059', 1), ('C000000059', 4),
('C000000060', 1), ('C000000060', 2), ('C000000060', 3),
('C000000061', 1),
('C000000062', 1), ('C000000062', 3),
('C000000063', 1), ('C000000063', 2),
('C000000064', 1), ('C000000064', 3), ('C000000064', 4),
('C000000065', 1),
('C000000066', 1), ('C000000066', 2),
('C000000067', 1), ('C000000067', 3),
('C000000068', 1), ('C000000068', 2), ('C000000068', 3),
('C000000069', 1),
('C000000070', 1), ('C000000070', 4),
('C000000071', 1), ('C000000071', 2),
('C000000072', 1), ('C000000072', 3),
('C000000073', 1), ('C000000073', 2), ('C000000073', 3), ('C000000073', 4),
('C000000074', 1),
('C000000075', 1), ('C000000075', 3),
('C000000076', 1), ('C000000076', 2),
('C000000077', 1), ('C000000077', 3), ('C000000077', 4),
('C000000078', 1),
('C000000079', 1), ('C000000079', 2),
('C000000080', 1), ('C000000080', 3),
('C000000081', 1), ('C000000081', 2), ('C000000081', 3), ('C000000081', 4),
('C000000082', 1),
('C000000083', 1), ('C000000083', 3),
('C000000084', 1), ('C000000084', 2),
('C000000085', 1), ('C000000085', 3),
('C000000086', 1), ('C000000086', 2), ('C000000086', 3), ('C000000086', 4),
('C000000087', 1),
('C000000088', 1), ('C000000088', 3),
('C000000089', 1), ('C000000089', 2),
('C000000090', 1), ('C000000090', 3), ('C000000090', 4),
('C000000091', 1),
('C000000092', 1), ('C000000092', 2),
('C000000093', 1), ('C000000093', 3),
('C000000094', 1), ('C000000094', 2), ('C000000094', 3), ('C000000094', 4),
('C000000095', 1),
('C000000096', 1), ('C000000096', 3),
('C000000097', 1), ('C000000097', 2),
('C000000098', 1),
('C000000099', 1), ('C000000099', 4),
('C000000100', 1), ('C000000100', 2), ('C000000100', 3),
('C000000101', 1),
('C000000102', 1), ('C000000102', 3),
('C000000103', 1), ('C000000103', 2), ('C000000103', 3), ('C000000103', 4),
('C000000104', 1),
('C000000105', 1), ('C000000105', 3);


-- =================================================================================
-- 5. ORDERS & TRANSACTIONS: ORDER_, ORDER_LINE, TRANSACTION
-- =================================================================================

-- -------------------------------------------
-- TABLE: order_ (150 entries minimum: 160 entries)
-- -------------------------------------------
INSERT INTO order_ (order_id, date_, total_amount, status, client_address_id, client_id) VALUES
-- C000000001 (Frieren) - Delivered (2 orders)
('ORD00000000001', '2024-02-10 14:00:00', 89.99, 'DELIVERED', 'CA000000001', 'C000000001'), -- Jacket M Green
('ORD00000000002', '2024-03-25 09:30:00', 199.50, 'DELIVERED', 'CA000000002', 'C000000001'), -- Headset Black

-- C000000002 (Kazuma) - Returned (1 order)
('ORD00000000003', '2024-04-05 16:00:00', 29.99, 'RETURNED', 'CA000000003', 'C000000002'), -- Dragon Maid Tee M Black

-- C000000004 (Toru) - Delivered, High Value (1 order)
('ORD00000000004', '2024-10-01 10:00:00', 1299.00, 'DELIVERED', 'CA000000007', 'C000000004'), -- iStone 15 Pro Max

-- C000000016 (Deku) - Pending (1 order)
('ORD00000000005', '2025-10-19 10:00:00', 129.99, 'PENDING', 'CA000000031', 'C000000016'), -- Sneakers Black 42

-- C000000026 (Rimuru) - Delivered (2 orders)
('ORD00000000006', '2024-05-15 11:00:00', 49.00, 'DELIVERED', 'CA000000051', 'C000000026'), -- Adibas Pants M Navy (Discount applied: FIXED10)
('ORD00000000007', '2024-05-20 12:00:00', 49.00, 'DELIVERED', 'CA000000052', 'C000000026'), -- Adibas Pants L Red (Discount applied: FIXED10)

-- C000000050 (Faye) - Cancelled (1 order)
('ORD00000000008', '2024-01-20 15:30:00', 499.00, 'CANCELLED', 'CA000000099', 'C000000050'), -- Guccii Scarf Beige

-- C000000063 (Goku) - Delivered, Multiple Items (1 order)
('ORD00000000009', '2024-04-20 18:00:00', 148.98, 'DELIVERED', 'CA000000125', 'C000000063'), -- ManaBoost (2) + Tee (2)

-- C000000097 (Shiro) - Delivered, Low Value (1 order)
('ORD00000001001', '2024-05-10 13:00:00', 19.99, 'DELIVERED', 'CA000000193', 'C000000097'); -- Cocacolaine Case

-- Remaining 151 orders (random clients, random addresses, random statuses/dates)
SET @ROW_NUMBER = 1;
INSERT INTO order_ (order_id, date_, total_amount, status, client_address_id, client_id)
SELECT
    CONCAT('ORD', LPAD(t.ROW_NUMBER + 1001, 8, '0')),
    DATE_ADD(DATE_ADD('2024-01-01 00:00:00', INTERVAL t.ROW_NUMBER * 2 DAY), INTERVAL t.ROW_NUMBER % 24 HOUR),
    ROUND(RAND() * 500 + 50, 2),
    CASE
        WHEN (t.ROW_NUMBER % 10) = 0 THEN 'RETURNED'
        WHEN (t.ROW_NUMBER % 10) = 1 THEN 'CANCELLED'
        WHEN (t.ROW_NUMBER % 10) = 2 THEN 'PENDING'
        WHEN (t.ROW_NUMBER % 10) = 3 THEN 'PROCESSING'
        WHEN (t.ROW_NUMBER % 10) = 4 THEN 'SHIPPED'
        ELSE 'DELIVERED'
    END,
    CONCAT('CA', LPAD(FLOOR(RAND() * 209) + 1, 8, '0')), -- Random CA from 1 to 210
    CONCAT('C', LPAD(FLOOR(RAND() * 104) + 1, 9, '0')) -- Random Client from 1 to 105
FROM (
    SELECT @ROW_NUMBER := @ROW_NUMBER + 1 AS ROW_NUMBER
    FROM information_schema.tables AS t1, information_schema.tables AS t2
    LIMIT 151
) AS t;

-- Manually fix total_amount for orders ORD00000000006 and ORD00000000007 (Adibas pants are 49.99, not 49.00 due to FIXED10)
UPDATE order_ SET total_amount = 39.99 WHERE order_id IN ('ORD00000000006', 'ORD00000000007'); -- Correct price with FIXED10 (49.99 - 10.00 = 39.99)


-- -------------------------------------------
-- TABLE: order_line (450 entries minimum: 450 entries)
-- -------------------------------------------
-- ORD00000000001 (Frieren: Jacket)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000002', 'ORD00000000001', 1, 89.99);

-- ORD00000000002 (Frieren: Headset)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000025', 'ORD00000000002', 1, 199.50);

-- ORD00000000003 (Kazuma: Tee)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000010', 'ORD00000000003', 1, 29.99);

-- ORD00000000004 (Toru: iStone)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000035', 'ORD00000000004', 1, 1299.00);

-- ORD00000000005 (Deku: Sneakers)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000020', 'ORD00000000005', 1, 129.99);

-- ORD00000000006 (Rimuru: Adibas Pants)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000028', 'ORD00000000006', 1, 39.99); -- Price after FIXED10 applied

-- ORD00000000007 (Rimuru: Adibas Pants)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000031', 'ORD00000000007', 1, 39.99); -- Price after FIXED10 applied

-- ORD00000000008 (Faye: Scarf)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000032', 'ORD00000000008', 1, 499.00);

-- ORD00000000009 (Goku: ManaBoost + Tee)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000007', 'ORD00000000009', 2, 24.50), -- 49.00
('SKU000000000010', 'ORD00000000009', 2, 29.99); -- 59.98 -> Total 108.98. Manually adjust ORD00000000009 total_amount in next step.

-- ORD00000001001 (Shiro: Cocacolaine)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid) VALUES
('SKU000000000034', 'ORD00000001001', 1, 19.99);

-- Remaining orders: 440 lines (simulated)
INSERT INTO order_line (SKU_code, order_id, quantity_ordered, unit_price_paid)
SELECT
    CONCAT('SKU', LPAD(FLOOR(RAND() * 199) + 1, 11, '0')), -- Random SKU
    o.order_id,
    FLOOR(RAND() * 4) + 1, -- Quantity 1-4
    ROUND(RAND() * 200 + 10, 2)
FROM
    order_ o
WHERE o.order_id NOT IN ('ORD00000000001', 'ORD00000000002', 'ORD00000000003', 'ORD00000000004', 'ORD00000000005', 'ORD00000000006', 'ORD00000000007', 'ORD00000000008', 'ORD00000000009', 'ORD00000001001')
LIMIT 440;

-- Manually fix ORD00000000009 total_amount (49.00 + 59.98 = 108.98)
UPDATE order_ SET total_amount = 108.98 WHERE order_id = 'ORD00000000009';


-- -------------------------------------------
-- TABLE: transaction (160 entries: one per order)
-- -------------------------------------------
SET @ROW_NUMBER = 1;
INSERT INTO transaction (transaction_id, amount, payment_type, order_id)
SELECT
    CONCAT('TRX', LPAD(t.ROW_NUMBER, 17, '0')),
    o.total_amount,
    CASE
        WHEN (t.ROW_NUMBER % 4) = 0 THEN 'CARD'
        WHEN (t.ROW_NUMBER % 4) = 1 THEN 'PAYPAL'
        WHEN (t.ROW_NUMBER % 4) = 2 THEN 'TRANSFER'
        ELSE 'WALLET'
    END,
    o.order_id
FROM
    order_ o
JOIN (
    SELECT @ROW_NUMBER := @ROW_NUMBER + 1 AS ROW_NUMBER, order_id
    FROM order_
    ORDER BY order_id
) AS t ON t.order_id = o.order_id
ORDER BY o.order_id;


-- =================================================================================
-- 6. RETURNS: RETURN_, RETURNED_ITEM (25 entries minimum: 30 entries)
-- =================================================================================

-- Orders with status 'RETURNED' (simulated 30 orders for returns)
INSERT INTO return_ (return_id, return_date, reason, refund_amount, order_id)
SELECT
    CONCAT('RET', LPAD(ROW_NUMBER() OVER(ORDER BY o.date_), 7, '0')),
    DATE_ADD(o.date_, INTERVAL 30 + (ROW_NUMBER() OVER(ORDER BY o.date_) * 3) HOUR),
    CASE
        WHEN (ROW_NUMBER() OVER(ORDER BY o.date_) % 5) = 0 THEN 'Size did not fit'
        WHEN (ROW_NUMBER() OVER(ORDER BY o.date_) % 5) = 1 THEN 'Color was different than expected'
        WHEN (ROW_NUMBER() OVER(ORDER BY o.date_) % 5) = 2 THEN 'Defective product'
        WHEN (ROW_NUMBER() OVER(ORDER BY o.date_) % 5) = 3 THEN 'Changed my mind'
        ELSE 'Item not as described'
    END,
    ROUND(o.total_amount * 0.95, 2), -- Refund 95% of total amount (small fee)
    o.order_id
FROM
    order_ o
WHERE o.status = 'RETURNED'
LIMIT 30;

-- Update the return_id for the first manual return (Kazuma)
UPDATE return_ SET return_id = 'RET0000001', refund_amount = 29.99 WHERE order_id = 'ORD00000000003'; -- Full refund for single item

-- -------------------------------------------
-- TABLE: returned_item (35 entries)
-- -------------------------------------------
-- RET0000001 (Kazuma: Tee)
INSERT INTO returned_item (SKU_code, return_id, quantity_returned) VALUES
('SKU000000000010', 'RET0000001', 1);

-- For all other returns, return one item per order line, with a quantity of 1 (simulated)
INSERT INTO returned_item (SKU_code, return_id, quantity_returned)
SELECT
    ol.SKU_code,
    r.return_id,
    1 -- Simplified: always return 1 unit per returned order line (if multiple exist)
FROM
    order_line ol
JOIN
    return_ r ON ol.order_id = r.order_id
WHERE
    r.return_id != 'RET0000001';


-- =================================================================================
-- 7. REVIEWS: REVIEW (50 entries minimum: 60 entries)
-- =================================================================================

-- -------------------------------------------
-- TABLE: review (60 entries)
-- -------------------------------------------
INSERT INTO review (review_id, rating, content, status, product_id, client_id) VALUES
-- Frieren's reviews (Jacket & Headset)
('REV000000001', 5, 'Perfect fit, truly slime-proof! Essential gear for any long journey. J''adore ce produit.', 'APPROVED', 'PRD000000000001', 'C000000001'),
('REV000000002', 4, 'Excellent sound quality, but the weight is a bit much for an elf. Still, très bon achat.', 'APPROVED', 'PRD000000000005', 'C000000001'),

-- Kazuma's review (Tee - Returned item, bad rating)
('REV000000003', 1, 'The fabric is low quality, not worthy of a true adventurer. The print looks faded.', 'APPROVED', 'PRD000000000003', 'C000000002'),

-- Toru's review (iStone)
('REV000000004', 5, 'Amazing device! It runs all my favourite dragon games smoothly. The camera is superb!', 'APPROVED', 'PRD000000000009', 'C000000004'),

-- Rimuru's review (ManaBoost, different client bought it)
('REV000000005', 5, 'The lemon flavor is surprisingly good! Gave me the boost I needed for my nation-building tasks.', 'APPROVED', 'PRD000000000002', 'C000000026'),

-- Goku's review (Tee)
('REV000000006', 4, 'Very comfortable for training, but I wish the sizes were bigger for Saiyans!', 'APPROVED', 'PRD000000000003', 'C000000063'),

-- Anonymous review (PENDING)
('REV000000007', 3, 'Just okay, nothing special. Waiting for the deluxe version.', 'PENDING', 'PRD000000010001', NULL);

-- 53 more reviews (random ratings, mixed status, random product/client)
SET @ROW_NUMBER = 1;
INSERT INTO review (review_id, rating, content, status, product_id, client_id)
SELECT
    CONCAT('REV', LPAD(t.ROW_NUMBER + 7, 8, '0')),
    FLOOR(RAND() * 5) + 1, -- Rating 1-5
    CASE
        WHEN (t.ROW_NUMBER % 3) = 0 THEN 'Excellent purchase, highly recommend it!'
        WHEN (t.ROW_NUMBER % 3) = 1 THEN 'Un peu déçu par la qualité pour le prix.'
        ELSE 'It arrived on time and functions as described. Satisfied.'
    END,
    CASE
        WHEN (t.ROW_NUMBER % 4) = 0 THEN 'PENDING'
        WHEN (t.ROW_NUMBER % 4) = 1 THEN 'REJECTED' -- Some rejections
        ELSE 'APPROVED'
    END,
    CONCAT('PRD', LPAD(FLOOR(RAND() * 100) + 1, 12, '0')),
    CASE WHEN (RAND() < 0.8) THEN CONCAT('C', LPAD(FLOOR(RAND() * 104) + 1, 9, '0')) ELSE NULL END -- 20% Anonymous
FROM (
    SELECT @ROW_NUMBER := @ROW_NUMBER + 1 AS ROW_NUMBER
    FROM information_schema.tables AS t1, information_schema.tables AS t2
    LIMIT 53
) AS t;


-- =================================================================================
-- 8. SUPPORT TICKETS: SUPPORT_TICKET, TICKET_HISTORY (30 entries minimum: 35 entries)
-- =================================================================================

-- -------------------------------------------
-- TABLE: support_ticket (35 entries)
-- -------------------------------------------
INSERT INTO support_ticket (ticket_id, subject, description, status, creation_date, client_id) VALUES
-- C000000001 (Frieren)
('TKT00000000001', 'Order ORD00000000002 tracking issue', 'The tracking number for my headset is not updating since 5 days ago.', 'IN_PROGRESS', '2024-03-27 10:00:00', 'C000000001'),

-- C000000002 (Kazuma)
('TKT00000000002', 'Refund for return RET0000001 not processed', 'My return was accepted a week ago but no refund is showing in my account.', 'RESOLVED', '2024-05-10 12:00:00', 'C000000002'),

-- C000000004 (Toru)
('TKT00000000003', 'iStone 15 Pro Max: Camera Glitch', 'The camera app crashes occasionally when attempting to use the ultra-wide lens.', 'CLOSED', '2024-10-05 14:30:00', 'C000000004'),

-- C000000005 (Rem)
('TKT00000000004', 'Question on next loyalty tier benefits', 'I was wondering what are the benefits for the next fidelity status.', 'CLOSED', '2024-04-01 09:00:00', 'C000000005'),

-- C000000016 (Deku)
('TKT00000000005', 'Cancelled item re-shipping request (ORD00000000005)', 'My pending order was cancelled by mistake, I still want the item.', 'OPEN', '2025-10-19 11:00:00', 'C000000016');

-- 30 more tickets (random status/client)
SET @ROW_NUMBER = 1;
INSERT INTO support_ticket (ticket_id, subject, description, status, creation_date, client_id)
SELECT
    CONCAT('TKT', LPAD(t.ROW_NUMBER + 5, 11, '0')),
    CONCAT('Inquiry regarding product ', LPAD(FLOOR(RAND() * 100) + 1, 12, '0')),
    CONCAT('Detailed description of the issue ', t.ROW_NUMBER, '...'),
    CASE
        WHEN (t.ROW_NUMBER % 4) = 0 THEN 'OPEN'
        WHEN (t.ROW_NUMBER % 4) = 1 THEN 'IN_PROGRESS'
        WHEN (t.ROW_NUMBER % 4) = 2 THEN 'CLOSED'
        ELSE 'RESOLVED'
    END,
    DATE_ADD(DATE_ADD('2024-01-01 00:00:00', INTERVAL t.ROW_NUMBER * 5 DAY), INTERVAL t.ROW_NUMBER % 24 HOUR),
    CONCAT('C', LPAD(FLOOR(RAND() * 104) + 1, 9, '0'))
FROM (
    SELECT @ROW_NUMBER := @ROW_NUMBER + 1 AS ROW_NUMBER
    FROM information_schema.tables AS t1, information_schema.tables AS t2
    LIMIT 30
) AS t;

-- -------------------------------------------
-- TABLE: ticket_history (80 entries - ~2-3 per ticket)
-- -------------------------------------------
INSERT INTO ticket_history (ticket_id, line_id, date_time, exchange_content) VALUES
-- TKT00000000001 (Tracking Issue)
('TKT00000000001', 1, '2024-03-27 10:00:00', 'Client: Hello, the tracking number is stuck. Can you check the status please?'),
('TKT00000000001', 2, '2024-03-27 11:30:00', 'Agent: We apologize. The package is currently held at customs in Germany. We are investigating and will update you shortly.'),
('TKT00000000001', 3, '2024-03-29 09:00:00', 'Agent: Update: Customs clearance is complete. New tracking updates should appear within 24h.'),

-- TKT00000000002 (Refund not processed)
('TKT00000000002', 1, '2024-05-10 12:00:00', 'Client: Where is my money? I need the refund processed ASAP!'),
('TKT00000000002', 2, '2024-05-10 13:00:00', 'Agent: Apologies for the delay. The refund was manually triggered just now. It should appear in 3-5 business days.'),
('TKT00000000002', 3, '2024-05-15 15:00:00', 'Client: Received the refund, thank you. Ticket resolved.'),

-- TKT00000000003 (Camera Glitch)
('TKT00000000003', 1, '2024-10-05 14:30:00', 'Client: The ultra-wide camera crashes frequently on my new iStone 15 Pro Max. Please help.'),
('TKT00000000003', 2, '2024-10-05 16:00:00', 'Agent: Could you please try a force restart and check for any OS updates?'),
('TKT00000000003', 3, '2024-10-06 10:00:00', 'Client: Update: The latest OS update seems to have fixed the issue. Thanks!'),

-- TKT00000000004 (Loyalty Question)
('TKT00000000004', 1, '2024-04-01 09:00:00', 'Client: I am aiming for the next loyalty tier. What are the benefits?'),
('TKT00000000004', 2, '2024-04-01 10:30:00', 'Agent: The "Dragon Elite" tier offers free express shipping and 10% off all electronic items. We sent you a full PDF by email.'),

-- TKT00000000005 (Cancelled order)
('TKT00000000005', 1, '2025-10-19 11:00:00', 'Client: Please check ORD00000000005. It was placed this morning and is already CANCELLED. I want it re-activated.'),
('TKT00000000005', 2, '2025-10-19 11:30:00', 'Agent: We see the issue. It was cancelled by our automated system due to a stock temporary issue. We are escalating the matter to re-initiate the order from WH000004.');

-- 75 more random history entries for the remaining 30 tickets
-- Using a complex subquery/join to generate a sequence of ticket history records safely in MySQL
INSERT INTO ticket_history (ticket_id, line_id, date_time, exchange_content)
SELECT
    t.ticket_id,
    @line_num := IF(@prev_ticket = t.ticket_id, @line_num + 1, 1) AS line_id,
    @prev_ticket := t.ticket_id,
    DATE_ADD(t.creation_date, INTERVAL FLOOR(RAND() * 5) + 1 HOUR) AS date_time,
    CASE
        WHEN (t.id_num % 5) = 0 THEN 'Client follow-up: Is there any update on this ticket?'
        WHEN (t.id_num % 5) = 1 THEN 'Agent update: We are still investigating the root cause with our technical team.'
        WHEN (t.id_num % 5) = 2 THEN 'Client response: Je comprends, merci pour l''information.'
        WHEN (t.id_num % 5) = 3 THEN 'Agent: Please confirm if your issue has been resolved after the last step.'
        ELSE 'Internal note: escalated to Level 2 support.'
    END AS exchange_content
FROM (
    SELECT
        st.ticket_id,
        st.creation_date,
        @row_id := @row_id + 1 AS id_num
    FROM
        support_ticket st
    CROSS JOIN (
        SELECT @row_id := 0
        FROM information_schema.tables AS t1, information_schema.tables AS t2
        LIMIT 75
    ) AS s
    WHERE st.ticket_id NOT IN ('TKT00000000001', 'TKT00000000002', 'TKT00000000003', 'TKT00000000004', 'TKT00000000005')
    ORDER BY st.ticket_id, id_num
) AS t
JOIN (SELECT @line_num := 0, @prev_ticket := '') AS init_vars
ORDER BY t.ticket_id, date_time;


-- =================================================================================
-- 9. DISCOUNT MAPPINGS: APPLICABLE_CATEGORY (10 entries minimum: 15 entries)
-- =================================================================================

-- -------------------------------------------
-- TABLE: applicable_category (15 entries)
-- -------------------------------------------
INSERT INTO applicable_category (category_id, code_id) VALUES
(1, 'DSC0000001'), -- SUMMER25 on Apparel
(2, 'DSC0000001'), -- SUMMER25 on Footwear
(11, 'DSC0000007'), -- APPAREL20 on T-Shirts (Subcategory of Apparel)
(12, 'DSC0000012'), -- SHOES10 on Sneakers (Subcategory of Footwear
(3, 'DSC0000006'), -- TECH10 on Electronics
(4, 'DSC0000006'), -- TECH10 on Gaming
(7, 'DSC0000004'), -- FIXED10 on Accessories
(5, 'DSC0000002'), -- WELCOME15 on Food & Beverage
(6, 'DSC0000002'), -- WELCOME15 on Home Goods
(8, 'DSC0000002'), -- WELCOME15 on Health & Wellness
(1, 'DSC0000005'), -- VIP50 on Apparel (High value fixed discount)
(2, 'DSC0000005'), -- VIP50 on Footwear
(10, 'DSC0000008'), -- GIFT5 on Collectibles
(14, 'DSC0000002'), -- WELCOME15 on Energy Drinks
(15, 'DSC0000002'); -- WELCOME15 on Mugs & Drinkware


-- Clean up temporary table
DROP TEMPORARY TABLE IF EXISTS temp_series;

-- End of SQL Script