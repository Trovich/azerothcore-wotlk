--
-- Digging Through Bones (10922), second pass: Letoll in the middle of his men, Letoll fights, the
-- researchers face him when he summons the drum.
--
-- 1. Letoll was not in the centre of the formation. The four Explorers' League Researchers (22464) follow
--    Chief Archaeologist Letoll (22458) with SMART_ACTION_FOLLOW, i.e. FollowMovementGenerator, and that one
--    re-paths behind a creature target only after the target has moved 2 * distance away from where it was -
--    with distance 3 the whole ring trailed a couple of yards behind him. The follow action has a new option
--    (rebuilt core needed): action_param6 bit 1 (+2) = keep a formation slot beside a creature target
--    (FormationMovementGenerator: aims at where the leader's spline takes him, at his pace).
--    Distance: the formation generator measures from the leader's centre without adding the follower's reach,
--    so 4 gives the ring of 4 yd the researchers are spawned in (was 3 + reach). An old core reads param6 = 2
--    as "aliveState on" (irrelevant here) and only makes the ring a yard wider.
--
UPDATE `smart_scripts` SET `action_param1` = 4, `action_param6` = 2
WHERE `entryorguid` = 22464 AND `source_type` = 0 AND `id` IN (0, 1, 2, 3) AND `action_type` = 29;

--
-- 2. At the dig, when Letoll summons the drum (Fumper, gameobject 185304), the researchers turn to face him
--    and stay so through the argument that follows. Only there - not at the other halts of the walk.
--    The researchers are told to form up round him again 5 s before the drum appears and some are still
--    walking in from the far dig spots (17-20 yd) when it does, so there are two rows:
--      id 10  Letoll's order "Set Data 4 0", sent together with the drum (new row 10 of his action list
--             2245802): face Letoll. Unit::SetFacingToObject does nothing for a unit that is still moving,
--             so it only turns those already standing in their slots and does not stop the others.
--      id 11  for the others: on reaching the formation slot (MovementInform, FORMATION_MOTION_TYPE = 18 -
--             the formation generator has just turned the member the way the leader looks), face Letoll,
--             on condition that the drum is within 30 yd (conditions: source type 22 = smart event,
--             SourceGroup = id + 1, condition 30 = near gameobject, ConditionTarget 1 = the creature itself).
--
DELETE FROM `smart_scripts` WHERE `entryorguid` = 22464 AND `source_type` = 0 AND `id` IN (10, 11);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22464,0,10,0,38,0,100,512,4,0,0,0,0,0,66,0,0,0,0,0,0,19,22458,50,0,0,0,0,0,0,'Explorers'' League Researcher - On Data Set 4 0 - Face Chief Archaeologist Letoll'),
(22464,0,11,0,34,0,100,512,18,0,0,0,0,0,66,0,0,0,0,0,0,19,22458,50,0,0,0,0,0,0,'Explorers'' League Researcher - On Formation Slot Reached - Face Chief Archaeologist Letoll (drum near)');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceGroup` = 12 AND `SourceEntry` = 22464 AND `SourceId` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 12, 22464, 0, 0, 30, 1, 185304, 30, 0, 0, 0, 0, '', 'Explorers'' League Researcher - face Letoll on reaching the formation slot only while the Fumper drum is out');

-- Letoll's action list at the dig, whole (ids are consecutive, so a row cannot be slipped in): the stock rows
-- with the new row 10 after the drum summon (row 9); rows 10-28 became 11-29, nothing else changed.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 2245802 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(2245802,9,0,0,0,0,100,0,1000,1000,0,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 4'),
(2245802,9,1,0,0,0,100,0,5000,5000,0,0,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 5'),
(2245802,9,2,0,0,0,100,0,2000,2000,0,0,0,0,45,0,1,0,0,0,0,10,78837,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Data 0 1'),
(2245802,9,3,0,0,0,100,0,0,0,0,0,0,0,45,0,2,0,0,0,0,10,78838,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Data 0 2'),
(2245802,9,4,0,0,0,100,0,0,0,0,0,0,0,45,0,3,0,0,0,0,10,78839,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Data 0 3'),
(2245802,9,5,0,0,0,100,0,0,0,0,0,0,0,45,0,4,0,0,0,0,10,78840,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Data 0 4'),
(2245802,9,6,0,0,0,100,0,0,0,0,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Emote State 0'),
(2245802,9,7,0,0,0,100,0,0,0,0,0,0,0,17,0,0,0,0,0,0,11,22464,30,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Emote State 0'),
(2245802,9,8,0,0,0,100,0,5000,5000,0,0,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 6'),
(2245802,9,9,0,0,0,100,0,0,0,0,0,0,0,50,185304,85,0,0,0,0,8,0,0,0,0,-3547.79,5456.06,-12.375,2.26,'Chief Archaeologist Letoll - On Script - Summon Game Object'),
(2245802,9,10,0,0,0,100,0,0,0,0,0,0,0,45,4,0,0,0,0,0,11,22464,30,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Data 4 0 (Researchers: face Letoll)'),
(2245802,9,11,0,0,0,100,0,5000,5000,0,0,0,0,1,0,0,0,0,0,0,10,78837,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 0 Target'),
(2245802,9,12,0,0,0,100,0,3000,3000,0,0,0,0,1,1,0,0,0,0,0,10,78838,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 1 Target'),
(2245802,9,13,0,0,0,100,0,6000,6000,0,0,0,0,1,2,0,0,0,0,0,10,78839,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 2 Target'),
(2245802,9,14,0,0,0,100,0,4500,4500,0,0,0,0,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 7'),
(2245802,9,15,0,0,0,100,0,10000,10000,0,0,0,0,1,3,0,0,0,0,0,10,78837,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 3 Target'),
(2245802,9,16,0,0,0,100,0,6000,6000,0,0,0,0,1,4,0,0,0,0,0,10,78839,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 4 Target'),
(2245802,9,17,0,0,0,100,0,6000,6000,0,0,0,0,1,5,0,0,0,0,0,10,78840,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 5 Target'),
(2245802,9,18,0,0,0,100,0,8000,8000,0,0,0,0,1,6,0,0,0,0,0,10,78838,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 6 Target'),
(2245802,9,19,0,0,0,100,0,11000,11000,0,0,0,0,1,8,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 8'),
(2245802,9,20,0,0,0,100,0,4000,4000,0,0,0,0,5,35,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Play Emote'),
(2245802,9,21,0,0,0,100,0,0,0,0,0,0,0,11,39217,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Cast Fumper Trap'),
(2245802,9,22,0,0,0,100,0,2000,2000,0,0,0,0,1,7,0,0,0,0,0,10,78840,22464,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 7 Target'),
(2245802,9,23,0,0,0,100,0,4000,4000,0,0,0,0,1,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 9'),
(2245802,9,24,0,0,0,100,0,2000,2000,0,0,0,0,1,10,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 10'),
(2245802,9,25,0,0,0,100,0,12000,12000,0,0,0,0,1,11,0,0,0,0,0,12,16777215,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 11'),
(2245802,9,26,0,0,0,100,0,0,0,0,0,0,0,1,12,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Say Line 12'),
(2245802,9,27,0,0,0,100,0,0,0,0,0,0,0,41,4000,0,0,0,0,0,11,22464,30,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Despawn Target'),
(2245802,9,28,0,0,0,100,0,0,0,0,0,0,0,41,4000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Despawn Self'),
(2245802,9,29,0,0,0,100,0,0,0,0,0,0,0,15,10922,0,0,0,0,0,18,40,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Area Explored');

--
-- 3. Letoll ignored the Scorpid Bonecrawlers. Two reasons: he kept faction 35 (friendly to everything; only
--    the researchers were switched to 250), and SMART_ACTION_ESCORT_START sets the react state from its
--    param6, which is 0 = REACT_PASSIVE in his script. When the escort sets off he now takes faction 250
--    as well and becomes aggressive (SMART_ACTION_SET_REACT_STATE 8, 2 = REACT_AGGRESSIVE). SmartAI escorts
--    go back to where they left the path after a fight and walk on. Both reset when he respawns.
--    Mind: he can die now - then the escort ends and the quest has to wait for his respawn.
--
DELETE FROM `smart_scripts` WHERE `entryorguid` = 2245800 AND `source_type` = 9 AND `id` IN (8, 9);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(2245800,9,8,0,0,0,100,0,0,0,0,0,0,0,2,250,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Faction Escortee Active'),
(2245800,9,9,0,0,0,100,0,0,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set React State Aggressive');
