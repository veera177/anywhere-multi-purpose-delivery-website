package com.app.start_app.delivery;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Two endpoints:
 *   POST /api/delivery-fee/preview  – full fee breakdown (Part B)
 *   POST /api/distance              – Haversine distance (used by distanceService.js)
 */
@RestController
@CrossOrigin(origins = "*")
public class DeliveryFeeController {

    private final DeliveryFeeService feeService;

    public DeliveryFeeController(DeliveryFeeService feeService) {
        this.feeService = feeService;
    }

    /**
     * Full enriched fee response consumed by Checkout.jsx.
     * Returns 400 when serviceType is missing or the customer is outside the radius.
     * The 400 on outside-radius is intentional so the frontend can block checkout.
     */
    @PostMapping("/api/delivery-fee/preview")
    public ResponseEntity<?> preview(@RequestBody DeliveryFeeRequest request) {
        if (request.getServiceType() == null || request.getServiceType().isBlank()) {
            return ResponseEntity.badRequest().body("serviceType is required");
        }
        DeliveryFeeResponse response = feeService.calculate(request);
        if (Boolean.FALSE.equals(response.getWithinRadius())) {
            // Return the full response with 422 so the frontend can display
            // the distance and reason while blocking the Pay button.
            return ResponseEntity.unprocessableEntity().body(response);
        }
        return ResponseEntity.ok(response);
    }

    /**
     * Haversine distance — mirrors the formula in distanceService.js.
     * Used as the backend fallback when the frontend cannot compute it.
     */
    @PostMapping("/api/distance")
    public ResponseEntity<?> distance(@RequestBody DistanceRequest req) {
        if (req.getLat1() == null || req.getLon1() == null
                || req.getLat2() == null || req.getLon2() == null) {
            return ResponseEntity.badRequest().body("lat1, lon1, lat2, lon2 are all required");
        }
        double km = DistanceCalculatorUtil.haversineKm(
                req.getLat1(), req.getLon1(), req.getLat2(), req.getLon2());
        return ResponseEntity.ok(Map.of("distanceKm", km));
    }
}
