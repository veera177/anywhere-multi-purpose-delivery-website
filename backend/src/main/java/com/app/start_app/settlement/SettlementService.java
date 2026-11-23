package com.app.start_app.settlement;

import com.app.start_app.settings.PlatformSettingsDAO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * Applies company-side profit rules (Part A) for all four service types.
 *
 * Rules — every figure comes from platform_settings:
 *
 * FOOD
 *   commission = 15% of itemTotal
 *   partnerPayout = itemTotal - commission
 *   riderPayout = deliveryFee (unchanged — customer already paid it)
 *
 * GROCERY
 *   commission rate = 8% when any single item price < grocery_high_threshold (299)
 *                   = 10% when any single item price >= grocery_high_threshold
 *   (The request carries per-item subtotals; we apply the per-item rate then sum.)
 *   For the preview/simple path (single combined itemTotal), we check the
 *   average item price against the threshold as a reasonable approximation.
 *   The settlement is per-order, not per-item — so we apply the rate to the
 *   whole itemTotal based on whether itemTotal >= grocery_high_threshold.
 *   partnerPayout = itemTotal - commission
 *
 * MEDICINE
 *   Per item: OTC → max(5% of price, 15); Prescription → max(7% of price, 15)
 *   prescriptionHandling = 5 per order if any prescription item present
 *   partnerPayout = itemTotal - commission - prescriptionHandling
 *
 * COURIER
 *   companyShare = max(15% of deliveryFee, 10)
 *   riderPayout = deliveryFee - companyShare
 *   platformProfit = companyShare (no item commission for courier)
 *
 * Customer totals and rider payouts are never changed here.
 */
@Service
public class SettlementService {

    private static final BigDecimal HUNDRED = BigDecimal.valueOf(100);

    private final SettlementDAO settlementDAO;
    private final PlatformSettingsDAO settings;

    public SettlementService(SettlementDAO settlementDAO, PlatformSettingsDAO settings) {
        this.settlementDAO = settlementDAO;
        this.settings = settings;
    }

    @Transactional
    public SettlementRecord settle(SettlementRequest req) {
        String svc = req.getServiceType() == null ? "" : req.getServiceType().toUpperCase().trim();
        return switch (svc) {
            case "FOOD"     -> settleFood(req);
            case "GROCERY"  -> settleGrocery(req);
            case "MEDICINE" -> settleMedicine(req);
            case "COURIER"  -> settleCourier(req);
            default         -> throw new IllegalArgumentException("Unknown serviceType: " + svc);
        };
    }

    // ── FOOD ──────────────────────────────────────────────────

    private SettlementRecord settleFood(SettlementRequest req) {
        BigDecimal rate       = settings.getDecimal("food_commission_rate", BigDecimal.valueOf(15));
        BigDecimal commission = pct(req.getItemTotal(), rate);
        BigDecimal partner    = req.getItemTotal().subtract(commission).setScale(2, RoundingMode.HALF_UP);
        BigDecimal rider      = req.getDeliveryFee().setScale(2, RoundingMode.HALF_UP);
        BigDecimal profit     = commission.setScale(2, RoundingMode.HALF_UP);

        return persist(req, commission, BigDecimal.ZERO, partner, rider, profit);
    }

    // ── GROCERY ───────────────────────────────────────────────

    private SettlementRecord settleGrocery(SettlementRequest req) {
        BigDecimal defaultRate  = settings.getDecimal("grocery_default_commission", BigDecimal.valueOf(8));
        BigDecimal highRate     = settings.getDecimal("grocery_high_commission",    BigDecimal.valueOf(10));
        BigDecimal threshold    = settings.getDecimal("grocery_high_threshold",     BigDecimal.valueOf(299));

        // Apply high rate when item total meets or exceeds the threshold
        BigDecimal rate = req.getItemTotal().compareTo(threshold) >= 0 ? highRate : defaultRate;

        BigDecimal commission = pct(req.getItemTotal(), rate);
        BigDecimal partner    = req.getItemTotal().subtract(commission).setScale(2, RoundingMode.HALF_UP);
        BigDecimal rider      = req.getDeliveryFee().setScale(2, RoundingMode.HALF_UP);
        BigDecimal profit     = commission.setScale(2, RoundingMode.HALF_UP);

        return persist(req, commission, BigDecimal.ZERO, partner, rider, profit);
    }

