--
-- Gryphon Rider Guard (15241) / Bat Rider Guard (15242): patrol fine, but
-- never fire on an intruder - they only ever land Guard's Mark.
--
-- Both have AIName = '' (no SmartAI, no C++ AI of their own) and no ranged
-- ability at all. The mark comes from a *different* mechanism entirely:
-- src/server/scripts/World/npcs_special.cpp's npc_air_force_bots (a shared
-- script used by dozens of zones' flight-detection guards) casts Guard's
-- Mark (38067) from a *temporarily summoned* copy of one of these two
-- entries, then calls AttackStart() on it once the mark is about to expire.
-- AttackStart() only ever produces melee - and a flying guard chasing a
-- flying player rarely closes to melee range, so in practice it never lands
-- a hit, mark or no mark.
--
-- Neither entry's own ScriptName is npc_air_force_bots (that lives on the
-- separate, invisible alarm-bot/guard-post trigger entries), so giving them
-- SmartAI doesn't touch that shared script - it only adds what every other
-- ranged humanoid guard in this DB already has: spell 6660 "Shoot", cast on
-- a repeat once combat starts (SMARTCAST_COMBAT_MOVE so it can keep firing
-- while chasing instead of needing to stop). This now also benefits the
-- permanent decorative spawns if anything ever aggros them directly, not
-- just the alarm-bot-summoned copies.
--

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (15241, 15242);

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (15241, 15242) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(15241,0,0,0,0,0,100,0,0,1000,2000,2000,0,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gryphon Rider Guard - In Combat - Cast Shoot'),
(15242,0,0,0,0,0,100,0,0,1000,2000,2000,0,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bat Rider Guard - In Combat - Cast Shoot');
