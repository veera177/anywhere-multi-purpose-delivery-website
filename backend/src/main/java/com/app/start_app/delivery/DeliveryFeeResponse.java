package com.app.start_app.delivery;

import java.math.BigDecimal;

/**
 * Full fee breakdown returned by POST /api/delivery-fee/preview.
 *
 * The frontend MUST display these values exactly — it must never recalculate.
 * The total field here equals the amount that will be sent to the payment gateway.
 *
 * Fields
 * ──────
 * distanceKm            – Haversine distance customer → shop (or pickup → drop for courier)
 * radiusKm              – service delivery radius from platform_settings
 * withinRadius          – whether the order is serviceable; false blocks checkout
 * radiusLabel           – human-readable e.g. "Within 15 km (Food)"
 * tierName              – "Tier 1", "Tier 2" or "Tier 3"
 * baseFee               – fixed base component from settings
 * distanceCharge        – per-km rate × distanceKm
 * rawFee                – baseFee + distanceCharge (before cap)
 * capApplied            – true when rawFee was reduced to the cap
 * feeCap                – the cap value (shown only when capApplied)
 * freeDeliveryApplied   – true when order total met the free-delivery threshold
 * freeDeliveryThreshold – threshold amount (shown so UI can display "add ₹X more")
 * deliveryFee           – final fee charged to customer (0 when freeDeliveryApplied)
 * itemTotal             – order subtotal passed in by caller
 * total                 – itemTotal + deliveryFee  (= payment amount)
 *
 * Legacy alias kept for backward-compat with any existing callers:
 * finalDeliveryFee      – same value as deliveryFee
 */
public class DeliveryFeeResponse {

    private Double      distanceKm;
    private Double      radiusKm;
    private Boolean     withinRadius;
    private String      radiusLabel;
    private String      tierName;
    private BigDecimal  baseFee;
    private BigDecimal  distanceCharge;
    private BigDecimal  rawFee;
    private Boolean     capApplied;
    private BigDecimal  feeCap;
    private Boolean     freeDeliveryApplied;
    private BigDecimal  freeDeliveryThreshold;
    private BigDecimal  deliveryFee;
    private BigDecimal  itemTotal;
    private BigDecimal  total;

    // ── Backward-compat alias ──
    public BigDecimal getFinalDeliveryFee() { return deliveryFee; }

    // ── Getters / Setters ────────────────────────────────────

    public Double getDistanceKm() { return distanceKm; }
    public void setDistanceKm(Double distanceKm) { this.distanceKm = distanceKm; }

    public Double getRadiusKm() { return radiusKm; }
    public void setRadiusKm(Double radiusKm) { this.radiusKm = radiusKm; }

    public Boolean getWithinRadius() { return withinRadius; }
    public void setWithinRadius(Boolean withinRadius) { this.withinRadius = withinRadius; }

    public String getRadiusLabel() { return radiusLabel; }
    public void setRadiusLabel(String radiusLabel) { this.radiusLabel = radiusLabel; }

    public String getTierName() { return tierName; }
    public void setTierName(String tierName) { this.tierName = tierName; }

    public BigDecimal getBaseFee() { return baseFee; }
    public void setBaseFee(BigDecimal baseFee) { this.baseFee = baseFee; }

    public BigDecimal getDistanceCharge() { return distanceCharge; }
    public void setDistanceCharge(BigDecimal distanceCharge) { this.distanceCharge = distanceCharge; }

    public BigDecimal getRawFee() { return rawFee; }
    public void setRawFee(BigDecimal rawFee) { this.rawFee = rawFee; }

    public Boolean getCapApplied() { return capApplied; }
    public void setCapApplied(Boolean capApplied) { this.capApplied = capApplied; }

    public BigDecimal getFeeCap() { return feeCap; }
    public void setFeeCap(BigDecimal feeCap) { this.feeCap = feeCap; }

    public Boolean getFreeDeliveryApplied() { return freeDeliveryApplied; }
    public void setFreeDeliveryApplied(Boolean freeDeliveryApplied) { this.freeDeliveryApplied = freeDeliveryApplied; }

    public BigDecimal getFreeDeliveryThreshold() { return freeDeliveryThreshold; }
    public void setFreeDeliveryThreshold(BigDecimal freeDeliveryThreshold) { this.freeDeliveryThreshold = freeDeliveryThreshold; }

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }

    public BigDecimal getItemTotal() { return itemTotal; }
    public void setItemTotal(BigDecimal itemTotal) { this.itemTotal = itemTotal; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
}
