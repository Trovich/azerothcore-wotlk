--
-- Quest 5721 "The Battle of Darrowshire" - complete the event (issue #19155).
--
-- The event used to stop right after Horgus the Ravager died: Captain Redpath
-- never spawned, so stages 2 and 3 never ran. Three separate defects:
--
--   1. Davil Lightfire drives the event from timed action lists, but all three
--      SMART_ACTION_CALL_TIMED_ACTIONLIST rows had allowOverride = 0
--      (action_param3). SmartScript::SetScript9() silently returns when a
--      previous list is still running, and Horgus was summoned ~20 s before the
--      stage 1 list ended - so any group that killed him promptly lost the
--      SetData(1,2) hand-off and the event stalled forever.
--   2. Horgus' "On Death - Set Data" targeted Davil with SMART_TARGET_CLOSEST_
--      CREATURE at 50 yd. Davil roams while fighting, so even the hand-off that
--      did get through was unreliable.
--   3. Stage 2/3 were never written: Captain Redpath had no wave script, Marduk
--      the Black (10939) was not used at all, and the Darrowshire Defender rows
--      that were meant to despawn the leftovers were unreachable dead code
--      (event_type 61 rows with nothing linking to them). The defender also
--      announced text 2 "Captain Redpath is slain!" when Horgus died.
--
-- The event is now a three-stage chain, each stage owned by the NPC whose
-- survival the quest log asks the player to guarantee:
--
--   Stage 1  Davil Lightfire (10944)      - skeletons/corpses, then Silver Hand
--                                           relief, then Horgus' ghouls, then
--                                           Horgus at ~3:20 (retail: ~3:30).
--            Horgus dies -> Davil cries out, summons Captain Redpath, dies.
--   Stage 2  Captain Redpath (10937)      - runs from the town square into the
--                                           battle, ~2:55 of waves led by the
--                                           Bloodletters that hunt him, then
--                                           Marduk the Black appears, kills him
--                                           and Redpath the Corrupted rises.
--   Stage 3  Redpath the Corrupted (10938)- waves stop, the Darrowshire
--                                           Betrayers turn on the defenders; his
--                                           death summons Joseph Redpath's
--                                           spirit in the town square.
--
-- Vanilla ran stage 2 for roughly half an hour; it is compressed to ~2:55 here.
-- Total event length is ~7.5 minutes plus the two boss fights.
--
-- Davil Lightfire spawns at half his original distance from the line the ordinary
-- Defenders and Militia form (centroid 1495.81, -3675.28): 19.7 -> 9.9 yd, Z read
-- off the terrain in data/maps (0002938.map). Captain Redpath keeps his blizzlike
-- entrance at the town square but now takes up position on that centroid itself,
-- with a second move order 13 s later in case the 59 yd run stalls. The Scourge
-- side is left where it was, up the hill, so it still charges down on the village
-- and the militia. All four named fighters get an out-of-combat re-engage; the
-- single scripted ATTACK_START only fires once, so after their first kill they
-- used to evade back to their spot and stand there for the rest of the battle.
-- The one Scourge position that did move is Redpath the Corrupted: he now rises
-- where Captain Redpath falls, because Marduk kills him on the spot.
--
-- Handing the quest in to Pamela plays the reunion: Joseph's spirit materialises
-- in front of her house, they speak the seven lines that were already in
-- creature_text but wired to nothing, and both fade away.
--
-- Carlin Redpath gets the "I need another Relic Bundle!" gossip so a failed run
-- of the battle no longer forces the player to abandon and re-take the quest.
--
-- Fixed after the first in-game run:
--   * Davil used to evade back to his spawn the moment Horgus died and play his
--     death scene there. Horgus now re-anchors his home position as he dies and
--     the hand-off script stops his motion first, so he falls where he fought.
--   * The Silver Hand Disciples were healing Bloodletters, Horgus and players.
--     Faction template 42 has hostileMask 0 and no enemy factions, so the
--     IsHostileTo() test that SMART_EVENT_FRIENDLY_HEALTH targets with is false
--     for everything alive. Swapped to SMART_EVENT_FRIENDLY_HEALTH_PCT with a
--     SMART_TARGET_CREATURE_RANGE target, which runs a real IsFriendlyTo() test
--     (false for factions 14 and 974) and never looks at players at all.
--   * Redpath kept his out-of-combat re-engage through the corruption and ran
--     off seconds after Marduk arrived, so he died far away from him. He is now
--     phased out of the re-engage, stopped and rooted before Marduk is summoned
--     two yards away; Marduk turns to him and strikes, and body and risen
--     spirit land a tenth of a second apart.
--
-- Texts are the sniffed Darrowshire lines that were already in the world DB but
-- unreferenced (45680/45681/45682/7366/7396 and Marduk's 7471). The only
-- judgement call without sniff backing is the UNIT_FLAG set on Marduk the Black:
-- he is a cinematic NPC that appears for six seconds, and players would
-- otherwise be able to pull and kill him mid-scene.
--

-- Announcer / narrator lines that had no creature_text row yet.
DELETE FROM `creature_text` WHERE `CreatureID` = 10944 AND `GroupID` IN (4, 5, 6);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(10944, 4, 0, 'Help Joseph Carlin\'s troops defend Darrowshire!', 41, 0, 100, 0, 0, 0, 45680, 0, 'Davil Lightfire - battle begins'),
(10944, 5, 0, 'Protect Davil Lightfire!', 41, 0, 100, 0, 0, 0, 45681, 0, 'Davil Lightfire - joins the line'),
(10944, 6, 0, 'Davil Lightfire is defeated!  Darrowshire is lost!', 41, 0, 100, 0, 0, 0, 7366, 0, 'Davil Lightfire - event failed');

DELETE FROM `creature_text` WHERE `CreatureID` = 10946 AND `GroupID` = 1;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(10946, 1, 0, 'Horgus the Ravager has appeared!  Kill him quickly!', 41, 0, 100, 0, 0, 0, 45682, 0, 'Horgus the Ravager - arrival');

DELETE FROM `creature_text` WHERE `CreatureID` = 10936 AND `GroupID` IN (3, 4, 5);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(10936, 3, 0, 'The Nightmare is finally over!  Darrowshire, forgive me!', 12, 0, 100, 0, 0, 0, 7396, 0, 'Joseph Redpath - spirit freed'),
(10936, 4, 0, 'Speak with Joseph Redpath in the center of Darrowshire.', 41, 0, 100, 0, 0, 0, 45685, 0, 'Joseph Redpath - points the player at the town square'),
(10936, 5, 0, 'Hahah!', 12, 0, 100, 0, 0, 0, 7398, 0, 'Joseph Redpath - reunion with Pamela');

-- Marduk the Black only ever had a text line; he needs an AI to use it.
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 10939;

-- Relic Bundle (the GO the quest item drops) - starts the event.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 177526 AND `source_type` = 1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(177526,1,0,0,60,0,100,1,2000,2000,0,0,0,0,12,10944,4,600000,0,0,0,8,0,0,0,0,1488.15,-3681.49,80.09,0.5,'Relic Bundle - On Update - Summon Davil Lightfire');

-- Davil Lightfire - stage 1 controller.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10944 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10944,0,0,0,37,0,100,512,0,0,0,0,0,0,80,1094400,2,1,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - On AI Init - Run Script (stage 1)'),
(10944,0,1,0,4,0,100,1,0,0,0,0,0,0,11,17232,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - On Aggro - Cast Devotion Aura'),
(10944,0,2,0,4,0,100,1,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - On Aggro - Set Home Pos'),
(10944,0,3,0,0,0,100,0,5000,7000,8000,10000,0,0,11,17284,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Davil Lightfire - In Combat - Cast Holy Strike'),
(10944,0,4,0,0,0,100,0,8000,11000,15000,20000,0,0,11,13005,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Davil Lightfire - In Combat - Cast Hammer of Justice'),
(10944,0,5,0,38,0,100,512,1,2,0,0,0,0,80,1094401,2,1,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - On Data Set 1 2 - Run Script (Horgus slain)'),
(10944,0,6,0,6,1,100,512,0,0,0,0,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - On Death (Phase 1) - Announce Defeat'),
(10944,0,7,0,1,0,100,256,82000,82000,4000,6000,0,0,49,0,0,0,0,0,0,25,40,0,0,0,0,0,0,0,'Davil Lightfire - Out of Combat - Re-engage Nearest Enemy');

-- Davil Lightfire - stage 1 wave script. Horgus arrives at ~3:20.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 1094400 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(1094400,9,0,0,0,0,0,100,0,1000,1000,0,0,0,0,211,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Keep Event Phase Across Resets'),
(1094400,9,1,0,0,0,0,100,0,500,500,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Set Event Phase 1'),
(1094400,9,2,0,0,0,0,100,0,500,500,0,0,0,0,8,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Set React State Defensive'),
(1094400,9,3,0,0,0,0,100,0,500,500,0,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Announce Battle'),
(1094400,9,4,0,0,0,0,100,0,3000,3000,0,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Say Line 0'),
(1094400,9,5,0,0,0,0,100,0,2000,2000,0,0,0,0,12,10948,4,300000,0,0,0,8,0,0,0,0,1447,-3697,76.8,0.5,'Davil Lightfire - Stage 1 - Summon Darrowshire Defender'),
(1094400,9,6,0,0,0,0,100,0,500,500,0,0,0,0,12,10948,4,300000,0,0,0,8,0,0,0,0,1490,-3667,81.27,0.4,'Davil Lightfire - Stage 1 - Summon Darrowshire Defender'),
(1094400,9,7,0,0,0,0,100,0,1000,1000,0,0,0,0,12,10950,4,300000,0,0,0,8,0,0,0,0,1499,-3686,81.2,0.1,'Davil Lightfire - Stage 1 - Summon Redpath Militia'),
(1094400,9,8,0,0,0,0,100,0,2000,2000,0,0,0,0,45,1,1,0,0,0,0,19,10948,100,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Set Data 1 1 (Defender calls to arms)'),
(1094400,9,9,0,0,0,0,100,0,8000,8000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,10,0,0,0,0,100,0,4000,4000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,11,0,0,0,0,100,0,4000,4000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,12,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,13,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,14,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,15,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,16,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,17,0,0,0,0,100,0,11000,11000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,18,0,0,0,0,100,0,4000,4000,0,0,0,0,12,10949,4,300000,0,0,0,8,0,0,0,0,1490,-3667,81.27,0.4,'Davil Lightfire - Stage 1 - Summon Silver Hand Disciple'),
(1094400,9,19,0,0,0,0,100,0,1000,1000,0,0,0,0,12,10949,4,300000,0,0,0,8,0,0,0,0,1495,-3669,81.44,0.4,'Davil Lightfire - Stage 1 - Summon Silver Hand Disciple'),
(1094400,9,20,0,0,0,0,100,0,2000,2000,0,0,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Announce Davil Joins The Line'),
(1094400,9,21,0,0,0,0,100,0,1000,1000,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Set React State Aggressive'),
(1094400,9,22,0,0,0,0,100,0,500,500,0,0,0,0,49,0,0,0,0,0,0,19,10952,40,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Attack Start'),
(1094400,9,23,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,24,0,0,0,0,100,0,4000,4000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,25,0,0,0,0,100,0,4000,4000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,26,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,27,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,28,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,29,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,30,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,31,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,32,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,33,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,34,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,35,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10948,4,300000,0,0,0,8,0,0,0,0,1499,-3686,81.2,0.1,'Davil Lightfire - Stage 1 - Summon Darrowshire Defender'),
(1094400,9,36,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,37,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,38,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,39,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,40,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10950,4,300000,0,0,0,8,0,0,0,0,1504,-3691,81.8,0.4,'Davil Lightfire - Stage 1 - Summon Redpath Militia'),
(1094400,9,41,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,42,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,43,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Davil Lightfire - Stage 1 - Summon Servant of Horgus'),
(1094400,9,44,0,0,0,0,100,0,4000,4000,0,0,0,0,1,1,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 - Say Line 1'),
(1094400,9,45,0,0,0,0,100,0,1500,1500,0,0,0,0,12,10946,4,600000,0,0,0,8,0,0,0,0,1507,-3663,84.36,3.9,'Davil Lightfire - Stage 1 - Summon Horgus the Ravager'),
(1094400,9,46,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,47,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Davil Lightfire - Stage 1 - Summon Marauding Corpse'),
(1094400,9,48,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10948,4,300000,0,0,0,8,0,0,0,0,1495,-3669,81.44,0.4,'Davil Lightfire - Stage 1 - Summon Darrowshire Defender'),
(1094400,9,49,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Davil Lightfire - Stage 1 - Summon Marauding Skeleton'),
(1094400,9,50,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10953,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Davil Lightfire - Stage 1 - Summon Servant of Horgus');

-- Davil Lightfire - Horgus is dead: hand the battle over to Captain Redpath.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 1094401 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(1094401,9,0,0,0,0,100,0,0,0,0,0,0,0,212,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 End - Stop Motion'),
(1094401,9,1,0,0,0,100,0,200,200,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 End - Set Home Pos'),
(1094401,9,2,0,0,0,100,0,300,300,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 End - Set Event Phase 2'),
(1094401,9,3,0,0,0,100,0,500,500,0,0,0,0,12,10937,4,900000,0,0,0,8,0,0,0,0,1443.25,-3702.94,77.38,0.5,'Davil Lightfire - Stage 1 End - Summon Captain Redpath'),
(1094401,9,4,0,0,0,100,0,1000,1000,0,0,0,0,1,2,5000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 End - Say Line 2'),
(1094401,9,5,0,0,0,100,0,6000,6000,0,0,0,0,1,3,3000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 End - Announce Davil Falls'),
(1094401,9,6,0,0,0,100,0,3000,3000,0,0,0,0,37,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Davil Lightfire - Stage 1 End - Die');

-- Horgus the Ravager - stage 1 boss.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10946 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10946,0,0,1,60,0,100,1,500,500,0,0,0,0,11,18951,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Horgus the Ravager - On Update - Cast Spirit Particles'),
(10946,0,1,2,61,0,100,512,0,0,0,0,0,0,11,17467,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Horgus the Ravager - On Update - Cast Unholy Aura'),
(10946,0,2,3,61,0,100,512,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Horgus the Ravager - On Update - Announce Arrival'),
(10946,0,3,4,61,0,100,512,0,0,0,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Horgus the Ravager - On Update - Say Line 0'),
(10946,0,4,0,61,0,100,512,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10944,60,0,0,0,0,0,0,'Horgus the Ravager - On Update - Attack Davil Lightfire'),
(10946,0,5,0,4,0,100,1,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Horgus the Ravager - On Aggro - Set Home Pos'),
(10946,0,6,0,0,0,100,0,8000,11000,9000,12000,0,0,11,15608,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Horgus the Ravager - In Combat - Cast Ravenous Claw'),
(10946,0,7,8,6,0,100,512,0,0,0,0,0,0,45,1,2,0,0,0,0,19,10948,150,0,0,0,0,0,0,'Horgus the Ravager - On Death - Set Data 1 2 (Defender announces)'),
(10946,0,8,9,61,0,100,512,0,0,0,0,0,0,45,1,2,0,0,0,0,19,10944,150,0,0,0,0,0,0,'Horgus the Ravager - On Death - Set Data 1 2 (Davil Lightfire)'),
(10946,0,9,0,61,0,100,512,0,0,0,0,0,0,101,0,0,0,0,0,0,19,10944,150,0,0,0,0,0,0,'Horgus the Ravager - On Death - Set Davil Lightfire Home Pos'),
(10946,0,10,0,1,0,100,256,6000,6000,4000,6000,0,0,49,0,0,0,0,0,0,25,60,0,0,0,0,0,0,0,'Horgus the Ravager - Out of Combat - Re-engage Nearest Enemy');

-- Captain Redpath - stage 2 controller.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10937 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10937,0,0,0,37,0,100,512,0,0,0,0,0,0,80,1093700,2,1,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - On AI Init - Run Script (stage 2)'),
(10937,0,1,0,0,0,100,0,5000,7000,8000,10000,0,0,11,15284,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Captain Redpath - In Combat - Cast Cleave'),
(10937,0,2,0,0,0,100,0,8000,10000,14000,18000,0,0,11,6253,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Captain Redpath - In Combat - Cast Backhand'),
(10937,0,3,0,0,0,100,0,3000,5000,15000,20000,0,0,11,9128,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - In Combat - Cast Battle Shout'),
(10937,0,4,0,4,0,100,1,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - On Aggro - Set Home Pos'),
(10937,0,5,0,6,1,100,512,0,0,0,0,0,0,45,1,3,0,0,0,0,19,10948,150,0,0,0,0,0,0,'Captain Redpath - On Death (Phase 1) - Set Data 1 3 (event failed)'),
(10937,0,6,0,1,1,100,256,30000,30000,4000,6000,0,0,49,0,0,0,0,0,0,25,80,0,0,0,0,0,0,0,'Captain Redpath - Out of Combat - Re-engage Nearest Enemy');

-- Captain Redpath - stage 2 wave script, ends with Marduk the Black.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 1093700 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(1093700,9,0,0,0,0,0,100,0,500,500,0,0,0,0,211,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Keep Event Phase Across Resets'),
(1093700,9,1,0,0,0,0,100,0,500,500,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Set Event Phase 1'),
(1093700,9,2,0,0,0,0,100,0,500,500,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Set React State Passive'),
(1093700,9,3,0,0,0,0,100,0,500,500,0,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Set Run On'),
(1093700,9,4,0,0,0,0,100,0,500,500,0,0,0,0,11,41232,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Cast Teleport Visual'),
(1093700,9,5,0,0,0,0,100,0,6000,6000,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Announce Arrival'),
(1093700,9,6,0,0,0,0,100,0,1500,1500,0,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Say Line 0'),
(1093700,9,7,0,0,0,0,100,0,1500,1500,0,0,0,0,69,0,0,0,0,0,0,8,0,0,0,0,1495.81,-3675.28,81.03,0.6,'Captain Redpath - Stage 2 - Move To Battle Line'),
(1093700,9,8,0,0,0,0,100,0,13000,13000,0,0,0,0,69,0,0,0,0,0,0,8,0,0,0,0,1495.81,-3675.28,81.03,0.6,'Captain Redpath - Stage 2 - Move To Battle Line (retry)'),
(1093700,9,9,0,0,0,0,100,0,3000,3000,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Set React State Aggressive'),
(1093700,9,10,0,0,0,0,100,0,500,500,0,0,0,0,49,0,0,0,0,0,0,19,10952,60,0,0,0,0,0,0,'Captain Redpath - Stage 2 - Attack Start'),
(1093700,9,11,0,0,0,0,100,0,4000,4000,0,0,0,0,12,10948,4,300000,0,0,0,8,0,0,0,0,1490,-3667,81.27,0.4,'Captain Redpath - Stage 2 - Summon Darrowshire Defender'),
(1093700,9,12,0,0,0,0,100,0,6000,6000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,13,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Captain Redpath - Stage 2 - Summon Marauding Corpse'),
(1093700,9,14,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10954,4,300000,0,0,0,8,0,0,0,0,1536.5,-3684,88.1,2.9,'Captain Redpath - Stage 2 - Summon Bloodletter'),
(1093700,9,15,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,16,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10954,4,300000,0,0,0,8,0,0,0,0,1537,-3680,88.4,2.9,'Captain Redpath - Stage 2 - Summon Bloodletter'),
(1093700,9,17,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Captain Redpath - Stage 2 - Summon Marauding Corpse'),
(1093700,9,18,0,0,0,0,100,0,10000,10000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,19,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10954,4,300000,0,0,0,8,0,0,0,0,1536.5,-3684,88.1,2.9,'Captain Redpath - Stage 2 - Summon Bloodletter'),
(1093700,9,20,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Captain Redpath - Stage 2 - Summon Marauding Corpse'),
(1093700,9,21,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,22,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10949,4,300000,0,0,0,8,0,0,0,0,1495,-3669,81.44,0.4,'Captain Redpath - Stage 2 - Summon Silver Hand Disciple'),
(1093700,9,23,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10954,4,300000,0,0,0,8,0,0,0,0,1537,-3680,88.4,2.9,'Captain Redpath - Stage 2 - Summon Bloodletter'),
(1093700,9,24,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,25,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Captain Redpath - Stage 2 - Summon Marauding Corpse'),
(1093700,9,26,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10954,4,300000,0,0,0,8,0,0,0,0,1536.5,-3684,88.1,2.9,'Captain Redpath - Stage 2 - Summon Bloodletter'),
(1093700,9,27,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10948,4,300000,0,0,0,8,0,0,0,0,1499,-3686,81.2,0.1,'Captain Redpath - Stage 2 - Summon Darrowshire Defender'),
(1093700,9,28,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,29,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1520.7,-3680.1,83.88,2.6,'Captain Redpath - Stage 2 - Summon Marauding Corpse'),
(1093700,9,30,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10954,4,300000,0,0,0,8,0,0,0,0,1537,-3680,88.4,2.9,'Captain Redpath - Stage 2 - Summon Bloodletter'),
(1093700,9,31,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1514,-3686,84.64,3.2,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,32,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10950,4,300000,0,0,0,8,0,0,0,0,1504,-3691,81.8,0.4,'Captain Redpath - Stage 2 - Summon Redpath Militia'),
(1093700,9,33,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1510,-3661,85.7,3.4,'Captain Redpath - Stage 2 - Summon Marauding Corpse'),
(1093700,9,34,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10954,4,300000,0,0,0,8,0,0,0,0,1536.5,-3684,88.1,2.9,'Captain Redpath - Stage 2 - Summon Bloodletter'),
(1093700,9,35,0,0,0,0,100,0,5000,5000,0,0,0,0,12,10952,4,300000,0,0,0,8,0,0,0,0,1515,-3663,86.42,3.6,'Captain Redpath - Stage 2 - Summon Marauding Skeleton'),
(1093700,9,36,0,0,0,0,100,0,8000,8000,0,0,0,0,12,10951,4,300000,0,0,0,8,0,0,0,0,1513,-3686,84.22,2.9,'Captain Redpath - Stage 2 - Summon Marauding Corpse'),
(1093700,9,37,0,0,0,0,100,0,8000,8000,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Corruption - Set Event Phase 2'),
(1093700,9,38,0,0,0,0,100,0,200,200,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Corruption - Set React State Passive'),
(1093700,9,39,0,0,0,0,100,0,200,200,0,0,0,0,224,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Corruption - Attack Stop'),
(1093700,9,40,0,0,0,0,100,0,200,200,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Corruption - Set Home Pos'),
(1093700,9,41,0,0,0,0,100,0,200,200,0,0,0,0,103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Corruption - Set Root'),
(1093700,9,42,0,0,0,0,100,0,700,700,0,0,0,0,12,10939,4,60000,0,0,0,1,0,0,0,0,2,2,0,0,'Captain Redpath - Corruption - Summon Marduk the Black'),
(1093700,9,43,0,0,0,0,100,0,7000,7000,0,0,0,0,45,1,3,0,0,0,0,19,10948,150,0,0,0,0,0,0,'Captain Redpath - Corruption - Set Data 1 3 (Defender announces)'),
(1093700,9,44,0,0,0,0,100,0,200,200,0,0,0,0,12,10947,4,300000,0,0,0,8,0,0,0,0,1490,-3667,81.27,0.4,'Captain Redpath - Corruption - Summon Darrowshire Betrayer'),
(1093700,9,45,0,0,0,0,100,0,100,100,0,0,0,0,12,10947,4,300000,0,0,0,8,0,0,0,0,1495,-3669,81.44,0.4,'Captain Redpath - Corruption - Summon Darrowshire Betrayer'),
(1093700,9,46,0,0,0,0,100,0,100,100,0,0,0,0,12,10947,4,300000,0,0,0,8,0,0,0,0,1499,-3686,81.2,0.1,'Captain Redpath - Corruption - Summon Darrowshire Betrayer'),
(1093700,9,47,0,0,0,0,100,0,300,300,0,0,0,0,12,10938,4,900000,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Corruption - Summon Redpath the Corrupted'),
(1093700,9,48,0,0,0,0,100,0,100,100,0,0,0,0,37,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Redpath - Corruption - Die');

-- Marduk the Black - cinematic appearance that ends Captain Redpath.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10939 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10939,0,0,1,60,0,100,1,500,500,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marduk the Black - On Update - Set React State Passive'),
(10939,0,1,2,61,0,100,512,0,0,0,0,0,0,18,770,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marduk the Black - On Update - Set Unit Flags'),
(10939,0,2,3,61,0,100,512,0,0,0,0,0,0,11,41232,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marduk the Black - On Update - Cast Teleport Visual'),
(10939,0,3,4,61,0,100,512,0,0,0,0,0,0,11,18951,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marduk the Black - On Update - Cast Spirit Particles'),
(10939,0,4,5,61,0,100,512,0,0,0,0,0,0,66,1,0,0,0,0,0,19,10937,25,0,0,0,0,0,0,'Marduk the Black - On Update - Face Captain Redpath'),
(10939,0,5,0,61,0,100,512,0,0,0,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marduk the Black - On Update - Say Line 0'),
(10939,0,6,7,60,0,100,1,6500,6500,0,0,0,0,66,1,0,0,0,0,0,19,10937,25,0,0,0,0,0,0,'Marduk the Black - On Update - Face Captain Redpath'),
(10939,0,7,0,61,0,100,512,0,0,0,0,0,0,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marduk the Black - On Update - Strike Captain Redpath'),
(10939,0,8,0,60,0,100,1,14000,14000,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marduk the Black - On Update - Despawn');

-- Redpath the Corrupted - stage 3 boss; his death ends the battle.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10938 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10938,0,0,0,0,0,100,0,3000,5000,5000,7000,0,0,11,15580,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Redpath the Corrupted - In Combat - Cast Strike'),
(10938,0,1,0,0,0,100,0,8000,10000,14000,18000,0,0,11,6253,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Redpath the Corrupted - In Combat - Cast Backhand'),
(10938,0,2,0,0,0,100,0,3000,5000,15000,20000,0,0,11,16244,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath the Corrupted - In Combat - Cast Demoralizing Shout'),
(10938,0,3,0,0,0,100,0,5000,7000,9000,14000,0,0,11,12542,1,0,0,0,0,6,0,0,0,0,0,0,0,0,'Redpath the Corrupted - In Combat - Cast Fear'),
(10938,0,4,5,60,0,100,1,500,500,0,0,0,0,11,41232,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath the Corrupted - On Update - Cast Teleport Visual'),
(10938,0,5,6,61,0,100,512,0,0,0,0,0,0,11,18951,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath the Corrupted - On Update - Cast Spirit Particles'),
(10938,0,6,7,61,0,100,512,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath the Corrupted - On Update - Announce Corruption'),
(10938,0,7,0,61,0,100,512,0,0,0,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath the Corrupted - On Update - Say Line 0'),
(10938,0,8,0,60,0,100,1,5000,5000,0,0,0,0,49,0,0,0,0,0,0,21,50,0,0,0,0,0,0,0,'Redpath the Corrupted - On Update - Attack Closest Player'),
(10938,0,9,0,4,0,100,1,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath the Corrupted - On Aggro - Set Home Pos'),
(10938,0,10,11,6,0,100,512,0,0,0,0,0,0,45,1,4,0,0,0,0,19,10948,150,0,0,0,0,0,0,'Redpath the Corrupted - On Death - Set Data 1 4 (Defender announces)'),
(10938,0,11,12,61,0,100,512,0,0,0,0,0,0,12,10936,4,300000,0,0,0,8,0,0,0,0,1443.25,-3702.94,77.38,0.5,'Redpath the Corrupted - On Death - Summon Joseph Redpath'),
(10938,0,12,13,61,0,100,512,0,0,0,0,0,0,45,1,1,0,0,0,0,19,10936,150,0,0,0,0,0,0,'Redpath the Corrupted - On Death - Set Data 1 1 (Joseph at the town square)'),
(10938,0,13,0,61,0,100,512,0,0,0,0,0,0,12,10945,4,300000,0,0,0,8,0,0,0,0,1459,-3678,77.9,5.9,'Redpath the Corrupted - On Death - Summon Davil Crokford'),
(10938,0,14,0,1,0,100,256,8000,8000,4000,6000,0,0,49,0,0,0,0,0,0,25,60,0,0,0,0,0,0,0,'Redpath the Corrupted - Out of Combat - Re-engage Nearest Enemy');

-- Joseph Redpath - the freed spirit. The same entry plays two scenes, so the
-- town-square appearance is keyed off data 1 1 (set by Redpath the Corrupted)
-- and the reunion at Pamela's house off data 1 2 (set by Pamela). Without a
-- key he just stands there quietly, which is what the reunion needs - his
-- lines there are spoken through him from Pamela's script.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10936 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10936,0,0,1,38,0,100,512,1,1,0,0,0,0,11,17321,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Data Set 1 1 - Cast Spirit Spawn-In'),
(10936,0,1,2,61,0,100,512,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Data Set 1 1 - Set Event Phase 1'),
(10936,0,2,0,61,0,100,512,0,0,0,0,0,0,1,3,6000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Data Set 1 1 - Say Line 3'),
(10936,0,3,0,60,1,100,1,10000,10000,0,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Update (Phase 1) - Announce Speak With Joseph Redpath'),
(10936,0,4,0,38,0,100,512,1,2,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Data Set 1 2 - Remove Gossip Flag'),
(10936,0,5,0,38,0,100,512,1,3,0,0,0,0,41,2000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Data Set 1 3 - Despawn'),
(10936,0,6,7,64,0,100,512,0,0,0,0,0,0,33,10936,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Joseph Redpath - On Gossip Hello - Kill Credit'),
(10936,0,7,8,61,0,100,512,0,0,0,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Gossip Hello - Set Phase 3'),
(10936,0,8,9,61,0,100,512,0,0,0,0,0,0,41,10000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Gossip Hello - Despawn'),
(10936,0,9,0,61,0,100,512,0,0,0,0,0,0,41,10000,0,0,0,0,0,11,10945,100,0,0,0,0,0,0,'Joseph Redpath - On Gossip Hello - Despawn Davil Crokford'),
(10936,0,10,0,60,4,100,0,2000,2000,6000,6000,0,0,5,20,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Joseph Redpath - On Update (Phase 3) - Play Emote');

-- Darrowshire Defender - the battle announcer and the final cleanup.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10948 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10948,0,0,0,0,0,100,0,3000,5000,5000,8000,0,0,11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darrowshire Defender - In Combat - Cast Strike'),
(10948,0,1,0,0,0,100,0,5000,7000,7000,10000,0,0,11,12169,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Defender - In Combat - Cast Shield Block'),
(10948,0,2,0,38,0,100,0,1,1,0,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Defender - On Data Set 1 1 - Say Line 0'),
(10948,0,3,0,38,0,100,0,1,2,0,0,0,0,1,1,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Defender - On Data Set 1 2 - Say Line 1'),
(10948,0,4,0,38,0,100,0,1,3,0,0,0,0,1,2,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Defender - On Data Set 1 3 - Say Line 2'),
(10948,0,5,0,38,0,100,0,1,4,0,0,0,0,1,3,9000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Defender - On Data Set 1 4 - Say Line 3'),
(10948,0,6,7,52,0,100,512,3,10948,0,0,0,0,41,15000,0,0,0,0,0,11,10951,200,0,0,0,0,0,0,'Darrowshire Defender - On Text Over - Despawn Marauding Corpses'),
(10948,0,7,8,61,0,100,512,0,0,0,0,0,0,41,15000,0,0,0,0,0,11,10952,200,0,0,0,0,0,0,'Darrowshire Defender - On Text Over - Despawn Marauding Skeletons'),
(10948,0,8,9,61,0,100,512,0,0,0,0,0,0,41,15000,0,0,0,0,0,11,10953,200,0,0,0,0,0,0,'Darrowshire Defender - On Text Over - Despawn Servants of Horgus'),
(10948,0,9,10,61,0,100,512,0,0,0,0,0,0,41,15000,0,0,0,0,0,11,10954,200,0,0,0,0,0,0,'Darrowshire Defender - On Text Over - Despawn Bloodletters'),
(10948,0,10,0,61,0,100,512,0,0,0,0,0,0,41,15000,0,0,0,0,0,11,10947,200,0,0,0,0,0,0,'Darrowshire Defender - On Text Over - Despawn Darrowshire Betrayers'),
(10948,0,11,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10952,60,0,0,0,0,0,0,'Darrowshire Defender - On Reset - Attack Start'),
(10948,0,12,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Defender - On Aggro - Set Home Pos'),
(10948,0,13,0,7,0,100,0,0,0,0,0,0,0,89,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Defender - On Evade - Move Random');

-- Battle rank and file: the spawn points sit 40-60 yd apart, so the old 30 yd
-- "On Reset - Attack Start" searches left whole waves standing idle. Anchoring
-- the home position on aggro stops them yo-yoing back up the hill mid-fight.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10947 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10947,0,0,0,0,0,100,0,3000,5000,7000,10000,0,0,11,5337,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darrowshire Betrayer - In Combat - Cast Wither Strike'),
(10947,0,1,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10948,60,0,0,0,0,0,0,'Darrowshire Betrayer - On Reset - Attack Start'),
(10947,0,2,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darrowshire Betrayer - On Aggro - Set Home Pos');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 10949 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10949,0,0,0,0,0,100,0,4000,6000,6000,9000,0,0,11,14518,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Silver Hand Disciple - In Combat - Cast Crusader Strike'),
(10949,0,1,0,74,0,100,0,4000,7000,12000,18000,75,40,11,15493,1,0,0,0,0,9,0,0,40,1,0,0,0,0,'Silver Hand Disciple - On Friendly Creature Below 75% Health - Cast Holy Light'),
(10949,0,2,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10952,60,0,0,0,0,0,0,'Silver Hand Disciple - On Reset - Attack Start'),
(10949,0,3,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Silver Hand Disciple - On Aggro - Set Home Pos'),
(10949,0,4,0,7,0,100,0,0,0,0,0,0,0,89,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Silver Hand Disciple - On Evade - Move Random');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 10950 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10950,0,0,0,0,0,100,0,3000,5000,5000,8000,0,0,11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Redpath Militia - In Combat - Cast Strike'),
(10950,0,1,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10952,60,0,0,0,0,0,0,'Redpath Militia - On Reset - Attack Start'),
(10950,0,2,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath Militia - On Aggro - Set Home Pos'),
(10950,0,3,0,7,0,100,0,0,0,0,0,0,0,89,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redpath Militia - On Evade - Move Random');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 10951 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10951,0,0,0,0,0,100,0,3000,5000,5000,8000,0,0,11,13584,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Marauding Corpse - In Combat - Cast Strike'),
(10951,0,1,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10948,60,0,0,0,0,0,0,'Marauding Corpse - On Reset - Attack Start'),
(10951,0,2,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marauding Corpse - On Aggro - Set Home Pos');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 10952 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10952,0,0,0,0,0,100,0,2000,4000,12000,15000,0,0,11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Marauding Skeleton - In Combat - Cast Hamstring'),
(10952,0,1,0,105,0,100,0,5000,7000,15000,18000,0,0,11,11972,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Marauding Skeleton - In Combat - Cast Shield Bash'),
(10952,0,2,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10948,60,0,0,0,0,0,0,'Marauding Skeleton - On Reset - Attack Start'),
(10952,0,3,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marauding Skeleton - On Aggro - Set Home Pos');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 10953 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10953,0,0,0,0,0,100,0,8000,11000,9000,12000,0,0,11,15608,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Servant of Horgus - In Combat - Cast Ravenous Claw'),
(10953,0,1,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10948,60,0,0,0,0,0,0,'Servant of Horgus - On Reset - Attack Start'),
(10953,0,2,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Servant of Horgus - On Aggro - Set Home Pos');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 10954 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10954,0,0,0,0,0,100,0,5000,7000,8000,12000,0,0,11,15583,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bloodletter - In Combat - Cast Rupture'),
(10954,0,1,0,0,0,100,0,14000,18000,20000,25000,0,0,11,15667,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bloodletter - In Combat - Cast Sinister Strike'),
(10954,0,2,0,25,0,100,0,0,0,0,0,0,0,49,0,0,0,0,0,0,19,10937,80,0,0,0,0,0,0,'Bloodletter - On Reset - Attack Captain Redpath'),
(10954,0,3,0,4,0,100,0,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodletter - On Aggro - Set Home Pos');

-- Pamela Redpath - the reunion scene that plays when quest 5721 is handed in.
--
-- creature_text already held the whole exchange, unreferenced by any script:
-- Joseph 7397 "Pamela?  Are you there, honey?", 7398 "Hahah!" (male-only line,
-- so it is his), Pamela 7399-7402, Joseph 7403 "I missed you too, honey.  And
-- I'm finally home...".  He materialises in front of her house with no spell
-- visual, they talk, and both leave the same way.  Pamela is back after two
-- minutes; her own 345 s respawn timer would keep the turn-in blocked for
-- other players for too long.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10926 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10926,0,0,0,20,0,100,0,5149,0,0,0,0,0,80,1092600,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pamela Redpath - On Quest \'Pamela\'s Doll\' Finished - Run Script'),
(10926,0,1,0,20,0,100,0,5721,0,0,0,0,0,80,1092601,2,1,0,0,0,1,0,0,0,0,0,0,0,0,'Pamela Redpath - On Quest \'The Battle of Darrowshire\' Finished - Run Script');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 1092601 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(1092601,9,0,0,0,0,100,0,2000,2000,0,0,0,0,12,10936,3,60000,0,0,0,8,0,0,0,0,1460.32,-3596.28,86.92,3.18,'Pamela Redpath - Reunion - Summon Joseph Redpath'),
(1092601,9,1,0,0,0,100,0,500,500,0,0,0,0,45,1,2,0,0,0,0,19,10936,20,0,0,0,0,0,0,'Pamela Redpath - Reunion - Set Data 1 2 (Joseph appears)'),
(1092601,9,2,0,0,0,100,0,3000,3000,0,0,0,0,1,0,4000,0,0,0,0,19,10936,20,0,0,0,0,0,0,'Pamela Redpath - Reunion - Joseph Says Line 0'),
(1092601,9,3,0,0,0,100,0,4000,4000,0,0,0,0,1,0,3000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pamela Redpath - Reunion - Say Line 0'),
(1092601,9,4,0,0,0,100,0,2000,2000,0,0,0,0,1,5,2000,0,0,0,0,19,10936,20,0,0,0,0,0,0,'Pamela Redpath - Reunion - Joseph Says Line 5'),
(1092601,9,5,0,0,0,100,0,3000,3000,0,0,0,0,1,1,3000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pamela Redpath - Reunion - Say Line 1'),
(1092601,9,6,0,0,0,100,0,4000,4000,0,0,0,0,1,2,9000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pamela Redpath - Reunion - Say Line 2'),
(1092601,9,7,0,0,0,100,0,10000,10000,0,0,0,0,1,3,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pamela Redpath - Reunion - Say Line 3'),
(1092601,9,8,0,0,0,100,0,5000,5000,0,0,0,0,1,1,5000,0,0,0,0,19,10936,20,0,0,0,0,0,0,'Pamela Redpath - Reunion - Joseph Says Line 1'),
(1092601,9,9,0,0,0,100,0,7000,7000,0,0,0,0,45,1,3,0,0,0,0,19,10936,20,0,0,0,0,0,0,'Pamela Redpath - Reunion - Set Data 1 3 (Joseph leaves)'),
(1092601,9,10,0,0,0,100,0,3000,3000,0,0,0,0,41,0,120,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pamela Redpath - Reunion - Despawn');

-- Carlin Redpath - "I need another Relic Bundle!".
--
-- The Relic Bundle (15209) is the source item of quest 5721 and is consumed on
-- use, so a failed run of the battle used to leave the player with no way to try
-- again short of abandoning and re-taking the quest. Blizzard's recovery is a
-- gossip option: text 7409 "I need another Relic Bundle!" sits immediately after
-- Carlin's own gossip text 7408 (npc_text 4716, his menu 3864), which is how the
-- client data pairs a menu with its options. The option only shows while the
-- quest is active and the player has no bundle in bags or bank.
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 11063;

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 3864 AND `OptionID` = 0;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(3864, 0, 0, 'I need another Relic Bundle!', 7409, 1, 1, 0, 0, 0, 0, '', 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 3864 AND `SourceEntry` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 3864, 0, 0, 0, 9, 0, 5721, 0, 0, 0, 0, 0, '', 'Carlin Redpath - Relic Bundle option only while The Battle of Darrowshire is active'),
(15, 3864, 0, 0, 0, 2, 0, 15209, 1, 1, 1, 0, 0, '', 'Carlin Redpath - Relic Bundle option only if the player has none');

DELETE FROM `smart_scripts` WHERE `entryorguid` = 11063 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(11063,0,0,1,62,0,100,512,3864,0,0,0,0,0,56,15209,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Carlin Redpath - On Gossip Select - Add Relic Bundle'),
(11063,0,1,0,61,0,100,512,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Carlin Redpath - On Gossip Select - Close Gossip');
