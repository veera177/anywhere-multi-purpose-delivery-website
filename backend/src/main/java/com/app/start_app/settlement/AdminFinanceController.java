package com.app.start_app.settlement;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * GET /api/admin/finance/monthly?year=2026&month=11
 *
 * Returns a monthly profit report broken down by service type.
 * Columns per service: commission, handling_fees, rider_payouts, partner_payouts.
 * Plus: subscription_income, grand_total_profit.
 *
 * This endpoint has no authentication guard in this codebase (no Spring Security).
 * The /api/admin/ prefix makes it straightforward to add a role check later.
 */
@RestController
@CrossOrigin(origins = "*")
public class AdminFinanceController {

    private final SettlementDAO           settlementDAO;
    private final PartnerSubscriptionDAO  subscriptionDAO;

    public AdminFinanceController(SettlementDAO settlementDAO,
                                  PartnerSubscriptionDAO subscriptionDAO) {
        this.settlementDAO  = settlementDAO;
        this.subscriptionDAO = subscriptionDAO;
    }

    @GetMapping("/api/admin/finance/monthly")
    public ResponseEntity<?> monthlyReport(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {

        // Default to current year/month when params are absent
        LocalDate now = LocalDate.now();
        int y = year  != null ? year  : now.getYear();
        int m = month != null ? month : now.getMonthValue();

        if (m < 1 || m > 12) {
            return ResponseEntity.badRequest().body("month must be 1–12");
        }

        List<SettlementRecord> records = settlementDAO.findByYearMonth(y, m);

        // Group by service type
        Map<String, List<SettlementRecord>> byService = records.stream()
                .collect(Collectors.groupingBy(r -> r.getServiceType().toUpperCase()));

        List<String> services = List.of("FOOD", "GROCERY", "MEDICINE", "COURIER");
        List<Map<String, Object>> rows = services.stream().map(svc -> {
            List<SettlementRecord> svcRecords = byService.getOrDefault(svc, List.of());
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("service",           svc);
            row.put("orderCount",        svcRecords.size());
            row.put("commission",        sum(svcRecords, "commission"));
            row.put("handlingFees",      sum(svcRecords, "handling"));
            row.put("riderPayouts",      sum(svcRecords, "rider"));
            row.put("partnerPayouts",    sum(svcRecords, "partner"));
            row.put("servicePlatformProfit", sum(svcRecords, "profit"));
            return row;
        }).collect(Collectors.toList());

        BigDecimal totalCommission = records.stream()
                .map(SettlementRecord::getPlatformCommission)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalHandling = records.stream()
                .map(SettlementRecord::getPrescriptionHandling)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalRider = records.stream()
                .map(SettlementRecord::getRiderPayout)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalPartner = records.stream()
                .map(SettlementRecord::getPartnerPayout)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalProfit = records.stream()
                .map(SettlementRecord::getPlatformProfit)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal subscriptionIncome = subscriptionDAO.sumFeesForMonth(y, m);

        BigDecimal grandProfit = totalProfit.add(subscriptionIncome).setScale(2, RoundingMode.HALF_UP);

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("year",               y);
        report.put("month",              m);
        report.put("services",           rows);
        report.put("totalCommission",    totalCommission.setScale(2, RoundingMode.HALF_UP));
        report.put("totalHandlingFees",  totalHandling.setScale(2, RoundingMode.HALF_UP));
        report.put("totalRiderPayouts",  totalRider.setScale(2, RoundingMode.HALF_UP));
        report.put("totalPartnerPayouts",totalPartner.setScale(2, RoundingMode.HALF_UP));
        report.put("subscriptionIncome", subscriptionIncome.setScale(2, RoundingMode.HALF_UP));
        report.put("grandPlatformProfit",grandProfit);

        return ResponseEntity.ok(report);
    }

    // ── Helpers ───────────────────────────────────────────────

    private BigDecimal sum(List<SettlementRecord> list, String field) {
        return list.stream()
                .map(r -> switch (field) {
                    case "commission" -> r.getPlatformCommission();
                    case "handling"   -> r.getPrescriptionHandling();
                    case "rider"      -> r.getRiderPayout();
                    case "partner"    -> r.getPartnerPayout();
                    case "profit"     -> r.getPlatformProfit();
                    default           -> BigDecimal.ZERO;
                })
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .setScale(2, RoundingMode.HALF_UP);
    }
}
