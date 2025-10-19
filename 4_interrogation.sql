-- Interrogation de la Base de Données - 

-- Scénario 1 Marketing
-- Rôle: Analyste Marketing chez "Impact"
-- On veut préparer la nouvelle campagne promotionnelle pour le trimestre prochain.
-- Donc on veut:
-- 1. Comprendre le comportement des clients : identifier les clients les plus fidèles, leurs préférences et leur répartition géographique
-- 2. Analyser les performances des produits : identifier les produits les plus vendus, les moins populaires et ceux qui génèrent le plus de revenus
-- 3. Évaluer l'efficacité des promotions passées : analyser l'utilisation des codes de réduction
-- 4. Optimiser la communication : segmenter les clients pour des campagnes ciblées

-- -------------------------------------------------------------------------------------
-- Liste des clients fidèles (avec statut de fidélité) pour une campagne exclusive
-- On sélectionne les noms et emails des clients ayant le statut de fidélité pour leur envoyer une offre spéciale et on tri par nom de famille
SELECT 
	first_name,
    last_name,
    email
FROM client
WHERE fidelity_status = TRUE
ORDER BY last_name, first_name;

-- -------------------------------------------------------------------------------------
-- Recherche des produits de la marque "Adibas" ou "Nikéa" pour une promotion croisée
SELECT
    p.name AS product_name,
    b.name AS brand_name
FROM product p
JOIN brand b ON p.brand_id = b.brand_id
WHERE b.name IN ('Adibas', 'Nikéa');

-- -------------------------------------------------------------------------------------
-- Trouver les commandes passées durant le premier trimestre 2024 pour analyse saisonnière
SELECT
    order_id,
    date_,
    total_amount,
    status
FROM order_
WHERE date_ BETWEEN '2024-01-01 00:00:00' AND '2024-03-31 23:59:59'
ORDER BY date_ DESC;


-- -------------------------------------------------------------------------------------
-- Afficher les villes uniques où nous avons des clients pour la planification logistique
SELECT DISTINCT
    pc.city,
    co.country_name
FROM client_address ca
JOIN location l ON ca.location_id = l.location_id
JOIN postal_code pc ON l.postal_code_id = pc.postal_code_id
JOIN country co ON pc.country_id = co.country_id
ORDER BY co.country_name, pc.city;

-- -----------------------------------------------------------------------------------------

-- Calculer le chiffre d'affaires total par marque pour identifier les marques les plus rentables
SELECT
    b.name AS brand_name,
    SUM(ol.quantity_ordered * ol.unit_price_paid) AS total_revenue
FROM order_line ol
JOIN article a ON ol.SKU_code = a.SKU_code
JOIN product p ON a.product_id = p.product_id
JOIN brand b ON p.brand_id = b.brand_id
GROUP BY b.name
ORDER BY total_revenue DESC;

-- -------------------------------------------------------------------------------------
-- Compter le nombre de clients par pays pour comprendre la répartition géographique
SELECT
    co.country_name,
    COUNT(DISTINCT c.client_id) AS number_of_clients
FROM client c
JOIN client_address ca ON c.client_id = ca.client_id
JOIN location l ON ca.location_id = l.location_id
JOIN postal_code pc ON l.postal_code_id = pc.postal_code_id
JOIN country co ON pc.country_id = co.country_id
GROUP BY co.country_name
ORDER BY number_of_clients DESC;

-- -------------------------------------------------------------------------------------
-- Trouver le montant moyen par commande pour les commandes livrées

SELECT
    AVG(total_amount) AS average_order_value
FROM order_
WHERE status = 'DELIVERED';

-- -------------------------------------------------------------------------------------
--  Identifier les clients ayant dépensé plus de 500€ au total / mercii au clients "fidèles"
SELECT
    c.client_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM client c
JOIN order_ o ON c.client_id = o.client_id
WHERE o.status = 'DELIVERED'
GROUP BY c.client_id, c.first_name, c.last_name
HAVING total_spent > 500
ORDER BY total_spent DESC;

-- -------------------------------------------------------------------------------------
-- Trouver le nombre de produits différents par catégorie
SELECT
    cat.name AS category_name,
    COUNT(p.product_id) AS number_of_products
FROM product p
JOIN category cat ON p.category_id = cat.category_id
GROUP BY cat.name
ORDER BY number_of_products DESC;


-- -------------------------------------------------------------------------------------
-- Lister les catégories et leurs sous-catégories
SELECT
    parent.name AS parent_category,
    child.name AS sub_category
FROM category parent
JOIN category child ON parent.category_id = child.category_parent_id
ORDER BY parent.name, child.name;

