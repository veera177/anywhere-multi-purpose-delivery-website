package com.app.start_app.settlement;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Maps one row in the settlements table.
 * All amounts are BigDecimal to avoid floating-point rounding.
 */
public class SettlementRecord {

    private Integer       id;
    private Integer       orderId;
    private String        serviceType;
    private BigDecimal    itemTotal;
    private BigDecimal    deliveryFee;
    private BigDecimal    platformCommission;
    private BigDecimal    prescriptionHandling;
    private BigDecimal    partnerPayout;
    private BigDecimal    riderPayout;
    private BigDecimal    platformProfit;
    private LocalDateTime settledAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public String getServiceType() { return serviceType; }
    public void setServiceType(String serviceType) { this.serviceType = serviceType; }

    public BigDecimal getItemTotal() { return itemTotal; }
    public void setItemTotal(BigDecimal itemTotal) { this.itemTotal = itemTotal; }

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }

    public BigDecimal getPlatformCommission() { return platformCommission; }
    public void setPlatformCommission(BigDecimal platformCommission) { this.platformCommission = platformCommission; }

    public BigDecimal getPrescriptionHandling() { return prescriptionHandling; }
    public void setPrescriptionHandling(BigDecimal prescriptionHandling) { this.prescriptionHandling = prescriptionHandling; }

    public BigDecimal getPartnerPayout() { return partnerPayout; }
    public void setPartnerPayout(BigDecimal partnerPayout) { this.partnerPayout = partnerPayout; }

    public BigDecimal getRiderPayout() { return riderPayout; }
    public void setRiderPayout(BigDecimal riderPayout) { this.riderPayout = riderPayout; }

    public BigDecimal getPlatformProfit() { return platformProfit; }
    public void setPlatformProfit(BigDecimal platformProfit) { this.platformProfit = platformProfit; }

    public LocalDateTime getSettledAt() { return settledAt; }
    public void setSettledAt(LocalDateTime settledAt) { this.settledAt = settledAt; }
}
