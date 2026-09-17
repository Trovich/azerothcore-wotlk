--
-- Quest 10935 "The Exorcism of Colonel Jules", part 5: the end of the ritual.
--
-- Checked against the retail event (Wowhead comments): the whole exorcism takes about 3.5
-- minutes; skulls, then oozes; "Colonel Jules will start floating back to the bed again";
-- the quest objective "Colonel Jules Saved" is credited only by talking to Jules once he is
-- back on the bed. Our credit path is intact (Jules gossip hello -> kill credit 22432), but
-- the end of the event never lined up with it:
--
-- 1. Jules keeps floating round the room for ~1.5 minutes after the ritual is over.
--    Waypoint path 22432 is 44 points; after the 70 s pause on point 2 the remaining 176 yd
--    are flown at walk speed, and Jules' speed_walk is 0.4 (1 yd/s) - so he reaches the last
--    point (the bed) around t+285s, well after Barada has finished at t+188s and walked back.
--    Until then he is hovering out of reach and the players are left waiting.
--    speed_walk 0.4 -> 0.9 brings the lap to ~78 s, ending with the ritual; and as a hard stop
--    his action list now ends the path, resets his home to the bed and sends him there before
--    he lies down and becomes talkable, so the finish no longer depends on the timing.
--
-- 2. More skulls. With the real source of the swarm gone (spell 39280, SpellInfoCorrections)
--    the 30-40 s cadence from rev_1789140000200000000.sql turned out too sparse: first skull
--    now after 8-12 s, then one every 15-20 s (~8-9 over the ritual, rarely more than two up).
--
-- 3. The vomit bunnies. 39296 summons The Exorcism Bubbling Slimer Bunny (22505) at Jules'
--    position - TARGET_DEST_CASTER, and Jules is hovering 1.5-4.5 yd over the floor - and the
--    bunny summons the Foul Purge oozes at its own position. Summons are not grounded, so the
--    oozes appeared in mid-air. The bunny now drops to the floor as soon as it is summoned.
--
-- 4. Barada's closing line. The final beat of his list used text group 3 ("I... must not...
--    falter"), which now belongs to the falters; the finale gets group 7, "Back! I cast you
--    back... corruptor of faith!", which was never used.
--

-- 1. Jules gets back to the bed with the ritual
UPDATE `creature_template` SET `speed_walk` = 0.9 WHERE `entry` = 22432;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 2243200 AND `source_type` = 9 AND `id` BETWEEN 17 AND 30;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(2243200,9,17,0,0,0,100,0,8000,8000,0,0,0,0,28,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - Script - Remove All Auras'),
(2243200,9,18,0,0,0,100,0,0,0,0,0,0,0,55,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - Script - Stop Path (if still flying the lap)'),
(2243200,9,19,0,0,0,100,0,0,0,0,0,0,0,101,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - Script - Set Home Position to spawn (the bed)'),
(2243200,9,20,0,0,0,100,0,0,0,0,0,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - Script - Evade (return to the bed)'),
(2243200,9,21,0,0,0,100,0,5000,5000,0,0,0,0,11,39283,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - Script - Cast ''Hellfire - The Exorcism, Jules goes prone'''),
(2243200,9,22,0,0,0,100,0,0,0,0,0,0,0,81,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - Script - Set Npc Flags Gossip (talk to Jules for the credit)');

-- Talking to Jules makes him evade 5 s later (action list 2243201), which strips the prone aura;
-- lie back down whenever he gets home.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 22432 AND `source_type` = 0 AND `id` = 10;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22432,0,10,0,21,0,100,512,0,0,0,0,0,0,11,39283,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On Reached Home - Cast ''Hellfire - The Exorcism, Jules goes prone''');

-- 2. more skulls
UPDATE `smart_scripts` SET `event_param1` = 8000, `event_param2` = 12000, `event_param3` = 15000, `event_param4` = 20000
WHERE `entryorguid` = 22432 AND `source_type` = 0 AND `id` = 7;

-- 3. the vomit bunny lands before it spawns oozes
DELETE FROM `smart_scripts` WHERE `entryorguid` = 22505 AND `source_type` = 0 AND `id` = 3;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22505,0,3,0,54,0,100,0,0,0,0,0,0,0,210,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bubbling Slimer Bunny - On Just Summoned - Fall to the floor (summoned where Jules hovers)');

-- 4. Barada's closing line
UPDATE `smart_scripts` SET `action_param1` = 7, `comment` = 'Script9 - Talk (finale)'
WHERE `entryorguid` = 2243100 AND `source_type` = 9 AND `id` = 28;
