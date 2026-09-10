--
-- Quest 10935 "The Exorcism of Colonel Jules" - thin out the flying skulls.
--
-- SERVER TUNING, not a data repair: the rows below are identical to upstream
-- AzerothCore except for the two numbers on row 7. Revert that row to
-- 2000,6000,3000,8000 / 60000 to go back to stock behaviour.
--
-- While the exorcism runs, Colonel Jules (22432) is in phase 1 and summons a
-- Darkness Released (22507) on a 3-8 s timer, each living 60 s. Phase 1 lasts
-- from roughly 26 s (Jules reaches WP2) to 174 s (script 2243200 row 14 clears
-- the phase) - about 148 s - so the event produces ~27 skulls and keeps
-- 60 / 5.5 = ~11 of them alive at any moment, all stacked on the single summon
-- point (-710, 2754.28, 105.3).
--
-- Each skull casts 39320 "The Exorcism, Flying Skull attack" - 238 shadow
-- damage in a 12 yard radius - every 5-8 s. Eleven of them is ~350-500 AoE dps
-- on everything in the room, including Anchorite Barada, whose health regen is
-- deliberately switched off for the duration (script 2243100 row 0). A two-man
-- group cannot out-heal that, and the escort NPC dies with them.
--
-- New timings: 5-10 s initial, 7-12 s repeat, 35 s lifetime. That gives ~15
-- skulls over the event and ~3.7 alive at a time, i.e. ~140 AoE dps, which a
-- small group can both survive and burn down (each skull has ~1494 HP).
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 22432 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22432,0,0,1,60,0,100,513,500,500,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On Update - Set NPC Flags'),
(22432,0,1,2,61,0,100,512,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On Update - Set React Passive'),
(22432,0,2,3,61,0,100,512,0,0,0,0,0,0,11,39283,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On Update - Cast Spell'),
(22432,0,3,0,61,0,100,512,0,0,0,0,0,0,60,1,30,1,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On Update - Set Fly'),
(22432,0,4,0,38,0,100,512,1,1,0,0,0,0,80,2243200,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On Data Set - Script9'),
(22432,0,5,6,40,0,100,512,2,0,0,0,0,0,54,70000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On WP Reached - Pause WP'),
(22432,0,6,0,61,0,100,512,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On WP Reached - Set Phase'),
(22432,0,7,0,60,1,100,0,5000,10000,7000,12000,0,0,12,22507,2,35000,0,0,0,8,0,0,0,0,-710,2754.28,105.3,4.7,'Colonel Jules - On Update - Summon Darkness Released'),
(22432,0,8,9,64,0,100,512,0,0,0,0,0,0,33,22432,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Colonel Jules - On Gossip Hello - Kill Credit'),
(22432,0,9,0,61,0,100,512,0,0,0,0,0,0,80,2243201,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Colonel Jules - On Gossip Hello - Script9');
