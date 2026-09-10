--
-- Oozes: immunity to Bleed.
--
-- Undead, Mechanical and Elemental creatures get this from Unit::IsImmunedToBleed(),
-- but this client build has no CREATURE_TYPE_OOZE: oozes sit in
-- CREATURE_TYPE_NOT_SPECIFIED (10) together with a lot of non-oozes, so they cannot be
-- recognised by type and are listed here by entry instead.
--
-- MECHANIC_BLEED is 15, and Creature::SetSpellImmunities applies the bit index as the
-- mechanic value, so the bit to set in MechanicsMask is 1 << 15 = 32768.
--
-- The negative immunity sets are curated and shared, so they are not edited. Every one
-- of them that an ooze uses gets a superset under a new positive id, and only those
-- oozes are repointed at it; other creatures on the same negative set are unaffected.
--
DELETE FROM `creature_immunities` WHERE `ID` BETWEEN 1972 AND 1982;
INSERT INTO `creature_immunities` (`ID`, `SchoolMask`, `DispelTypeMask`, `MechanicsMask`, `Effects`, `Auras`, `ImmuneAoE`, `ImmuneChain`, `Comment`) VALUES
(1972, 0, 0, 32768, '', '', 0, 0, 'mech=0x8000(BLEED) - oozes'),
(1973, 4, 0, 32768, '', '', 0, 0, 'superset of -4: school=0x4(FIRE), mech=0x8000(BLEED) - oozes'),
(1974, 8, 0, 32768, '', '', 0, 0, 'superset of -5: school=0x8(NATURE), mech=0x8000(BLEED) - oozes'),
(1975, 16, 0, 32768, '', '', 0, 0, 'superset of -6: school=0x10(FROST), mech=0x8000(BLEED) - oozes'),
(1976, 32, 0, 32768, '', '', 0, 0, 'superset of -7: school=0x20(SHADOW), mech=0x8000(BLEED) - oozes'),
(1977, 0, 0, 1301741310, '98,124,144,145', '', 0, 0, 'superset of -361 plus mech BLEED - oozes'),
(1978, 0, 0, 1301741310, '98,114,124,144,145', '11', 0, 0, 'superset of -362 plus mech BLEED - oozes'),
(1979, 0, 0, 2031549476, '', '', 0, 0, 'superset of -393 plus mech BLEED - oozes'),
(1980, 0, 0, 2031549604, '', '', 0, 0, 'superset of -394 plus mech BLEED - oozes'),
(1981, 0, 0, 2031550140, '', '', 0, 0, 'superset of -395 plus mech BLEED - oozes'),
(1982, 0, 0, 2044132390, '', '', 0, 0, 'superset of -417 plus mech BLEED - oozes');

-- Oozes that carried no immunity set at all.
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1972 WHERE `entry` IN
(364, 1030, 1031, 1032, 1033, 1806, 1808, 2656, 3928, 4391, 4392, 4393, 4394, 4395, 4469, 5228, 5235, 6218,
 6556, 6557, 6559, 7086, 7092, 7093, 8257, 8766, 9477, 9621, 10290, 10697, 12221, 12387, 15472, 15925, 16903,
 17356, 17357, 20565, 20566, 21264, 22505, 24279, 26366, 27981, 29026, 31245, 31388, 35176, 37006, 37690,
 37986, 38107, 38234, 38556);

-- Oozes moved from a shared negative set to its bleed-immune superset.
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1973 WHERE `entry` IN (16784);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1974 WHERE `entry` IN (16785);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1975 WHERE `entry` IN (16783);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1976 WHERE `entry` IN (16243);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1977 WHERE `entry` IN (36899, 38123);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1978 WHERE `entry` IN (36897, 37697, 38138, 38604, 38758, 38759);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1979 WHERE `entry` IN (16024, 29355);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1980 WHERE `entry` IN (16375, 29354);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1981 WHERE `entry` IN (16290, 29388);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1982 WHERE `entry` IN (29575, 351064);
