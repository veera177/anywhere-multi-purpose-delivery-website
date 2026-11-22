package com.app.start_app.settlement;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** Maps one row from partner_subscriptions. */
public class PartnerSubscription {

    private Integer       id;
    private Integer       partnerId;
    private String        partnerType;   // FOOD | GROCERY | MEDICINE
    private BigDecimal    monthlyFee;
    private LocalDate     startDate;
    private String        status;        // ACTIVE | CANCELLED
    private LocalDateTime createdAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getPartnerId() { return partnerId; }
    public void setPartnerId(Integer partnerId) { this.partnerId = partnerId; }

    public String getPartnerType() { return partnerType; }
    public void setPartnerType(String partnerType) { this.partnerType = partnerType; }

    public BigDecimal getMonthlyFee() { return monthlyFee; }
    public void setMonthlyFee(BigDecimal monthlyFee) { this.monthlyFee = monthlyFee; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
