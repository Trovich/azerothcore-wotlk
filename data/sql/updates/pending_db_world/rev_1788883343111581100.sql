--
-- Quest 9709 "Stealing Back the Mushrooms" - Buddy (17953) still runs (and moves in
-- bursts) while following Watcher Leesa'oh (17831), despite the SET_RUN(0) added in
-- rev_1788798207395049200.sql. That fix was aimed at the wrong unit.
--
-- FollowMovementGenerator does not care what walk state the *follower* has:
--
--     TargetedMovementGenerator.cpp:708
--     if (_inheritWalkState)
--         init.SetWalk(target->IsWalking());
--
-- and MotionMaster::MoveFollow() defaults inheritWalkState to true, so the follower
-- always mirrors the *leader*.
--
-- Leesa'oh does walk visually - her SMART_ACTION_WP_START passes ForcedMovement 1
-- (FORCED_MOVEMENT_WALK), so MoveSplinePath picks walk speed for her spline. But
-- MoveSplineInit::Launch() only folds MOVEMENTFLAG_WALKING into a *local* copy of the
-- move flags when selecting the spline velocity; it never sets the flag on the unit.
-- Unit::IsWalking() therefore stays false, and Buddy inherits "run" - run gait at a
-- walker's pace, closing the 2 yd follow gap in bursts and stopping dead each time.
--
-- Fix: set the walk flag on Leesa'oh herself (SMART_ACTION_SET_RUN with run = 0 ->
-- Unit::SetWalk(true) -> MOVEMENTFLAG_WALKING) right before her path starts. Her own
-- speed is unchanged (the spline was already walking); Buddy now inherits walk.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 1783101 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(1783101,9,1,0,0,0,100,0,0,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script 2 - Set Npc Flags'),
(1783101,9,2,0,0,0,100,0,0,0,0,0,0,0,1,0,7000,0,0,0,0,12,1,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script 2 - Say Line 1'),
(1783101,9,3,0,0,0,100,0,7000,7000,0,0,0,0,45,1,1,0,0,0,0,19,17953,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script 2 - Set Data 1 1 on Buddy'),
(1783101,9,4,0,0,0,100,0,0,0,0,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script 2 - Set Walk (so Buddy inherits walk while following)'),
(1783101,9,5,0,0,0,100,0,0,0,0,0,0,0,53,1,17831,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script 2 - Start WP');
