-- Migration 004: static columns on device (location, device_type).
-- Live readings are not stored in DB; use MQTT/payload in the app layer.
--
-- Usage:
--   docker compose exec -T db mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < sql/004_device_ui_columns.sql
--
-- If you previously ran an older 004 that added last_reading_* columns, run 005_drop_last_reading.sql first.

DELIMITER $$

DROP PROCEDURE IF EXISTS migrate_device_ui_columns$$
CREATE PROCEDURE migrate_device_ui_columns()
BEGIN
  IF (SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device' AND COLUMN_NAME = 'location') = 0 THEN
    ALTER TABLE `device` ADD COLUMN `location` VARCHAR(255) NULL;
  END IF;

  IF (SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device' AND COLUMN_NAME = 'device_type') = 0 THEN
    ALTER TABLE `device` ADD COLUMN `device_type` VARCHAR(45) NULL;
  END IF;
END$$

DELIMITER ;

CALL migrate_device_ui_columns();
DROP PROCEDURE IF EXISTS migrate_device_ui_columns;
