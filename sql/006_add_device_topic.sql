-- Migration 006: add persisted topic column on device for backend MQTT subscription restore.
--
-- Usage:
--   docker compose exec -T db mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < sql/006_add_device_topic.sql

DELIMITER $$

DROP PROCEDURE IF EXISTS migrate_add_device_topic$$
CREATE PROCEDURE migrate_add_device_topic()
BEGIN
  IF (SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device' AND COLUMN_NAME = 'topic') = 0 THEN
    ALTER TABLE `device` ADD COLUMN `topic` VARCHAR(255) NULL;
  END IF;
END$$

DELIMITER ;

CALL migrate_add_device_topic();
DROP PROCEDURE IF EXISTS migrate_add_device_topic;
