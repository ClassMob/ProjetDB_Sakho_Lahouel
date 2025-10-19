CREATE SCHEMA impactdb;
USE impactdb;

CREATE TABLE client (
    client_id VARCHAR(10), -- ID du client Alphanumérique 10
    email VARCHAR(100) NOT NULL, -- Adresse email du client Texte 100
    first_name VARCHAR(50) NOT NULL, -- Prénom du client Texte 50
    last_name VARCHAR(50) NOT NULL, -- Nom de famille du client Texte 50
    phone_number VARCHAR(20) NOT NULL, -- Numéro de téléphone du client (non spécifié dans le PDF, taille estimée)
    password VARCHAR(255) NOT NULL, -- Mot de passe du client Texte 255
    fidelity_status BOOLEAN NOT NULL DEFAULT FALSE, -- Statut programme fidélité Booléen 1
    subscribtion_date TIMESTAMP -- Date d'inscription du client Date 10
);

CREATE TABLE comm_preference_type (
    type_id SMALLINT, -- Identifiant interne (non spécifié dans le PDF)
    label VARCHAR(50) NOT NULL, -- Nom ou libellé (non spécifié dans le PDF)
    description VARCHAR(255) -- Description (non spécifié dans le PDF)
);

CREATE TABLE brand (
    brand_id SMALLINT, -- Identifiant de la marque (non spécifié dans le PDF)
    name VARCHAR(50) NOT NULL -- Marque de l'article Texte 50
);

CREATE TABLE category (
    category_id SMALLINT, -- Identifiant de catégorie (non spécifié dans le PDF)
    name VARCHAR(50) NOT NULL, -- Catégorie principale Texte 50
    category_parent_id SMALLINT -- Sous-catégorie Texte 50 (référence parent)
);

CREATE TABLE discount_code (
    code_id VARCHAR(10), -- ID code de réduction Alphanumérique 10
    code VARCHAR(10) NOT NULL, -- Code du bon de réduction Alphanumérique 10
    value DECIMAL(5, 2) NOT NULL, -- Valeur du code de réduction Numérique 5,2
    type VARCHAR(10) NOT NULL, -- Type de réduction (fixe/%) Texte 10
    start_date TIMESTAMP NOT NULL, -- Date de début de validité Date 10
    end_date TIMESTAMP NOT NULL -- Date de fin de validité Date 10
);

CREATE TABLE support_ticket (
    ticket_id VARCHAR(12), -- ID du ticket support Alphanumérique 12
    subject VARCHAR(100) NOT NULL, -- Sujet du ticket Texte 100
    description VARCHAR(1000), -- Description du ticket Texte 1000
    status VARCHAR(20) NOT NULL, -- Statut du ticket Texte 20
    creation_date TIMESTAMP NOT NULL, -- Date de création du ticket Date 10
    client_id VARCHAR(10) NOT NULL -- ID du client Alphanumérique 10
);

CREATE TABLE ticket_history (
    ticket_id VARCHAR(12), -- ID du ticket support Alphanumérique 12
    line_id SMALLINT, -- Ligne interne (non spécifié dans le PDF)
    date_time TIMESTAMP NOT NULL, -- Date de l'échange Date 10
    exchange_content VARCHAR(2000) NOT NULL -- Contenu de l'échange Texte (non spécifié, 2000)
);

CREATE TABLE location (
    location_id VARCHAR(8), -- ID de l'entrepôt/magasin Alphanumérique 8
    address_line VARCHAR(200) NOT NULL, -- Ligne d'adresse Texte 200
    postal_code_id INT NOT NULL
);
CREATE TABLE postal_code(
	postal_code_id INT,
    postal_code VARCHAR(10) NOT NULL, -- Code postal Alphanumérique 10
    city VARCHAR(50) NOT NULL , -- Ville Texte 50
    country_id INT NOT NULL
);
CREATE TABLE country(
	country_id INT,
    country_name VARCHAR(50) NOT NULL-- Pays Texte 50
);


CREATE TABLE client_address (
    client_address_id VARCHAR(10), -- ID de l'adresse de livraison Alphanumérique 10
    is_default BOOLEAN NOT NULL DEFAULT FALSE, -- Statut adresse par défaut Booléen 1
    location_id VARCHAR(8) NOT NULL, -- ID de l'entrepôt/magasin Alphanumérique 8
    client_id VARCHAR(10) NOT NULL-- ID du client Alphanumérique 10
);

