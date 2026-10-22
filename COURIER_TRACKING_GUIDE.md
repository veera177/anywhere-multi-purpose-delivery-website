# Courier Location Tracking & Distance Calculation Guide

## 📍 Overview

Complete implementation for real-time courier location tracking with automatic distance calculation and fee estimation for the "Anywhere" delivery app.

## 🏗️ Architecture

### Backend (Java Spring Boot)

#### 1. **Models**
- `CourierLocation.java` - Individual location points (pickup/delivery)
- `CourierRoute.java` - Complete route with start/end locations

#### 2. **Utilities**
- `DistanceCalculator.java` - Haversine formula for accurate distance calculation

#### 3. **Data Access Layer (DAO)**
- `CourierLocationDAO.java` - CRUD operations for locations
- `CourierRouteDAO.java` - CRUD operations for routes

#### 4. **Service Layer**
- `CourierTrackingService.java` - Business logic for tracking

#### 5. **REST Controller**
- `CourierTrackingController.java` - API endpoints

### Frontend (React)

#### 1. **Services**
- `courierTrackingService.js` - API calls and utility functions

#### 2. **Components**
- `CourierTracking.jsx` - Real-time tracking UI
- `CourierTracking.css` - Styling with animations

---

## 🚀 API Endpoints

### 1. Create Route
```
POST /api/courier/tracking/create-route
Content-Type: application/json

Request:
{
  "orderId": 123,
  "courierId": 45,
  "pickupLatitude": 13.0827,
  "pickupLongitude": 80.2707,
  "deliveryLatitude": 13.1939,
  "deliveryLongitude": 80.2823,
  "pickupAddress": "Door no 10, Anna Nagar, Chennai",
  "deliveryAddress": "Door no 50, T. Nagar, Chennai",
  "mapUrl": "https://www.openstreetmap.org/..."
}

Response:
{
  "success": true,
  "message": "Route created successfully",
  "route": {
    "id": 1,
    "orderId": 123,
    "status": "PENDING",
    "totalDistanceKm": 8.5,
    "estimatedDurationMinutes": 18
  }
}
```

### 2. Add Location
```
POST /api/courier/tracking/add-location
Content-Type: application/json

Request:
{
  "courierId": 45,
  "locationName": "Pickup Point A",
  "latitude": 13.0827,
  "longitude": 80.2707,
  "address": "Door no 10, Anna Nagar",
  "contactName": "Raj Kumar",
  "contactPhone": "9876543210",
  "locationType": "PICKUP"
}

Response:
{
  "success": true,
  "location": {
    "id": 1,
    "status": "PENDING",
    "distanceFromPrevious": 0.0
  }
}
```

### 3. Get Route Details
```
GET /api/courier/tracking/route/{routeId}

Response:
{
  "success": true,
  "route": {
    "id": 1,
    "status": "PENDING",
    "totalDistanceKm": 8.5,
    "pickupAddress": "...",
    "deliveryAddress": "...",
    "locationHistory": [
      {
        "id": 1,
        "locationType": "PICKUP",
        "status": "PENDING",
        "address": "...",
        "distanceFromPrevious": 0.0
      },
      {
        "id": 2,
        "locationType": "DELIVERY",
        "status": "PENDING",
        "address": "...",
        "distanceFromPrevious": 8.5
      }
    ]
  }
}
```

### 4. Start Route
```
POST /api/courier/tracking/start/{routeId}

Response:
{
  "success": true,
  "message": "Route started successfully",
  "status": "IN_TRANSIT"
}
```

### 5. Mark Location Reached
```
POST /api/courier/tracking/location/{locationId}/reached

Response:
{
  "success": true,
  "status": "REACHED"
}
```

### 6. Mark Location Completed
```
POST /api/courier/tracking/location/{locationId}/completed

Response:
{
  "success": true,
  "status": "COMPLETED"
}
```

### 7. Complete Route
```
POST /api/courier/tracking/complete/{routeId}

Response:
{
  "success": true,
  "status": "DELIVERED",
  "actualDurationMinutes": 16
}
```

