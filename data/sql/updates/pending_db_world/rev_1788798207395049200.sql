--
-- Quest 9709 "Stealing Back the Mushrooms" - Buddy (17953) moves in jerky bursts
-- while escorting Watcher Leesa'oh (17831), even though both are only walking.
--
-- SMART_ACTION_FOLLOW never sets the follower's walk state - it only picks a
-- follow distance/angle. Watcher Leesa'oh's own escort waypoints are walked
-- (npc_escortAI-style slow pace), but Buddy keeps its default RUN gait: every
-- time the 2 yd follow distance opens up even slightly, MoveFollow closes the
-- gap with a run-speed burst, then has to stop dead once back in range -
-- which reads exactly as "runs in jerks" instead of walking alongside her.
--
-- Two new rows, chained after the existing follow/stop-follow actions:
-- SMART_ACTION_SET_RUN(0) puts Buddy in walk gait for the whole escort;
-- SMART_ACTION_SET_RUN(1) restores normal run for its ambient random
-- movement once the escort ends, so this doesn't leak into unrelated OOC
-- wandering.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 17953 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(17953,0,0,6,38,0,100,512,1,1,0,0,0,0,29,2,180,0,0,0,0,19,17831,0,0,0,0,0,0,0,'Buddy - On Data Set 1 1 - Follow Watcher Leesa\'oh At 2yd Behind'),
(17953,0,1,2,1,0,100,0,0,30000,60000,75000,0,0,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - OOC - Play emote OneShotAttack1H'),
(17953,0,2,0,61,0,100,0,0,0,0,0,0,0,4,643,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - OOC - Play Sound ID 643'),
(17953,0,3,0,25,0,100,0,0,0,0,0,0,0,89,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - On Reset Set Random Movement'),
(17953,0,4,7,38,0,100,512,2,2,0,0,0,0,29,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - On Data Set 2 2 - Stop Following Watcher Leesa\'oh'),
(17953,0,5,0,61,0,100,512,0,0,0,0,0,0,89,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - On Data Set 2 2 - Set Random Movement'),
(17953,0,6,0,61,0,100,512,0,0,0,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - Linked - Set Walk (following)'),
(17953,0,7,0,61,0,100,512,0,0,0,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - Linked - Set Run (escort over)');
