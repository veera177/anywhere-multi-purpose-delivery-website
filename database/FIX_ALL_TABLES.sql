-- ============================================================
-- ANYWHERE — COMPLETE SCHEMA FIX
-- Run this ONCE in MySQL to align ALL tables with Java code.
-- Safe to re-run (uses IF NOT EXISTS / ADD COLUMN IF NOT EXISTS)
-- ============================================================

USE anywhere;

-- ════════════════════════════════════════════════════════════
-- 1. RESTAURANTS — ensure correct schema (from fooddelivery.sql)
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150),
    district VARCHAR(100),
    rating DOUBLE,
    location VARCHAR(200),
    delivery_type VARCHAR(50),
    latitude DOUBLE,
    longitude DOUBLE,
    taluk VARCHAR(100),
    pincode VARCHAR(20),
    is_verified BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE
);

-- ════════════════════════════════════════════════════════════
-- 2. FOOD_PRODUCTS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS food_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    district VARCHAR(100),
    category VARCHAR(100),
    name VARCHAR(150),
    description TEXT,
    price DOUBLE,
    stock INT,
    rating DOUBLE DEFAULT 4.5,
    offer_tag VARCHAR(100),
    food_type VARCHAR(50),
    image_url TEXT,
    available BOOLEAN DEFAULT TRUE,
    restaurant_id INT
);

-- ════════════════════════════════════════════════════════════
-- 3. GROCERY_STORES
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS grocery_stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150),
    district VARCHAR(100),
    rating DOUBLE,
    location VARCHAR(200),
    delivery_type VARCHAR(50),
    latitude DOUBLE,
    longitude DOUBLE,
    taluk VARCHAR(100),
    pincode VARCHAR(20),
    is_verified BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE
);

-- ════════════════════════════════════════════════════════════
-- 4. GROCERY_PRODUCTS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS grocery_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    district VARCHAR(100),
    category VARCHAR(100),
    name VARCHAR(150),
    description TEXT,
    price DOUBLE,
    stock INT,
    rating DOUBLE DEFAULT 4.5,
    offer_tag VARCHAR(100),
    unit_type VARCHAR(50),
    image_url TEXT,
    available BOOLEAN DEFAULT TRUE,
    store_id INT
);

-- ════════════════════════════════════════════════════════════
-- 5. PHARMACIES
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS pharmacies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150),
    district VARCHAR(100),
    rating DOUBLE,
    location VARCHAR(200),
    delivery_type VARCHAR(50),
    latitude DOUBLE,
    longitude DOUBLE,
    taluk VARCHAR(100),
    pincode VARCHAR(20),
    is_verified BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE
);

-- ════════════════════════════════════════════════════════════
-- 6. MEDICINE_PRODUCTS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS medicine_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    district VARCHAR(100),
    category VARCHAR(100),
    name VARCHAR(150),
    description TEXT,
    price DOUBLE,
    stock INT,
    rating DOUBLE DEFAULT 4.5,
    offer_tag VARCHAR(100),
    dosage VARCHAR(50),
    image_url TEXT,
    available BOOLEAN DEFAULT TRUE,
    pharmacy_id INT,
    schedule_type VARCHAR(30) DEFAULT 'OTC',
    requires_prescription BOOLEAN DEFAULT FALSE
);

-- Add missing columns to existing partner tables (safe if already exist)
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS latitude DOUBLE AFTER delivery_type;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS longitude DOUBLE AFTER latitude;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS taluk VARCHAR(100) AFTER longitude;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS pincode VARCHAR(20) AFTER taluk;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT TRUE AFTER pincode;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE AFTER is_verified;

ALTER TABLE grocery_stores ADD COLUMN IF NOT EXISTS latitude DOUBLE AFTER delivery_type;
ALTER TABLE grocery_stores ADD COLUMN IF NOT EXISTS longitude DOUBLE AFTER latitude;
ALTER TABLE grocery_stores ADD COLUMN IF NOT EXISTS taluk VARCHAR(100) AFTER longitude;
ALTER TABLE grocery_stores ADD COLUMN IF NOT EXISTS pincode VARCHAR(20) AFTER taluk;
ALTER TABLE grocery_stores ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT TRUE AFTER pincode;
ALTER TABLE grocery_stores ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE AFTER is_verified;

ALTER TABLE pharmacies ADD COLUMN IF NOT EXISTS latitude DOUBLE AFTER delivery_type;
ALTER TABLE pharmacies ADD COLUMN IF NOT EXISTS longitude DOUBLE AFTER latitude;
ALTER TABLE pharmacies ADD COLUMN IF NOT EXISTS taluk VARCHAR(100) AFTER longitude;
ALTER TABLE pharmacies ADD COLUMN IF NOT EXISTS pincode VARCHAR(20) AFTER taluk;
ALTER TABLE pharmacies ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT TRUE AFTER pincode;
ALTER TABLE pharmacies ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE AFTER is_verified;

