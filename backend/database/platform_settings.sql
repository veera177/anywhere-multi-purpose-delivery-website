-- =============================================================
-- platform_settings — single source of truth for every numeric
-- rule used by the fee calculator, settlement and radius checks.
-- Never hardcode these values in Java or JavaScript.
-- =============================================================
USE anywhere;

CREATE TABLE IF NOT EXISTS platform_settings (
    id            INT PRIMARY KEY AUTO_INCREMENT,
    setting_key   VARCHAR(100) NOT NULL UNIQUE,
    setting_value VARCHAR(255) NOT NULL,
    description   VARCHAR(300),
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ── Delivery radii (km) ──────────────────────────────────────
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('delivery.food.radius_km',       '15',   'Max delivery radius for food orders'),
('delivery.grocery.radius_km',    '15',   'Max delivery radius for grocery orders'),
('delivery.medicine.radius_km',   '15',   'Max delivery radius for medicine orders'),
('delivery.courier.radius_km',    '50',   'Max delivery radius for courier orders')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ── Free-delivery thresholds (₹) ────────────────────────────
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('delivery.food.free_threshold',      '199', 'Order total above which food delivery is free'),
('delivery.grocery.free_threshold',   '299', 'Order total above which grocery delivery is free'),
('delivery.medicine.free_threshold',  '199', 'Order total above which medicine delivery is free')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ── Delivery fee caps (₹) ────────────────────────────────────
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('delivery.food.fee_cap',      '80',  'Maximum food delivery fee charged to customer'),
('delivery.grocery.fee_cap',   '70',  'Maximum grocery delivery fee charged to customer'),
('delivery.medicine.fee_cap',  '60',  'Maximum medicine delivery fee charged to customer'),
('delivery.courier.fee_cap',   '150', 'Maximum courier delivery fee charged to customer')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ── Tier 1 delivery fee rates ────────────────────────────────
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('delivery.tier1.food.base_fee',      '25',   'Tier 1 food base delivery fee (₹)'),
('delivery.tier1.food.per_km',        '4.38', 'Tier 1 food per-km charge (₹)'),
('delivery.tier1.grocery.base_fee',   '20',   'Tier 1 grocery base delivery fee (₹)'),
('delivery.tier1.grocery.per_km',     '3.62', 'Tier 1 grocery per-km charge (₹)'),
('delivery.tier1.medicine.base_fee',  '18',   'Tier 1 medicine base delivery fee (₹)'),
('delivery.tier1.medicine.per_km',    '2.38', 'Tier 1 medicine per-km charge (₹)'),
('delivery.tier1.courier.base_fee',   '20',   'Tier 1 courier base delivery fee (₹)'),
('delivery.tier1.courier.per_km',     '2.62', 'Tier 1 courier per-km charge (₹)')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ── Tier 2 delivery fee rates ────────────────────────────────
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('delivery.tier2.food.base_fee',      '30',   'Tier 2 food base delivery fee (₹)'),
('delivery.tier2.food.per_km',        '5.00', 'Tier 2 food per-km charge (₹)'),
('delivery.tier2.grocery.base_fee',   '25',   'Tier 2 grocery base delivery fee (₹)'),
('delivery.tier2.grocery.per_km',     '4.00', 'Tier 2 grocery per-km charge (₹)'),
('delivery.tier2.medicine.base_fee',  '22',   'Tier 2 medicine base delivery fee (₹)'),
('delivery.tier2.medicine.per_km',    '3.00', 'Tier 2 medicine per-km charge (₹)'),
('delivery.tier2.courier.base_fee',   '25',   'Tier 2 courier base delivery fee (₹)'),
('delivery.tier2.courier.per_km',     '3.00', 'Tier 2 courier per-km charge (₹)')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ── Tier 3 delivery fee rates ────────────────────────────────
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('delivery.tier3.food.base_fee',      '40',   'Tier 3 food base delivery fee (₹)'),
('delivery.tier3.food.per_km',        '6.00', 'Tier 3 food per-km charge (₹)'),
('delivery.tier3.grocery.base_fee',   '35',   'Tier 3 grocery base delivery fee (₹)'),
('delivery.tier3.grocery.per_km',     '5.00', 'Tier 3 grocery per-km charge (₹)'),
('delivery.tier3.medicine.base_fee',  '30',   'Tier 3 medicine base delivery fee (₹)'),
('delivery.tier3.medicine.per_km',    '4.00', 'Tier 3 medicine per-km charge (₹)'),
('delivery.tier3.courier.base_fee',   '35',   'Tier 3 courier base delivery fee (₹)'),
('delivery.tier3.courier.per_km',     '4.00', 'Tier 3 courier per-km charge (₹)')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ── Tier district mapping ────────────────────────────────────
-- Tier 1: major metro/urban districts
-- Tier 2: mid-size towns
-- Tier 3: rural/remote districts
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('district.tier.chennai',        '1', 'Delivery tier for Chennai'),
('district.tier.coimbatore',     '1', 'Delivery tier for Coimbatore'),
('district.tier.madurai',        '1', 'Delivery tier for Madurai'),
('district.tier.trichy',         '1', 'Delivery tier for Trichy'),
('district.tier.salem',          '2', 'Delivery tier for Salem'),
('district.tier.thanjavur',      '2', 'Delivery tier for Thanjavur'),
('district.tier.ooty',           '2', 'Delivery tier for Ooty'),
('district.tier.kanyakumari',    '2', 'Delivery tier for Kanyakumari'),
('district.tier.theni',          '3', 'Delivery tier for Theni'),
('district.tier.karaikudi',      '3', 'Delivery tier for Karaikudi'),
('district.tier.pollachi',       '3', 'Delivery tier for Pollachi'),
('district.tier.ambur',          '3', 'Delivery tier for Ambur'),
('district.tier.tiruvannamalai', '3', 'Delivery tier for Tiruvannamalai')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

-- ── Commission rates ─────────────────────────────────────────
INSERT INTO platform_settings (setting_key, setting_value, description) VALUES
('food_commission_rate',                   '15',  'Food restaurant commission % of item total'),
('grocery_default_commission',             '8',   'Grocery commission % for orders below threshold'),
('grocery_high_commission',                '10',  'Grocery commission % for orders at/above threshold'),
('grocery_high_threshold',                 '299', 'Grocery item price threshold for high commission (₹)'),
('medicine_otc_commission_rate',           '5',   'Medicine OTC commission % of item total'),
('medicine_otc_commission_minimum',        '15',  'Medicine OTC commission minimum (₹)'),
('medicine_prescription_commission_rate',  '7',   'Medicine prescription commission % of item total'),
('medicine_prescription_commission_minimum', '15','Medicine prescription commission minimum (₹)'),
('medicine_prescription_handling_fee',     '5',   'Per-order handling fee for prescription items (₹)'),
('courier_commission_rate',                '15',  'Courier company share % of delivery fee'),
('courier_commission_floor',               '10',  'Courier company minimum share (₹)')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

SELECT setting_key, setting_value FROM platform_settings ORDER BY setting_key;
