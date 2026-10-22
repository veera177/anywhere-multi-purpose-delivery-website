# Database Folder Structure

This is the **Database** folder containing all SQL scripts and database schemas for the multi-service delivery application.

## Project Structure

```
D:\anywhere/
├── Core Tables
│   ├── user-profile.sql             # User accounts & profiles
│   ├── address-management.sql       # User addresses
│   └── address-locations.sql        # Geographic location data
│
├── Food Delivery Service
│   ├── fooddelivery.sql             # Restaurant & food products
│   └── orderitems.sql               # Food order items
│
├── Grocery Service
│   └── grocery_store.sql            # Grocery stores & products
│
├── Pharmacy Service
│   ├── pharmacy.sql                 # Pharmacy & medicines
│   └── prescription-verification.sql# Prescription records
│
├── Order Management
│   └── order[payment].sql           # Order & payment details
│
├── Cart Service
│   └── cart.sql                     # Shopping cart data
│
├── Payment Service
│   └── payment.sql                  # Payment transactions
│
├── Delivery & Logistics
│   ├── delivery-fee-settings.sql    # Delivery fee configuration
│   ├── courier-tracking.sql         # Courier route tracking
│   ├── district-areas.sql           # District & area division
│
├── Seed Data
│   ├── seed_3_stores.sql            # Sample store data
│   └── seed_new_districts.sql       # Sample district data
│
└── README.md                        # Documentation
```

## Database Schema Overview

### Core Tables
| Table | File | Purpose |
|-------|------|---------|
| **users** | `user-profile.sql` | User authentication & profiles |
| **addresses** | `address-management.sql` | Delivery & user addresses |
| **locations** | `address-locations.sql` | Geographic coordinates |

### Food Delivery
| Table | File | Purpose |
|-------|------|---------|
| **restaurants** | `fooddelivery.sql` | Restaurant info |
| **food_products** | `fooddelivery.sql` | Food items & menu |
| **order_items** | `orderitems.sql` | Items in each order |

### Grocery Service
| Table | File | Purpose |
|-------|------|---------|
| **grocery_stores** | `grocery_store.sql` | Store locations |
| **grocery_products** | `grocery_store.sql` | Grocery items & pricing |

### Pharmacy Service
| Table | File | Purpose |
|-------|------|---------|
| **pharmacies** | `pharmacy.sql` | Pharmacy locations |
| **medicines** | `pharmacy.sql` | Medicine catalog |
| **prescriptions** | `prescription-verification.sql` | Prescription records |

### Order & Payment
| Table | File | Purpose |
|-------|------|---------|
| **orders** | `order[payment].sql` | Order records |
| **payments** | `payment.sql` | Payment transactions |

### Delivery & Logistics
| Table | File | Purpose |
|-------|------|---------|
| **couriers** | `courier-tracking.sql` | Courier info |
| **routes** | `courier-tracking.sql` | Delivery routes |
| **districts** | `district-areas.sql` | Area divisions |
| **delivery_fees** | `delivery-fee-settings.sql` | Fee calculations |

### Cart Service
| Table | File | Purpose |
|-------|------|---------|
| **carts** | `cart.sql` | User shopping carts |
| **cart_items** | `cart.sql` | Items in carts |

## Setup Instructions

1. **Create Database**:
   ```sql
   CREATE DATABASE startapp_db;
   USE startapp_db;
   ```

2. **Run All SQL Scripts** (in order):
   ```bash
   mysql -u root -p startapp_db < user-profile.sql
   mysql -u root -p startapp_db < address-management.sql
   mysql -u root -p startapp_db < address-locations.sql
   mysql -u root -p startapp_db < fooddelivery.sql
   mysql -u root -p startapp_db < grocery_store.sql
   mysql -u root -p startapp_db < pharmacy.sql
   mysql -u root -p startapp_db < prescription-verification.sql
   mysql -u root -p startapp_db < cart.sql
   mysql -u root -p startapp_db < orderitems.sql
   mysql -u root -p startapp_db < payment.sql
   mysql -u root -p startapp_db < delivery-fee-settings.sql
   mysql -u root -p startapp_db < courier-tracking.sql
   mysql -u root -p startapp_db < district-areas.sql
   mysql -u root -p startapp_db < seed_3_stores.sql
   mysql -u root -p startapp_db < seed_new_districts.sql
   ```

3. **Seed Data** (optional):
   ```bash
   mysql -u root -p startapp_db < seed_3_stores.sql
   mysql -u root -p startapp_db < seed_new_districts.sql
   ```

## Backend Configuration
- Update `application.properties` in backend with database connection:
  ```properties
  spring.datasource.url=jdbc:mysql://localhost:3306/startapp_db
  spring.datasource.username=root
  spring.datasource.password=your_password
  ```

## Related Folders
- **Backend**: `d:\springboot\start-app\start-app` (Java services accessing these tables)
- **Frontend**: `C:\Users\veera vadivelan\OneDrive\Desktop` (React UI displaying data)