-- -------------------------------------------------------------------------------------
-- 3.5 :Lister tous les produits et le nombre de fois où ils ont été commandés, même ceux jamais vendus
SELECT
    p.name AS product_name,
    SUM(ol.quantity_ordered) AS total_sold
FROM product p
LEFT JOIN article a ON p.product_id = a.product_id
LEFT JOIN order_line ol ON a.SKU_code = ol.SKU_code
GROUP BY p.name
ORDER BY total_sold DESC;


-- -------------------------------------------------------------------------------------
-- Trouver les produits qui n'ont jamais été retournés.

SELECT
    p.product_id,
    p.name
FROM
    product p
WHERE NOT EXISTS (
    SELECT 1
    FROM returned_item ri
    JOIN article a ON ri.SKU_code = a.SKU_code
    WHERE a.product_id = p.product_id
);


-- ------------------------------------------------------------------------------------
-- Trouver les produits les plus chers de tout le catalogue.
SELECT
    p.name,
    pr.sale_price
FROM product p
JOIN article a ON p.product_id = a.product_id
JOIN price pr ON a.SKU_code = pr.SKU_code
WHERE
    pr.sale_price >= ALL (
        SELECT sale_price FROM price
    );

-- -------------------------------------------------------------------------------------
-- Calculer le chiffre d'affaires moyen par pays
SELECT
    co.country_name,
    AVG(ClientRevenue.total_spent) AS average_revenue_per_client
FROM
    (
        SELECT c.client_id, SUM(o.total_amount) AS total_spent
        FROM client c
        JOIN order_ o ON c.client_id = o.client_id
        GROUP BY c.client_id
    ) AS ClientRevenue
JOIN client_address ca ON ClientRevenue.client_id = ca.client_id AND ca.is_default = TRUE
JOIN location l ON ca.location_id = l.location_id
JOIN postal_code pc ON l.postal_code_id = pc.postal_code_id
JOIN country co ON pc.country_id = co.country_id
GROUP BY co.country_name
ORDER BY average_revenue_per_client DESC;


-- -------------------------------------------------------------------------

-- Scénario 2 : Enquête sur une Suspicion de Fraude (Rôle : Analyste Fraude)
-- Objectif : Confirmer ou infirmer une suspicion de fraude aux retours suite à une alerte de l'entrepôt
-- Contexte : Le ticket TICKET011 signale une boîte vide pour le retour RET016

-- on retrouve d'abord l'id du client qui a fait le retour
SELECT * 
FROM return_ r
JOIN order_ o ON r.order_id = o.order_id
wHERE return_id = 'RET016';

-- on pourrait faire des requetes imbriquée pour avoir l'id du client suspect mais il est plus simple de juste noter l'id du client apres cette requete
-- client CL106
-- -------------------------------------------------------------------------------------
-- Étape 1: Obtenir une vue d'ensemble du client suspect (CL106) à partir du ticket
-- L'analyste commence par rassembler toutes les informations de base sur le client
-- -------------------------------------------------------------------------------------
SELECT * FROM client WHERE client_id = 'CL106';
SELECT * FROM client_address WHERE client_id = 'CL106';

-- -------------------------------------------------------------------------------------
-- Étape 2 : Examiner l'historique complet des commandes et des retours du client.
-- L'analyste cherche des montants élevés, des retours fréquents, ou tout autre schéma inhabituel.
-- -------------------------------------------------------------------------------------
SELECT
    o.order_id,
    o.date_ AS order_date,
    o.total_amount,
    o.status,
    r.return_id,
    r.return_date,
    r.reason AS return_reason,
    r.refund_amount
FROM order_ o
LEFT JOIN return_ r ON o.order_id = r.order_id
WHERE o.client_id = 'CL106'
ORDER BY o.date_ DESC;

-- Observation: Le client a passé 2 commandes de grande valeur et les a retournées rapidement; c'est un premier red flag

-- -------------------------------------------------------------------------------------
-- Étape 3 : Croiser les informations avec les tickets de support.
-- nous cherchons des communications qui pourraient fortifier la suspicion de fraude
-- -------------------------------------------------------------------------------------
SELECT
    st.ticket_id,
    st.subject,
    st.description,
    st.status,
    th.date_time,
    th.exchange_content
FROM support_ticket st
JOIN ticket_history th ON st.ticket_id = th.ticket_id
WHERE st.client_id = 'CL106'
ORDER BY th.date_time;
-- Confirmation: Le ticket TICKET011 confirme l'alerte de l'entrepot

