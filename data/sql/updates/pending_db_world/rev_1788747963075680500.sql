--
-- Quest 9718 "As the Crow Flies" - the crow form wears off before the flight
-- ends (azerothcore/azerothcore-wotlk#14546, "Event lasts longer than the
-- transformation"; expected: "Crow transformation ends when arriving back at
-- the Cenarion Refuge").
--
-- How the quest is wired:
--
--   quest 9718 gives item 25465 "Stormcrow Amulet"
--     -> spell 31606 "Stormcrow Amulet"
--          effect 0 = SPELL_EFFECT_SEND_TAXI, misc value 512
--          (taxi path 512: 25 nodes, 4640.6 yd, a loop that starts and ends
--           4 yd from Ysiel Windsinger; at PLAYER_FLIGHT_SPEED 32 yd/s that is
--           145 seconds of flight)
--     -> spell_linked_spell (SPELL_LINK_HIT) applies the crow form
--     -> when the crow form drops, spell_q9718_crow_transform completes the quest
--
-- The link pointed at spell 38776 "Evergrove Druid Transform Crow" - a Blade's
-- Edge NPC spell that SpellInfoCorrections.cpp deliberately clamps to
-- 120 seconds for its own use. 120 < 145, so the player turned back into
-- themselves ~25 seconds before landing and the quest completed mid-air.
--
-- AzerothCore already ships the right spell for this quest and never used it:
-- server-side spell 31746 "Stormcrow Shape" (spell_dbc) - SPELL_AURA_TRANSFORM
-- into creature 17970 "Stormcrow Shape", duration index 554 = 155 seconds, i.e.
-- sized to cover the 145 s flight with 10 s to spare. Ysiel Windsinger's SmartAI
-- already has "On OOC LOS within 30 yd -> Remove Aura 31746", which ends the
-- transformation the moment the player lands next to her. Nothing in the whole
-- database or core ever applied 31746, so that cleanup row was dead.
--
-- Both rows are repointed at 31746. The removal cannot misfire at take-off:
-- GridNotifiers.cpp CreatureUnitRelocationWorker() returns early for units with
-- IsInFlight(), so Ysiel gets no MoveInLineOfSight callbacks while the player is
-- on the taxi, and Spell::DoAllEffectOnTarget() casts the SPELL_LINK_HIT spell
-- after the taxi effect has already been handled.
--
-- Still open from that upstream report and not addressed here: the crow uses the
-- hover animation for the whole flight, and Ysiel has no whispers during it.
--

DELETE FROM `spell_linked_spell` WHERE `spell_trigger` = 31606 AND `spell_effect` = 38776;
DELETE FROM `spell_linked_spell` WHERE `spell_trigger` = 31606 AND `spell_effect` = 31746;
INSERT INTO `spell_linked_spell` (`spell_trigger`, `spell_effect`, `type`, `comment`) VALUES
(31606, 31746, 1, 'As the Crow Flies quest - Stormcrow Amulet applies Stormcrow Shape');

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_q9718_crow_transform';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(31746, 'spell_q9718_crow_transform');
