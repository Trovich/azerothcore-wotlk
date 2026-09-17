--
-- Quest 10935 "The Exorcism of Colonel Jules", part 3: the skulls never go away, and
-- Anchorite Barada stops performing the rite a third of the way in.
--
-- 1. The summons never expire.
--
-- Colonel Jules summons Darkness Released (22507) with summon type 2 =
-- TEMPSUMMON_TIMED_OR_CORPSE_DESPAWN, and the Bubbling Slimer Bunny (22505) summons Foul
-- Purge (22506) the same way. TempSummon::Update only counts that timer down while the
-- summon is OUT of combat - in combat it resets the timer to the full lifetime every
-- tick (TemporarySummon.cpp:163-174). The skulls are faction 14 and put out an AoE every
-- 12 s, so they are permanently in combat and the 30 s lifetime never elapses. Every
-- skull spawned during the ~150 s ritual is still alive at the end of it, roughly a
-- dozen of them, each firing 39320 for 238 damage in a 12 yd radius. That is the "they
-- just keep appearing and appearing, impossible to kill them all" report - the earlier
-- passes at the spawn interval and at the duplicate damage row could only ever slow the
-- pile-up down, not stop it.
--
-- Switched to summon type 3 = TEMPSUMMON_TIMED_DESPAWN, which expires unconditionally.
-- With the 9-14 s interval from rev_1788883343705544700.sql and a real 30 s life that
-- settles at 2-3 skulls alive, which is what the encounter is balanced around.
--
-- A self-despawn row is added to 22507 as a backstop, so a skull cannot outlive the
-- ritual even if the cleanup rows never run (the same safety net 22505 already carries
-- from rev_1788798208317525600.sql).
--
-- 2. Barada stops mid-ritual.
--
-- His action list casts 39277 "Barada commands" at t+14s and 39278 "Barada falters" at
-- t+35s. Both are infinite-duration dummy auras whose only job is the spell visual
-- (8978 and 8979), and nothing ever takes 39278 back off or re-applies 39277 - so from
-- t+35s to the end of the list at t+188s Barada kneels there with the faltering visual
-- and no exorcism animation at all, for two and a half of the three minutes. That is
-- "Barada's animation broke, he just stopped while we were being beaten".
--
-- Rewritten so the two visuals alternate the way the encounter reads: he commands,
-- falters for 6 s at t+35s and again at t+128s (each falter now paired with his
-- "I... must not... falter" line, text group 3), resumes commanding after each, and only
-- drops into the falter visual for good at the finale. Every beat of the original
-- cadence is preserved, so the list still runs exactly 188 s and stays in step with
-- Colonel Jules' own list.
--
-- All casts in both lists also get SMARTCAST_TRIGGERED | SMARTCAST_INTERRUPT_PREVIOUS.
-- SmartScript::UpdateTimer delays a non-interrupting SMART_ACTION_CAST for as long as
-- the caster is busy casting, and in a timed action list only the current row is armed -
-- so a single stuck cast stalls the whole remainder, which for Jules would mean his
-- SMART_ACTION_SET_EVENT_PHASE never runs and the skull spawner never stops.
--

-- 1. summons that actually expire
UPDATE `smart_scripts` SET `action_param2` = 3
WHERE `entryorguid` = 22432 AND `source_type` = 0 AND `id` = 7;

UPDATE `smart_scripts` SET `action_param2` = 3
WHERE `entryorguid` = 22505 AND `source_type` = 0 AND `id` = 1;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 22507 AND `source_type` = 0 AND `id` = 5;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22507,0,5,0,60,0,100,513,45000,45000,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkness Released - On Update - Force Despawn Self (No Repeat) - safety net if the cleanup rows never run');

-- 2. Colonel Jules casts cannot stall his list
UPDATE `smart_scripts` SET `action_param2` = 3
WHERE `entryorguid` = 2243200 AND `source_type` = 9 AND `id` IN (7, 8, 18);

