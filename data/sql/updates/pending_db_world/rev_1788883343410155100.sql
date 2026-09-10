--
-- Gryphon Rider Guard (15241) / Bat Rider Guard (15242) still never shoot after
-- rev_1788798208085417800.sql - they close to melee and swing instead.
--
-- Spell 6660 "Shoot" has range 5-30 yd: it cannot be cast from inside melee range at
-- all. The row added last round used SMART_EVENT_UPDATE_IC, which fires regardless of
-- distance, so every attempt was made while the guard was sitting on top of its target
-- and silently failed the range check; SMARTCAST_COMBAT_MOVE then re-enabled the chase,
-- which is what kept them glued in melee.
--
-- Every ranged humanoid in this DB that actually shoots uses SMART_EVENT_RANGE instead,
-- with the 5-30 band spelled out in event_param5/6 - e.g. Redridge Poacher (424) and
-- Dun Garok Rifleman (2345):
--     event_type 9, params 0,0,2000,4000, range 5..30, castFlags 64, target 2
-- Matching that pattern exactly. SmartAI::InitializeAI() picks the first
-- SMARTCAST_COMBAT_MOVE cast as the "main spell" and sets _attackDistance to
-- maxRange - NOMINAL_MELEE_RANGE = 25 yd, so the guard now holds station and fires
-- instead of diving into melee.
--
-- The same NPCs also have creature_template_addon.equipment_id = 1 pointing at a
-- creature_equip_template row that does not exist, so they carry nothing: no projectile
-- visual, and Spell::EffectSchoolDMG has no ranged weapon to scale off for a
-- SPELL_DAMAGE_CLASS_RANGED spell. Given the two are faction mirrors, the Alliance
-- gryphon rider gets the standard monster gun and the Horde bat rider the crossbow -
-- the same placeholder items every other shooting NPC in the DB uses.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (15241, 15242) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(15241,0,0,0,9,0,100,0,0,0,2000,4000,5,30,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gryphon Rider Guard - Within 5-30 Range - Cast Shoot'),
(15242,0,0,0,9,0,100,0,0,0,2000,4000,5,30,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bat Rider Guard - Within 5-30 Range - Cast Shoot');

DELETE FROM `creature_equip_template` WHERE `CreatureID` IN (15241, 15242) AND `ID` = 1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `ItemID2`, `ItemID3`, `VerifiedBuild`) VALUES
(15241, 1, 0, 0, 2552, 0),
(15242, 1, 0, 0, 2551, 0);
