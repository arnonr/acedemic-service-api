/*
  Warnings:

  - A unique constraint covering the columns `[uuid]` on the table `department` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[username]` on the table `user` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `user` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `uuid` to the `department` table without a default value. This is not possible if the table is not empty.
  - Added the required column `department_id` to the `user` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `user` table without a default value. This is not possible if the table is not empty.
  - Added the required column `username` to the `user` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `department` ADD COLUMN `uuid` VARCHAR(100) NOT NULL;

-- AlterTable
ALTER TABLE `serve` ADD COLUMN `breif_detail_en` LONGTEXT NULL,
    ADD COLUMN `breif_detail_th` LONGTEXT NULL,
    ADD COLUMN `email` VARCHAR(500) NULL,
    ADD COLUMN `phone` VARCHAR(500) NULL,
    ADD COLUMN `price1` INTEGER NULL,
    ADD COLUMN `price2` INTEGER NULL,
    ADD COLUMN `price3` INTEGER NULL,
    ADD COLUMN `price4` INTEGER NULL,
    ADD COLUMN `price5` INTEGER NULL,
    ADD COLUMN `serve_file` VARCHAR(500) NULL,
    ADD COLUMN `type_id` INTEGER NULL,
    ADD COLUMN `unit_th` VARCHAR(500) NULL;

-- AlterTable
ALTER TABLE `user` ADD COLUMN `department_id` INTEGER NOT NULL,
    ADD COLUMN `name` VARCHAR(500) NOT NULL,
    ADD COLUMN `username` VARCHAR(500) NOT NULL;

-- CreateTable
CREATE TABLE `type` (
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
CREATE TABLE `test_type` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name_th` VARCHAR(500) NOT NULL,
    `name_en` VARCHAR(500) NULL,
    `price1` INTEGER NULL,
    `price2` INTEGER NULL,
    `price3` INTEGER NULL,
    `price4` INTEGER NULL,
    `price5` INTEGER NULL,
    `unit_th` VARCHAR(500) NULL,
    `level` INTEGER NULL,
    `detail_th` LONGTEXT NULL,
    `detail_en` LONGTEXT NULL,
    `is_active` INTEGER NOT NULL DEFAULT 1,
    `is_publish` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `created_by` VARCHAR(255) NULL,
    `updated_at` DATETIME(3) NULL,
    `updated_by` VARCHAR(255) NULL,
    `deleted_at` DATETIME(3) NULL,
    `serve_id` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE UNIQUE INDEX `department_uuid_key` ON `department`(`uuid`);

-- CreateIndex
CREATE UNIQUE INDEX `user_username_key` ON `user`(`username`);

-- CreateIndex
CREATE UNIQUE INDEX `user_name_key` ON `user`(`name`);

-- AddForeignKey
ALTER TABLE `user` ADD CONSTRAINT `user_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `department`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `serve` ADD CONSTRAINT `serve_type_id_fkey` FOREIGN KEY (`type_id`) REFERENCES `type`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `test_type` ADD CONSTRAINT `test_type_serve_id_fkey` FOREIGN KEY (`serve_id`) REFERENCES `serve`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
