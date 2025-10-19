use perpleksitydb;
-- Client
ALTER TABLE Client
    ADD CONSTRAINT PK_Client PRIMARY KEY (client_id),
    ADD CONSTRAINT UK_Client_Email UNIQUE (email);

-- comm_preference_type

ALTER TABLE comm_preference_type
    ADD CONSTRAINT PK_CommPreferenceType PRIMARY KEY (type_id),
    ADD CONSTRAINT UK_CommPreferenceType_Label UNIQUE (label);

-- TABLE: brand
ALTER TABLE brand
    ADD CONSTRAINT PK_Brand PRIMARY KEY (brand_id),
    ADD CONSTRAINT UK_Brand_Name UNIQUE (name);

-- TABLE: category
ALTER TABLE category
    ADD CONSTRAINT PK_Category PRIMARY KEY (category_id);
ALTER TABLE category    
    ADD CONSTRAINT UK_Category_Name UNIQUE (name),
    ADD CONSTRAINT FK_Category_ParentCategory FOREIGN KEY (category_parent_id)
        REFERENCES category (category_id)
        ON DELETE SET NULL -- si la catégorie parente est supprimée, la sous-catégorie devient principale (NULL)
        ON UPDATE CASCADE;


-- TABLE: discount_code
ALTER TABLE discount_code
    ADD CONSTRAINT PK_DiscountCode PRIMARY KEY (code_id),
    ADD CONSTRAINT UK_DiscountCode_Code UNIQUE (code),
    ADD CONSTRAINT CHK_DiscountCode_Dates CHECK (end_date >= start_date),
    ADD CONSTRAINT CHK_DiscountCode_ValuePositive CHECK (value >= 0),
    ADD CONSTRAINT CHK_DiscountCode_Type CHECK (type IN ('PERCENT', 'FIXED'));



-- TABLE: country
ALTER TABLE country
    ADD CONSTRAINT PK_Country PRIMARY KEY (country_id),
    ADD CONSTRAINT UK_Country_Name UNIQUE (country_name);