### 8. Get Total Distance
```
GET /api/courier/tracking/distance/{courierId}

Response:
{
  "success": true,
  "totalDistance": 25.3,
  "unit": "km"
}
```

### 9. Calculate Delivery Fee
```
POST /api/courier/tracking/calculate-fee
Content-Type: application/json

Request:
{
  "distanceKm": 8.5,
  "areaTier": 1
}

Response:
{
  "success": true,
  "distanceKm": 8.5,
  "areaTier": 1,
  "deliveryFee": 98.0,
  "currency": "INR"
}
```

---

## 💾 Database Schema

### courier_routes Table
```sql
CREATE TABLE courier_routes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  courier_id INT,
  status ENUM('PENDING', 'IN_TRANSIT', 'DELIVERED'),
  total_distance_km DECIMAL(10, 2),
  estimated_duration_minutes INT,
  actual_duration_minutes INT,
  pickup_latitude DECIMAL(10, 8),
  pickup_longitude DECIMAL(11, 8),
  delivery_latitude DECIMAL(10, 8),
  delivery_longitude DECIMAL(11, 8),
  pickup_address TEXT,
  delivery_address TEXT,
  map_url TEXT,
  created_at DATETIME,
  started_at DATETIME,
  completed_at DATETIME,
  FOREIGN KEY (order_id) REFERENCES orders(id)
);
```

### courier_locations Table
```sql
CREATE TABLE courier_locations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  courier_id INT NOT NULL,
  location_name VARCHAR(255),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  address TEXT,
  contact_name VARCHAR(100),
  contact_phone VARCHAR(20),
  location_type ENUM('PICKUP', 'DELIVERY'),
  status ENUM('PENDING', 'REACHED', 'COMPLETED'),
  arrival_time DATETIME,
  completion_time DATETIME,
  distance_from_previous DECIMAL(10, 2),
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (courier_id) REFERENCES orders(id)
);
```

---

## 📊 Distance Calculation

### Haversine Formula (Great-circle distance)
```
Δσ = 2 * arcsin(√[sin²(Δφ/2) + cos φ1 * cos φ2 * sin²(Δλ/2)])
d = R * Δσ

Where:
- φ is latitude, λ is longitude, R is earth's radius (6371 km)
- Δφ = lat2 - lat1
- Δλ = lon2 - lon1
```

### Duration Estimation
```
Duration (minutes) = Distance (km) / (Speed km/h ÷ 60)
With 15% traffic buffer added
Average speed: 40 km/h (urban area)
```

### Delivery Fee Calculation

**Urban (Tier 1):**
- Base Fee: ₹30
- Per KM Rate: ₹8/km
- Formula: 30 + ((distance - 1) × 8)

**Town (Tier 2):**
- Base Fee: ₹50
- Per KM Rate: ₹12/km
- Formula: 50 + ((distance - 1) × 12)

**Rural (Tier 3):**
- Base Fee: ₹70
- Per KM Rate: ₹15/km
- Formula: 70 + ((distance - 1) × 15)

---

## 🔌 Integration Steps

### 1. Backend Setup
```java
// In CourierTrackingController constructor
CourierLocationDAO locationDAO = new CourierLocationDAO(jdbcTemplate);
CourierRouteDAO routeDAO = new CourierRouteDAO(jdbcTemplate);
trackingService = new CourierTrackingService(locationDAO, routeDAO);
```

### 2. Frontend Usage

```javascript
import { getRouteDetails, subscribeToRouteUpdates } from '@/services/courierTrackingService';
import CourierTracking from '@/components/CourierTracking';

// Use component
<CourierTracking routeId={routeId} onBack={handleBack} />

// Or use service directly
const route = await getRouteDetails(routeId);
```

### 3. Real-time Updates

```javascript
// Subscribe to updates every 5 seconds
const unsubscribe = subscribeToRouteUpdates(routeId, (data) => {
  console.log("Updated route:", data);
});

// Cleanup when done
unsubscribe();
```

