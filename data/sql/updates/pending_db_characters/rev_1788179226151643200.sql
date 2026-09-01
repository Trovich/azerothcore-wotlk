--
-- Player skeletons (bones) persistence: store converted player bones so they
-- survive server restarts and so a single player can leave several skeletons.
-- Kept in a dedicated table (the `corpse` table is PK'd on the character guid
-- and can only hold one row per player).
--
DROP TABLE IF EXISTS `character_bones`;
CREATE TABLE `character_bones` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ownerGuid` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
    `posX` FLOAT NOT NULL DEFAULT '0',
    `posY` FLOAT NOT NULL DEFAULT '0',
    `posZ` FLOAT NOT NULL DEFAULT '0',
    `orientation` FLOAT NOT NULL DEFAULT '0',
    `mapId` SMALLINT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
    `phaseMask` INT UNSIGNED NOT NULL DEFAULT '1',
    `displayId` INT UNSIGNED NOT NULL DEFAULT '0',
    `itemCache` TEXT NOT NULL,
    `bytes1` INT UNSIGNED NOT NULL DEFAULT '0',
    `bytes2` INT UNSIGNED NOT NULL DEFAULT '0',
    `guildId` INT UNSIGNED NOT NULL DEFAULT '0',
    `flags` TINYINT UNSIGNED NOT NULL DEFAULT '0',
    `dynFlags` TINYINT UNSIGNED NOT NULL DEFAULT '0',
    `time` INT UNSIGNED NOT NULL DEFAULT '0',
    `instanceId` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Instance Identifier',
    PRIMARY KEY (`id`),
    KEY `idx_map_instance` (`mapId`, `instanceId`),
    KEY `idx_owner_time` (`ownerGuid`, `time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Death System - persisted player skeletons';

-- The `corpse` table is only ever meant to hold resurrectable corpses (corpseType 1/2).
-- Drop any bones rows an earlier revision of this feature may have written there so they
-- do not get reloaded forever (bones now live in `character_bones`).
DELETE FROM `corpse` WHERE `corpseType` = 0;
