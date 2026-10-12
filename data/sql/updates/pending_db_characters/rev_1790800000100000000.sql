--
-- Death knights are humans, dwarves and blood elves only (pending_db_world/rev_1790800000100000000.sql):
-- the RANDOM BOT death knights of the other races are moved to an allowed race of their own faction.
--
-- Without this they could not be loaded any more ("has incorrect race/class pair"): `.playerbots bot addclass dk`
-- picks a random death knight of the player's faction and would fail on most of them, and so would every one
-- of them at login if AiPlayerbot.DisableDeathKnightLogin is ever switched off.
--
--   Night Elf (4), Gnome (7), Draenei (11)        -> Human (1) or Dwarf (3), half and half
--   Orc (2), Undead (5), Tauren (6), Troll (8)    -> Blood Elf (10)
--
-- Only characters on the bot accounts (AiPlayerbot.RandomBotAccountPrefix = "rndbot": rndbot0, rndbot1, ...)
-- are touched. A death knight of a removed race on a normal account is left as it is - it stays in the
-- database, hidden from the character list, until it is given an allowed race or its playercreateinfo row
-- is put back.
--
-- Same steps as the core's own race change (WorldSession::HandleCharFactionOrRaceChangeCallback): race, looks,
-- languages. In addition the old racial skill line and its spells are removed; the new racial skill and
-- spells are taught at the next login (Player::LearnDefaultSkills -> learnSkillRewardedSpells).
-- Gender, name, level, gear, position and reputations are kept (the faction does not change).
--
-- The old race and looks are saved in `character_dk_race_backup` (guid -> race, skin, face, hair).
--

CREATE TABLE IF NOT EXISTS `character_dk_race_backup` (
    `guid` INT UNSIGNED NOT NULL COMMENT 'Character Global Unique Identifier',
    `race` TINYINT UNSIGNED NOT NULL,
    `skin` TINYINT UNSIGNED NOT NULL,
    `face` TINYINT UNSIGNED NOT NULL,
    `hairStyle` TINYINT UNSIGNED NOT NULL,
    `hairColor` TINYINT UNSIGNED NOT NULL,
    `facialStyle` TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Random bot death knights before their race was changed';

DROP TEMPORARY TABLE IF EXISTS `tmp_dk_race_change`;
CREATE TEMPORARY TABLE `tmp_dk_race_change` (PRIMARY KEY (`guid`)) AS
SELECT c.`guid`,
       CASE WHEN c.`race` IN (4, 7, 11) THEN IF(CRC32(CONCAT(c.`guid`, 'race')) % 2, 3, 1) ELSE 10 END AS `newRace`
FROM `characters` c
JOIN `acore_auth`.`account` a ON a.`id` = c.`account`
WHERE c.`class` = 6 AND c.`race` IN (2, 4, 5, 6, 7, 8, 11) AND LOWER(a.`username`) REGEXP '^rndbot[0-9]+$';

INSERT IGNORE INTO `character_dk_race_backup` (`guid`, `race`, `skin`, `face`, `hairStyle`, `hairColor`, `facialStyle`)
SELECT c.`guid`, c.`race`, c.`skin`, c.`face`, c.`hairStyle`, c.`hairColor`, c.`facialStyle`
FROM `characters` c
JOIN `tmp_dk_race_change` t ON t.`guid` = c.`guid`;

--
-- Race and looks. The looks are picked per character (a hash of the guid) from the ordinary, non-death-knight
-- options that the character creation screen offers for the new race and gender - counts from CharSections.dbc
-- (playable skins, every face exists for every one of them; hair styles without the barber-only ones;
-- 10 hair colours everywhere) and CharacterFacialHairStyles.dbc:
--                     skins  faces  hair styles  facial styles
--   Human     male      10     12       12            9
--   Human     female    10     15       19            7
--   Dwarf     male       9     10       11           11
--   Dwarf     female     9     10       14            6
--   Blood Elf male      10     10       11           10
--   Blood Elf female    10     10       14           11
--
UPDATE `characters` c
JOIN `tmp_dk_race_change` t ON t.`guid` = c.`guid`
SET c.`race` = t.`newRace`,
    c.`skin` = CRC32(CONCAT(c.`guid`, 'skin')) % IF(t.`newRace` = 3, 9, 10),
    c.`face` = CRC32(CONCAT(c.`guid`, 'face')) % CASE WHEN t.`newRace` = 1 AND c.`gender` = 0 THEN 12
                                                      WHEN t.`newRace` = 1 THEN 15
                                                      ELSE 10 END,
    c.`hairStyle` = CRC32(CONCAT(c.`guid`, 'hair')) % CASE WHEN t.`newRace` = 1 AND c.`gender` = 0 THEN 12
                                                           WHEN t.`newRace` = 1 THEN 19
                                                           WHEN c.`gender` = 0 THEN 11
                                                           ELSE 14 END,
    c.`hairColor` = CRC32(CONCAT(c.`guid`, 'colour')) % 10,
    c.`facialStyle` = CRC32(CONCAT(c.`guid`, 'facial')) % CASE WHEN t.`newRace` = 1 AND c.`gender` = 0 THEN 9
                                                               WHEN t.`newRace` = 1 THEN 7
                                                               WHEN t.`newRace` = 3 AND c.`gender` = 0 THEN 11
                                                               WHEN t.`newRace` = 3 THEN 6
                                                               WHEN c.`gender` = 0 THEN 10
                                                               ELSE 11 END;

-- Languages, as the core does it: all of them out, then the faction's one and the race's own
DELETE s FROM `character_skills` s
JOIN `tmp_dk_race_change` t ON t.`guid` = s.`guid`
WHERE s.`skill` IN (98, 113, 759, 111, 313, 109, 115, 315, 673, 137);

INSERT INTO `character_skills` (`guid`, `skill`, `value`, `max`)
SELECT `guid`, IF(`newRace` = 10, 109, 98), 300, 300 FROM `tmp_dk_race_change`; -- Orcish / Common

INSERT INTO `character_skills` (`guid`, `skill`, `value`, `max`)
SELECT `guid`, IF(`newRace` = 10, 137, 111), 300, 300 FROM `tmp_dk_race_change` WHERE `newRace` IN (3, 10); -- Thalassian / Dwarven

-- Racial skill lines of the seven removed races: Tauren, Orc, Night Elf, Undead, Troll, Gnome, Draenei
DELETE s FROM `character_skills` s
JOIN `tmp_dk_race_change` t ON t.`guid` = s.`guid`
WHERE s.`skill` IN (124, 125, 126, 220, 733, 753, 760);

-- ... and every spell of those lines (SkillLineAbility.dbc; none of them belongs to another skill line)
DELETE s FROM `character_spell` s
JOIN `tmp_dk_race_change` t ON t.`guid` = s.`guid`
WHERE s.`spell` IN (
    20549, 20550, 20551, 20552,                                                 -- Tauren
    20572, 20573, 20574, 20575, 20576, 21563, 33697, 33702, 54562, 65222,       -- Orc
    20582, 20583, 20585, 21009, 58984,                                          -- Night Elf
    5227, 7744, 20577, 20579,                                                   -- Undead
    20555, 20557, 20558, 26290, 26297, 58943,                                   -- Troll
    20589, 20591, 20592, 20593,                                                 -- Gnome
    6562, 28875, 28878, 28880, 59221, 59535, 59536, 59538, 59539, 59540,        -- Draenei
    59541, 59542, 59543, 59544, 59545, 59547, 59548);

DROP TEMPORARY TABLE `tmp_dk_race_change`;
