--
-- Digging Through Bones (10922), third pass: the ending.
--
-- As it was: 12 s after "Help him out!", whether the Bone Sifter was dead or not, Letoll thanked the player,
-- "picked up the drum", and four seconds later he and the researchers vanished at the dig.
-- The cMaNGOS TBC-DB reference (script_texts -1000528..-1000531, script_waypoint 22458) has it this way:
-- "IN YOUR FACE!" - "Help him out!" - the worm - "%s picks up the drum." - "You have been a tremendous help...
-- Let us get out of here before more of those things show up!" - and then the party WALKS BACK to the camp
-- (waypoints 14-24, "start returning") and is gone there.
--
-- The reference script itself (cmangos-wotlk, terokkar_forest.cpp, npc_letollAI) moves its event on only while
-- Letoll has no enemy - so the drum is picked up after the worm is dead, with the thanks and the quest credit in
-- the same step - and switches to running at the first point of the way back (SetRun at waypoint 14).
--
-- Now: Letoll waits at the dig (escort paused) until the Bone Sifter tells him it is dead, then picks the drum
-- up, thanks, gives the credit and leads everybody home at a run.
-- Staying "on escort" at the dig also keeps him there after a fight: with the path ended at the dig, as it
-- was, the evade after the worm sent him running to his spawn point.
--

-- 1. the way back, the reference points 14-24, twice:
--    as path 2245801, which the ending starts at a run (an escort keeps the pace it was started with, so the walk
--    out and the run back cannot be one path);
--    and as points 18-28 of the path out. Point 17 must not be the last one - an escort that reaches its last
--    point is over, and Letoll has to stay "on escort" while he waits at the dig. These are only walked if the
--    wait times out (5 min).
DELETE FROM `waypoints` WHERE `entry` = 2245801;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `point_comment`) VALUES
(2245801, 1, -3556.58, 5446.48, -11.92, NULL, 0, 'Chief Archaeologist Letoll - return, at a run'),
(2245801, 2, -3564.44, 5422.62, -16.104, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 3, -3574.87, 5412.7, -16.543, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 4, -3612.79, 5392.81, -13.655, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 5, -3649.19, 5389.11, -11.917, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 6, -3688.28, 5379.72, -9.4, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 7, -3705.63, 5379.26, -7.711, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 8, -3717.27, 5379.18, -4.4, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 9, -3728.77, 5385.65, -3.704, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 10, -3733.33, 5389.24, -5.331, NULL, 0, 'Chief Archaeologist Letoll - return'),
(2245801, 11, -3739.91, 5393.69, -4.213, NULL, 0, 'Chief Archaeologist Letoll - back at the camp');
DELETE FROM `waypoints` WHERE `entry` = 22458 AND `pointid` BETWEEN 18 AND 28;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `point_comment`) VALUES
(22458, 18, -3556.58, 5446.48, -11.92, NULL, 0, 'Chief Archaeologist Letoll - start returning'),
(22458, 19, -3564.44, 5422.62, -16.104, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 20, -3574.87, 5412.7, -16.543, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 21, -3612.79, 5392.81, -13.655, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 22, -3649.19, 5389.11, -11.917, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 23, -3688.28, 5379.72, -9.4, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 24, -3705.63, 5379.26, -7.711, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 25, -3717.27, 5379.18, -4.4, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 26, -3728.77, 5385.65, -3.704, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 27, -3733.33, 5389.24, -5.331, NULL, 0, 'Chief Archaeologist Letoll'),
(22458, 28, -3739.91, 5393.69, -4.213, NULL, 0, 'Chief Archaeologist Letoll - back at the camp');

-- 2. the timed ending goes: rows 25-29 of the dig action list (thanks, pick up, despawn x2, credit)
DELETE FROM `smart_scripts` WHERE `entryorguid` = 2245802 AND `source_type` = 9 AND `id` >= 25;

-- 3. Letoll: wait at the dig (5 min at most, then he goes home anyway), end the event when told, clean up
DELETE FROM `smart_scripts` WHERE `entryorguid` = 22458 AND `source_type` = 0 AND `id` BETWEEN 8 AND 14;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22458,0,8,0,40,0,100,512,17,0,0,0,0,0,54,300000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Waypoint 17 Reached - Pause Waypoint (until the Bone Sifter is dealt with)'),
(22458,0,9,0,38,0,100,513,5,0,0,0,0,0,80,2245803,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Data Set 5 0 (Bone Sifter gone) - Run Script (No Repeat)'),
(22458,0,10,11,58,0,100,512,0,2245801,0,0,0,0,41,1000,0,0,0,0,0,11,22464,60,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Escort Ended (return path: back at the camp) - Despawn Researchers'),
(22458,0,11,0,61,0,100,512,0,0,0,0,0,0,41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Escort Ended - Despawn Self'),
(22458,0,13,14,58,0,100,512,28,22458,0,0,0,0,41,1000,0,0,0,0,0,11,22464,60,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Escort Ended At Point 28 (timed out, walked home) - Despawn Researchers'),
(22458,0,14,0,61,0,100,512,0,0,0,0,0,0,41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Escort Ended At Point 28 - Despawn Self'),
(22458,0,12,0,6,0,100,512,0,0,0,0,0,0,41,5000,0,0,0,0,0,11,22464,100,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Death - Despawn Researchers');

-- 4. the ending: pick the drum up (text 12, the drum gameobject goes), thanks to the escorting player (text 11),
--    quest credit, and home at a run
DELETE FROM `smart_scripts` WHERE `entryorguid` = 2245803 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(2245803,9,0,0,0,0,100,0,3000,3000,0,0,0,0,1,12,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 12 (picks up the drum)'),
(2245803,9,1,0,0,0,100,0,0,0,0,0,0,0,41,0,0,0,0,0,0,20,185304,40,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Despawn Fumper'),
(2245803,9,2,0,0,0,100,0,3000,3000,0,0,0,0,1,11,0,0,0,0,0,12,16777215,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 11 (thanks)'),
(2245803,9,3,0,0,0,100,0,0,0,0,0,0,0,15,10922,0,0,0,0,0,18,60,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Area Explored'),
(2245803,9,4,0,0,0,100,0,3000,3000,0,0,0,0,53,2,2245801,0,0,0,2,12,16777215,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Start Waypoint (return path, run, aggressive)');

-- 5. Bone Sifter (22466) reports to Letoll when it dies - and a second before it leaves unfought (row 13 despawns it
--    after 15 s out of combat)
DELETE FROM `smart_scripts` WHERE `entryorguid` = 22466 AND `source_type` = 0 AND `id` IN (19, 20);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22466,0,19,0,6,0,100,512,0,0,0,0,0,0,45,5,0,0,0,0,0,19,22458,100,0,0,0,0,0,0,'Bone Sifter - On Death - Set Data 5 0 (Chief Archaeologist Letoll)'),
(22466,0,20,0,1,0,100,513,14000,14000,0,0,0,0,45,5,0,0,0,0,0,19,22458,100,0,0,0,0,0,0,'Bone Sifter - Out of Combat 14 s - Set Data 5 0 (Chief Archaeologist Letoll) (No Repeat)');
