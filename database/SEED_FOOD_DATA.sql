-- ═══════════════════════════════════════════════════════════════════════════
-- ANYWHERE DELIVERY - SEED FOOD DATA
-- ═══════════════════════════════════════════════════════════════════════════
-- This script adds sample restaurants and food items to the database

USE anywhere;

-- ═══════════════════════════════════════════════════════════════════════════
-- STEP 1: Clear existing data (optional - comment out if you want to keep)
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM food_items;
DELETE FROM food_stores;

-- ═══════════════════════════════════════════════════════════════════════════
-- STEP 2: Insert Food Stores
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO food_stores (store_name, cuisine_type, rating, delivery_time, delivery_fee, is_open)
VALUES
('Salem RR Biryani', 'Biryani', 4.7, '30-45 mins', 50, TRUE),
('Banana Leaf Restaurant', 'South Indian', 4.5, '35-50 mins', 60, TRUE),
('Kumbakonam Degree Coffee', 'Cafe & Tiffin', 4.8, '20-30 mins', 40, TRUE),
('Hotel Gowri Krishna', 'Vegetarian', 4.4, '30-45 mins', 55, TRUE),
('Nagercoil Arya Bhavan', 'Tamil & Vegetarian', 4.6, '40-55 mins', 70, TRUE),
('Chettinad Virundhu', 'Chettinad Cuisine', 4.9, '30-45 mins', 60, TRUE),
('Pollachi Mess', 'Traditional', 4.5, '35-50 mins', 50, TRUE),
('Ooty Cafe', 'Cafe & Continental', 4.8, '25-40 mins', 45, TRUE),
('Ambur Star Biryani', 'Biryani', 5.0, '25-35 mins', 55, TRUE),
('Temple Tiffin Center', 'Breakfast & Tiffin', 4.6, '15-25 mins', 35, TRUE);

-- ═══════════════════════════════════════════════════════════════════════════
-- STEP 3: Insert Food Items
-- ═══════════════════════════════════════════════════════════════════════════

-- Salem RR Biryani (store_id = 1)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(1, 'Chicken Biryani', 'Aromatic biryani with tender chicken', 220, 'Biryani', TRUE),
(1, 'Mutton Biryani', 'Slow-cooked mutton biryani', 270, 'Biryani', TRUE),
(1, 'Veg Biryani', 'Mixed vegetables biryani', 180, 'Biryani', TRUE),
(1, 'Raita', 'Cooling yogurt side dish', 60, 'Side', TRUE),
(1, 'Pickle Mix', 'Assorted pickles', 50, 'Side', TRUE);

-- Banana Leaf Restaurant (store_id = 2)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(2, 'Veg Meals', 'Traditional South Indian vegetarian meals', 180, 'Meals', TRUE),
(2, 'Non-Veg Meals', 'Meals with chicken or fish', 220, 'Meals', TRUE),
(2, 'Parotta & Salna', 'Crispy parotta with spicy salna', 150, 'Breakfast', TRUE),
(2, 'Dosa', 'Crispy dosa with sambar and chutney', 120, 'Breakfast', TRUE),
(2, 'Idli Sambar', 'Soft idli with sambar', 100, 'Breakfast', TRUE);

-- Kumbakonam Degree Coffee (store_id = 3)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(3, 'Filter Coffee', 'Authentic filter coffee', 80, 'Beverages', TRUE),
(3, 'Degree Coffee', 'Strong degree coffee', 90, 'Beverages', TRUE),
(3, 'Kesari Pongal', 'Sweet vermicelli pongal', 100, 'Sweet', TRUE),
(3, 'Upma', 'Traditional savory upma', 90, 'Breakfast', TRUE),
(3, 'Chikhalii', 'Sweet fried snack', 70, 'Snacks', TRUE);

-- Hotel Gowri Krishna (store_id = 4)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(4, 'Veg Meals', 'Purely vegetarian meals', 170, 'Meals', TRUE),
(4, 'Pulao', 'Vegetarian pulao', 160, 'Rice', TRUE),
(4, 'Paneer Tikka', 'Grilled paneer pieces', 210, 'Starter', TRUE),
(4, 'Samosa', 'Crispy potato samosa', 60, 'Snacks', TRUE),
(4, 'Sweet Payasam', 'Traditional payasam', 80, 'Sweet', TRUE);