CREATE TABLE product (
    product_id VARCHAR(15), -- Référence de l'article Alphanumérique 15
    name VARCHAR(100) NOT NULL, -- Nom de l'article Texte 100
    description VARCHAR(1000), -- Description de l'article Texte 1000
    category_id SMALLINT NOT NULL, -- Catégorie principale Texte 50
    brand_id SMALLINT NOT NULL-- Marque de l'article Texte 50
);

CREATE TABLE warehouse (
    warehouse_id VARCHAR(8), -- ID de l'entrepôt/magasin Alphanumérique 8
    name VARCHAR(50) NOT NULL, -- Nom de l'entrepôt/magasin Texte 50
    location_id VARCHAR(8) NOT NULL -- ID de localisation (référence au même type)
);

CREATE TABLE article (
    SKU_code VARCHAR(15), -- Référence de l'article Alphanumérique 15
    size VARCHAR(5) NOT NULL, -- Taille de l'article Alphanumérique 5
    color VARCHAR(30) NOT NULL, -- Couleur de l'article Texte 30
    product_id VARCHAR(15) NOT NULL -- Référence de l'article Alphanumérique 15
);

CREATE TABLE price (
    SKU_code VARCHAR(15), -- Référence de l'article Alphanumérique 15
    start_date TIMESTAMP NOT NULL, -- Date de début de validité Date 10
    sale_price DECIMAL(8, 2) NOT NULL, -- Prix de base Numérique 8,2
    end_date TIMESTAMP NOT NULL -- Date de fin de validité Date 10
);

CREATE TABLE order_ (
    order_id VARCHAR(12), -- ID de la commande Alphanumérique 12
    date_ TIMESTAMP NOT NULL, -- Date de la commande Date 10
    total_amount DECIMAL(10, 2) NOT NULL, -- Montant total de la commande Numérique 10,2
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- Statut de la commande Texte 20
    client_address_id VARCHAR(10) NOT NULL, -- ID de l'adresse de livraison Alphanumérique 10
    client_id VARCHAR(10) NOT NULL -- ID du client Alphanumérique 10
);

CREATE TABLE transaction (
    transaction_id VARCHAR(20), -- ID de la transaction Alphanumérique 20
    amount DECIMAL(10, 2) NOT NULL, -- Montant de la transaction Numérique 10,2
    payment_type VARCHAR(30) NOT NULL, -- Type de paiement Texte 30
    order_id VARCHAR(12) NOT NULL -- ID de la commande Alphanumérique 12
);

CREATE TABLE return_ (
    return_id VARCHAR(10), -- ID du retour Alphanumérique 10
    return_date TIMESTAMP NOT NULL, -- Date de retour Date 10
    reason VARCHAR(150), -- Raison du retour Texte 150
    refund_amount DECIMAL(10, 2) NOT NULL, -- Montant du remboursement Numérique 10,2
    order_id VARCHAR(12) NOT NULL -- ID de la commande Alphanumérique 12
);

CREATE TABLE review (
    review_id VARCHAR(10), -- ID de l'avis Alphanumérique 10
    rating SMALLINT NOT NULL, -- Note (sur 5) Numérique 1
    content VARCHAR(500), -- Contenu de l'avis Texte 500
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- Statut de l'avis Texte 20
    product_id VARCHAR(15) NOT NULL, -- Référence de l'article Alphanumérique 15
    client_id VARCHAR(10) -- ID du client Alphanumérique 10
);

CREATE TABLE client_preference (
    client_id VARCHAR(10), -- ID du client Alphanumérique 10
    type_id SMALLINT -- Type de préférence (non spécifié dans le PDF)
);

CREATE TABLE stock (
    SKU_code VARCHAR(15), -- Référence de l'article Alphanumérique 15
    warehouse_id VARCHAR(8), -- ID de l'entrepôt/magasin Alphanumérique 8
    quantity SMALLINT NOT NULL -- Quantité en stock Numérique 5
);

CREATE TABLE order_line (
    SKU_code VARCHAR(15), -- Référence de l'article Alphanumérique 15
    order_id VARCHAR(12), -- ID de la commande Alphanumérique 12
    quantity_ordered SMALLINT NOT NULL, -- Quantité d'article commandée Numérique 4
    unit_price_paid DECIMAL(10, 2) NOT NULL -- Prix payé unitaire Numérique 10,2
);

CREATE TABLE applicable_category (
    category_id SMALLINT, -- Catégorie principale Texte 50
    code_id VARCHAR(10) -- ID code de réduction Alphanumérique 10
);

CREATE TABLE returned_item (
    SKU_code VARCHAR(15), -- Référence de l'article Alphanumérique 15
    return_id VARCHAR(10), -- ID du retour Alphanumérique 10
    quantity_returned SMALLINT NOT NULL -- Quantité retournée Numérique 4
);