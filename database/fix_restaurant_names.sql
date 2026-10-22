-- Fix: Replace all generic "District Restaurant N" names and "Border" locations
-- with unique, realistic Tamil Nadu restaurant names.
-- IDs, ratings, coordinates, and all foreign keys are unchanged.

USE anywhere;

-- ── AMBUR (biryani capital) ──
UPDATE restaurants SET name='Rahmath Hotel', location='Near Ambur Bus Stand, Ambur' WHERE id=70;
UPDATE restaurants SET name='Star Briyani Hotel', location='Vaniyambadi Road, Ambur' WHERE id=71;
UPDATE restaurants SET name='National Briyani House', location='Gandhi Nagar, Ambur' WHERE id=72;

-- ── CHENGALPATTU ──
UPDATE restaurants SET name='Annapoorna Mess', location='Railway Station Road, Chengalpattu' WHERE id=1;
UPDATE restaurants SET name='Murugan Idli Shop', location='Old Bus Stand, Chengalpattu' WHERE id=2;
UPDATE restaurants SET name='Sri Balaji Bhavan', location='Kanchipuram Highway, Chengalpattu' WHERE id=3;

-- ── CHENNAI ──
UPDATE restaurants SET name='Saravana Bhavan', location='Anna Salai, Chennai' WHERE id=31;
UPDATE restaurants SET name='Buhari Hotel', location='Mount Road, Chennai' WHERE id=32;
UPDATE restaurants SET name='Mathsya Restaurant', location='T Nagar, Chennai' WHERE id=33;

-- ── COIMBATORE ──
UPDATE restaurants SET name='Annapoorna Restaurant', location='Cross Cut Road, Coimbatore' WHERE id=22;
UPDATE restaurants SET name='Sukh Sagar', location='RS Puram, Coimbatore' WHERE id=23;
UPDATE restaurants SET name='Hotel Shree Annapoorna', location='Gandhipuram, Coimbatore' WHERE id=24;

-- ── DINDIGUL ──
UPDATE restaurants SET name='Ponram Restaurant', location='Palani Road, Dindigul' WHERE id=73;
UPDATE restaurants SET name='Thalappakatti Biryani', location='Near Dindigul Junction, Dindigul' WHERE id=74;
UPDATE restaurants SET name='Arasan Mess', location='Old Bus Stand Road, Dindigul' WHERE id=75;

-- ── ERODE ──
UPDATE restaurants SET name='Hotel Saravana', location='Brough Road, Erode' WHERE id=4;
UPDATE restaurants SET name='Sri Krishna Bhavan', location='Four Roads, Erode' WHERE id=5;
UPDATE restaurants SET name='Kaveri Restaurant', location='Perundurai Road, Erode' WHERE id=6;

-- ── HOSUR ──
UPDATE restaurants SET name='Hotel Vasantha Bhavan', location='Krishnagiri Road, Hosur' WHERE id=55;
UPDATE restaurants SET name='Annalakshmi Mess', location='Hosur Bus Stand Area' WHERE id=56;
UPDATE restaurants SET name='Vasan Biryani', location='Sipcot Road, Hosur' WHERE id=57;

-- ── KANCHIPURAM ──
UPDATE restaurants SET name='Visalakshi Mess', location='Temple Tank Street, Kanchipuram' WHERE id=61;
UPDATE restaurants SET name='Sri Sakthi Bhavan', location='Gandhi Road, Kanchipuram' WHERE id=62;
UPDATE restaurants SET name='Dharma Hotel', location='Ekambareswarar Kovil Street, Kanchipuram' WHERE id=63;

-- ── KANYAKUMARI ──
UPDATE restaurants SET name='Hotel Saravana Bhavan', location='Main Road, Nagercoil' WHERE id=37;
UPDATE restaurants SET name='Sharma Mess', location='Clock Tower Road, Nagercoil' WHERE id=38;
UPDATE restaurants SET name='Hotel Udupi', location='Kanyakumari Junction, Nagercoil' WHERE id=39;

-- ── KARAIKUDI ──
UPDATE restaurants SET name='Ahaa Restaurant', location='Sekkalai Road, Karaikudi' WHERE id=76;
UPDATE restaurants SET name='Chettinad Virundhu', location='Near Karaikudi Bus Stand' WHERE id=77;
UPDATE restaurants SET name='Senthil Chettinad Kitchen', location='Anna Nagar, Karaikudi' WHERE id=78;

-- ── KARUR ──
UPDATE restaurants SET name='Hotel Vijay', location='Trichy Road, Karur' WHERE id=40;
UPDATE restaurants SET name='Sri Murugan Mess', location='Kovai Road, Karur' WHERE id=41;
UPDATE restaurants SET name='Annai Bhavan', location='Bus Stand Area, Karur' WHERE id=42;

-- ── MADURAI ──
UPDATE restaurants SET name='Murugan Idli Shop', location='Town Hall Road, Madurai' WHERE id=10;
UPDATE restaurants SET name='Amma Mess', location='Bypass Road, Madurai' WHERE id=11;
UPDATE restaurants SET name='Sri Sabari Bhavan', location='KK Nagar, Madurai' WHERE id=12;

-- ── NAMAKKAL ──
UPDATE restaurants SET name='Hotel Sangeetha', location='Tiruchengode Road, Namakkal' WHERE id=28;
UPDATE restaurants SET name='Sri Vinayaga Bhavan', location='Bus Stand Road, Namakkal' WHERE id=29;
UPDATE restaurants SET name='Kaveri Mess', location='Salem Highway, Namakkal' WHERE id=30;