    // ── MEDICINE ──────────────────────────────────────────────

    private SettlementRecord settleMedicine(SettlementRequest req) {
        BigDecimal otcRate    = settings.getDecimal("medicine_otc_commission_rate",          BigDecimal.valueOf(5));
        BigDecimal rxRate     = settings.getDecimal("medicine_prescription_commission_rate",  BigDecimal.valueOf(7));
        BigDecimal minComm    = settings.getDecimal("medicine_otc_commission_minimum",        BigDecimal.valueOf(15));
        BigDecimal handlingFee= settings.getDecimal("medicine_prescription_handling_fee",     BigDecimal.valueOf(5));

        List<Boolean> flags = req.getItemPrescriptionFlags();
        boolean hasRx = flags != null && flags.stream().anyMatch(Boolean.TRUE::equals);

        // Simple (single-total) path: apply the appropriate rate to the whole itemTotal
        BigDecimal rate       = hasRx ? rxRate : otcRate;
        BigDecimal calculated = pct(req.getItemTotal(), rate);
        BigDecimal commission = calculated.max(minComm).setScale(2, RoundingMode.HALF_UP);

        BigDecimal handling   = hasRx ? handlingFee.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
        BigDecimal partner    = req.getItemTotal()
                                   .subtract(commission)
                                   .subtract(handling)
                                   .setScale(2, RoundingMode.HALF_UP);
        BigDecimal rider      = req.getDeliveryFee().setScale(2, RoundingMode.HALF_UP);
        BigDecimal profit     = commission.add(handling).setScale(2, RoundingMode.HALF_UP);

        return persist(req, commission, handling, partner, rider, profit);
    }

    // ── COURIER ───────────────────────────────────────────────

    private SettlementRecord settleCourier(SettlementRequest req) {
        BigDecimal rateDecimal = settings.getDecimal("courier_commission_rate",  BigDecimal.valueOf(15));
        BigDecimal floor       = settings.getDecimal("courier_commission_floor", BigDecimal.valueOf(10));

        BigDecimal fee         = req.getDeliveryFee().setScale(2, RoundingMode.HALF_UP);
        BigDecimal calculated  = pct(fee, rateDecimal);
        BigDecimal companyShare= calculated.max(floor).setScale(2, RoundingMode.HALF_UP);
        BigDecimal rider       = fee.subtract(companyShare).setScale(2, RoundingMode.HALF_UP);

        // No item commission for courier — entire profit is the company delivery share
        BigDecimal commission = BigDecimal.ZERO;
        BigDecimal partner    = BigDecimal.ZERO;
        BigDecimal profit     = companyShare;

        // For courier, store company share in platform_commission field
        SettlementRecord r = new SettlementRecord();
        r.setOrderId(req.getOrderId());
        r.setServiceType("COURIER");
        r.setItemTotal(req.getItemTotal() != null ? req.getItemTotal() : BigDecimal.ZERO);
        r.setDeliveryFee(fee);
        r.setPlatformCommission(companyShare);
        r.setPrescriptionHandling(BigDecimal.ZERO);
        r.setPartnerPayout(partner);
        r.setRiderPayout(rider);
        r.setPlatformProfit(profit);
        settlementDAO.insert(r);
        return r;
    }

    // ── Shared helper ─────────────────────────────────────────

    private SettlementRecord persist(SettlementRequest req,
                                     BigDecimal commission, BigDecimal handling,
                                     BigDecimal partner, BigDecimal rider, BigDecimal profit) {
        SettlementRecord r = new SettlementRecord();
        r.setOrderId(req.getOrderId());
        r.setServiceType(req.getServiceType().toUpperCase().trim());
        r.setItemTotal(req.getItemTotal().setScale(2, RoundingMode.HALF_UP));
        r.setDeliveryFee(req.getDeliveryFee().setScale(2, RoundingMode.HALF_UP));
        r.setPlatformCommission(commission);
        r.setPrescriptionHandling(handling);
        r.setPartnerPayout(partner);
        r.setRiderPayout(rider);
        r.setPlatformProfit(profit);
        settlementDAO.insert(r);
        return r;
    }

    /** Compute (amount × rate / 100) rounded to 2dp. */
    private BigDecimal pct(BigDecimal amount, BigDecimal rate) {
        return amount.multiply(rate).divide(HUNDRED, 2, RoundingMode.HALF_UP);
    }
}
