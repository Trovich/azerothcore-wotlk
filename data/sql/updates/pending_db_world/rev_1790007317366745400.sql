--
-- Zombie Infestation: remove the Argent Healers entirely. Curing is now done by curer NPCs (see the
-- Healer.CurerNpcEntries default in ZombieInfestationMgr.cpp - every disease-curing class trainer plus
-- the named Argent Dawn leaders at Light's Hope Chapel and Chillwind Camp) and by nearby players of a
-- disease-curing class (Healer.PlayerCureCapableClasses), replacing the old dedicated healer NPCs.
--
DELETE FROM `game_event_creature` WHERE `guid` IN (
    5320010, 5320017, 5320025, 5320037, 5320051, 5320059, 5320068, 5320074,
    5320103, 5320110, 5320119, 5320124, 5320134, 5320142, 5320147, 5320154
);
DELETE FROM `creature` WHERE `guid` IN (
    5320010, 5320017, 5320025, 5320037, 5320051, 5320059, 5320068, 5320074,
    5320103, 5320110, 5320119, 5320124, 5320134, 5320142, 5320147, 5320154
);
-- the C++ AI class this pointed at (npc_zi_argent_healer) no longer exists - clear it so any future
-- spawn of these templates (GM .npc add, another script's SummonCreature) doesn't hit a missing script
UPDATE `creature_template` SET `ScriptName` = '' WHERE `entry` IN (27305, 31282);
