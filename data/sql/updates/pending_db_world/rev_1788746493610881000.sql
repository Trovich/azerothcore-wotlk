--
-- Quest 9709 "Stealing Back the Mushrooms" - Watcher Leesa'oh (17831) and her
-- cat Buddy (17953).
--
-- Two problems on turn-in:
--
-- 1. Buddy was told to follow with SMART_ACTION_FOLLOW dist 0 / angle 0, which
--    SmartAI turns into SetFollow(target, 0.1f, 0.0f) - the cat walks *inside*
--    Leesa'oh's model for the whole escort, so the two read as one NPC sharing a
--    single waypoint path. Now dist 2 / angle 180 (the pattern already used by
--    other escort companions in this table), i.e. Buddy pads along behind her.
--
-- 2. When Leesa'oh reached the mushroom patch (WP13) her script sent "data 2 2"
--    to Buddy, whose reaction was: stop following, then SMART_ACTION_WP_START on
--    path 17953. That path has exactly one point, (-223.89, 8147.56, 20.74),
--    which is ~166 yards away from the camp - so the cat walked off alone into
--    the marsh and never came back (azerothcore/azerothcore-wotlk#14550: "Buddy
--    will slowly walk into isolation", expected to stay next to Leesa'oh).
--
--    The release is now moved to the *end* of the escort: Buddy keeps following
--    all the way home, and the "data 2 2" is fired from Leesa'oh's WP30 (her
--    spawn point) handler instead. Buddy then just stops following and takes up
--    random movement where he stands, which is right next to her.
--
--    The dialogue timing of script 1783100 is preserved: the 1000 ms that
--    belonged to the removed "Set Data 2 2" row is folded into the next row.
--
-- Waypoint path 17953 is left in place but is no longer referenced by anything.
--
-- Comments on several rows were wrong (Buddy's WP start was labelled "Play
-- Sound ID 643", Leesa'oh's WP13/WP30 handlers were labelled WP21/WP41/WP31);
-- they are corrected here since the blocks are rewritten in full anyway.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 17831 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(17831,0,0,1,20,0,100,512,9709,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - On Quest Reward - Store Target List'),
(17831,0,1,6,61,0,100,512,0,0,0,0,0,0,80,1783101,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - On Quest Reward - Run Script'),
(17831,0,2,3,40,0,100,512,13,17831,0,0,0,0,54,50000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - On Reached WP13 - Pause WP'),
(17831,0,3,0,61,0,100,512,0,0,0,0,0,0,80,1783100,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - On Reached WP13 - Run Script'),
(17831,0,4,5,40,0,100,512,30,17831,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0.925025,'Watcher Leesa\'oh - On Reached WP30 - Set Orientation'),
(17831,0,5,9,61,0,100,512,0,0,0,0,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - On Reached WP30 - Set NPC Flags'),
(17831,0,6,0,61,0,100,512,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Quest Reward - Set Phase 1'),
(17831,0,7,8,1,1,100,512,300000,300000,0,0,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - OOC (Phase 1) - Set NPC Flags'),
(17831,0,8,0,61,1,100,512,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - OOC (Phase 1) - Set Phase 0'),
(17831,0,9,0,61,0,100,512,0,0,0,0,0,0,45,2,2,0,0,0,0,19,17953,0,0,0,0,0,0,0,'Watcher Leesa\'oh - On Reached WP30 - Set Data 2 2 on Buddy');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 17953 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(17953,0,0,0,38,0,100,512,1,1,0,0,0,0,29,2,180,0,0,0,0,19,17831,0,0,0,0,0,0,0,'Buddy - On Data Set 1 1 - Follow Watcher Leesa\'oh At 2yd Behind'),
(17953,0,1,2,1,0,100,0,0,30000,60000,75000,0,0,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - OOC - Play emote OneShotAttack1H'),
(17953,0,2,0,61,0,100,0,0,0,0,0,0,0,4,643,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - OOC - Play Sound ID 643'),
(17953,0,3,0,25,0,100,0,0,0,0,0,0,0,89,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - On Reset Set Random Movement'),
(17953,0,4,5,38,0,100,512,2,2,0,0,0,0,29,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - On Data Set 2 2 - Stop Following Watcher Leesa\'oh'),
(17953,0,5,0,61,0,100,512,0,0,0,0,0,0,89,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Buddy - On Data Set 2 2 - Set Random Movement');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 1783100 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(1783100,9,0,0,0,0,100,0,0,0,0,0,0,0,1,1,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script - Say Line 2'),
(1783100,9,1,0,0,0,100,0,2000,2000,0,0,0,0,11,32618,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script - Cast'),
(1783100,9,2,0,0,0,100,0,8000,8000,0,0,0,0,1,2,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script - Say Line 3'),
(1783100,9,3,0,0,0,100,0,5000,5000,0,0,0,0,50,182073,21,0,0,0,0,8,0,0,0,0,-293.135,8218.52,22.2616,2.75761,'Watcher Leesa\'oh - Script - Spawn Grown Mushroom'),
(1783100,9,4,0,0,0,100,0,1000,1000,0,0,0,0,12,17955,1,30000,0,0,0,8,0,0,0,0,-362.376,8215.58,25.2591,0.379451,'Watcher Leesa\'oh - Script - Spawn Hungry Boglord'),
(1783100,9,5,0,0,0,100,0,8000,8000,0,0,0,0,1,0,0,0,0,0,0,19,17955,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script - Say Line 1 on Hungry Boglord'),
(1783100,9,7,0,0,0,100,0,5000,5000,0,0,0,0,1,3,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script - Say Line 4'),
(1783100,9,8,0,0,0,100,0,9000,9000,0,0,0,0,1,1,0,0,0,0,0,19,17955,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script - Say Line 2 on Hungry Boglord'),
(1783100,9,9,0,0,0,100,0,10000,10000,0,0,0,0,1,4,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Watcher Leesa\'oh - Script - Say Line 4');
