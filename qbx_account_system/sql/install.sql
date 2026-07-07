-- Таблиця для акаунтів
CREATE TABLE IF NOT EXISTS `accounts` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `discord_id` VARCHAR(50) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_username` (`username`),
    UNIQUE KEY `unique_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця для відновлення паролю
CREATE TABLE IF NOT EXISTS `password_resets` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `discord_id` VARCHAR(50) NOT NULL,
    `reset_code` VARCHAR(10) NOT NULL,
    `expires_at` TIMESTAMP NOT NULL,
    `used` TINYINT(1) DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_discord_code` (`discord_id`, `reset_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Додаємо зв'язок між персонажами та акаунтами
-- Припускаємо, що у вас таблиця персонажів називається `players` (стандарт Qbox)
ALTER TABLE `players` 
ADD COLUMN `account_id` INT(11) DEFAULT NULL,
ADD KEY `idx_account_id` (`account_id`);