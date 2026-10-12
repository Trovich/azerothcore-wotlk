--
-- The plagued bears, wolves and the plagued boar become Undead (they were Beasts that only look dead).
--
-- What follows from the creature type, by the rules of this core:
--   - they do not bleed (Unit::IsImmunedToBleed - for every bleed since the fix in Unit::IsImmunedToSpell, which
--     needs the rebuilt worldserver);
--   - those that can be tamed (pet family + tameable flag, unchanged here) obey Forsaken hunters only, and as pets
--     they stay undead;
--   - Shackle Undead, Turn Evil and the like work on them; Scare Beast, Hibernate, Beast Slaying do not.
-- Chosen by the look of the creature (its skin texture): bears with BearSkin*Diseased, wolves with
-- WolfSkinDiseased, the boar with BoarSkinUndead. Spirit wolves (WolfSkin_Ghost) and kill-credit dummies are left alone.
-- A client that has met them keeps the old type in Cache\WDB\<locale>\creaturecache.wdb.
--

-- Bears: Angerclaw Bear / Grizzly / Mauler, Deathclaw, Diseased Black Bear, Diseased Grizzly, Infected Grizzly Bear,
--        Rabid Grizzly, Rotclaw, Ursoc, Ferra
-- Wolves: Bonechewer War Wolf, Diseased Wolf, Felpaw Wolf / Scavenger / Ravager, Mutant War Hound
-- Boar: Plagued Swine
UPDATE `creature_template` SET `type` = 6
WHERE `type` IN (1, 6) AND `entry` IN (
    8956, 8957, 8958, 17661, 1815, 1816, 26706, 26643, 30326, 26633, 14308,
    16926, 1817, 8959, 8960, 8961, 23232,
    16117);

-- An earlier version of this file gave them a bleed immunity row instead; the type does that now
UPDATE `creature_template` SET `CreatureImmunitiesId` = 0 WHERE `CreatureImmunitiesId` = 9000071 AND `entry` IN (
    8956, 8957, 8958, 17661, 1815, 1816, 26706, 26643, 30326, 26633,
    16926, 1817, 8959, 8960, 8961, 23232,
    16117);
UPDATE `creature_template` SET `CreatureImmunitiesId` = -92 WHERE `entry` = 14308 AND `CreatureImmunitiesId` = 9000072;

-- The three gargoyles that are not of the Undead type (Zelfrax - a demon; Ebon Blade Gargoyle and Ebon Blade Winged
-- Defender - humanoids) keep their type and get the immunity as data.   Mask: 1 << mechanic (BLEED = 15)
DELETE FROM `creature_immunities` WHERE `ID` IN (9000071, 9000072);
INSERT INTO `creature_immunities` (`ID`, `SchoolMask`, `DispelTypeMask`, `MechanicsMask`, `Effects`, `Auras`, `ImmuneAoE`, `ImmuneChain`, `Comment`) VALUES
(9000071, 0, 0, 32768, '', '', 0, 0, 'gargoyles that are not of the Undead type: bleed');
UPDATE `creature_template` SET `CreatureImmunitiesId` = 9000071 WHERE `CreatureImmunitiesId` IN (0, 9000071) AND `entry` IN (23864, 32472, 31257);
