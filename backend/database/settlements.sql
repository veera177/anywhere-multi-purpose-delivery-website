-- =============================================================
-- settlements — one row per order, stores revenue split.
-- order_id links back to orders.id.
-- All amounts are stored to 2 decimal places.
-- =============================================================
USE anywhere;

CREATE TABLE IF NOT EXISTS settlements (
    id                    INT PRIMARY KEY AUTO_INCREMENT,
    order_id              INT NOT NULL UNIQUE,
    service_type          VARCHAR(30)    NOT NULL,
    item_total            DECIMAL(10,2)  NOT NULL,
    delivery_fee          DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    platform_commission   DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    prescription_handling DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    partner_payout        DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    rider_payout          DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    platform_profit       DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    settled_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- =============================================================
-- partner_subscriptions — monthly subscription fees billed to
-- restaurant / grocery / pharmacy partners.
-- =============================================================
CREATE TABLE IF NOT EXISTS partner_subscriptions (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    partner_id   INT          NOT NULL,
    partner_type VARCHAR(30)  NOT NULL,   -- FOOD, GROCERY, MEDICINE
    monthly_fee  DECIMAL(10,2) NOT NULL,
    start_date   DATE         NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',  -- ACTIVE, CANCELLED
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- Schema additions required by the settlement and fee logic.
-- Run these ALTER statements once; they are idempotent via IF NOT EXISTS
-- (MySQL 8.0+).  Spring Boot will error on startup if the columns are missing.
-- =============================================================

-- Add prescription_required to medicine_products
ALTER TABLE medicine_products
    ADD COLUMN IF NOT EXISTS prescription_required BOOLEAN NOT NULL DEFAULT FALSE;

-- Mark antibiotics and chronic-disease medicines as prescription-required
UPDATE medicine_products SET prescription_required = TRUE
WHERE category IN ('Antibiotic', 'BP Care', 'Diabetes')
   OR name IN ('Amoxicillin 500mg','Metformin 500mg','Amlodipine 5mg',
               'Gluconorm 500mg','Telmisartan 40mg',
               'Aspirin 75mg','Clotrimazole Cream','Diclofenac Gel',
               'Baby Fever Drops');

-- Add prescription_required to order_items (denormalised snapshot at order time)
ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS tracking_status VARCHAR(30) DEFAULT 'ORDER_PLACED',
    ADD COLUMN IF NOT EXISTS estimated_delivery_time DATETIME;

ALTER TABLE order_items
    ADD COLUMN IF NOT EXISTS prescription_required BOOLEAN NOT NULL DEFAULT FALSE;
