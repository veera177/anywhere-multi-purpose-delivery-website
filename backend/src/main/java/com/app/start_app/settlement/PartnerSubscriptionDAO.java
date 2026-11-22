package com.app.start_app.settlement;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class PartnerSubscriptionDAO {

    private final JdbcTemplate jdbcTemplate;

    public PartnerSubscriptionDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /** All active subscriptions whose start_date falls within the given month. */
    public BigDecimal sumFeesForMonth(int year, int month) {
        String sql = """
                SELECT COALESCE(SUM(monthly_fee), 0)
                FROM partner_subscriptions
                WHERE status = 'ACTIVE'
                  AND YEAR(start_date) <= ?
                  AND (MONTH(start_date) <= ? OR YEAR(start_date) < ?)
                """;
        return jdbcTemplate.queryForObject(sql, BigDecimal.class, year, month, year);
    }

    public List<PartnerSubscription> findAll() {
        String sql = "SELECT * FROM partner_subscriptions ORDER BY partner_type, partner_id";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            PartnerSubscription s = new PartnerSubscription();
            s.setId(rs.getInt("id"));
            s.setPartnerId(rs.getInt("partner_id"));
            s.setPartnerType(rs.getString("partner_type"));
            s.setMonthlyFee(rs.getBigDecimal("monthly_fee"));
            Date d = rs.getDate("start_date");
            if (d != null) s.setStartDate(d.toLocalDate());
            s.setStatus(rs.getString("status"));
            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) s.setCreatedAt(ts.toLocalDateTime());
            return s;
        });
    }
}