-- -------------------------------------------------------------------------------------
-- Étape 4 : Recherche de liens : d'autres clients ont-ils utilisé les mêmes adresses ?
-- on vérifie si les adresses du suspect sont utilisées par d'autres comptes, ce qui pourrait indiquer un réseau
-- On utilise une sous-requête pour trouver toutes les adresses du suspect.
-- -------------------------------------------------------------------------------------
SELECT
    c.client_id,
    c.email,
    ca.location_id
FROM client c
JOIN client_address ca ON c.client_id = ca.client_id
WHERE ca.location_id IN (
	SELECT location_id FROM client_address WHERE client_id = 'CL106'
    )
AND c.client_id != 'CL106';
-- Aucun autre client n'utilise ces adresses. Le fraudeur semble opérer seul pour l'instant

-- -------------------------------------------------------------------------------------
-- Conclusion de l'enquête :
-- Le client CL106 présente un comportement très suspect: commandes à haute valeur systématiquement retournées,
-- Avec au moins un retour confirmé comme frauduleux(boîte vide)
-- Décision : Bloquer le compte client CL106 et les adresses associées
-- =====================================================================================




-- Scénario 3 : Résolution d'une Plainte Client "Complexe" (Rôle: Agent de Support)
-- Objectif : Résoudre l'ensemble des problèmes soulevés par la cliente fidèle Frieren (CL001) dans le ticket TICKET012.
-- Problèmes : 1. Surcharge sur la commande ORD001. 2. Remboursement manquant pour le retour RET018.
-- -------------------------------------------------------------------------------------
-- Étape 1 : Vérifier l'identité et l'historique de la cliente pour évaluer son importance (faroritisme ?)
-- L'agent confirme qu'il s'agit bien d'une cliente fidèle et de longue date
-- -------------------------------------------------------------------------------------
SELECT
    client_id,
    email,
    first_name,
    last_name,
    fidelity_status,
    subscribtion_date
FROM client
WHERE client_id = 'CL001';
-- Observation : Cliente fidèle, inscrite depuis 2022. Sa plainte doit être traitée avec la plus haute priorité :)

-- -------------------------------------------------------------------------------------
-- Etape 2 : Reconstituer la commande ORD001 pour vérifier le problème de surcharge
-- on calcule manuellement le total qui aurait dû être facturé et le compare au total payé.
-- -------------------------------------------------------------------------------------
-- 2.a: Voir le montant qui a été facturé.
SELECT order_id, total_amount FROM order_ WHERE order_id = 'ORD001'; -- 189.97
-- 2.b Calculer le montant qui aurait dû être facturé
SELECT
    SUM(ol.quantity_ordered * ol.unit_price_paid) AS correct_total
FROM order_line ol
WHERE ol.order_id = 'ORD001'; -- 149.97
-- Conclusin: La commande a un total de 189.97€ alors que la somme des lignes fait 149.97€. Il y a bien eu une erreur

-- -------------------------------------------------------------------------------------
-- Etape 3 : Vérifier le statut du retour RET018 et l'absence de remboursement
-- L'agent recherche une transaction financière liée à ce retour
-- -------------------------------------------------------------------------------------
-- 3.a: coonfirmer les détails du retour
SELECT * FROM return_ WHERE return_id = 'RET018' AND order_id = 'ORD001';
-- 3.b: chercher une transaction de remboursement. Il n'y a pas de lien direct, il faut chercher par montant et date.
-- on utilise NOT EXISTS pour confirmer qu'aucune transaction ne correspond au remboursement
SELECT
    r.return_id,
    r.refund_amount
FROM return_ r
WHERE r.return_id = 'RET018'
    AND NOT EXISTS (
        SELECT 1
        FROM transaction t
        -- On cherche une transaction négative pour le meme order_id que celui de la cliente
        WHERE t.order_id = r.order_id AND t.amount = -r.refund_amount
    );
-- Conclusion: Le retour RET018 d'un montant de 29.99€ a bien été enregistré, mais aucune transaction de remboursement n'a été effectuée

-- -------------------------------------------------------------------------------------
-- Étape 4 : Consolider toutes les informations avant de répondre à la cliente.
-- L'agent résume l'historique complet pour avoir une vue à 360°.
-- -------------------------------------------------------------------------------------
SELECT 'Order' AS type, order_id AS id, date_ AS event_date, total_amount AS amount FROM order_ WHERE client_id = 'CL001'
UNION ALL
SELECT 'Return' AS type, return_id AS id, return_date AS event_date, -refund_amount AS amount FROM return_ r JOIN order_ o ON r.order_id = o.order_id WHERE o.client_id = 'CL001'
UNION ALL
SELECT 'Transaction' AS type, transaction_id AS id, o.date_ AS event_date, amount FROM transaction t JOIN order_ o ON t.order_id = o.order_id WHERE o.client_id = 'CL001'
ORDER BY event_date DESC;


