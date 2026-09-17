--
-- Infernals: immunity to Bleed.
--
-- Infernals are animated stone - nothing to bleed - but they are CREATURE_TYPE_DEMON, so
-- Unit::IsImmunedToBleed() (undead / mechanical / elemental) does not cover them. Same
-- approach as the oozes in rev_1788795041485227100.sql: MechanicsMask bit 1 << 15 (MECHANIC_BLEED),
-- shared negative immunity sets left untouched, each one an infernal uses gets a bleed
-- superset under a new positive id.
--
-- The creatures are the demons drawn with Creature\Infernal\Infernal.mdx (displays 169, 1126,
-- 4200, 7029, 7950, 10905, 10906, 12817, 14520, 17312), trigger NPCs on the same displays
-- excluded - warlock Infernal, Searing / Lesser / Massive / Towering / Giant Infernals,
-- Infernal Siegebreaker, the Hellfire and Shadowmoon infernals, Felflame Infernals, and the named
-- ones (Immolatus, Kroshius, Hand of the Highlord).
-- Already immune: Lesser Infernal (-68) and Corrupted Infernal (-10015). Raze and Guardian of
-- Blizzard use the same model but are elementals, so the core already covers them.
--
-- Note: mod-individual-progression's vanilla_creature_immunities.sql sets the warlock Infernal
-- (89) to -4; if that module file is ever re-applied it will undo the change for that entry.
--
DELETE FROM `creature_immunities` WHERE `ID` BETWEEN 1983 AND 1990;
INSERT INTO `creature_immunities` (`ID`, `SchoolMask`, `DispelTypeMask`, `MechanicsMask`, `Effects`, `Auras`, `ImmuneAoE`, `ImmuneChain`, `Comment`) VALUES
(1983, 0, 0, 32768, '', '', 0, 0, 'mech=0x8000(BLEED) - infernals'),
(1984, 4, 0, 32768, '', '', 0, 0, 'superset of -4: school=0x4(FIRE), mech=0x8000(BLEED) - infernals'),
(1985, 4, 0, 1234632374, '', '', 0, 0, 'superset of -276 plus mech BLEED - infernals'),
(1986, 0, 0, 294914, '114', '11', 0, 0, 'superset of -84 plus mech BLEED - infernals'),
(1987, 0, 0, 1234632374, '', '', 0, 0, 'superset of -273 plus mech BLEED - infernals'),
(1988, 0, 0, 16809984, '', '', 0, 0, 'superset of -92 plus mech BLEED - infernals'),
(1989, 0, 0, 1301737214, '98,124,144,145', '', 0, 0, 'superset of -340 plus mech BLEED - infernals'),
(1990, 0, 0, 1301741310, '98,124,144,145', '', 0, 0, 'superset of -361 plus mech BLEED - infernals');

-- Infernals that carried no immunity set at all.
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1983 WHERE `entry` IN
(1862, 11437, 14467, 16963, 17908, 18946, 19259, 19285, 19752, 19759, 19760, 19761, 20160, 21289, 21316, 21419,
 21786, 22203, 22289, 23044, 23075, 25860);

-- Infernals moved from a shared negative set to its bleed-immune superset.
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1984 WHERE `entry` IN (89, 6073, 7135, 7136, 7137, 8608, 8616);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1985 WHERE `entry` IN (8680);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1986 WHERE `entry` IN (17818);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1987 WHERE `entry` IN (19214);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1988 WHERE `entry` IN (19261);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1989 WHERE `entry` IN (34815, 35262);
UPDATE `creature_template` SET `CreatureImmunitiesId` = 1990 WHERE `entry` IN (35263, 35264);
