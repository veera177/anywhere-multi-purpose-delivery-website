package com.app.start_app.settlement;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public class SettlementDAO {

    private final JdbcTemplate jdbcTemplate;

    public SettlementDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /** Insert a new settlement row and return its generated id. */
    public Integer insert(SettlementRecord record) {
        String sql = """
                INSERT INTO settlements
                (order_id, service_type, item_total, delivery_fee,
                 platform_commission, prescription_handling,
                 partner_payout, rider_payout, platform_profit)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, record.getOrderId());
            ps.setString(2, record.getServiceType());
            ps.setBigDecimal(3, record.getItemTotal());
            ps.setBigDecimal(4, record.getDeliveryFee());
            ps.setBigDecimal(5, record.getPlatformCommission());
            ps.setBigDecimal(6, record.getPrescriptionHandling());
            ps.setBigDecimal(7, record.getPartnerPayout());
            ps.setBigDecimal(8, record.getRiderPayout());
            ps.setBigDecimal(9, record.getPlatformProfit());
            return ps;
        }, keyHolder);
        return keyHolder.getKey().intValue();
    }

    public SettlementRecord findByOrderId(Integer orderId) {
        List<SettlementRecord> rows = jdbcTemplate.query(
                "SELECT * FROM settlements WHERE order_id = ?",
                this::mapRow, orderId);
        return rows.isEmpty() ? null : rows.get(0);
    }

    /** All settlements for the monthly finance report. */
    public List<SettlementRecord> findByYearMonth(int year, int month) {
        String sql = """
                SELECT * FROM settlements
                WHERE YEAR(settled_at) = ? AND MONTH(settled_at) = ?
                ORDER BY settled_at
                """;
        return jdbcTemplate.query(sql, this::mapRow, year, month);
    }

    private SettlementRecord mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException {
        SettlementRecord r = new SettlementRecord();
        r.setId(rs.getInt("id"));
        r.setOrderId(rs.getInt("order_id"));
        r.setServiceType(rs.getString("service_type"));
        r.setItemTotal(rs.getBigDecimal("item_total"));
        r.setDeliveryFee(rs.getBigDecimal("delivery_fee"));
        r.setPlatformCommission(rs.getBigDecimal("platform_commission"));
        r.setPrescriptionHandling(rs.getBigDecimal("prescription_handling"));
        r.setPartnerPayout(rs.getBigDecimal("partner_payout"));
        r.setRiderPayout(rs.getBigDecimal("rider_payout"));
        r.setPlatformProfit(rs.getBigDecimal("platform_profit"));
        Timestamp ts = rs.getTimestamp("settled_at");
        if (ts != null) r.setSettledAt(ts.toLocalDateTime());
        return r;
    }
}
