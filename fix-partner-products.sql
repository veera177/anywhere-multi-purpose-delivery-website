-- ============================================================
-- Anywhere: products for the newly added grocery stores and
-- pharmacies. Product names are prefixed with their own store /
-- pharmacy name so each partner owns its own catalogue and the
-- existing district filters keep working.
-- Idempotent: safe to re-run.
-- ============================================================

-- ---------- GROCERY PRODUCTS ----------
INSERT INTO grocery_products
  (district, category, name, description, price, stock, rating, offer_tag, unit_type, image_url, available, store_id)
SELECT s.district, x.c, CONCAT(s.name, ' ', x.n), x.d, x.p, 40, 4.5, NULL, x.u,
       'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80', 1, s.id
FROM grocery_stores s
JOIN (
  SELECT 'Karaikudi Daily Bazaar'       AS sname, 'Fresh Vegetables' AS c, 'Tomato (Local)' AS n, 'Farm-fresh tomatoes sourced from local Karaikudi farms' AS d, 48.00 AS p, '1 kg' AS u
  UNION ALL SELECT 'Karaikudi Daily Bazaar',       'Staples',        'Ponni Boiled Rice',      'Premium Samba rice, 25 kg bag',                    1450.00, '25 kg'
  UNION ALL SELECT 'Karaikudi Daily Bazaar',       'Dairy',          'Fresh Farm Milk',        'Pasteurised full-cream milk, daily',                62.00, '1 L'
  UNION ALL SELECT 'Karaikudi Daily Bazaar',       'Snacks',         'Murukku Classic Pack',   'Traditional rice murukku, baked fresh',              85.00, '400 g'

  UNION ALL SELECT 'Chettinad Provision Mart',   'Fresh Vegetables', 'Onion (Nashik)',         'Sharp red onions, sorted and cleaned',             54.00, '1 kg'
  UNION ALL SELECT 'Chettinad Provision Mart',   'Staples',        'Toor Dal',               'Arhar dal, unpolished and stone-ground',           168.00, '1 kg'
  UNION ALL SELECT 'Chettinad Provision Mart',   'Dairy',          'Curd',                   'Thick set curd, no added preservatives',           40.00, '500 g'
  UNION ALL SELECT 'Chettinad Provision Mart',   'Household',      'Sunflower Oil',          'Refined sunflower cooking oil',                    142.00, '1 L'

  UNION ALL SELECT 'Ponnarai Fresh Vegetables',   'Fresh Vegetables', 'Green Bananas',         'Naturally ripened Nendran bananas',                 56.00, '1 kg'
  UNION ALL SELECT 'Ponnarai Fresh Vegetables',   'Fresh Vegetables', 'Carrots',                'Sweet, crunchy carrots from local farms',           44.00, '1 kg'
  UNION ALL SELECT 'Ponnarai Fresh Vegetables',   'Fruits',         'Seasonal Fruit Box',     'Mixed seasonal fruit selection, seasonal',         320.00, '2 kg'
  UNION ALL SELECT 'Ponnarai Fresh Vegetables',   'Dairy',          'Paneer Fresh',           'Soft, fresh paneer made in-store daily',            96.00, '200 g'

  UNION ALL SELECT 'Pollachi Fresh Farm Mart',    'Fresh Vegetables', 'Tomatoes (Pollachi)',    'Vine-ripened tomatoes from Pollachi farms',          44.00, '1 kg'
  UNION ALL SELECT 'Pollachi Fresh Farm Mart',    'Fruits',         'Guava',                  'Sweet guava, high in Vitamin C',                     72.00, '1 kg'
  UNION ALL SELECT 'Pollachi Fresh Farm Mart',    'Dairy',          'Buffalo Milk',           'Full-cream buffalo milk, delivered chilled',         95.00, '1 L'
  UNION ALL SELECT 'Pollachi Fresh Farm Mart',    'Staples',        'Wheat Flour',            'Chakkar fresh atta, stone-ground',                  68.00, '5 kg'

  UNION ALL SELECT 'Kongu Super Bazaar',          'Beverages',       'Filter Coffee Powder',   'Classic South Indian filter coffee blend',           185.00, '500 g'
  UNION ALL SELECT 'Kongu Super Bazaar',          'Snacks',         'Chips (Assorted)',       'Assorted savoury chips, 6 pack',                      60.00, '6 pack'
  UNION ALL SELECT 'Kongu Super Bazaar',          'Household',      'Dishwash Bar',           'Lemon dishwash bar, long lasting',                   48.00, '200 g'
  UNION ALL SELECT 'Kongu Super Bazaar',          'Personal Care',  'Bath Soap (3 pack)',     'Antibacterial herbal bath soap',                    108.00, '3 pack'

  UNION ALL SELECT 'Anaimalai Agro Store',        'Fresh Vegetables', 'Beetroot',              'Fresh beetroot, rich in iron',                       50.00, '1 kg'
  UNION ALL SELECT 'Anaimalai Agro Store',        'Staples',        'Ragi Flour',             'Finger millet flour, locally stone-ground',         88.00, '1 kg'
  UNION ALL SELECT 'Anaimalai Agro Store',        'Fruits',         'Pomegranate',            'Anaimalai-aravai sun-dried pomegranate',          220.00, '500 g'
  UNION ALL SELECT 'Anaimalai Agro Store',        'Staples',        'Sugar',                  'Refined cane sugar, 1 kg',                           52.00, '1 kg'

  UNION ALL SELECT 'Nagercoil Daily Supermarket', 'Staples',        'Matta Rice',             'Niger-specific Matta rice, 5 kg',                  1250.00, '5 kg'
  UNION ALL SELECT 'Nagercoil Daily Supermarket', 'Fresh Vegetables', 'Jackfruit (Pazham)',    'Seasonal Nendran pazham fruit',                      95.00, '1 kg'
  UNION ALL SELECT 'Nagercoil Daily Supermarket', 'Beverages',       'Tamil Nadu Coffee',      'Nilgiri blend coffee, medium roast',                240.00, '250 g'
  UNION ALL SELECT 'Nagercoil Daily Supermarket', 'Dairy',          'Ghee',                   'Pure cow ghee, traditional bilona',                 620.00, '500 ml'

  UNION ALL SELECT 'Marthandam Supermarket',      'Fresh Vegetables', 'Cassava Root',          'Fresh kodakailu, locally grown',                     40.00, '1 kg'
  UNION ALL SELECT 'Marthandam Supermarket',      'Staples',        'Coconut (Fresh)',        'Dehusked tender coconut',                            65.00, '1 pc'
  UNION ALL SELECT 'Marthandam Supermarket',      'Snacks',         'Banana Chips',           'Kerala-style raw banana chips',                      75.00, '200 g'
  UNION ALL SELECT 'Marthandam Supermarket',      'Household',      'Coconut Oil',            'Cold-pressed coconut oil, 1 L',                     320.00, '1 L'

  UNION ALL SELECT 'Theni Organic Farm Store',    'Fresh Vegetables', 'Organic Tomatoes',      'Certified organic tomatoes, pesticide free',        89.00, '1 kg'
  UNION ALL SELECT 'Theni Organic Farm Store',    'Organic',        'Organic Honey',          'Raw hill honey, unheated and unfiltered',          420.00, '500 g'
  UNION ALL SELECT 'Theni Organic Farm Store',    'Organic',        'Organic Millet Idli Mix','Millet-based premix with no maida',                  95.00, '500 g'
  UNION ALL SELECT 'Theni Organic Farm Store',    'Fresh Vegetables', 'Hill Vegetables Box',   'Assorted seasonal hill vegetables',                 260.00, '1 kg'

  UNION ALL SELECT 'Coddalore Spice Bazaar',      'Spices',         'Turmeric Powder',        'Pure Lakadong turmeric, sun-dried',                 185.00, '200 g'
  UNION ALL SELECT 'Coddalore Spice Bazaar',      'Spices',         'Coriander Powder',       'Aromatic coriander, freshly ground',               145.00, '200 g'
  UNION ALL SELECT 'Coddalore Spice Bazaar',      'Spices',         'Chilli Powder',          'Medium-hot red chilli powder',                      165.00, '200 g'
  UNION ALL SELECT 'Coddalore Spice Bazaar',      'Staples',        'Gingelly Oil',           'Cold-pressed sesame oil for cooking',               380.00, '1 L'
) x ON LOWER(s.name) = LOWER(x.sname)
WHERE NOT EXISTS (
  SELECT 1 FROM grocery_products gp
  WHERE gp.store_id = s.id AND LOWER(gp.name) = LOWER(CONCAT(s.name, ' ', x.n))
);

