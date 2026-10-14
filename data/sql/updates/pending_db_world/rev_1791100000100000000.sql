--
-- Elwynn Forest and Dun Morogh: doubled spawns removed.
--
-- In places two identical beasts wandered about on one spot - mostly wolves. These are two spawn rows of the
-- same creature a couple of yards apart (the same spawn point recorded twice in the data this database grew
-- from), not a pool and not an event. Found with tools/cmangos_duplicates.py against the cMaNGOS TBC-DB
-- reference copy: clusters of same-entry spawns within 6 yd of each other, where the reference has fewer
-- spawns of that entry within 10 yd; removed is the surplus, the guids the reference does not have first.
-- Spawns with a path, formation, pool, game event or their own script were not candidates. Wildlife and
-- hostile mobs only: the doubled war effort NPCs and a city guard the tool also lists are left alone.
--
DELETE FROM `creature_addon` WHERE `guid` IN (80141, 80071, 80267, 80269, 80279, 79631, 79636, 81088, 81089, 81097, 81381, 4528, 2095, 3217, 4114, 1727, 1731);
-- Timber Wolf (69): 1
DELETE FROM `creature` WHERE `id` = 69 AND `guid` IN (80141);
-- Kobold Laborer (80): 1
DELETE FROM `creature` WHERE `id` = 80 AND `guid` IN (80071);
-- Defias Cutpurse (94): 3
DELETE FROM `creature` WHERE `id` = 94 AND `guid` IN (80267, 80269, 80279);
-- Mangy Wolf (525): 5
DELETE FROM `creature` WHERE `id` = 525 AND `guid` IN (79631, 79636, 81088, 81089, 81097);
-- Young Forest Bear (822): 1
DELETE FROM `creature` WHERE `id` = 822 AND `guid` IN (81381);
-- Rockjaw Skullthumper (1115): 1
DELETE FROM `creature` WHERE `id` = 1115 AND `guid` IN (4528);
-- Large Crag Boar (1126): 2
DELETE FROM `creature` WHERE `id` = 1126 AND `guid` IN (2095, 3217);
-- Elder Crag Boar (1127): 1
DELETE FROM `creature` WHERE `id` = 1127 AND `guid` IN (4114);
-- Winter Wolf (1131): 1
DELETE FROM `creature` WHERE `id` = 1131 AND `guid` IN (1727);
-- Snow Tracker Wolf (1138): 1
DELETE FROM `creature` WHERE `id` = 1138 AND `guid` IN (1731);
