package com.app.start_app.settlement;

import java.math.BigDecimal;

/**
 * Body for POST /api/settlements/order/{orderId}.
 *
 * deliveryFee  – the GROSS calculated delivery fee (rawFee from the fee response).
 *                This is what the rider earns.  When the platform granted free
 *                delivery, the customer paid ₹0 but the rider still earns this
 *                amount; the platform absorbs the difference.
 *                The frontend must pass fee.rawFee here, NOT fee.deliveryFee.
 */
public class SettlementTriggerRequest {

    private BigDecimal deliveryFee;

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }
}
