-- Migration 008: add persisted publish_topic column on device for backend MQTT downlink / ping echo.
--
-- Usage:
--   docker compose exec -T db mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < sql/008_add_device_publish_topic.sql

DELIMITER $$

DROP PROCEDURE IF EXISTS migrate_add_device_publish_topic$$
CREATE PROCEDURE migrate_add_device_publish_topic()
BEGIN
  IF (SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device' AND COLUMN_NAME = 'publish_topic') = 0 THEN
    ALTER TABLE `device` ADD COLUMN `publish_topic` VARCHAR(255) NULL;
  END IF;
END$$

DELIMITER ;

CALL migrate_add_device_publish_topic();
DROP PROCEDURE IF EXISTS migrate_add_device_publish_topic;