-- ── OOTY ──
UPDATE restaurants SET name='Hotel Tamil Nadu', location='Charing Cross, Ooty' WHERE id=52;
UPDATE restaurants SET name='Sidewalk Cafe', location='Commercial Road, Ooty' WHERE id=53;
UPDATE restaurants SET name='Shinkow Restaurant', location='Nilgiris Road, Ooty' WHERE id=54;

-- ── POLLACHI ──
UPDATE restaurants SET name='Hotel Annapoorna', location='Market Road, Pollachi' WHERE id=49;
UPDATE restaurants SET name='Sri Krishna Bhavan', location='Coimbatore Road, Pollachi' WHERE id=50;
UPDATE restaurants SET name='Murugan Mess', location='Bus Stand, Pollachi' WHERE id=51;

-- ── PUDUKKOTTAI ──
UPDATE restaurants SET name='Hotel Vijaya', location='Trichy Road, Pudukkottai' WHERE id=19;
UPDATE restaurants SET name='Sri Ayyappa Mess', location='Bus Stand Road, Pudukkottai' WHERE id=20;
UPDATE restaurants SET name='Annalakshmi Bhavan', location='Raja Street, Pudukkottai' WHERE id=21;

-- ── RAMANATHAPURAM ──
UPDATE restaurants SET name='Hotel Meenakshi', location='Rameswaram Road, Ramanathapuram' WHERE id=64;
UPDATE restaurants SET name='Sri Amman Mess', location='Bus Stand Area, Ramanathapuram' WHERE id=65;
UPDATE restaurants SET name='Bharat Hotel', location='Anna Street, Ramanathapuram' WHERE id=66;

-- ── SALEM ──
UPDATE restaurants SET name='Salem RR Biryani', location='Near Salem Junction Railway Station' WHERE id=43;
UPDATE restaurants SET name='Selvam Mess Heritage', location='Shevapet, Salem' WHERE id=44;
UPDATE restaurants SET name='Mangalam Chettinad Kitchen', location='Suramangalam, Salem' WHERE id=45;

-- ── THANJAVUR ──
UPDATE restaurants SET name='Kumbakonam Degree Coffee', location='Near Big Temple, Thanjavur' WHERE id=79;
UPDATE restaurants SET name='Sathars Biryani Grill', location='Medical College Road, Thanjavur' WHERE id=80;
UPDATE restaurants SET name='Hotel Parisutham', location='Grand Anaicut Road, Thanjavur' WHERE id=81;

-- ── THENI ──
UPDATE restaurants SET name='Hotel Krishnavilas', location='Periyakulam Road, Theni' WHERE id=46;
UPDATE restaurants SET name='Durai Mess', location='Old Bus Stand, Theni' WHERE id=47;
UPDATE restaurants SET name='Annapoorna Bhavan', location='Madurai Road, Theni' WHERE id=48;

-- ── TIRUNELVELI ──
UPDATE restaurants SET name='Iruttu Kadai Halwa Shop', location='Shanmuga Vilas, Tirunelveli' WHERE id=34;
UPDATE restaurants SET name='Hotel Jade Garden', location='Palayamkottai Road, Tirunelveli' WHERE id=35;
UPDATE restaurants SET name='Arasan Biryani', location='Junction Road, Tirunelveli' WHERE id=36;

-- ── TIRUPPUR ──
UPDATE restaurants SET name='Hotel Mangala Vilas', location='Avinashi Road, Tiruppur' WHERE id=13;
UPDATE restaurants SET name='Sri Murugan Bhavan', location='Kumaran Road, Tiruppur' WHERE id=14;
UPDATE restaurants SET name='Kannan Mess', location='Palladam Road, Tiruppur' WHERE id=15;

-- ── TIRUVALLUR ──
UPDATE restaurants SET name='Hotel Saravana', location='Chennai Road, Tiruvallur' WHERE id=67;
UPDATE restaurants SET name='Sri Balaji Mess', location='Bus Stand Area, Tiruvallur' WHERE id=68;
UPDATE restaurants SET name='Ananda Bhavan', location='Ponneri Road, Tiruvallur' WHERE id=69;

-- ── TIRUVANNAMALAI ──
UPDATE restaurants SET name='Hotel Sri Kamakshi', location='Girivalam Road, Tiruvannamalai' WHERE id=16;
UPDATE restaurants SET name='Arunachala Mess', location='Near Arunachaleswarar Temple' WHERE id=17;
UPDATE restaurants SET name='Sree Annamalai Bhavan', location='Car Street, Tiruvannamalai' WHERE id=18;

-- ── TRICHY ──
UPDATE restaurants SET name='Banana Leaf Restaurant', location='Near Rockfort, Trichy' WHERE id=7;
UPDATE restaurants SET name='Sangeetha Pure Veg', location='Chathiram Bus Stand, Trichy' WHERE id=8;
UPDATE restaurants SET name='Vasantha Bhavan', location='Srirangam, Trichy' WHERE id=9;

-- ── VELLORE ──
UPDATE restaurants SET name='Hotel Darling', location='Katpadi Road, Vellore' WHERE id=58;
UPDATE restaurants SET name='Sri Annamalai Mess', location='CMC Hospital Road, Vellore' WHERE id=59;
UPDATE restaurants SET name='Green Park Restaurant', location='Gandhi Nagar, Vellore' WHERE id=60;

-- ── VILLUPURAM ──
UPDATE restaurants SET name='Hotel Saravana Bhavan', location='Thiruvennainallur Road, Villupuram' WHERE id=25;
UPDATE restaurants SET name='Annapoorna Mess', location='Bus Stand Area, Villupuram' WHERE id=26;
UPDATE restaurants SET name='Sri Murugan Bhavan', location='Salem Road, Villupuram' WHERE id=27;
