--
-- Gryphon Rider Guard (15241) / Bat Rider Guard (15242) only open fire point-blank, and
-- barely notice anyone.
--
-- 1. Point-blank shooting. rev_1788969600200000000.sql added the three legacy
--    SMART_ACTION_ALLOW_COMBAT_MOVEMENT range bands copied from Redridge Poacher (424).
--    On this core they fight SmartAI's ranged mode instead of helping it: the Shoot row
--    carries SMARTCAST_COMBAT_MOVE, so SmartAI::InitializeAI already makes 6660 the main
--    spell and chases at 30 - 5 = 25 yd with melee switched off. But the 30-60 yd band
--    calls SmartAI::SetCombatMovement(true, true), which re-issues MoveChase(victim)
--    with no distance at all - so every 4 s the guard is told to fly into melee, and it
--    only shoots from wherever it happens to be when the 5-30 band catches it on the way
--    in. The bands are dropped; SMARTCAST_MAIN_SPELL is set explicitly on Shoot so the
--    25 yd stand-off does not depend on the COMBAT_MOVE fallback.
--
-- 2. Aggro radius. Both guards have detection_range 20 - a normal ground mob's radius,
--    measured in 3D against players flying past at mount speed. Raised to 45, the core's
--    MAX_AGGRO_RADIUS cap (Creature::GetAggroRange). This covers the 16 world-spawned Bat
--    Rider Guards patrolling Thrallmar; the summoned ones are sent in by the alarm posts,
--    see npc_air_force_bots in npcs_special.cpp.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (15241, 15242) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(15241,0,0,0,9,0,100,0,0,0,2000,4000,5,30,11,6660,1088,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gryphon Rider Guard - Within 5-30 Range - Cast Shoot (main spell)'),
(15242,0,0,0,9,0,100,0,0,0,2000,4000,5,30,11,6660,1088,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bat Rider Guard - Within 5-30 Range - Cast Shoot (main spell)');

UPDATE `creature_template` SET `detection_range` = 45 WHERE `entry` IN (15241, 15242);
