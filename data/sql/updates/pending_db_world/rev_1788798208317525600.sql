--
-- Quest 10935 "The Exorcism of Colonel Jules" - dozens of adds pile up, all
-- attacking at once, and the quest exorcist (Anchorite Barada) always dies
-- first. Worse than before rev_1788747371173487200.sql, which only touched
-- Colonel Jules' (22432) own Darkness Released timer and was confirmed live
-- (smart_scripts row 7 has the new 5-10s/7-12s/35s values).
--
-- The actual multiplier is a second, *separate* summoner: The Exorcism
-- Bubbling Slimer Bunny (22505, a positional "(DND)" helper), which spawns
-- Foul Purge (22506) on its own 5-30s repeat with no phase gate, no combat
-- check, and no bounded lifetime of its own. It is despawned by Jules' own
-- success-path script (Script9 2243200, rows 22-24 - already correct), but
-- that path is a scripted sequence keyed to Barada staying alive to finish
-- her lines. Every attempt where Barada dies first (which, per the report,
-- is every attempt) leaves that bunny running forever: it has no despawn
-- timer of its own and nothing else ever removes it. 22505 has no
-- `creature` table spawn (it's summoned by a spell effect, not SmartAI), so
-- there's no way to query how many are currently stacked up on the live
-- server - only a worldserver restart clears temporary summons, which the
-- pending timer/root fixes already need anyway.
--
-- Fix: give the bunny a bounded lifetime of its own, independent of whether
-- the encounter succeeds, fails, or is abandoned. 55s comfortably covers a
-- full attempt (Jules' own phase 1 runs ~150s, but 22505 is summoned near
-- the start of an attempt) while capping worst-case Foul Purge output to
-- ~3 per bunny even if this exact failure mode recurs. This is on top of,
-- not instead of, the existing explicit despawn on success.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 22505 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22505,0,0,0,60,0,100,1,0,0,0,0,0,0,11,39300,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bubbling Slimer Bunny - On Update - Cast Spell'),
(22505,0,1,0,60,0,100,0,5000,10000,15000,30000,0,0,12,22506,2,30000,0,0,0,1,0,0,0,0,0,0,0,0,'Bubbling Slimer Bunny - On Update - Summon Foul Purge'),
(22505,0,2,0,60,0,100,1,55000,55000,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bubbling Slimer Bunny - On Update - Force Despawn Self (No Repeat) - safety net if the success-path despawn never runs');
