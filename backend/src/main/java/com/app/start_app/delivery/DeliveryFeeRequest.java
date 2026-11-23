package com.app.start_app.delivery;

import java.math.BigDecimal;

/**
 * Payload sent by the frontend to POST /api/delivery-fee/preview.
 * distanceKm is optional: when absent the backend computes it from lat/lon pairs.
 */
public class DeliveryFeeRequest {

    private String serviceType;   // FOOD | GROCERY | MEDICINE | COURIER
    private String district;      // lower-case district name or code
    private Double distanceKm;    // pre-computed by frontend Haversine (optional)
    private BigDecimal orderTotal; // item subtotal only — no delivery fee included
    private Boolean firstOrder;   // reserved for future promotions

    // lat/lon for the customer and the shop — used when distanceKm is null
    private Double customerLat;
    private Double customerLon;
    private Double shopLat;
    private Double shopLon;

    public String getServiceType() { return serviceType; }
    public void setServiceType(String serviceType) { this.serviceType = serviceType; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public Double getDistanceKm() { return distanceKm; }
    public void setDistanceKm(Double distanceKm) { this.distanceKm = distanceKm; }

    public BigDecimal getOrderTotal() { return orderTotal; }
    public void setOrderTotal(BigDecimal orderTotal) { this.orderTotal = orderTotal; }

    public Boolean getFirstOrder() { return firstOrder; }
    public void setFirstOrder(Boolean firstOrder) { this.firstOrder = firstOrder; }

    public Double getCustomerLat() { return customerLat; }
    public void setCustomerLat(Double customerLat) { this.customerLat = customerLat; }

    public Double getCustomerLon() { return customerLon; }
    public void setCustomerLon(Double customerLon) { this.customerLon = customerLon; }

    public Double getShopLat() { return shopLat; }
    public void setShopLat(Double shopLat) { this.shopLat = shopLat; }

    public Double getShopLon() { return shopLon; }
    public void setShopLon(Double shopLon) { this.shopLon = shopLon; }
}