---

## 🎯 Usage Example

### Creating a New Route
```javascript
import { createCourierRoute } from '@/services/courierTrackingService';

const routeData = {
  orderId: 123,
  courierId: 45,
  pickupLatitude: 13.0827,
  pickupLongitude: 80.2707,
  deliveryLatitude: 13.1939,
  deliveryLongitude: 80.2823,
  pickupAddress: "Anna Nagar, Chennai",
  deliveryAddress: "T. Nagar, Chennai",
  mapUrl: "https://..."
};

const result = await createCourierRoute(routeData);
console.log("Route created:", result.route);
console.log("Total Distance:", result.totalDistance, "km");
```

### Tracking a Route
```javascript
import CourierTracking from '@/components/CourierTracking';

export default function OrderTrackingPage() {
  return (
    <CourierTracking 
      routeId={orderId}
      onBack={() => navigate('/orders')}
    />
  );
}
```

---

## 📱 Features

✅ **Real-time Location Tracking**
- Live GPS coordinates
- Status updates (PENDING → REACHED → COMPLETED)
- Arrival and completion timestamps

✅ **Distance Calculation**
- Haversine formula for accuracy
- Automatic distance from previous location
- Total route distance

✅ **Delivery Fee Estimation**
- Based on distance and area tier
- Shown before and after delivery
- Transparent fee breakdown

✅ **Route Management**
- Create routes with multiple locations
- Track multiple stops
- View complete route history

✅ **UI Features**
- Expandable location details
- Real-time status badges
- Map integration with OSM
- Animations and transitions
- Responsive design

---

## ⚙️ Configuration

### Connection Pool Settings (application.properties)
```properties
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=20000
```

### CORS Configuration
```java
@CrossOrigin(origins = "*", allowedHeaders = "*", 
             methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT})
```

---

## 🧪 Testing

### Test Route Creation
```bash
curl -X POST http://localhost:8080/api/courier/tracking/create-route \
  -H "Content-Type: application/json" \
  -d '{
    "orderId": 1,
    "courierId": 2,
    "pickupLatitude": 13.0827,
    "pickupLongitude": 80.2707,
    "deliveryLatitude": 13.1939,
    "deliveryLongitude": 80.2823,
    "pickupAddress": "Anna Nagar",
    "deliveryAddress": "T. Nagar"
  }'
```

### Test Distance Calculation
```bash
curl -X POST http://localhost:8080/api/courier/tracking/calculate-fee \
  -H "Content-Type: application/json" \
  -d '{
    "distanceKm": 8.5,
    "areaTier": 1
  }'
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Tables not created | Ensure DAO methods are called on startup |
| Invalid coordinates | Check latitude (-90 to 90) and longitude (-180 to 180) |
| Distance = 0 | Ensure different coordinates for pickup/delivery |
| CORS errors | Verify CrossOrigin annotation in controller |
| Null pointer on updates | Ensure route exists before starting |

---

## 📚 Additional Resources

- [Haversine Formula](https://en.wikipedia.org/wiki/Haversine_formula)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Spring Boot JDBC](https://spring.io/projects/spring-framework)

---

## 📝 Notes

- All distances are rounded to 2 decimal places
- Duration estimates include 15% traffic buffer
- Coordinates use WGS84 (latitude, longitude) format
- Database timestamps use `yyyy-MM-dd HH:mm:ss` format
- Delivery fees are in Indian Rupees (₹)

---

## ✅ Completed Files

✅ Backend:
- `CourierLocation.java`
- `CourierRoute.java`
- `DistanceCalculator.java`
- `CourierLocationDAO.java`
- `CourierRouteDAO.java`
- `CourierTrackingService.java`
- `CourierTrackingController.java`

✅ Frontend:
- `courierTrackingService.js`
- `CourierTracking.jsx`
- `CourierTracking.css`

---

Last Updated: 2025-08-11 | Version: 1.0
