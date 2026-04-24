-- Paste your CREATE TABLE statements here when deploying on server.
-- This file is intentionally left blank in repo by default.

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema demo_iot
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema demo_iot
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `demo_iot` DEFAULT CHARACTER SET utf8 ;
USE `demo_iot` ;

-- -----------------------------------------------------
-- Table `demo_iot`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `demo_iot`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `fullname` VARCHAR(45) NOT NULL,
  `cccd` DECIMAL(12) NOT NULL,
  `email` VARCHAR(45) NULL,
  `phone` INT NULL,
  `creat_at` DATE NOT NULL,
  `expired_at` DATE NULL,
  `status` ENUM('active', 'deactive') NOT NULL,
  `role` ENUM('admin', 'user') NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `cccd_UNIQUE` (`cccd` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `demo_iot`.`device`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `demo_iot`.`device` (
  `device_id` INT NOT NULL,
  `devicename` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  `status` ENUM('active', 'deactive') NULL,
  `user_device_asignment_id` INT NOT NULL,
  `location` VARCHAR(255) NULL,
  `device_type` VARCHAR(45) NULL,
  `topic` VARCHAR(255) NULL,
  PRIMARY KEY (`device_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `demo_iot`.`device_authorization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `demo_iot`.`device_authorization` (
  `device_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `granted_at` DATE NULL,
  `granted_by` VARCHAR(45) NULL,
  `expired_at` DATE NULL,
  PRIMARY KEY (`device_id`, `user_id`),
  INDEX `fk_device_has_user_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_device_has_user_device_idx` (`device_id` ASC) VISIBLE,
  CONSTRAINT `fk_device_has_user_device`
    FOREIGN KEY (`device_id`)
    REFERENCES `demo_iot`.`device` (`device_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_device_has_user_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `demo_iot`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `demo_iot`.`test_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `demo_iot`.`test_logs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `protocol` VARCHAR(32) NOT NULL,
  `version` INT NULL,
  `message_len` INT NULL,
  `message` TEXT NULL,
  `node_id_len` INT NULL,
  `node_id` VARCHAR(128) NOT NULL,
  `gateway_id_len` INT NULL,
  `gateway_id` VARCHAR(128) NOT NULL,
  `event_timestamp_ms` BIGINT NULL,
  `gateway_timestamp_ms` BIGINT NULL,
  `mark_time_ms` BIGINT NOT NULL,
  `delay_node_to_gateway_ms` BIGINT NULL,
  `delay_gateway_to_server_ms` BIGINT NULL,
  `delay_node_to_server_ms` BIGINT NULL,
  `rssi` INT NULL,
  `src_mac` VARCHAR(17) NULL,
  `topic` VARCHAR(255) NULL,
  `raw_hex` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_test_logs_lookup` (`gateway_id` ASC, `node_id` ASC, `protocol` ASC, `created_at` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
