package com.app.start_app.settlement;

import java.math.BigDecimal;
import java.util.List;

/**
 * Input to SettlementService.settle().
 * The caller (PaymentService or a webhook) supplies the order details;
 * the settlement service applies the platform-settings rules and persists.
 *
 * prescriptionItemIds  – product IDs in this order that are prescription-required.
 *                        Used by medicine settlement to apply the handling fee.
 * deliveryFee          – the amount already charged to the customer.
 */
public class SettlementRequest {

    private Integer       orderId;
    private String        serviceType;
    private BigDecimal    itemTotal;
    private BigDecimal    deliveryFee;
    private List<Boolean> itemPrescriptionFlags; // one entry per order item

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public String getServiceType() { return serviceType; }
    public void setServiceType(String serviceType) { this.serviceType = serviceType; }

    public BigDecimal getItemTotal() { return itemTotal; }
    public void setItemTotal(BigDecimal itemTotal) { this.itemTotal = itemTotal; }

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }

    public List<Boolean> getItemPrescriptionFlags() { return itemPrescriptionFlags; }
    public void setItemPrescriptionFlags(List<Boolean> itemPrescriptionFlags) {
        this.itemPrescriptionFlags = itemPrescriptionFlags;
    }
}