-- Nagercoil Arya Bhavan (store_id = 5)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(5, 'Appam Curry', 'Soft appam with curry', 160, 'Breakfast', TRUE),
(5, 'Fish Curry Meals', 'Spicy fish curry with rice', 250, 'Meals', TRUE),
(5, 'Dosa Vadai Combo', 'Crispy dosa with medu vadai', 140, 'Breakfast', TRUE),
(5, 'Coconut Sambar', 'Rich coconut sambar', 120, 'Curry', TRUE),
(5, 'Erissery', 'Vegetable stew', 140, 'Curry', TRUE);

-- Chettinad Virundhu (store_id = 6)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(6, 'Chettinad Chicken', 'Spicy Chettinad style chicken', 280, 'Curry', TRUE),
(6, 'Chettinad Meals', 'Traditional Chettinad meals', 220, 'Meals', TRUE),
(6, 'Chicken 65', 'Crispy spicy chicken', 200, 'Starter', TRUE),
(6, 'Mutton Pepper Fry', 'Pepper spiced mutton', 300, 'Curry', TRUE),
(6, 'Rasam', 'Spicy tangy rasam', 80, 'Curry', TRUE);

-- Pollachi Mess (store_id = 7)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(7, 'Coconut Meals', 'Kongu region coconut meals', 190, 'Meals', TRUE),
(7, 'Grilled Chicken', 'Pollachi style grilled chicken', 280, 'Starter', TRUE),
(7, 'Vegetable Biryani', 'Mixed veg biryani', 170, 'Biryani', TRUE),
(7, 'Chilli Parotta', 'Spicy stuffed parotta', 140, 'Breakfast', TRUE),
(7, 'Badam Milk', 'Traditional badam milk', 100, 'Beverages', TRUE);

-- Ooty Cafe (store_id = 8)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(8, 'Hot Chocolate', 'Rich hot chocolate', 150, 'Beverages', TRUE),
(8, 'Bread Omelette', 'Buttered bread with omelette', 130, 'Breakfast', TRUE),
(8, 'Mushroom Pasta', 'Creamy mushroom pasta', 240, 'Continental', TRUE),
(8, 'Sandwich Combo', 'Toasted sandwich with fries', 180, 'Lunch', TRUE),
(8, 'Tea & Cake', 'Tea with slice of cake', 120, 'Snacks', TRUE);

-- Ambur Star Biryani (store_id = 9)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(9, 'Ambur Chicken Biryani', 'World famous Ambur biryani', 300, 'Biryani', TRUE),
(9, 'Mutton Biryani', 'Premium mutton biryani', 350, 'Biryani', TRUE),
(9, 'Chicken 65', 'Spicy chicken 65', 200, 'Starter', TRUE),
(9, 'Shorba', 'Flavored meat soup', 120, 'Soup', TRUE),
(9, 'Haleem', 'Meat and lentil stew', 220, 'Curry', TRUE);

-- Temple Tiffin Center (store_id = 10)
INSERT INTO food_items (store_id, item_name, description, price, category, is_available)
VALUES
(10, 'Temple Idli Combo', 'Soft idli with pongal and chutney', 120, 'Breakfast', TRUE),
(10, 'Sambar Meals', 'Traditional sambar with rice', 150, 'Meals', TRUE),
(10, 'Dosa Masala', 'Masala dosa', 130, 'Breakfast', TRUE),
(10, 'Rose Milk', 'Cold rose milk', 80, 'Beverages', TRUE),
(10, 'Vada Curry', 'Vadai with gravy', 100, 'Breakfast', TRUE);

-- ═══════════════════════════════════════════════════════════════════════════
-- VERIFICATION QUERIES
-- ═══════════════════════════════════════════════════════════════════════════

SELECT '✓ Data Seeding Complete' AS status;
SELECT COUNT(*) AS total_stores FROM food_stores;
SELECT COUNT(*) AS total_items FROM food_items;

-- Show stores and their item counts
SELECT 
    f.store_id,
    s.store_name,
    COUNT(f.id) as item_count
FROM food_items f
JOIN food_stores s ON f.store_id = s.id
GROUP BY f.store_id, s.store_name
ORDER BY s.store_name;

-- Show sample items from each store
SELECT 
    s.id,
    s.store_name,
    GROUP_CONCAT(f.item_name SEPARATOR ', ') as items
FROM food_stores s
LEFT JOIN food_items f ON s.id = f.store_id
GROUP BY s.id, s.store_name
LIMIT 5;
