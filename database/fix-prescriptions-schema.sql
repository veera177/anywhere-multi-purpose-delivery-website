-- ============================================================
-- Fix: prescriptions table schema mismatch
-- The existing table was created from an older schema.
-- The Java code expects: medicine_name, quantity, file_path,
-- address_id, district, confirmed_price, resolved_at
-- The existing table has: file_url, reviewed_at (different names)
-- ============================================================

-- Step 1: Add missing columns (ALTER TABLE is safe if columns already exist
--         because each statement is guarded by the procedure below)

-- Add medicine_name (free text from doctor prescription)
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS medicine_name VARCHAR(300) NULL;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS quantity VARCHAR(100) NULL;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS file_path VARCHAR(500) NULL;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS address_id INT NULL;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS district VARCHAR(100) NULL;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS confirmed_price DOUBLE NULL;
ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMP NULL;

-- Step 2: Copy existing file_url data into file_path so historical rows are preserved
UPDATE prescriptions SET file_path = file_url WHERE file_path IS NULL AND file_url IS NOT NULL;

-- Step 3: Verify
SELECT
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'anywhere'
  AND TABLE_NAME = 'prescriptions'
ORDER BY ORDINAL_POSITION;
