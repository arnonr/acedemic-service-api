/*
  Warnings:

  - You are about to drop the `direction` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `equipment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `equipment_booking` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `equipment_booking_method` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `equipment_category` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `equipment_department` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `equipment_gallery` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `equipment_method` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `team` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `department_id` to the `news` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `equipment` DROP FOREIGN KEY `equipment_equipment_category_id_fkey`;

-- DropForeignKey
ALTER TABLE `equipment` DROP FOREIGN KEY `equipment_equipment_department_id_fkey`;

-- DropForeignKey
ALTER TABLE `equipment_booking` DROP FOREIGN KEY `equipment_booking_equipment_id_fkey`;

-- DropForeignKey
ALTER TABLE `equipment_booking` DROP FOREIGN KEY `equipment_booking_user_id_fkey`;

-- DropForeignKey
ALTER TABLE `equipment_booking_method` DROP FOREIGN KEY `equipment_booking_method_equipment_booking_id_fkey`;

-- DropForeignKey
ALTER TABLE `equipment_booking_method` DROP FOREIGN KEY `equipment_booking_method_equipment_method_id_fkey`;

-- DropForeignKey
ALTER TABLE `equipment_method` DROP FOREIGN KEY `equipment_method_equipment_id_fkey`;

-- DropForeignKey
ALTER TABLE `team` DROP FOREIGN KEY `team_department_id_fkey`;

-- AlterTable
ALTER TABLE `department` ADD COLUMN `contact_en` LONGTEXT NULL,
    ADD COLUMN `contact_th` LONGTEXT NULL,
    ADD COLUMN `department_file` VARCHAR(500) NULL,
    ADD COLUMN `detail_en` LONGTEXT NULL,
    ADD COLUMN `detail_th` LONGTEXT NULL;

-- AlterTable
ALTER TABLE `news` ADD COLUMN `department_id` INTEGER NOT NULL;

-- DropTable
DROP TABLE `direction`;

-- DropTable
DROP TABLE `equipment`;

-- DropTable
DROP TABLE `equipment_booking`;

-- DropTable
DROP TABLE `equipment_booking_method`;

-- DropTable
DROP TABLE `equipment_category`;

-- DropTable
DROP TABLE `equipment_department`;

-- DropTable
DROP TABLE `equipment_gallery`;

-- DropTable
DROP TABLE `equipment_method`;

-- DropTable
DROP TABLE `team`;

-- CreateTable
CREATE TABLE `service_category` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name_th` VARCHAR(500) NOT NULL,
    `name_en` VARCHAR(500) NULL,
    `detail_th` LONGTEXT NULL,
    `detail_en` LONGTEXT NULL,
    `is_active` INTEGER NOT NULL DEFAULT 1,
    `is_publish` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `created_by` VARCHAR(255) NULL,
    `updated_at` DATETIME(3) NULL,
    `updated_by` VARCHAR(255) NULL,
    `deleted_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `service_category_on_department` (
    `department_id` INTEGER NOT NULL,
    `service_category_id` INTEGER NOT NULL,
    `assignedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `assignedBy` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`department_id`, `service_category_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `service_category_on_news` (
    `news_id` INTEGER NOT NULL,
    `service_category_id` INTEGER NOT NULL,
    `assignedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `assignedBy` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`news_id`, `service_category_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `serve` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `department_id` INTEGER NOT NULL,
    `service_category_id` INTEGER NOT NULL,
    `title_th` VARCHAR(500) NOT NULL,
    `title_en` VARCHAR(500) NULL,
    `detail_th` LONGTEXT NULL,
    `detail_en` LONGTEXT NULL,
    `rates_th` LONGTEXT NULL,
    `rates_en` LONGTEXT NULL,
    `location_th` LONGTEXT NULL,
    `location_en` LONGTEXT NULL,
    `contact_th` LONGTEXT NULL,
    `contact_en` LONGTEXT NULL,
    `is_active` INTEGER NOT NULL DEFAULT 1,
    `is_publish` INTEGER NOT NULL DEFAULT 1,
    `count_views` INTEGER NOT NULL DEFAULT 0,
    `created_serve` DATE NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `created_by` VARCHAR(255) NULL,
    `updated_at` DATETIME(3) NULL,
    `updated_by` VARCHAR(255) NULL,
    `deleted_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `news` ADD CONSTRAINT `news_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `department`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `service_category_on_department` ADD CONSTRAINT `service_category_on_department_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `department`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `service_category_on_department` ADD CONSTRAINT `service_category_on_department_service_category_id_fkey` FOREIGN KEY (`service_category_id`) REFERENCES `service_category`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `service_category_on_news` ADD CONSTRAINT `service_category_on_news_news_id_fkey` FOREIGN KEY (`news_id`) REFERENCES `news`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `service_category_on_news` ADD CONSTRAINT `service_category_on_news_service_category_id_fkey` FOREIGN KEY (`service_category_id`) REFERENCES `service_category`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `serve` ADD CONSTRAINT `serve_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `department`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `serve` ADD CONSTRAINT `serve_service_category_id_fkey` FOREIGN KEY (`service_category_id`) REFERENCES `service_category`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