-- ════════════════════════════════════════════════════════════
-- 7. CART — fix to match CartDAO expectations
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    service_type ENUM('FOOD','GROCERY','MEDICINE','COURIER','HOME_SERVICE','AGRICULTURE') NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ════════════════════════════════════════════════════════════
-- 8. ORDERS — fix to match OrderDAO expectations
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_id INT,
    delivery_address VARCHAR(500) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'ORDER_PLACED',
    tracking_status VARCHAR(50) DEFAULT 'ORDER_PLACED',
    estimated_delivery_time TIMESTAMP,
    ordered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    product_total DECIMAL(10,2) DEFAULT 0,
    distance_km DECIMAL(6,2) DEFAULT 0,
    delivery_fee_original DECIMAL(10,2) DEFAULT 0,
    delivery_discount DECIMAL(10,2) DEFAULT 0,
    final_delivery_fee DECIMAL(10,2) DEFAULT 0,
    delivery_eta_label VARCHAR(50)
);

-- Add columns safely if orders table existed without them
ALTER TABLE orders ADD COLUMN IF NOT EXISTS address_id INT AFTER user_id;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS payment_method VARCHAR(30) DEFAULT 'CASH_ON_DELIVERY' AFTER delivery_address;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS tracking_status VARCHAR(50) DEFAULT 'ORDER_PLACED' AFTER status;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS estimated_delivery_time TIMESTAMP NULL AFTER tracking_status;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS product_total DECIMAL(10,2) DEFAULT 0 AFTER ordered_at;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS distance_km DECIMAL(6,2) DEFAULT 0 AFTER product_total;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS delivery_fee_original DECIMAL(10,2) DEFAULT 0 AFTER distance_km;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS delivery_discount DECIMAL(10,2) DEFAULT 0 AFTER delivery_fee_original;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS final_delivery_fee DECIMAL(10,2) DEFAULT 0 AFTER delivery_discount;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS delivery_eta_label VARCHAR(50) AFTER final_delivery_fee;

-- ════════════════════════════════════════════════════════════
-- 9. ORDER_ITEMS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    service_type VARCHAR(30) NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
);

-- ════════════════════════════════════════════════════════════
-- 10. PAYMENTS — fix to match PaymentDAO expectations
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(150),
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add columns safely if payments table existed without them
ALTER TABLE payments ADD COLUMN IF NOT EXISTS user_id INT AFTER order_id;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS payment_method VARCHAR(50) DEFAULT 'COD' AFTER user_id;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS transaction_id VARCHAR(150) NULL AFTER payment_method;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS payment_status VARCHAR(30) DEFAULT 'PENDING' AFTER amount;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER payment_status;

-- ════════════════════════════════════════════════════════════
-- 11. ADDRESSES — fix to match AddressDAO expectations
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    latitude DOUBLE,
    longitude DOUBLE,
    address_type VARCHAR(20) DEFAULT 'HOME',
    is_default BOOLEAN DEFAULT FALSE
);

-- Add columns safely if addresses table existed without them
ALTER TABLE addresses ADD COLUMN IF NOT EXISTS latitude DOUBLE AFTER pincode;
ALTER TABLE addresses ADD COLUMN IF NOT EXISTS longitude DOUBLE AFTER latitude;
ALTER TABLE addresses ADD COLUMN IF NOT EXISTS address_type VARCHAR(20) DEFAULT 'HOME' AFTER longitude;
ALTER TABLE addresses ADD COLUMN IF NOT EXISTS is_default BOOLEAN DEFAULT FALSE AFTER address_type;

-- ════════════════════════════════════════════════════════════
-- 12. PRESCRIPTIONS — supports both old (order-time) and new (upload) flows
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    -- New upload flow columns
    medicine_name VARCHAR(300) NULL,
    quantity VARCHAR(100) DEFAULT '1',
    file_path VARCHAR(500) NULL,
    address_id INT NULL,
    district VARCHAR(100) NULL,
    confirmed_price DOUBLE NULL,
    -- Legacy order-time flow columns
    medicine_id INT NULL,
    file_url VARCHAR(500) NULL,
    order_id INT NULL,
    valid_until DATE NULL,
    reviewed_by INT NULL,
    reviewed_at TIMESTAMP NULL,
    -- Common columns
    assigned_pharmacy_id INT NULL,
    status VARCHAR(30) DEFAULT 'PENDING',
    rejection_reason VARCHAR(255) NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL
);

