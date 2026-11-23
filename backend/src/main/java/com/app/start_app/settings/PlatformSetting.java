package com.app.start_app.settings;

/**
 * Maps one row from the platform_settings table.
 * Callers read values via PlatformSettingsDAO.getSetting(key).
 */
public class PlatformSetting {

    private Integer id;
    private String settingKey;
    private String settingValue;
    private String description;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getSettingKey() { return settingKey; }
    public void setSettingKey(String settingKey) { this.settingKey = settingKey; }

    public String getSettingValue() { return settingValue; }
    public void setSettingValue(String settingValue) { this.settingValue = settingValue; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
