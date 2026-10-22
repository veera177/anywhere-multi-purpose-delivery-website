-- ═══════════════════════════════════════════════════════════════════════════
-- ANYWHERE DELIVERY APP - DATABASE INITIALIZATION SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════
-- This script sets up the complete database for the Anywhere delivery app
-- Run this in MySQL Workbench or mysql CLI
-- ═══════════════════════════════════════════════════════════════════════════

-- Step 1: Create Database if it doesn't exist
DROP DATABASE IF EXISTS anywhere;
CREATE DATABASE IF NOT EXISTS anywhere;
USE anywhere;

-- Step 2: Create Users Table (Authentication)
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(30) DEFAULT 'CUSTOMER',
    address_line VARCHAR(255),
    landmark VARCHAR(150),
    district VARCHAR(100),
    town VARCHAR(100),
    area_type VARCHAR(20) DEFAULT 'URBAN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Seed test user (password will auto-hash on first JWT login)
INSERT INTO users
(full_name, email, phone, password, role, address_line, landmark, district, town, area_type)
VALUES
('Demo Customer', 'demo@gmail.com', '9876543210', '12345', 'CUSTOMER',
 '12 Anna Street', 'Near Bus Stand', 'chennai', 'T Nagar', 'URBAN');

-- Step 4: Create Districts Table
DROP TABLE IF EXISTS districts;
CREATE TABLE IF NOT EXISTS districts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 5: Create District Areas Table
DROP TABLE IF EXISTS district_areas;
CREATE TABLE IF NOT EXISTS district_areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    district_id INT NOT NULL,
    area_name VARCHAR(150) NOT NULL,
    subtext VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    pincode VARCHAR(20) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_district_areas_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE CASCADE,
    INDEX idx_district_area_name (district_id, area_name)
);

-- Step 6: Seed Districts
INSERT INTO districts (id, name, code) VALUES
(1, 'Salem', 'salem'),
(2, 'Trichy', 'trichy'),
(3, 'Thanjavur', 'thanjavur'),
(4, 'Theni', 'theni'),
(5, 'Kanyakumari', 'kanyakumari'),
(6, 'Karaikudi', 'karaikudi'),
(7, 'Pollachi', 'pollachi'),
(8, 'Ooty', 'ooty'),
(9, 'Ambur', 'ambur'),
(10, 'Tiruvannamalai', 'tiruvannamalai'),
(11, 'Chennai', 'chennai'),
(12, 'Coimbatore', 'coimbatore'),
(13, 'Madurai', 'madurai'),
(14, 'Dindigul', 'dindigul'),
(15, 'Tirunelveli', 'tirunelveli'),
(16, 'Erode', 'erode'),
(17, 'Vellore', 'vellore'),
(18, 'Tiruppur', 'tiruppur'),
(19, 'Namakkal', 'namakkal'),
(20, 'Karur', 'karur'),
(21, 'Hosur', 'hosur'),
(22, 'Kanchipuram', 'kanchipuram'),
(23, 'Chengalpattu', 'chengalpattu'),
(24, 'Tiruvallur', 'tiruvallur'),
(25, 'Villupuram', 'villupuram'),
(26, 'Ramanathapuram', 'ramanathapuram'),
(27, 'Pudukkottai', 'pudukkottai')
ON DUPLICATE KEY UPDATE name = VALUES(name), code = VALUES(code);

-- Step 7: Create Cart Table
DROP TABLE IF EXISTS cart;
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Step 8: Create Orders Table
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    delivery_address VARCHAR(500) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Step 9: Create Order Items Table
DROP TABLE IF EXISTS order_items;
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Step 10: Create Addresses Table
DROP TABLE IF EXISTS addresses;
CREATE TABLE IF NOT EXISTS addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_line VARCHAR(500) NOT NULL,
    landmark VARCHAR(255),
    area VARCHAR(150),
    district VARCHAR(100),
    town VARCHAR(100),
    area_type VARCHAR(20) DEFAULT 'URBAN',
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_addresses_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Step 11: Create Payment Table
DROP TABLE IF EXISTS payments;
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    razorpay_order_id VARCHAR(255),
    razorpay_payment_id VARCHAR(255),
    razorpay_signature VARCHAR(255),
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    status VARCHAR(50) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Step 12: Create Courier Tracking Table
DROP TABLE IF EXISTS courier_tracking;
CREATE TABLE IF NOT EXISTS courier_tracking (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    courier_id INT,
    current_location VARCHAR(255),
    status VARCHAR(50) DEFAULT 'ASSIGNED',
    estimated_delivery_time VARCHAR(50),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_courier_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Step 13: Create Food Delivery Store Table
DROP TABLE IF EXISTS food_stores;
CREATE TABLE IF NOT EXISTS food_stores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    cuisine_type VARCHAR(100),
    rating DECIMAL(3, 1) DEFAULT 4.5,
    delivery_time VARCHAR(50) DEFAULT '30-45 mins',
    delivery_fee DECIMAL(5, 2) DEFAULT 0,
    is_open BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 14: Create Food Items Table
DROP TABLE IF EXISTS food_items;
CREATE TABLE IF NOT EXISTS food_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_food_items_store FOREIGN KEY (store_id) REFERENCES food_stores(id) ON DELETE CASCADE
);

-- Step 15: Create Grocery Store Table
DROP TABLE IF EXISTS grocery_stores;
CREATE TABLE IF NOT EXISTS grocery_stores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    rating DECIMAL(3, 1) DEFAULT 4.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 16: Create Grocery Items Table
DROP TABLE IF EXISTS grocery_items;
CREATE TABLE IF NOT EXISTS grocery_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    quantity_unit VARCHAR(50),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_grocery_items_store FOREIGN KEY (store_id) REFERENCES grocery_stores(id) ON DELETE CASCADE
);

-- Step 17: Create Pharmacy Table
DROP TABLE IF EXISTS pharmacies;
CREATE TABLE IF NOT EXISTS pharmacies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pharmacy_name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    phone VARCHAR(15),
    is_operational BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 18: Create Medicine Table
DROP TABLE IF EXISTS medicines;
CREATE TABLE IF NOT EXISTS medicines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pharmacy_id INT NOT NULL,
    medicine_name VARCHAR(255) NOT NULL,
    composition VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    requires_prescription BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_medicines_pharmacy FOREIGN KEY (pharmacy_id) REFERENCES pharmacies(id) ON DELETE CASCADE
);

-- Step 19: Create Prescription Verification Table
DROP TABLE IF EXISTS prescription_verifications;
CREATE TABLE IF NOT EXISTS prescription_verifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    medicine_ids JSON,
    verification_status VARCHAR(50) DEFAULT 'PENDING',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescription_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_prescription_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ═══════════════════════════════════════════════════════════════════════════
-- VERIFICATION QUERIES
-- ═══════════════════════════════════════════════════════════════════════════

SELECT '✓ Database Setup Complete' AS status;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_districts FROM districts;
SELECT COUNT(*) AS total_areas FROM district_areas;

-- Display test user
SELECT id, email, password, role FROM users WHERE email = 'demo@gmail.com';
