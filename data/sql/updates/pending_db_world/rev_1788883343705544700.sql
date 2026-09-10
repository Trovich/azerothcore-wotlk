--
-- Quest 10935 "The Exorcism of Colonel Jules" - the flying skulls still put out more
-- damage than a small group can absorb, even after the summon timer was widened in
-- rev_1788747371173487200.sql (verified applied: Colonel Jules row 7 now reads
-- 5-10s / 7-12s / 35s).
--
-- Each skull (Darkness Released, 22507) fires 39320 "The Exorcism, Flying Skull attack"
-- - 238 shadow damage in a 12 yd radius - from *two* independent sources:
--
--   * its own aura 39303 "Flying Skull (DND)", SPELL_AURA_PERIODIC_TRIGGER_SPELL with a
--     12000 ms period, cast on itself by smart_scripts row 1; and
--   * smart_scripts row 4, an SMART_EVENT_UPDATE that casts the same 39320 directly
--     every 5-8 s.
--
-- Together that is one 238-damage AoE roughly every 4 s per skull. Row 1 also has to
-- stay: 22507's model is InvisibleStalker, so 39303 is what makes the skull visible at
-- all. Row 4 is the duplicate, and it roughly triples the encounter's damage - Anchorite
-- Barada has health regen deliberately switched off for the duration, which is why he
-- goes down first every time.
--
-- Row 4 removed, leaving the aura's 12 s cadence. Jules' summon timer is widened a
-- little further (7-12s -> 9-14s) and the skull lifetime trimmed (35s -> 30s), taking
-- the steady-state count from ~3.7 to ~2.6.
--
-- Note both rows are stock AzerothCore data, not a local edit - see the still-open
-- upstream report azerothcore/azerothcore-wotlk#638.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 22507 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22507,0,0,1,60,0,100,513,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkness Released - On Update - Set React State'),
(22507,0,1,2,61,0,100,512,0,0,0,0,0,0,11,39303,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkness Released - On Update - Cast Flying Skull (visual + 12s attack trigger)'),
(22507,0,2,3,61,0,100,512,0,0,0,0,0,0,60,1,40,1,0,0,0,1,0,0,0,0,0,0,0,0,'Darkness Released - On Update - Set Fly'),
(22507,0,3,0,61,0,100,512,0,0,0,0,0,0,53,1,22507,1,0,0,0,1,0,0,0,0,0,0,0,0,'Darkness Released - On Update - Start WP'),
(22507,0,4,0,6,0,100,0,0,0,0,0,0,0,11,39307,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkness Released - On Death - Cast Despawn');

UPDATE `smart_scripts` SET `event_param3` = 9000, `event_param4` = 14000, `action_param3` = 30000
WHERE `entryorguid` = 22432 AND `source_type` = 0 AND `id` = 7;