-- TABLE: postal_code
ALTER TABLE postal_code
    ADD CONSTRAINT PK_PostalCode PRIMARY KEY (postal_code_id),
    ADD CONSTRAINT UK_PostalCode_PostalCodeCountry UNIQUE (postal_code, country_id),
    ADD CONSTRAINT FK_PostalCode_Country FOREIGN KEY (country_id)
        REFERENCES country (country_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE;

-- -------------------------------------------
-- TABLE: location
-- -------------------------------------------
ALTER TABLE location
    ADD CONSTRAINT PK_Location PRIMARY KEY (location_id),
    ADD CONSTRAINT FK_Location_PostalCode FOREIGN KEY (postal_code_id)
        REFERENCES postal_code (postal_code_id)
        ON DELETE RESTRICT -- protecting the locations 
        ON UPDATE CASCADE;



-- TABLE: support_ticket
ALTER TABLE support_ticket
    ADD CONSTRAINT PK_SupportTicket PRIMARY KEY (ticket_id), 
    ADD CONSTRAINT FK_SupportTicket_Client FOREIGN KEY (client_id)
        REFERENCES Client (client_id)
        ON DELETE CASCADE -- si le client est supprimé, l'historique de ses tickets n'est plus pertinent, no come back
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_SupportTicket_Status CHECK (status IN ('OPEN', 'IN_PROGRESS', 'CLOSED', 'RESOLVED'));


-- TABLE: warehouse
ALTER TABLE warehouse
    ADD CONSTRAINT PK_Warehouse PRIMARY KEY (warehouse_id),
    ADD CONSTRAINT UK_Warehouse_Name UNIQUE (name),
    ADD CONSTRAINT FK_Warehouse_Location FOREIGN KEY (location_id)
        REFERENCES location (location_id)
        ON DELETE RESTRICT -- Protège les emplacements utilisés
        ON UPDATE CASCADE;


-- TABLE: product
ALTER TABLE product
    ADD CONSTRAINT PK_Product PRIMARY KEY (product_id),
    ADD CONSTRAINT FK_Product_Category FOREIGN KEY (category_id)
        REFERENCES category (category_id)
        ON DELETE RESTRICT -- impossible de suppremersi des produits existent
        ON UPDATE CASCADE,
    ADD CONSTRAINT FK_Product_Brand FOREIGN KEY (brand_id)
        REFERENCES brand (brand_id)
        ON DELETE RESTRICT -- ici aussi
        ON UPDATE CASCADE;


-- TABLE: article (SKU)
ALTER TABLE article
    ADD CONSTRAINT PK_Article PRIMARY KEY (SKU_code),
    ADD CONSTRAINT FK_Article_Product FOREIGN KEY (product_id)
        REFERENCES product (product_id)
        ON DELETE CASCADE -- si le produit est supprime toutes les variations disparaissent
        ON UPDATE CASCADE;


-- TABLE: client_address 
ALTER TABLE client_address
    ADD CONSTRAINT PK_ClientAddress PRIMARY KEY (client_address_id),
    ADD CONSTRAINT UK_ClientAddress_Unique_Location UNIQUE (client_id, location_id),
    
    ADD CONSTRAINT FK_ClientAddress_Client FOREIGN KEY (client_id)
        REFERENCES Client (client_id)
        ON DELETE CASCADE -- l'adresse n'existe pas sans le client
        ON UPDATE CASCADE,
    ADD CONSTRAINT FK_ClientAddress_Location FOREIGN KEY (location_id)
        REFERENCES location (location_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_ClientAddress_IsDefault CHECK (is_default IN (0, 1));
    
    
-- TABLE: order_
ALTER TABLE order_
    ADD CONSTRAINT PK_Order PRIMARY KEY (order_id),
    ADD CONSTRAINT FK_Order_Client FOREIGN KEY (client_id)
        REFERENCES Client (client_id)
        ON DELETE RESTRICT    -- le client ne doit pas être supprimé tant qu'il a des commandes
        ON UPDATE CASCADE,
    -- impossoble de supprimer une adresse si commande en cours pour cette adresse par mesure de sécurité; RESTRICT est plus sûr.
    ADD CONSTRAINT FK_Order_ClientAddress FOREIGN KEY (client_address_id)
        REFERENCES client_address (client_address_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_Order_Status CHECK (status IN ('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED'));



-- TABLE: transaction
ALTER TABLE transaction
    ADD CONSTRAINT PK_Transaction PRIMARY KEY (transaction_id),
    ADD CONSTRAINT FK_Transaction_Order FOREIGN KEY (order_id)
        REFERENCES order_ (order_id)
        ON DELETE CASCADE    -- La transaction dépend entièrement de la commande.
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_Transaction_PaymentType CHECK (payment_type IN ('CARD', 'PAYPAL', 'TRANSFER', 'WALLET','REFUND'));


-- TABLE: return_
ALTER TABLE return_
    ADD CONSTRAINT PK_Return PRIMARY KEY (return_id),
    ADD CONSTRAINT FK_Return_Order FOREIGN KEY (order_id)
        REFERENCES order_ (order_id)
        ON DELETE RESTRICT -- Protège l'historique de la commande
        ON UPDATE CASCADE;


-- TABLE: review
ALTER TABLE review
    ADD CONSTRAINT PK_Review PRIMARY KEY (review_id),
    -- un avis est lié au produit et au client
    ADD CONSTRAINT FK_Review_Client FOREIGN KEY (client_id)
        REFERENCES Client (client_id)
        ON DELETE SET NULL -- si le client est supprimé l'avis reste anonyme
        ON UPDATE CASCADE,
    ADD CONSTRAINT FK_Review_Product FOREIGN KEY (product_id)
        REFERENCES product (product_id)
        ON DELETE CASCADE -- si le produit est supprimé, les avis le concernant aussi sont supp
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_Review_Rating CHECK (rating BETWEEN 1 AND 5),
    ADD CONSTRAINT CHK_Review_Status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED'));




-- TABLE: TICKET_HISTORY 

ALTER TABLE ticket_history
    ADD CONSTRAINT PK_TicketHistory PRIMARY KEY (ticket_id, line_id),
    ADD CONSTRAINT FK_TicketHistory_Ticket FOREIGN KEY (ticket_id)
        REFERENCES support_ticket (ticket_id)
        ON DELETE CASCADE  -- L'historique des lignes dépend du ticket parent.
        ON UPDATE CASCADE;

-- TABLE: PRICE (Historisation Article)
ALTER TABLE price
    ADD CONSTRAINT PK_Price PRIMARY KEY (SKU_code, start_date),
    
    ADD CONSTRAINT FK_Price_Article FOREIGN KEY (SKU_code)
        REFERENCES article (SKU_code)
        ON DELETE CASCADE -- les prix dépendent de l'article (SKU)
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_Price_SalePrice CHECK (sale_price > 0);

-- TABLE: CLIENT_PREFERENCE 
ALTER TABLE client_preference
    ADD CONSTRAINT PK_ClientPreference PRIMARY KEY (client_id, type_id),
    ADD CONSTRAINT FK_ClientPreference_Client FOREIGN KEY (client_id)
        REFERENCES Client (client_id)
        ON DELETE CASCADE -- si le client est supprimé ses préférences le sont aussi
        ON UPDATE CASCADE,
    ADD CONSTRAINT FK_ClientPreference_Type FOREIGN KEY (type_id)
        REFERENCES comm_preference_type (type_id)
        ON DELETE RESTRICT-- si le type de préférence est supprimé on ne supprime pas le client
        ON UPDATE CASCADE;


-- TABLE: STOCK
ALTER TABLE stock
    ADD CONSTRAINT PK_Stock PRIMARY KEY (SKU_code, warehouse_id),
    
    ADD CONSTRAINT FK_Stock_Article FOREIGN KEY (SKU_code)
        REFERENCES article (SKU_code)
        ON DELETE CASCADE -- Si l'article(SKUç) est supprimé, l'enregistrement de stock doit l'etre
        ON UPDATE CASCADE,
    ADD CONSTRAINT FK_Stock_Warehouse FOREIGN KEY (warehouse_id)
        REFERENCES warehouse (warehouse_id)
        ON DELETE CASCADE -- Si l'entrepôt est supprimé aussi
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_Stock_Quantity CHECK (quantity >= 0);


-- TABLE: ORDER_LINE 
ALTER TABLE order_line
    ADD CONSTRAINT PK_OrderLine PRIMARY KEY (SKU_code, order_id),
    ADD CONSTRAINT FK_OrderLine_Order FOREIGN KEY (order_id)
        REFERENCES order_ (order_id)
        ON DELETE CASCADE -- Si la commande est supprimée ses lignes de commande doivent l'etre
        ON UPDATE CASCADE,
    ADD CONSTRAINT FK_OrderLine_Article FOREIGN KEY (SKU_code)
        REFERENCES article (SKU_code)
        ON DELETE RESTRICT  -- Si l'article est supprimé, on garde la ligne de commande pour l'historique de l'ordre
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_OrderLine_Quantity CHECK (quantity_ordered > 0);


-- TABLE: APPLICABLE_CATEGORY 
ALTER TABLE applicable_category
    ADD CONSTRAINT PK_ApplicableCategory PRIMARY KEY (category_id, code_id),
    ADD CONSTRAINT FK_ApplicableCategory_Category FOREIGN KEY (category_id)
        REFERENCES category (category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT FK_ApplicableCategory_DiscountCode FOREIGN KEY (code_id)
        REFERENCES discount_code (code_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;


-- TABLE: RETURNED_ITEM
ALTER TABLE returned_item
    ADD CONSTRAINT PK_ReturnedItem PRIMARY KEY (SKU_code, return_id),
    ADD CONSTRAINT FK_ReturnedItem_Return FOREIGN KEY (return_id)
        REFERENCES return_ (return_id)	
        ON DELETE CASCADE -- Si le retour est supprimé le détail des articles retournés est supprimé.
        ON UPDATE CASCADE,
    
    ADD CONSTRAINT FK_ReturnedItem_Article FOREIGN KEY (SKU_code)
        REFERENCES article (SKU_code)
        ON DELETE RESTRICT -- mais sii l'article est supprimé on garde la trace dans l'historique de retour
        ON UPDATE CASCADE,
    ADD CONSTRAINT CHK_ReturnedItem_Quantity CHECK (quantity_returned > 0);