-- ---------- MEDICINE PRODUCTS ----------
INSERT INTO medicine_products
  (district, category, name, description, price, stock, rating, offer_tag, dosage, image_url, available, pharmacy_id, schedule_type, requires_prescription)
SELECT p.district, x.c, CONCAT(p.name, ' ', x.n), x.d, x.p, 60, 4.5, NULL, x.g,
       'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=600&q=80', 1, p.id, 'OTC', 0
FROM pharmacies p
JOIN (
  SELECT 'Karaikudi Apollo Pharmacy'   AS pname, 'Pain Relief'  AS c, 'Paracetamol 650'     AS n, 'Trusted paracetamol tablets for fever and pain relief' AS d, 12.00 AS p, '10 tablets' AS g
  UNION ALL SELECT 'Karaikudi Apollo Pharmacy',   'Digestive',     'Pan 40',                 'Antacid suspension for acidity and indigestion',                48.00, '100 ml'
  UNION ALL SELECT 'Karaikudi Apollo Pharmacy',   'First Aid',     'Bandage Roll',           'Sterile crepe bandage for sprains and cuts',                   85.00, '1 roll'
  UNION ALL SELECT 'Karaikudi Apollo Pharmacy',   'Vitamins',      'Vitamin C Tablets',       'Vitamin C supplementation for immunity support',               95.00, '30 tablets'

  UNION ALL SELECT 'Chettinad Health Pharmacy',   'Antibiotic',    'Amoxicillin Capsules',    'Broad-spectrum antibiotic for bacterial infections',          86.00, '10 capsules'
  UNION ALL SELECT 'Chettinad Health Pharmacy',   'Cough & Cold',  'Cough Syrup',             'Dry cough relief, sugar free',                                 64.00, '150 ml'
  UNION ALL SELECT 'Chettinad Health Pharmacy',   'Diabetes Care', 'Metformin Tablet',        'First-line medicine for type 2 diabetes',                      72.00, '10 tablets'
  UNION ALL SELECT 'Chettinad Health Pharmacy',   'First Aid',     'Antiseptic Liquid',       'Antiseptic wash for cuts, grazes and minor wounds',             55.00, '200 ml'

  UNION ALL SELECT 'Sivaganga Road Medicals',      'Pain Relief',   'Dolo 650',                'Paracetamol 650 mg, fast-acting pain relief',                   34.00, '15 tablets'
  UNION ALL SELECT 'Sivaganga Road Medicals',      'Digestive',     'ORS Sachet',              'Oral rehydration salts for dehydration',                        12.00, '1 sachet'
  UNION ALL SELECT 'Sivaganga Road Medicals',      'Eye Care',      'Eye Drops',               'Sterile lubricant eye drops for dry eyes',                      88.00, '10 ml'
  UNION ALL SELECT 'Sivaganga Road Medicals',      'Skin Care',     'Burn Ointment',           'Soothing burn and antiseptic ointment',                         42.00, '20 g'

  UNION ALL SELECT 'Pollachi City Pharmacy',       'Pain Relief',   'Ibuprofen 400',           'Anti-inflammatory analgesic for body pain',                    58.00, '10 tablets'
  UNION ALL SELECT 'Pollachi City Pharmacy',       'Allergy',       'Cetirizine Tablet',       'Non-drowsy antihistamine for allergies',                        42.00, '10 tablets'
  UNION ALL SELECT 'Pollachi City Pharmacy',       'Vitamins',      'Calcium + Vitamin D3',    'Bone and immunity support supplement',                          175.00, '30 tablets'
  UNION ALL SELECT 'Pollachi City Pharmacy',       'First Aid',     'Crepe Bandage 4"',       'Elastic crepe bandage for sprain support',                       95.00, '1 roll'

  UNION ALL SELECT 'Kongu Health Medicals',        'Cold & Fever',  'Combination Cold Tablet',  'Multi-symptom relief for common cold',                           38.00, '10 tablets'
  UNION ALL SELECT 'Kongu Health Medicals',        'Stomach Care',  'Antacid Gel',             'Antacid gel for quick acidity relief',                           68.00, '170 g'
  UNION ALL SELECT 'Kongu Health Medicals',        'Personal Care', 'Povidone Iodine',         'Povidone iodine antiseptic solution for cuts',                  45.00, '100 ml'
  UNION ALL SELECT 'Kongu Health Medicals',        'First Aid',     'Cotton Roll',             'Absorbent cotton for dressing wounds',                          28.00, '100 g'

  UNION ALL SELECT 'Udumalaipettai Chemist',       'Antibiotic',    'Azithromycin Tablet',      'Antibiotic for respiratory tract infections',                   165.00, '5 tablets'
  UNION ALL SELECT 'Udumalaipettai Chemist',       'Blood Pressure','Amlodipine Tablet',       'Calcium channel blocker for hypertension',                     78.00, '10 tablets'
  UNION ALL SELECT 'Udumalaipettai Chemist',       'Cholesterol',   'Atorvastatin Tablet',     'Statin for cholesterol management',                            132.00, '10 tablets'
  UNION ALL SELECT 'Udumalaipettai Chemist',       'Vitamins',      'Multivitamin Capsules',    'Daily multivitamin with essential minerals',                   225.00, '30 capsules'

  UNION ALL SELECT 'Nagercoil Apollo Meds',        'Pain Relief',   'Dolo 650',                'Paracetamol 650 mg fast-acting relief',                          34.00, '15 tablets'
  UNION ALL SELECT 'Nagercoil Apollo Meds',        'Skin Care',     'Ketoconazole Cream',      'Antifungal cream for skin infections',                           88.00, '20 g'
  UNION ALL SELECT 'Nagercoil Apollo Meds',        'Child Care',    'Paracetamol Pediatric',    'Children liquid suspension, gentle on the stomach',              42.00, '60 ml'
  UNION ALL SELECT 'Nagercoil Apollo Meds',        'First Aid',     'Antiseptic Cream',        'Antiseptic cream for minor cuts and scrapes',                    52.00, '20 g'

  UNION ALL SELECT 'Marthandam Medical Store',     'Allergy',       'Levocetirizine Tablet',   'Non-drowsy allergy relief',                                     56.00, '10 tablets'
  UNION ALL SELECT 'Marthandam Medical Store',     'Digestive',     'Esomeprazole Tablet',     'Acid control for acidity and reflux',                            98.00, '10 tablets'
  UNION ALL SELECT 'Marthandam Medical Store',     'Eye Care',      'Lubricant Eye Drops',     'Sterile ocular lubricant for irritated eyes',                    92.00, '10 ml'
  UNION ALL SELECT 'Marthandam Medical Store',     'First Aid',     'Sterile Gauze Pack',      'Sterile gauze pads for wound dressing',                         62.00, '4 pcs'

  UNION ALL SELECT 'Kanyakumari Health Centre',   'Pain Relief',   'Ibuprofen 400',           'Anti-inflammatory pain relief',                                 58.00, '10 tablets'
  UNION ALL SELECT 'Kanyakumari Health Centre',   'Respiratory',   'Salbutamol Inhaler',      'Bronchodilator inhaler for asthma relief',                      185.00, '1 inhaler'
  UNION ALL SELECT 'Kanyakumari Health Centre',   'Digestive',     'Ondem Syrup',             'Antiemetic syrup for nausea and vomiting',                       45.00, '100 ml'
  UNION ALL SELECT 'Kanyakumari Health Centre',   'First Aid',     'Adhesive Bandage',         'Skin-friendly adhesive bandages for minor cuts',                 32.00, '20 pcs'

  UNION ALL SELECT 'Theni City Pharmacy',          'Pain Relief',   'Crocin Tablet',           'Paracetamol for headache and body pain',                          14.00, '10 tablets'
  UNION ALL SELECT 'Theni City Pharmacy',          'Sugar Care',    'Metformin 500mg',          'First-line diabetes management tablet',                         72.00, '10 tablets'
  UNION ALL SELECT 'Theni City Pharmacy',          'Cardiac Care',  'Amlodipine 5mg',           'Blood pressure control tablet',                                  78.00, '10 tablets'
  UNION ALL SELECT 'Theni City Pharmacy',          'Vitamins',      'Omega 3 Capsules',         'Fish oil omega 3 for heart and brain health',                   340.00, '60 capsules'

  UNION ALL SELECT 'Bodinayakanur Medicals',       'Cough & Cold',  'Ascoril LS Syrup',         'Cough and cold syrup for adults',                                 82.00, '100 ml'
  UNION ALL SELECT 'Bodinayakanur Medicals',       'Gastro',        'Rantac Tablet',            'Ranitidine for acidity and stomach upset',                        46.00, '10 tablets'
  UNION ALL SELECT 'Bodinayakanur Medicals',       'First Aid',     'Betadine Solution',        'Povidone iodine antiseptic for cuts and grazes',                  45.00, '100 ml'
  UNION ALL SELECT 'Bodinayakanur Medicals',       'Vitamins',      'Zincovit Tablet',          'Multivitamin with zinc for immunity',                            155.00, '30 tablets'

  UNION ALL SELECT 'Periyakulam Health Mart',      'Pain Relief',   'Paracetamol 500',          'Everyday pain reliever and fever reducer',                       11.00, '10 tablets'
  UNION ALL SELECT 'Periyakulam Health Mart',      'Respiratory',   'Steam Inhalation Capsules','Aromatic capsules for nasal congestion',                       68.00, '10 capsules'
  UNION ALL SELECT 'Periyakulam Health Mart',      'Eye Care',      'Refresh Tears',            'Artificial tears for eye lubrication',                          85.00, '10 ml'
  UNION ALL SELECT 'Periyakulam Health Mart',      'Skin Care',     'Moisturising Cream',       'Daily moisturiser for dry and irritated skin',                    125.00, '100 g'
) x ON LOWER(p.name) = LOWER(x.pname)
WHERE NOT EXISTS (
  SELECT 1 FROM medicine_products mp
  WHERE mp.pharmacy_id = p.id AND LOWER(mp.name) = LOWER(CONCAT(p.name, ' ', x.n))
);