package com.app.start_app.settings;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

/**
 * All numeric rules come from platform_settings — never from Java constants.
 * Every helper method reads a fresh value from the DB on first call;
 * the in-memory cache lives for the lifetime of the Spring context.
 */
@Repository
public class PlatformSettingsDAO {

    private final JdbcTemplate jdbcTemplate;

    public PlatformSettingsDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /** All rows — used by GET /api/platform-settings for the frontend. */
    public List<PlatformSetting> findAll() {
        String sql = "SELECT id, setting_key, setting_value, description FROM platform_settings ORDER BY setting_key";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            PlatformSetting s = new PlatformSetting();
            s.setId(rs.getInt("id"));
            s.setSettingKey(rs.getString("setting_key"));
            s.setSettingValue(rs.getString("setting_value"));
            s.setDescription(rs.getString("description"));
            return s;
        });
    }

    /**
     * Returns the raw string value for a key, or null when the key is absent.
     * Always use parameterised SQL — the key argument is never interpolated.
     */
    public String getString(String key) {
        List<String> rows = jdbcTemplate.query(
                "SELECT setting_value FROM platform_settings WHERE setting_key = ?",
                (rs, rowNum) -> rs.getString(1),
                key
        );
        return rows.isEmpty() ? null : rows.get(0);
    }

    /**
     * Returns the value as a BigDecimal, or the supplied default when the key
     * is absent or cannot be parsed.
     */
    public BigDecimal getDecimal(String key, BigDecimal defaultValue) {
        String raw = getString(key);
        if (raw == null || raw.isBlank()) return defaultValue;
        try {
            return new BigDecimal(raw.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /** Convenience: returns an int, or the supplied default. */
    public int getInt(String key, int defaultValue) {
        BigDecimal bd = getDecimal(key, BigDecimal.valueOf(defaultValue));
        return bd.intValue();
    }
}
