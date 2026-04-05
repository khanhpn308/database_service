-- Migration 005: drop last_reading_* columns if they exist (telemetry is dynamic, not persisted in DB).
-- Run after pulling older schema that added those columns.
--
-- Usage:
--   docker compose exec -T db mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < sql/005_drop_last_reading.sql

DELIMITER $$

DROP PROCEDURE IF EXISTS migrate_drop_last_reading$$
CREATE PROCEDURE migrate_drop_last_reading()
BEGIN
  IF (SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device' AND COLUMN_NAME = 'last_reading_unit') > 0 THEN
    ALTER TABLE `device` DROP COLUMN `last_reading_unit`;
  END IF;

  IF (SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device' AND COLUMN_NAME = 'last_reading_value') > 0 THEN
    ALTER TABLE `device` DROP COLUMN `last_reading_value`;
  END IF;

  IF (SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device' AND COLUMN_NAME = 'last_reading_at') > 0 THEN
    ALTER TABLE `device` DROP COLUMN `last_reading_at`;
  END IF;
END$$

DELIMITER ;

CALL migrate_drop_last_reading();
DROP PROCEDURE IF EXISTS migrate_drop_last_reading;