-- 3. Anchorite Barada keeps performing the rite
DELETE FROM `smart_scripts` WHERE `entryorguid` = 2243100 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(2243100,9,0,0,0,0,100,0,0,0,0,0,0,0,102,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Set Regen Health'),
(2243100,9,1,0,0,0,100,0,0,0,0,0,0,0,91,8,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove Byte 0'),
(2243100,9,2,0,0,0,100,0,0,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Set NPC Flags'),
(2243100,9,3,0,0,0,100,0,1000,1000,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,4,0,0,0,100,0,4000,4000,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,5,0,0,0,100,0,2000,2000,0,0,0,0,69,0,0,0,0,0,0,8,0,0,0,0,-707.68,2747.8,101.6,0,'Script9 - Move To Pos'),
(2243100,9,6,0,0,0,100,0,2000,2000,0,0,0,0,69,0,0,0,0,0,0,8,0,0,0,0,-710.87,2747.8,101.6,0,'Script9 - Move To Pos'),
(2243100,9,7,0,0,0,100,0,2000,2000,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,1.57,'Script9 - Set Orientation'),
(2243100,9,8,0,0,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Set Home Pos'),
(2243100,9,9,0,0,0,100,0,0,0,0,0,0,0,45,1,1,0,0,0,0,19,22432,50,0,0,0,0,0,0,'Script9 - Set Data'),
(2243100,9,10,0,0,0,100,0,1500,1500,0,0,0,0,90,8,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Set Byte 0'),
(2243100,9,11,0,0,0,100,0,1500,1500,0,0,0,0,11,39277,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Cast Barada Commands'),
(2243100,9,12,0,0,0,100,0,5000,5000,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,13,0,0,0,100,0,16000,16000,0,0,0,0,28,39277,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove Barada Commands'),
(2243100,9,14,0,0,0,100,0,0,0,0,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,15,0,0,0,100,0,0,0,0,0,0,0,11,39278,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Cast Barada Falters'),
(2243100,9,16,0,0,0,100,0,6000,6000,0,0,0,0,28,39278,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove Barada Falters'),
(2243100,9,17,0,0,0,100,0,0,0,0,0,0,0,11,39277,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Cast Barada Commands'),
(2243100,9,18,0,0,0,100,0,22000,22000,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,19,0,0,0,100,0,25000,25000,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,20,0,0,0,100,0,40000,40000,0,0,0,0,28,39277,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove Barada Commands'),
(2243100,9,21,0,0,0,100,0,0,0,0,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,22,0,0,0,100,0,0,0,0,0,0,0,11,39278,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Cast Barada Falters'),
(2243100,9,23,0,0,0,100,0,6000,6000,0,0,0,0,28,39278,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove Barada Falters'),
(2243100,9,24,0,0,0,100,0,0,0,0,0,0,0,11,39277,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Cast Barada Commands'),
(2243100,9,25,0,0,0,100,0,12000,12000,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,26,0,0,0,100,0,18000,18000,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,27,0,0,0,100,0,15000,15000,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,28,0,0,0,100,0,9000,9000,0,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Talk'),
(2243100,9,29,0,0,0,100,0,0,0,0,0,0,0,28,39277,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove Barada Commands'),
(2243100,9,30,0,0,0,100,0,0,0,0,0,0,0,11,39278,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Cast Barada Falters'),
(2243100,9,31,0,0,0,100,0,0,0,0,0,0,0,41,0,0,0,0,0,0,11,22505,50,0,0,0,0,0,0,'Script9 - Despawn Target'),
(2243100,9,32,0,0,0,100,0,0,0,0,0,0,0,41,0,0,0,0,0,0,11,22506,50,0,0,0,0,0,0,'Script9 - Despawn Target'),
(2243100,9,33,0,0,0,100,0,0,0,0,0,0,0,41,0,0,0,0,0,0,11,22507,50,0,0,0,0,0,0,'Script9 - Despawn Target'),
(2243100,9,34,0,0,0,100,0,0,0,0,0,0,0,91,8,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove Byte 0'),
(2243100,9,35,0,0,0,100,0,0,0,0,0,0,0,28,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Remove All Auras'),
(2243100,9,36,0,0,0,100,0,6000,6000,0,0,0,0,69,0,0,0,0,0,0,8,0,0,0,0,-707.68,2747.8,101.6,0,'Script9 - Move To Pos'),
(2243100,9,37,0,0,0,100,0,2000,2000,0,0,0,0,69,0,0,0,0,0,0,8,0,0,0,0,-707.211,2754.11,101.675,0,'Script9 - Move To Pos'),
(2243100,9,38,0,0,0,100,0,4000,4000,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,2.74,'Script9 - Set Orientation'),
(2243100,9,39,0,0,0,100,0,2000,2000,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Set Home Pos'),
(2243100,9,40,0,0,0,100,0,1000,1000,0,0,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Evade'),
(2243100,9,41,0,0,0,100,0,0,0,0,0,0,0,102,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Script9 - Set Regen Health');