-- Add columns safely if table existed without them
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS medicine_name VARCHAR(300) NULL AFTER user_id;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS quantity VARCHAR(100) DEFAULT '1' AFTER medicine_name;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS file_path VARCHAR(500) NULL AFTER quantity;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS address_id INT NULL AFTER file_path;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS district VARCHAR(100) NULL AFTER address_id;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS confirmed_price DOUBLE NULL AFTER district;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS assigned_pharmacy_id INT NULL AFTER status;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMP NULL AFTER uploaded_at;

-- ════════════════════════════════════════════════════════════
-- 13. PLATFORM_SETTINGS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS platform_settings (
    setting_key VARCHAR(150) PRIMARY KEY,
    setting_value VARCHAR(150) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ════════════════════════════════════════════════════════════
-- 14. DISTRICTS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS districts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    tier INT DEFAULT 2,
    capital_area VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ════════════════════════════════════════════════════════════
-- 15. DISTRICT_AREAS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS district_areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    district_id INT NOT NULL,
    area_name VARCHAR(150) NOT NULL,
    subtext VARCHAR(255) NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    pincode VARCHAR(20) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ════════════════════════════════════════════════════════════
-- 16. COURIER_TRACKING
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS courier_tracking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    courier_id INT,
    current_location VARCHAR(255),
    status VARCHAR(50) DEFAULT 'ASSIGNED',
    estimated_delivery_time VARCHAR(50),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ════════════════════════════════════════════════════════════
-- 17. COUPONS
-- ════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS coupons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percent INT DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    min_order_amount DECIMAL(10,2) DEFAULT 0,
    max_uses INT DEFAULT 100,
    used_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS coupon_usages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ════════════════════════════════════════════════════════════
-- SEED DATA: Ensure key tables have data
-- Only insert if table is empty (to avoid duplicates on re-run)
-- ════════════════════════════════════════════════════════════

-- Seed districts if empty
INSERT IGNORE INTO districts (id, name, code, tier, capital_area) VALUES
(1, 'Salem', 'salem', 2, 'Salem Town'),
(2, 'Trichy', 'trichy', 2, 'Trichy Central'),
(3, 'Thanjavur', 'thanjavur', 2, 'Thanjavur Town'),
(4, 'Theni', 'theni', 2, 'Theni Town'),
(5, 'Kanyakumari', 'kanyakumari', 2, 'Nagercoil'),
(6, 'Karaikudi', 'karaikudi', 3, 'Karaikudi Town'),
(7, 'Pollachi', 'pollachi', 2, 'Pollachi Town'),
(8, 'Ooty', 'ooty', 2, 'Ooty Town'),
(9, 'Ambur', 'ambur', 2, 'Ambur Town'),
(10, 'Tiruvannamalai', 'tiruvannamalai', 2, 'Tiruvannamalai Town'),
(11, 'Chennai', 'chennai', 1, 'T Nagar'),
(12, 'Coimbatore', 'coimbatore', 1, 'Gandhipuram'),
(13, 'Madurai', 'madurai', 1, 'Madurai Central'),
(14, 'Kanchipuram', 'kanchipuram', 2, 'Kanchipuram Town'),
(15, 'Chengalpattu', 'chengalpattu', 2, 'Chengalpattu Town'),
(16, 'Tiruvallur', 'thiruvallur', 2, 'Thiruvallur Town');

-- Seed platform_settings if empty
INSERT IGNORE INTO platform_settings (setting_key, setting_value) VALUES
('district.default.tier', '2'),
('delivery.food.radius_km', '15'),
('delivery.food.base_distance_km', '3'),
('delivery.food.first_band_limit_km', '8'),
('delivery.food.free_delivery_threshold', '199'),
('delivery.food.tier1.base_fee', '35'),
('delivery.food.tier1.first_band_rate', '7'),
('delivery.food.tier1.second_band_rate', '6'),
('delivery.food.tier1.max_fee', '100'),
('delivery.food.tier2.base_fee', '25'),
('delivery.food.tier2.first_band_rate', '6'),
('delivery.food.tier2.second_band_rate', '5'),
('delivery.food.tier2.max_fee', '80'),
('delivery.grocery.radius_km', '25'),
('delivery.grocery.base_distance_km', '3'),
('delivery.grocery.first_band_limit_km', '10'),
('delivery.grocery.free_delivery_threshold', '299'),
('delivery.medicine.radius_km', '20'),
('delivery.medicine.base_distance_km', '3'),
('delivery.medicine.first_band_limit_km', '8'),
('delivery.medicine.free_delivery_threshold', '149'),
('courier.base_fee', '40'),
('courier.per_km_rate', '12'),
('courier.max_weight_kg', '15'),
('prescription.review_delay_seconds', '10'),
('prescription.max_file_size_mb', '5');

-- ════════════════════════════════════════════════════════════
-- DONE
-- ════════════════════════════════════════════════════════════
SELECT '✓ FIX_ALL_TABLES.sql complete — all tables aligned with Java code' AS status;
