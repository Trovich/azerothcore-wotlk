--
-- The Dark Portal battle (Stair of Destiny, Hellfire Peninsula side).
--
-- How it is built: the Alliance and Horde defenders are spawned as a battle line at the
-- foot of the stairs (respawn 1 s). On (re)spawn each one teleports to its faction's side
-- of the portal, runs down waypoint path 18965 (Alliance) / 18970 (Horde), and on the last
-- point is meant to go back to its own place in the line. Four Wrath Masters (guids
-- 68311-68314) spawn along the road, summon four Fel Soldiers each and march them down to
-- the portal; the Pit Commander walks to the gate and once a minute has the two Infernal
-- Target triggers drop meteors that land two Infernal Siegebreakers (75 s) in the line.
-- Retail matches this (Wowhead: "Alliance fight only at left side, Horde at right side",
-- groups of Fel Soldiers with a Wrath Master "slowly make their way to the Dark Portal",
-- the Pit Commander "every minute ... two huge meteors ... summoning two Infernal
-- Siegebreakers").
--
-- 1. The defenders never return to the line. The last-waypoint handler is commented "Set
--    Home Position to Respawn", but SMART_ACTION_SET_HOME_POS has param1 0, i.e. "here":
--    every defender of a faction adopts the path's last point (-263, 1071) / (-237, 1072)
--    at the top of the stairs as home and evades onto it - the whole side standing inside
--    one model, 25-30 yd above where the meteors land and the Fel Soldiers arrive, out of
--    aggro range of both. So nothing fought, and none of their abilities were ever seen.
--    param1 = 1 sends each of them back to its own spawn point in the line.
--
-- 2. The marching Fel Soldiers vanished. Fel Soldier row 14 despawns the soldier after 10 s
--    out of combat - fine for leftovers, but it also fires on the ones escorting a Wrath
--    Master, so the groups dissolved a few seconds into the march. Soldiers now carry a
--    phase: free (1, set on summon) or escorting (2, set when a Wrath Master assigns them a
--    formation slot); the cleanup only runs while free, and a dying Wrath Master frees his
--    escort. Phase reset on evade is disabled so the state survives fights.
--
-- 3. Missing abilities, checked against Wowhead's ability lists:
--    Undercity Mage   - was a copy of the Stormwind Mage (Fireball, Arcane Missiles);
--                       retail is Icebolt + Blizzard.
--    Ironforge Paladin - Holy Smite -> Hammer of Justice; Seal of Sacrifice added;
--                       Exorcism no longer only 40% of the time.
--    Orgrimmar Shaman - Bloodlust added.
--    Justinius the Harbinger - Consecration, Greater Blessing of Might, Divine Shield added
--                       (Judgement of Command and Flash of Light were there).
--    Melgromm Highmountain - Chain Heal, Magma Flow Totem, Strength of the Storm Totem
--                       added (Chain Lightning and Earth Shock were there). The two totems
--                       had no spell at all: 19222 now pulses 33561 (Magma Flow, 8k fire
--                       every 3 s), 19225 carries 33571 (Strength of the Storm).
--    The mages' bolts get SMARTCAST_COMBAT_MOVE so they fight from range instead of
--    walking into melee.
--    Not done: Melgromm's Revive Self (32343) is a dummy that needs a script.
--
-- Commander Duron and Lieutenant General Orion are the officers standing at the portal
-- itself: IMMUNE_TO_PC | IMMUNE_TO_NPC, civilian, no AI - decoration, as on retail (no
-- abilities listed). Justinius and Melgromm stand behind the line and join in when the
-- demons reach the top of the stairs.
--

-- 1. back to the battle line
UPDATE `smart_scripts` SET `action_param1` = 1
WHERE `entryorguid` IN (18948, 18950, 18965, 18970, 18972, 18986) AND `source_type` = 0 AND `id` = 5 AND `action_type` = 101;

-- 2. Fel Soldier escorts
UPDATE `smart_scripts` SET `link` = 8 WHERE `entryorguid` = 18944 AND `source_type` = 0 AND `id` = 0;
UPDATE `smart_scripts` SET `link` = 9 WHERE `entryorguid` = 18944 AND `source_type` = 0 AND `id` = 1;
UPDATE `smart_scripts` SET `link` = 15 WHERE `entryorguid` = 18944 AND `source_type` = 0 AND `id` = 2;
UPDATE `smart_scripts` SET `link` = 16 WHERE `entryorguid` = 18944 AND `source_type` = 0 AND `id` = 3;
UPDATE `smart_scripts` SET `event_phase_mask` = 1, `comment` = 'Fel Soldier - Out of Combat for 10 s while free (Phase 1) - Despawn'
WHERE `entryorguid` = 18944 AND `source_type` = 0 AND `id` = 14;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 18944 AND `source_type` = 0 AND `id` IN (6, 7, 8, 9, 15, 16, 17);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-68311, -68312, -68313, -68314) AND `source_type` = 0 AND `id` = 9;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 18986 AND `source_type` = 0 AND `id` = 13;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 18971 AND `source_type` = 0 AND `id` = 11;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 18972 AND `source_type` = 0 AND `id` = 13;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 18966 AND `source_type` = 0 AND `id` IN (3, 4, 5);
DELETE FROM `smart_scripts` WHERE `entryorguid` = 18969 AND `source_type` = 0 AND `id` IN (2, 3, 4);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18944,0,6,7,54,0,100,512,0,0,0,0,0,0,211,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fel Soldier - On Just Summoned - Keep event phase through evades'),
(18944,0,7,0,61,0,100,512,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fel Soldier - On Just Summoned - Set Phase 1 (free)'),
(18944,0,8,0,61,0,100,512,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fel Soldier - On Data Set 1 - Set Phase 2 (escorting)'),
(18944,0,9,0,61,0,100,512,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fel Soldier - On Data Set 2 - Set Phase 2 (escorting)'),
(18944,0,15,0,61,0,100,512,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fel Soldier - On Data Set 3 - Set Phase 2 (escorting)'),
(18944,0,16,0,61,0,100,512,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fel Soldier - On Data Set 4 - Set Phase 2 (escorting)'),
(18944,0,17,0,38,0,100,512,5,5,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fel Soldier - On Data Set 5 5 (Wrath Master died) - Set Phase 1 (free)'),
(-68311,0,9,0,6,0,100,512,0,0,0,0,0,0,45,5,5,0,0,0,0,204,18944,0,0,0,0,0,0,0,'Wrath Master - On Death - Release escort (Set Data 5 5)'),
(-68312,0,9,0,6,0,100,512,0,0,0,0,0,0,45,5,5,0,0,0,0,204,18944,0,0,0,0,0,0,0,'Wrath Master - On Death - Release escort (Set Data 5 5)'),
(-68313,0,9,0,6,0,100,512,0,0,0,0,0,0,45,5,5,0,0,0,0,204,18944,0,0,0,0,0,0,0,'Wrath Master - On Death - Release escort (Set Data 5 5)'),
(-68314,0,9,0,6,0,100,512,0,0,0,0,0,0,45,5,5,0,0,0,0,204,18944,0,0,0,0,0,0,0,'Wrath Master - On Death - Release escort (Set Data 5 5)'),
-- 3. abilities
(18986,0,13,0,0,0,100,0,2000,4000,30000,30000,0,0,11,13903,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ironforge Paladin - In Combat - Cast ''Seal of Sacrifice'''),
(18972,0,13,0,0,0,100,0,4000,8000,60000,60000,0,0,11,16170,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Orgrimmar Shaman - In Combat - Cast ''Bloodlust'''),
(18966,0,3,0,0,0,100,0,6000,10000,15000,20000,0,0,11,33559,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Justinius the Harbinger - In Combat - Cast ''Consecration'''),
(18966,0,4,0,60,0,100,0,2000,4000,25000,30000,0,0,11,33564,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Justinius the Harbinger - On Update - Cast ''Greater Blessing of Might'''),
(18966,0,5,0,2,0,100,1,0,15,0,0,0,0,11,33581,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Justinius the Harbinger - Between 0-15% Health - Cast ''Divine Shield'' (No Repeat)'),
(18969,0,2,0,14,0,100,0,3000,40,12000,16000,0,0,11,33642,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Melgromm Highmountain - Friendly Missing 3000 Health - Cast ''Chain Heal'''),
(18969,0,3,0,0,0,100,0,5000,8000,25000,30000,0,0,11,33560,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Melgromm Highmountain - In Combat - Cast ''Magma Flow Totem'''),
(18969,0,4,0,1,0,100,0,2000,4000,120000,120000,0,0,11,33570,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Melgromm Highmountain - Out of Combat - Cast ''Strength of the Storm Totem''');

UPDATE `smart_scripts` SET `action_param1` = 13005, `event_param1` = 5000, `event_param2` = 10000, `event_param3` = 15000, `event_param4` = 25000,
    `comment` = 'Ironforge Paladin - In Combat - Cast ''Hammer of Justice'''
WHERE `entryorguid` = 18986 AND `source_type` = 0 AND `id` = 10;
UPDATE `smart_scripts` SET `event_chance` = 100, `event_param3` = 8000, `event_param4` = 14000
WHERE `entryorguid` = 18986 AND `source_type` = 0 AND `id` = 11;

UPDATE `smart_scripts` SET `action_param1` = 33463, `action_param2` = 64, `comment` = 'Undercity Mage - In Combat - Cast ''Icebolt'''
WHERE `entryorguid` = 18971 AND `source_type` = 0 AND `id` = 10;
UPDATE `smart_scripts` SET `action_param2` = 64
WHERE `entryorguid` = 18949 AND `source_type` = 0 AND `id` = 10;

DELETE FROM `creature_template_spell` WHERE `CreatureID` IN (19222, 19225);
INSERT INTO `creature_template_spell` (`CreatureID`, `Index`, `Spell`, `VerifiedBuild`) VALUES
(19222, 0, 33561, 0),  -- Magma Flow Totem: Magma Flow Totem Passive
(19225, 0, 33571, 0);  -- Strength of the Storm Totem: Strength of the Storm
