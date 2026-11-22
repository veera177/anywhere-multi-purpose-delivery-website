package com.app.start_app.delivery;

/**
 * Haversine formula — identical to the one used in the frontend
 * (distanceService.js).  Result is rounded to 2 decimal places.
 * This is the single canonical implementation; both the fee service
 * and the /api/distance endpoint use it.
 */
public final class DistanceCalculatorUtil {

    private static final double EARTH_RADIUS_KM = 6371.0;

    private DistanceCalculatorUtil() {}

    public static double haversineKm(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double raw = EARTH_RADIUS_KM * c;
        return Math.round(raw * 100.0) / 100.0;
    }
}
