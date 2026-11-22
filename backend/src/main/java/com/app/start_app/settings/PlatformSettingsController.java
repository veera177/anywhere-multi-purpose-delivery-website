package com.app.start_app.settings;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * GET /api/platform-settings
 * Returns every setting row so the frontend can resolve radii, tier names,
 * and free-delivery thresholds without hardcoding anything.
 */
@RestController
@CrossOrigin(origins = "*")
public class PlatformSettingsController {

    private final PlatformSettingsDAO dao;

    public PlatformSettingsController(PlatformSettingsDAO dao) {
        this.dao = dao;
    }

    @GetMapping("/api/platform-settings")
    public List<PlatformSetting> getAll() {
        return dao.findAll();
    }
}
