-- Update existing `test_logs` table:
-- 1) add `device_name`
-- 2) drop `delay_node_to_gateway_ms`
-- 3) drop `delay_node_to_server_ms`
--
-- Safe to run multiple times.

SET @schema_name = DATABASE();

SELECT COUNT(*) INTO @has_test_logs
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = @schema_name
  AND TABLE_NAME = 'test_logs';

-- Add device_name if missing
SELECT IF(@has_test_logs = 1, (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = @schema_name
      AND TABLE_NAME = 'test_logs'
      AND COLUMN_NAME = 'device_name'
), 1) INTO @has_device_name;

SET @sql = IF(@has_device_name = 0,
    'ALTER TABLE `test_logs` ADD COLUMN `device_name` VARCHAR(128) NULL AFTER `node_id`',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Drop delay_node_to_gateway_ms if present
SELECT IF(@has_test_logs = 1, (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = @schema_name
      AND TABLE_NAME = 'test_logs'
      AND COLUMN_NAME = 'delay_node_to_gateway_ms'
), 0) INTO @has_delay_ng;

SET @sql = IF(@has_delay_ng > 0,
    'ALTER TABLE `test_logs` DROP COLUMN `delay_node_to_gateway_ms`',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Drop delay_node_to_server_ms if present
SELECT IF(@has_test_logs = 1, (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = @schema_name
      AND TABLE_NAME = 'test_logs'
      AND COLUMN_NAME = 'delay_node_to_server_ms'
), 0) INTO @has_delay_ns;

SET @sql = IF(@has_delay_ns > 0,
    'ALTER TABLE `test_logs` DROP COLUMN `delay_node_to_server_ms`',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verify final schema
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = @schema_name
  AND TABLE_NAME = 'test_logs'
ORDER BY ORDINAL_POSITION;
