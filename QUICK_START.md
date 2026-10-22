# 🚀 Quick Start Guide - Anywhere Courier Tracking

## Prerequisites
- Node.js 16+ (React frontend)
- Java 17+ (Spring Boot backend)
- MySQL 8.0+ (auto-creates tables)
- Browser with ES6+ support

---

## 🏃 5-Minute Setup

### Step 1: Start Backend
```bash
cd backend
./mvnw.cmd spring-boot:run
# Server runs on http://localhost:8080
# Auto-creates courier_routes and courier_locations tables
```

### Step 2: Start Frontend
```bash
cd my-react-app
npm install  # First time only
npm start
# App runs on http://localhost:3000
```

### Step 3: Test Courier Booking
1. Open http://localhost:3000
2. Click "Courier" service
3. Fill form: Anna Nagar → T. Nagar
4. Click "Calculate route and fee"
5. Expected: 8.5 km, ~18 min, ₹98 fee
6. Complete payment (COD or Razorpay test)
7. Go to Orders → Click "📍 Track Delivery"
8. See live location tracking!

---

## 📞 Key API Endpoints

### Create Route
```bash
curl -X POST http://localhost:8080/api/courier/tracking/create-route \
  -H "Content-Type: application/json" \
  -d '{
    "orderId": 1001,
    "courierId": 1,
    "pickupLatitude": 13.0827,
    "pickupLongitude": 80.2707,
    "deliveryLatitude": 13.1939,
    "deliveryLongitude": 80.2823,
    "pickupAddress": "Anna Nagar, Chennai",
    "deliveryAddress": "T. Nagar, Chennai",
    "mapUrl": "https://osm.org"
  }'
```

### Add Location
```bash
curl -X POST http://localhost:8080/api/courier/tracking/add-location \
  -H "Content-Type: application/json" \
  -d '{
    "courierId": 1,
    "locationName": "Pickup - Document",
    "latitude": 13.0827,
    "longitude": 80.2707,
    "address": "Anna Nagar, Chennai",
    "contactName": "John Doe",
    "contactPhone": "9876543210",
    "locationType": "PICKUP"
  }'
```

### Get Route Status
```bash
curl http://localhost:8080/api/courier/tracking/route/1
```

---

## 🧪 Test Scenarios

### Scenario 1: Normal Booking → Tracking
```
1. User: "Book courier"
2. AI: Shows courier form
3. User: Fills pickup/delivery addresses
4. System: Creates route (8.5 km)
5. User: Completes payment
6. System: Order saved with routeId
7. User: Clicks "Track Delivery"
8. Result: Live tracking with updates
```

### Scenario 2: AI Navigation
```
1. User: "Find food nearby"
2. AI: Navigates to FoodDelivery page
3. User: "Show my cart"
4. AI: Navigates to Cart page
5. User: "Track my order"
6. AI: Navigates to Orders page
```

### Scenario 3: Real-time Updates
```
1. Open CourierTracking component
2. Backend updates location status via API
3. Frontend polls every 5 seconds
4. UI updates with new status
5. Animation shows status change
```

---

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check Java version
java -version  # Should be 17+

# Clear Maven cache
mvn clean

# Rebuild
./mvnw.cmd clean spring-boot:run
```

### Frontend won't load
```bash
# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -r node_modules
npm install

# Start fresh
npm start
```

### Routes not tracking
- Verify backend is running on :8080
- Check browser console for API errors
- Verify routeId is in order data
- Check database connection

### Distance calculation wrong
- Verify coordinates format: lat, lon (not lon, lat)
- Test with known locations
- Check Haversine formula in DistanceCalculator.java

---

## 📊 File Locations Reference

| Component | File |
|-----------|------|
| Courier Booking | `my-react-app/src/pages/CourierDelivery/CourierDelivery.jsx` |
| Tracking Display | `my-react-app/src/components/CourierTracking.jsx` |
| Order History | `my-react-app/src/pages/Orders/Orders.jsx` |
| Payment Flow | `my-react-app/src/pages/Payment/Payment.jsx` |
| Backend API | `backend/src/.../courier/CourierTrackingController.java` |
| AI Assistant | `my-react-app/src/components/AIChatWindow.jsx` |
| App Router | `my-react-app/src/App.jsx` |

---

## 🔑 Important Variables

### Frontend (courierTrackingService.js)
```javascript
API_URL = "http://localhost:8080/api/courier/tracking"
POLLING_INTERVAL = 5000  // milliseconds
HAVERSINE_RADIUS = 6371  // Earth's radius in km
```

### Backend (CourierTrackingController.java)
```java
@RequestMapping("/api/courier/tracking")
// 9 endpoints available
```

### Database
```sql
-- Auto-created tables:
courier_routes       -- Main route data
courier_locations    -- Pickup/delivery stops
```

---

## ✅ Verification Checklist

Before considering implementation complete:
- [ ] Backend runs without errors
- [ ] Frontend loads splash screen
- [ ] AI chat button appears (bottom-right)
- [ ] Courier booking form shows
- [ ] Route calculation works (8.5 km)
- [ ] Payment completes
- [ ] Orders page shows courier order
- [ ] "Track Delivery" button appears
- [ ] Tracking page loads
- [ ] Real-time updates work (every 5 sec)
- [ ] AI navigation works
- [ ] Theme colors are consistent

---

## 📞 Common Tasks

### Add a new location to route
```javascript
import { addLocationToRoute } from '../services/courierTrackingService';

await addLocationToRoute({
  courierId: routeId,
  locationName: "Stop 3",
  latitude: 13.2,
  longitude: 80.3,
  address: "Some Address",
  contactName: "Name",
  contactPhone: "9876543210",
  locationType: "DELIVERY"
});
```

### Update route status
```javascript
// In backend, update via API:
POST /api/courier/tracking/start/{routeId}
// Status changes: PENDING → IN_TRANSIT
```

### Calculate fee
```javascript
import { calculateDeliveryFee } from '../services/courierTrackingService';

const fee = await calculateDeliveryFee(8.5, 1); // 8.5 km, Urban tier
// Returns: ₹98
```

---

## 🎯 Success Metrics

After setup, verify:
- [ ] First route creation: <500ms
- [ ] Location polling: 5-second intervals
- [ ] Frontend re-render: <50ms
- [ ] Total UX: ~2-3 seconds to tracking
- [ ] Mobile responsiveness: Tested on 3 screen sizes
- [ ] Zero console errors
- [ ] Database tables present

---

## 📖 Full Documentation

For detailed info, see:
- `IMPLEMENTATION_COMPLETE.md` - Full feature overview
- `COURIER_TRACKING_GUIDE.md` - API reference
- `INTEGRATION_EXAMPLE.md` - Code samples
- Inline code comments in Java/JSX files

---

## 🎉 You're Ready!

Courier tracking is now fully functional. Users can book deliveries and track them in real-time!

Questions? Check the docs or review the code comments.

Happy coding! 🚀
