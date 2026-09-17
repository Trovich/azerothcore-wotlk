--
-- Miss Danna (3513) walks her Stormwind tour, the orphans running after her in bursts.
--
-- Her path starts with SMART_ACTION_WP_START ForcedMovement = WALK, which walks the spline
-- but never sets MOVEMENTFLAG_WALKING on her. The seven children follow her
-- (SMART_ACTION_FOLLOW from her Set Data 1 0), and FollowMovementGenerator copies the
-- leader's walk state (init.SetWalk(target->IsWalking())) - IsWalking() is false, so they
-- run, catch up, stop, and run again. Same fault as Watcher Leesa'oh and Buddy in
-- rev_1788883343111581100.sql; same fix: an explicit SET_RUN 0 on the leader when the tour
-- starts.
--

UPDATE `smart_scripts` SET `link` = 16 WHERE `entryorguid` = 3513 AND `source_type` = 0 AND `id` = 14;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 3513 AND `source_type` = 0 AND `id` = 16;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3513,0,16,0,61,0,100,0,0,0,0,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Miss Danna - Linked - Set Walk (the orphans copy the walk flag)');
