package com.app.start_app.delivery;

import com.app.start_app.settings.PlatformSettingsDAO;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Single entry point for every delivery-fee calculation.
 *
 * Rules (all numbers from platform_settings — never hardcoded here):
 *   fee = base + (per_km × distanceKm),  capped at fee_cap
 *   if orderTotal >= free_threshold → fee = 0
 *   if distanceKm > radius_km      → withinRadius = false (checkout blocked)
 *
 * Courier is always charged (no free-delivery threshold), and the fee is
 * the entire delivery cost — the platform/rider split is done in settlement.
 */
@Service
public class DeliveryFeeService {

    private final PlatformSettingsDAO settings;

    public DeliveryFeeService(PlatformSettingsDAO settings) {
        this.settings = settings;
    }

    // ── Public API ────────────────────────────────────────────

    public DeliveryFeeResponse calculate(DeliveryFeeRequest req) {
        String svc = normalise(req.getServiceType());
        String dist = normalise(req.getDistrict());

        double distanceKm = resolveDistance(req);
        double radiusKm   = settings.getDecimal("delivery." + svc + ".radius_km",
                                                 BigDecimal.valueOf(15)).doubleValue();
        boolean withinRadius = distanceKm <= radiusKm;

        int tier        = resolveTier(dist);
        String tierName = "Tier " + tier;

        BigDecimal baseFee    = settings.getDecimal(tierKey(tier, svc, "base_fee"), BigDecimal.ZERO);
        BigDecimal perKm      = settings.getDecimal(tierKey(tier, svc, "per_km"),   BigDecimal.ZERO);
        BigDecimal feeCap     = settings.getDecimal("delivery." + svc + ".fee_cap", BigDecimal.valueOf(150));
        BigDecimal freeThresh = freeThreshold(svc);

        BigDecimal distCharge = perKm.multiply(BigDecimal.valueOf(distanceKm))
                                     .setScale(2, RoundingMode.HALF_UP);
        BigDecimal rawFee     = baseFee.add(distCharge).setScale(2, RoundingMode.HALF_UP);

        boolean capApplied = rawFee.compareTo(feeCap) > 0;
        BigDecimal capped  = capApplied ? feeCap : rawFee;

        // Courier has no free-delivery threshold
        BigDecimal orderTotal = req.getOrderTotal() != null ? req.getOrderTotal() : BigDecimal.ZERO;
        boolean freeApplied = !"courier".equals(svc) && freeThresh != null
                && orderTotal.compareTo(freeThresh) >= 0;

        BigDecimal deliveryFee = freeApplied ? BigDecimal.ZERO : capped;
        BigDecimal total       = orderTotal.add(deliveryFee).setScale(2, RoundingMode.HALF_UP);

        // ── Radius label ──────────────────────────────────────
        String svcLabel = svc.substring(0, 1).toUpperCase() + svc.substring(1).toLowerCase();
        String radiusLabel = withinRadius
                ? String.format("Within %.0f km (%s)", radiusKm, svcLabel)
                : String.format("Outside %.0f km radius (%s)", radiusKm, svcLabel);

        // ── Build response ────────────────────────────────────
        DeliveryFeeResponse resp = new DeliveryFeeResponse();
        resp.setDistanceKm(distanceKm);
        resp.setRadiusKm(radiusKm);
        resp.setWithinRadius(withinRadius);
        resp.setRadiusLabel(radiusLabel);
        resp.setTierName(tierName);
        resp.setBaseFee(baseFee);
        resp.setDistanceCharge(distCharge);
        resp.setRawFee(rawFee);
        resp.setCapApplied(capApplied);
        resp.setFeeCap(capApplied ? feeCap : null);
        resp.setFreeDeliveryApplied(freeApplied);
        resp.setFreeDeliveryThreshold(freeThresh);
        resp.setDeliveryFee(deliveryFee.setScale(2, RoundingMode.HALF_UP));
        resp.setItemTotal(orderTotal.setScale(2, RoundingMode.HALF_UP));
        resp.setTotal(total);
        return resp;
    }

    // ── Helpers ───────────────────────────────────────────────

    private double resolveDistance(DeliveryFeeRequest req) {
        if (req.getDistanceKm() != null && req.getDistanceKm() >= 0) {
            return req.getDistanceKm();
        }
        Double clat = req.getCustomerLat(), clon = req.getCustomerLon();
        Double slat = req.getShopLat(),     slon = req.getShopLon();
        if (clat != null && clon != null && slat != null && slon != null) {
            return DistanceCalculatorUtil.haversineKm(slat, slon, clat, clon);
        }
        return 0.0;
    }

    /**
     * Looks up the district tier from platform_settings key
     * "district.tier.<name>".  Defaults to Tier 2 when unknown.
     */
    private int resolveTier(String district) {
        if (district == null || district.isBlank()) return 2;
        int tier = settings.getInt("district.tier." + district, 0);
        if (tier >= 1 && tier <= 3) return tier;
        return 2; // safe default for unknown districts
    }

    private String tierKey(int tier, String svc, String component) {
        return "delivery.tier" + tier + "." + svc + "." + component;
    }

    private BigDecimal freeThreshold(String svc) {
        String key = "delivery." + svc + ".free_threshold";
        String raw = settings.getString(key);
        if (raw == null || raw.isBlank()) return null;
        try { return new BigDecimal(raw.trim()); } catch (NumberFormatException e) { return null; }
    }

    private String normalise(String s) {
        return s == null ? "" : s.trim().toLowerCase();
    }
}
