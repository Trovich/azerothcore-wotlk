--
-- Argent Dawn supply caravan: Guard Didier (16226), Caravan Mule (16232), Field Marshal
-- Chambers (16254) and quest 9165 "Writ of Safe Passage".
--
-- The quest, the NPC templates and every line of dialogue (broadcast_text 12105-12128) are in
-- the database, but the escort that hands the quest out never was: Didier, the mules and
-- Chambers had no spawns, no path and nothing to summon them, so the quest could not be picked
-- up (TrinityCore/TrinityCore#14947 "Need script"). Rebuilt from Wowpedia/Wowhead:
--
--   * "The train starts out twice per day between 6 and 8 o'clock server time": game event 240,
--     active 06:00-08:00 and 18:00-20:00. While it is active Didier rolls a 5% chance every
--     minute to set off, so departures land somewhere in the window (~0.2% chance of none).
--   * Didier waits by Packmaster Stonebruiser at Light's Hope, summons three mules, casts Mark of
--     Didier (28114: periodic 28115, threat on every enemy within 100 yd every 2 s - retail
--     comments: "EVERYTHING within 100 yards aggro'd") and walks the main road west to the
--     Argent Dawn camp by the Stratholme graveyard (classic map 47.2, 42.6).
--   * The mules are passive, never evade (so they keep following) and heal to full after each
--     fight. "If any of the mules die, it's over": Didier stops, mourns, the shipment despawns.
--   * At the camp Didier becomes a quest giver. ~5 minutes later he calls out, Field Marshal
--     Chambers arrives and signs writs through gossip; the signature is now an explicit quest
--     objective (Wowhead lists Chambers as the quest's objective, the row had none).
--   * Didier despawns after Chambers leaves (or two minutes after a failure) with a 2 h respawn,
--     so a caravan runs at most once per window.
--
-- The route (174 points, ~1520 yd) was built on the server's navmesh between the retail
-- sightings of Didier (Wowhead mapper data converted to world coordinates, fit error <= 3 yd
-- against 9 known spawns), with terrain Z read from data/maps.
--
-- Guid 5300719 is the Guard Didier this realm already has standing next to the Packmaster
-- (added in-game, not by any SQL in the repository); it is replaced by the scripted spawn.
--

DELETE FROM `game_event` WHERE `eventEntry` = 240;
INSERT INTO `game_event` (`eventEntry`, `start_time`, `end_time`, `occurence`, `length`, `holiday`, `holidayStage`, `description`, `world_event`, `announce`) VALUES
(240, '2010-01-01 06:00:00', '2030-12-31 12:00:00', 720, 120, 0, 0, 'Argent Dawn Supply Caravan (Light''s Hope Chapel)', 0, 2);

DELETE FROM `creature` WHERE `guid` = 5300719;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`, `CreateObject`, `Comment`) VALUES
(5300719, 16226, 0, 0, 0, 1, 1, 1, 2299.69, -5298.37, 81.9967, 0.846801, 7200, 0, 0, 0, 0, 0, 0, 0, 0, '', NULL, 0, 'Argent Dawn supply caravan');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `gossip_menu_id` = 900161 WHERE `entry` = 16254;
UPDATE `quest_template` SET `RequiredNpcOrGo1` = 16254, `RequiredNpcOrGoCount1` = 1, `ObjectiveText1` = 'Writ of Safe Passage signed' WHERE `ID` = 9165;

DELETE FROM `waypoints` WHERE `entry` = 1622600;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `point_comment`) VALUES
(1622600,1,2306.41,-5288.45,82.305,NULL,0,'Guard Didier - supply caravan'),
(1622600,2,2313.13,-5278.53,82.025,NULL,0,'Guard Didier - supply caravan'),
(1622600,3,2313.90,-5268.60,82.428,NULL,0,'Guard Didier - supply caravan'),
(1622600,4,2314.67,-5258.67,83.543,NULL,0,'Guard Didier - supply caravan'),
(1622600,5,2315.14,-5251.53,84.319,NULL,0,'Guard Didier - supply caravan'),
(1622600,6,2315.60,-5244.40,84.628,NULL,0,'Guard Didier - supply caravan'),
(1622600,7,2316.07,-5237.26,84.899,NULL,0,'Guard Didier - supply caravan'),
(1622600,8,2316.53,-5230.13,84.604,NULL,0,'Guard Didier - supply caravan'),
(1622600,9,2321.81,-5227.10,84.505,NULL,0,'Guard Didier - supply caravan'),
(1622600,10,2327.09,-5224.08,84.226,NULL,0,'Guard Didier - supply caravan'),
(1622600,11,2332.37,-5221.06,84.305,NULL,0,'Guard Didier - supply caravan'),
(1622600,12,2337.65,-5218.03,83.918,NULL,0,'Guard Didier - supply caravan'),
(1622600,13,2342.57,-5212.19,81.851,NULL,0,'Guard Didier - supply caravan'),
(1622600,14,2347.49,-5206.35,78.553,NULL,0,'Guard Didier - supply caravan'),
(1622600,15,2352.41,-5200.51,76.870,NULL,0,'Guard Didier - supply caravan'),
(1622600,16,2357.33,-5194.67,76.304,NULL,0,'Guard Didier - supply caravan'),
(1622600,17,2362.66,-5189.34,76.888,NULL,0,'Guard Didier - supply caravan'),
(1622600,18,2368.00,-5184.00,77.125,NULL,0,'Guard Didier - supply caravan'),
(1622600,19,2373.34,-5178.66,75.980,NULL,0,'Guard Didier - supply caravan'),
(1622600,20,2378.67,-5173.33,74.373,NULL,0,'Guard Didier - supply caravan'),
(1622600,21,2378.67,-5162.67,73.669,NULL,0,'Guard Didier - supply caravan'),
(1622600,22,2378.67,-5152.00,75.034,NULL,0,'Guard Didier - supply caravan'),
(1622600,23,2378.67,-5141.33,76.338,NULL,0,'Guard Didier - supply caravan'),
(1622600,24,2378.67,-5130.67,77.507,NULL,0,'Guard Didier - supply caravan'),
(1622600,25,2378.67,-5120.00,78.941,NULL,0,'Guard Didier - supply caravan'),
(1622600,26,2378.67,-5109.33,79.181,NULL,0,'Guard Didier - supply caravan'),
(1622600,27,2378.67,-5098.67,77.818,NULL,0,'Guard Didier - supply caravan'),
(1622600,28,2378.67,-5088.00,76.179,NULL,0,'Guard Didier - supply caravan'),
(1622600,29,2384.00,-5082.66,77.987,NULL,0,'Guard Didier - supply caravan'),
(1622600,30,2389.33,-5077.33,79.430,NULL,0,'Guard Didier - supply caravan'),
(1622600,31,2394.66,-5072.00,80.025,NULL,0,'Guard Didier - supply caravan'),
(1622600,32,2400.00,-5066.67,79.795,NULL,0,'Guard Didier - supply caravan'),
(1622600,33,2400.00,-5056.00,80.520,NULL,0,'Guard Didier - supply caravan'),
(1622600,34,2400.00,-5045.33,80.632,NULL,0,'Guard Didier - supply caravan'),
(1622600,35,2394.66,-5039.15,79.384,NULL,0,'Guard Didier - supply caravan'),
(1622600,36,2389.33,-5032.96,76.571,NULL,0,'Guard Didier - supply caravan'),
(1622600,37,2384.00,-5026.77,74.547,NULL,0,'Guard Didier - supply caravan'),
(1622600,38,2378.67,-5020.59,73.456,NULL,0,'Guard Didier - supply caravan'),
(1622600,39,2372.97,-5016.68,73.190,NULL,0,'Guard Didier - supply caravan'),
(1622600,40,2367.27,-5012.76,72.896,NULL,0,'Guard Didier - supply caravan'),
(1622600,41,2361.57,-5008.85,72.282,NULL,0,'Guard Didier - supply caravan'),
(1622600,42,2355.87,-5004.93,71.757,NULL,0,'Guard Didier - supply caravan'),
(1622600,43,2356.60,-4993.13,72.612,NULL,0,'Guard Didier - supply caravan'),
(1622600,44,2357.33,-4981.33,72.590,NULL,0,'Guard Didier - supply caravan'),
(1622600,45,2362.66,-4976.00,72.309,NULL,0,'Guard Didier - supply caravan'),
(1622600,46,2368.00,-4970.67,70.724,NULL,0,'Guard Didier - supply caravan'),
(1622600,47,2373.34,-4965.34,70.386,NULL,0,'Guard Didier - supply caravan'),
(1622600,48,2378.67,-4960.00,71.737,NULL,0,'Guard Didier - supply caravan'),
(1622600,49,2384.00,-4954.66,73.235,NULL,0,'Guard Didier - supply caravan'),
(1622600,50,2389.33,-4949.33,73.734,NULL,0,'Guard Didier - supply caravan'),
(1622600,51,2394.66,-4944.00,73.934,NULL,0,'Guard Didier - supply caravan'),
(1622600,52,2400.00,-4938.67,74.741,NULL,0,'Guard Didier - supply caravan'),
(1622600,53,2405.34,-4933.34,76.489,NULL,0,'Guard Didier - supply caravan'),
(1622600,54,2410.67,-4928.00,75.850,NULL,0,'Guard Didier - supply caravan'),
(1622600,55,2416.00,-4922.66,71.418,NULL,0,'Guard Didier - supply caravan'),
(1622600,56,2421.33,-4917.33,64.676,NULL,0,'Guard Didier - supply caravan'),
(1622600,57,2421.33,-4906.67,63.831,NULL,0,'Guard Didier - supply caravan'),
(1622600,58,2421.33,-4896.00,64.172,NULL,0,'Guard Didier - supply caravan'),
(1622600,59,2421.33,-4885.33,64.632,NULL,0,'Guard Didier - supply caravan'),
(1622600,60,2421.33,-4874.67,65.789,NULL,0,'Guard Didier - supply caravan'),
(1622600,61,2421.33,-4864.00,66.180,NULL,0,'Guard Didier - supply caravan'),
(1622600,62,2421.33,-4853.33,66.345,NULL,0,'Guard Didier - supply caravan'),
(1622600,63,2416.00,-4848.00,64.652,NULL,0,'Guard Didier - supply caravan'),
(1622600,64,2410.67,-4842.67,64.374,NULL,0,'Guard Didier - supply caravan'),
(1622600,65,2405.34,-4837.34,64.793,NULL,0,'Guard Didier - supply caravan'),
(1622600,66,2400.00,-4832.00,69.330,NULL,0,'Guard Didier - supply caravan'),
(1622600,67,2400.00,-4821.33,68.705,NULL,0,'Guard Didier - supply caravan'),
(1622600,68,2400.00,-4810.67,68.244,NULL,0,'Guard Didier - supply caravan'),
(1622600,69,2400.00,-4800.00,68.536,NULL,0,'Guard Didier - supply caravan'),
(1622600,70,2400.00,-4789.33,67.477,NULL,0,'Guard Didier - supply caravan'),
(1622600,71,2400.00,-4778.67,66.757,NULL,0,'Guard Didier - supply caravan'),
(1622600,72,2400.00,-4768.00,66.117,NULL,0,'Guard Didier - supply caravan'),
(1622600,73,2405.34,-4762.66,62.563,NULL,0,'Guard Didier - supply caravan'),
(1622600,74,2410.67,-4757.33,61.863,NULL,0,'Guard Didier - supply caravan'),
(1622600,75,2416.00,-4752.00,63.448,NULL,0,'Guard Didier - supply caravan'),
(1622600,76,2421.33,-4746.67,66.758,NULL,0,'Guard Didier - supply caravan'),
(1622600,77,2421.33,-4736.00,66.409,NULL,0,'Guard Didier - supply caravan'),
(1622600,78,2421.33,-4725.33,66.039,NULL,0,'Guard Didier - supply caravan'),
(1622600,79,2426.66,-4720.00,69.018,NULL,0,'Guard Didier - supply caravan'),
(1622600,80,2432.00,-4714.67,72.484,NULL,0,'Guard Didier - supply caravan'),
(1622600,81,2437.34,-4709.34,76.370,NULL,0,'Guard Didier - supply caravan'),
(1622600,82,2442.67,-4704.00,78.242,NULL,0,'Guard Didier - supply caravan'),
(1622600,83,2448.02,-4698.34,78.030,NULL,0,'Guard Didier - supply caravan'),
(1622600,84,2453.36,-4692.67,78.043,NULL,0,'Guard Didier - supply caravan'),
(1622600,85,2458.70,-4687.00,81.308,NULL,0,'Guard Didier - supply caravan'),
(1622600,86,2464.05,-4681.33,79.293,NULL,0,'Guard Didier - supply caravan'),
(1622600,87,2469.37,-4676.33,75.701,NULL,0,'Guard Didier - supply caravan'),
(1622600,88,2474.69,-4671.33,75.636,NULL,0,'Guard Didier - supply caravan'),
(1622600,89,2480.01,-4666.33,75.671,NULL,0,'Guard Didier - supply caravan'),
(1622600,90,2485.33,-4661.33,75.386,NULL,0,'Guard Didier - supply caravan'),
(1622600,91,2490.80,-4658.26,75.185,NULL,0,'Guard Didier - supply caravan'),
(1622600,92,2496.27,-4655.20,75.403,NULL,0,'Guard Didier - supply caravan'),
(1622600,93,2501.73,-4652.14,75.721,NULL,0,'Guard Didier - supply caravan'),
(1622600,94,2507.20,-4649.07,76.005,NULL,0,'Guard Didier - supply caravan'),
(1622600,95,2507.04,-4641.07,77.747,NULL,0,'Guard Didier - supply caravan'),
(1622600,96,2506.88,-4633.07,77.770,NULL,0,'Guard Didier - supply caravan'),
(1622600,97,2506.72,-4625.07,76.794,NULL,0,'Guard Didier - supply caravan'),
(1622600,98,2506.56,-4617.07,76.451,NULL,0,'Guard Didier - supply caravan'),
(1622600,99,2505.92,-4606.08,77.434,NULL,0,'Guard Didier - supply caravan'),
(1622600,100,2505.28,-4595.09,79.577,NULL,0,'Guard Didier - supply caravan'),
(1622600,101,2506.86,-4588.78,79.393,NULL,0,'Guard Didier - supply caravan'),
(1622600,102,2508.44,-4582.48,78.476,NULL,0,'Guard Didier - supply caravan'),
(1622600,103,2510.02,-4576.17,75.626,NULL,0,'Guard Didier - supply caravan'),
(1622600,104,2511.60,-4569.87,75.560,NULL,0,'Guard Didier - supply caravan'),
(1622600,105,2509.14,-4562.27,75.877,NULL,0,'Guard Didier - supply caravan'),
(1622600,106,2506.67,-4554.67,78.050,NULL,0,'Guard Didier - supply caravan'),
(1622600,107,2509.23,-4546.51,76.913,NULL,0,'Guard Didier - supply caravan'),
(1622600,108,2511.78,-4538.36,77.753,NULL,0,'Guard Didier - supply caravan'),
(1622600,109,2514.34,-4530.20,79.612,NULL,0,'Guard Didier - supply caravan'),
(1622600,110,2516.89,-4522.04,81.031,NULL,0,'Guard Didier - supply caravan'),
(1622600,111,2525.15,-4519.39,81.065,NULL,0,'Guard Didier - supply caravan'),
(1622600,112,2533.42,-4516.73,79.980,NULL,0,'Guard Didier - supply caravan'),
(1622600,113,2541.69,-4514.07,78.877,NULL,0,'Guard Didier - supply caravan'),
(1622600,114,2549.96,-4511.42,79.837,NULL,0,'Guard Didier - supply caravan'),
(1622600,115,2549.64,-4501.04,80.365,NULL,0,'Guard Didier - supply caravan'),
(1622600,116,2549.33,-4490.67,79.126,NULL,0,'Guard Didier - supply caravan'),
(1622600,117,2549.33,-4480.00,78.969,NULL,0,'Guard Didier - supply caravan'),
(1622600,118,2549.33,-4469.33,78.424,NULL,0,'Guard Didier - supply caravan'),
(1622600,119,2549.33,-4458.67,78.169,NULL,0,'Guard Didier - supply caravan'),
(1622600,120,2549.33,-4448.00,78.573,NULL,0,'Guard Didier - supply caravan'),
(1622600,121,2549.33,-4437.33,81.493,NULL,0,'Guard Didier - supply caravan'),
(1622600,122,2549.33,-4426.67,81.223,NULL,0,'Guard Didier - supply caravan'),
(1622600,123,2549.33,-4416.00,78.796,NULL,0,'Guard Didier - supply caravan'),
(1622600,124,2549.33,-4405.33,77.960,NULL,0,'Guard Didier - supply caravan'),
(1622600,125,2549.33,-4394.67,77.095,NULL,0,'Guard Didier - supply caravan'),
(1622600,126,2549.33,-4384.00,76.862,NULL,0,'Guard Didier - supply caravan'),
(1622600,127,2549.33,-4373.33,77.846,NULL,0,'Guard Didier - supply caravan'),
(1622600,128,2549.33,-4362.67,75.443,NULL,0,'Guard Didier - supply caravan'),
(1622600,129,2549.33,-4352.00,70.520,NULL,0,'Guard Didier - supply caravan'),
(1622600,130,2549.33,-4341.33,67.300,NULL,0,'Guard Didier - supply caravan'),
(1622600,131,2552.26,-4333.62,67.520,NULL,0,'Guard Didier - supply caravan'),
(1622600,132,2555.20,-4325.91,68.848,NULL,0,'Guard Didier - supply caravan'),
(1622600,133,2558.14,-4318.20,67.952,NULL,0,'Guard Didier - supply caravan'),
(1622600,134,2561.07,-4310.49,67.002,NULL,0,'Guard Didier - supply caravan'),
(1622600,135,2566.75,-4305.54,67.472,NULL,0,'Guard Didier - supply caravan'),
(1622600,136,2572.43,-4300.59,67.987,NULL,0,'Guard Didier - supply caravan'),
(1622600,137,2577.08,-4294.32,69.170,NULL,0,'Guard Didier - supply caravan'),
(1622600,138,2581.73,-4288.05,69.719,NULL,0,'Guard Didier - supply caravan'),
(1622600,139,2586.39,-4281.78,70.554,NULL,0,'Guard Didier - supply caravan'),
(1622600,140,2591.04,-4275.52,72.433,NULL,0,'Guard Didier - supply caravan'),
(1622600,141,2591.01,-4265.44,71.653,NULL,0,'Guard Didier - supply caravan'),
(1622600,142,2590.99,-4255.36,71.356,NULL,0,'Guard Didier - supply caravan'),
(1622600,143,2591.49,-4245.01,73.233,NULL,0,'Guard Didier - supply caravan'),
(1622600,144,2592.00,-4234.67,72.009,NULL,0,'Guard Didier - supply caravan'),
(1622600,145,2596.93,-4228.90,74.668,NULL,0,'Guard Didier - supply caravan'),
(1622600,146,2601.87,-4223.12,76.372,NULL,0,'Guard Didier - supply caravan'),
(1622600,147,2606.80,-4217.34,76.958,NULL,0,'Guard Didier - supply caravan'),
(1622600,148,2611.73,-4211.57,77.934,NULL,0,'Guard Didier - supply caravan'),
(1622600,149,2612.24,-4204.32,78.170,NULL,0,'Guard Didier - supply caravan'),
(1622600,150,2612.76,-4197.08,78.039,NULL,0,'Guard Didier - supply caravan'),
(1622600,151,2613.27,-4189.83,78.076,NULL,0,'Guard Didier - supply caravan'),
(1622600,152,2613.78,-4182.58,78.923,NULL,0,'Guard Didier - supply caravan'),
(1622600,153,2619.38,-4174.04,80.602,NULL,0,'Guard Didier - supply caravan'),
(1622600,154,2624.98,-4165.51,80.803,NULL,0,'Guard Didier - supply caravan'),
(1622600,155,2632.73,-4161.47,80.337,NULL,0,'Guard Didier - supply caravan'),
(1622600,156,2640.49,-4157.42,80.566,NULL,0,'Guard Didier - supply caravan'),
(1622600,157,2648.24,-4153.38,81.604,NULL,0,'Guard Didier - supply caravan'),
(1622600,158,2656.00,-4149.33,83.022,NULL,0,'Guard Didier - supply caravan'),
(1622600,159,2661.34,-4144.00,84.400,NULL,0,'Guard Didier - supply caravan'),
(1622600,160,2666.67,-4138.67,85.759,NULL,0,'Guard Didier - supply caravan'),
(1622600,161,2672.00,-4133.34,87.576,NULL,0,'Guard Didier - supply caravan'),
(1622600,162,2677.33,-4128.00,87.019,NULL,0,'Guard Didier - supply caravan'),
(1622600,163,2677.33,-4117.33,88.194,NULL,0,'Guard Didier - supply caravan'),
(1622600,164,2677.33,-4106.67,88.667,NULL,0,'Guard Didier - supply caravan'),
(1622600,165,2677.33,-4096.00,88.940,NULL,0,'Guard Didier - supply caravan'),
(1622600,166,2677.33,-4085.33,88.194,NULL,0,'Guard Didier - supply caravan'),
(1622600,167,2677.33,-4074.67,88.574,NULL,0,'Guard Didier - supply caravan'),
(1622600,168,2677.33,-4064.00,87.516,NULL,0,'Guard Didier - supply caravan'),
(1622600,169,2676.28,-4057.60,87.166,NULL,0,'Guard Didier - supply caravan'),
(1622600,170,2675.24,-4051.20,87.766,NULL,0,'Guard Didier - supply caravan'),
(1622600,171,2674.20,-4044.80,89.831,NULL,0,'Guard Didier - supply caravan'),
(1622600,172,2673.16,-4038.40,92.583,NULL,0,'Guard Didier - supply caravan'),
(1622600,173,2677.68,-4030.65,93.022,NULL,0,'Guard Didier - supply caravan'),
(1622600,174,2682.20,-4022.90,92.986,NULL,0,'Guard Didier - supply caravan');

DELETE FROM `creature_text` WHERE `CreatureID` IN (16226, 16254);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`)
SELECT 16226, 0, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 12, 0, 100, 0, 0, 0, `ID`, 0, 'Guard Didier - departure' FROM `broadcast_text` WHERE `ID` = 12105
UNION ALL
SELECT 16226, 1, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 14, 0, 100, 0, 0, 0, `ID`, 0, 'Guard Didier - departure' FROM `broadcast_text` WHERE `ID` = 12113
UNION ALL
SELECT 16226, 2, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 14, 0, 100, 0, 0, 0, `ID`, 0, 'Guard Didier - Field Marshal Chambers approaching' FROM `broadcast_text` WHERE `ID` = 12128
UNION ALL
SELECT 16226, 3, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 12, 0, 100, 0, 0, 0, `ID`, 0, 'Guard Didier - answering Field Marshal Chambers' FROM `broadcast_text` WHERE `ID` = 12124
UNION ALL
SELECT 16226, 4, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 12, 0, 100, 0, 0, 0, `ID`, 0, 'Guard Didier - a mule died' FROM `broadcast_text` WHERE `ID` = 12118
UNION ALL
SELECT 16254, 0, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 12, 0, 100, 0, 0, 0, `ID`, 0, 'Field Marshal Chambers - to Guard Didier' FROM `broadcast_text` WHERE `ID` = 12126
UNION ALL
SELECT 16254, 1, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 14, 0, 100, 0, 0, 0, `ID`, 0, 'Field Marshal Chambers - arrival' FROM `broadcast_text` WHERE `ID` = 12127
UNION ALL
SELECT 16254, 2, 0, TRIM(TRAILING CHAR(10) FROM `MaleText`), 12, 0, 100, 25, 0, 0, `ID`, 0, 'Field Marshal Chambers - signing a writ' FROM `broadcast_text` WHERE `ID` = 12123;

DELETE FROM `npc_text` WHERE `ID` IN (900160, 900161);
INSERT INTO `npc_text` (`ID`, `text0_0`, `BroadcastTextID0`, `lang0`, `Probability0`, `em0_0`)
SELECT 900160, `MaleText`, `ID`, 0, 1, 1 FROM `broadcast_text` WHERE `ID` = 12114
UNION ALL
SELECT 900161, `MaleText`, `ID`, 0, 1, 6 FROM `broadcast_text` WHERE `ID` = 12125;

DELETE FROM `gossip_menu` WHERE `MenuID` IN (900160, 900161, 900162);
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES
(900160, 900160), -- Guard Didier, the caravan made it (text 12114)
(900161, 900161), -- Field Marshal Chambers (text 12125)
(900162, 8438);   -- Guard Didier, the caravan was lost (text 12116, previously unused)

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 900161;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES
(900161, 0, 0, 'Here is my Writ of Safe Passage, Field Marshal.', 0, 1, 1, 0, 0, 0, 0, '', 0);

DELETE FROM `conditions` WHERE (`SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 16226) OR (`SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 900161);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 5, 16226, 0, 0, 12, 0, 240, 0, 0, 0, 0, 0, '', 'Guard Didier - the caravan only sets off while game event 240 is active'),
(15, 900161, 0, 0, 0, 9, 0, 9165, 0, 0, 0, 0, 0, '', 'Field Marshal Chambers - sign option needs Writ of Safe Passage in progress'),
(15, 900161, 0, 0, 0, 28, 0, 9165, 0, 0, 1, 0, 0, '', 'Field Marshal Chambers - sign option hidden once the writ is signed');

DELETE FROM `smart_scripts` WHERE (`entryorguid` IN (16226, 16232, 16254) AND `source_type` = 0) OR (`entryorguid` IN (1622600, 1622601, 1622602, 1625400) AND `source_type` = 9);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(16226,0,0,1,11,0,100,0,0,0,0,0,0,0,211,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Respawn - Keep event phase through evades'),
(16226,0,1,2,61,0,100,0,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Respawn - Set Phase 1 (waiting at Light''s Hope)'),
(16226,0,2,3,61,0,100,0,0,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Respawn - Set Npc Flags None'),
(16226,0,3,0,61,0,100,0,0,0,0,0,0,0,240,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Respawn - Set Gossip Menu None'),
(16226,0,4,0,1,1,5,0,30000,60000,60000,60000,0,0,80,1622600,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - OOC every minute, 5% chance, game event 240 active (Phase 1) - Run Script: depart'),
(16226,0,5,0,4,0,100,1,0,0,0,0,0,0,11,22120,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Guard Didier - On Aggro - Cast ''Charge'' (No Repeat)'),
(16226,0,6,0,7,2,100,0,0,0,0,0,0,0,11,28114,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Evade (Phase 2) - Cast ''Mark of Didier'''),
(16226,0,7,0,38,2,100,0,1,1,0,0,0,0,80,1622602,2,1,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Data Set 1 1: a mule died (Phase 2) - Run Script: caravan lost'),
(16226,0,8,0,59,2,100,0,1,0,0,0,0,0,80,1622602,2,1,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Timed Event 1: 30 min timeout (Phase 2) - Run Script: caravan lost'),
(16226,0,9,0,58,2,100,0,0,1622600,0,0,0,0,80,1622601,2,1,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - On Path Ended (Phase 2) - Run Script: caravan made it'),
(16226,0,10,0,6,2,100,0,0,0,0,0,0,0,41,0,0,0,0,0,0,204,16232,0,0,0,0,0,0,0,'Guard Didier - On Death (Phase 2) - Despawn mules'),
(1622600,9,0,0,0,0,100,0,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Phase 2 (escorting)'),
(1622600,9,1,0,0,0,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Say Line 0'),
(1622600,9,2,0,0,0,100,0,3000,3000,0,0,0,0,12,16232,3,3600000,0,0,0,8,0,0,0,0,2296.5,-5301.5,81.995,0.85,'Guard Didier - Script - Summon Caravan Mule'),
(1622600,9,3,0,0,0,100,0,0,0,0,0,0,0,12,16232,3,3600000,0,0,0,8,0,0,0,0,2294.0,-5299.0,81.995,0.85,'Guard Didier - Script - Summon Caravan Mule'),
(1622600,9,4,0,0,0,100,0,0,0,0,0,0,0,12,16232,3,3600000,0,0,0,8,0,0,0,0,2297.0,-5304.5,81.995,0.85,'Guard Didier - Script - Summon Caravan Mule'),
(1622600,9,5,0,0,0,100,0,1000,1000,0,0,0,0,230,1,6,400,0,0,0,204,16232,0,0,0,0,0,0,0,'Guard Didier - Script - Mules follow in formation'),
(1622600,9,6,0,0,0,100,0,2000,2000,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Yell Line 1'),
(1622600,9,7,0,0,0,100,0,0,0,0,0,0,0,11,28114,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Cast ''Mark of Didier'''),
(1622600,9,8,0,0,0,100,0,0,0,0,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Walk (followers copy the walk flag)'),
(1622600,9,9,0,0,0,100,0,0,0,0,0,0,0,67,1,1800000,1800000,0,0,100,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Create Timed Event 1 (30 min timeout)'),
(1622600,9,10,0,0,0,100,0,0,0,0,0,0,0,53,1,1622600,0,0,0,2,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Start Path (walk, aggressive)'),
(1622601,9,0,0,0,0,100,0,0,0,0,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Phase 3'),
(1622601,9,1,0,0,0,100,0,0,0,0,0,0,0,74,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Remove Timed Event 1'),
(1622601,9,2,0,0,0,100,0,0,0,0,0,0,0,28,28114,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Remove ''Mark of Didier'''),
(1622601,9,3,0,0,0,100,0,0,0,0,0,0,0,28,28114,0,0,0,0,0,204,16232,0,0,0,0,0,0,0,'Guard Didier - Script - Remove ''Mark of Didier'' from mules'),
(1622601,9,4,0,0,0,100,0,1000,1000,0,0,0,0,240,900160,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Gossip Menu'),
(1622601,9,5,0,0,0,100,0,0,0,0,0,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Npc Flags Gossip, Questgiver'),
(1622601,9,6,0,0,0,100,0,0,0,0,0,0,0,5,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Play Emote Cheer'),
(1622601,9,7,0,0,0,100,0,300000,300000,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Yell Line 2'),
(1622601,9,8,0,0,0,100,0,4000,4000,0,0,0,0,12,16254,3,900000,0,0,0,8,0,0,0,0,2697.6,-4015.2,91.41,3.605,'Guard Didier - Script - Summon Field Marshal Chambers (15 min)'),
(1622601,9,9,0,0,0,100,0,930000,930000,0,0,0,0,41,0,0,0,0,0,0,204,16232,0,0,0,0,0,0,0,'Guard Didier - Script - Despawn mules'),
(1622601,9,10,0,0,0,100,0,0,0,0,0,0,0,41,2000,7200,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Despawn (respawn in 2 h)'),
(1622602,9,0,0,0,0,100,0,0,0,0,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Phase 3'),
(1622602,9,1,0,0,0,100,0,0,0,0,0,0,0,74,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Remove Timed Event 1'),
(1622602,9,2,0,0,0,100,0,0,0,0,0,0,0,55,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Stop Path (failed: no path-ended event)'),
(1622602,9,3,0,0,0,100,0,0,0,0,0,0,0,28,28114,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Remove ''Mark of Didier'''),
(1622602,9,4,0,0,0,100,0,0,0,0,0,0,0,28,28114,0,0,0,0,0,204,16232,0,0,0,0,0,0,0,'Guard Didier - Script - Remove ''Mark of Didier'' from mules'),
(1622602,9,5,0,0,0,100,0,0,0,0,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Say Line 4'),
(1622602,9,6,0,0,0,100,0,3000,3000,0,0,0,0,5,18,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Play Emote Cry'),
(1622602,9,7,0,0,0,100,0,0,0,0,0,0,0,240,900162,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Gossip Menu'),
(1622602,9,8,0,0,0,100,0,0,0,0,0,0,0,81,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Set Npc Flags Gossip'),
(1622602,9,9,0,0,0,100,0,2000,2000,0,0,0,0,41,0,0,0,0,0,0,204,16232,0,0,0,0,0,0,0,'Guard Didier - Script - Despawn mules'),
(1622602,9,10,0,0,0,100,0,120000,120000,0,0,0,0,41,0,7200,0,0,0,0,1,0,0,0,0,0,0,0,0,'Guard Didier - Script - Despawn (respawn in 2 h)'),
(16232,0,0,0,25,0,100,0,0,0,0,0,0,0,11,28114,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Caravan Mule - On Reset - Cast ''Mark of Didier'''),
(16232,0,1,2,54,0,100,0,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Caravan Mule - On Just Summoned - Set Reactstate Passive'),
(16232,0,2,0,61,0,100,0,0,0,0,0,0,0,117,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Caravan Mule - On Just Summoned - Disable Evade (keeps following)'),
(16232,0,3,0,7,0,100,0,0,0,0,0,0,0,142,100,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Caravan Mule - On Evade - Set Health 100%'),
(16232,0,4,0,6,0,100,0,0,0,0,0,0,0,45,1,1,0,0,0,0,23,0,0,0,0,0,0,0,0,'Caravan Mule - On Death - Set Data 1 1 on Guard Didier'),
(16254,0,0,1,54,0,100,0,0,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Field Marshal Chambers - On Just Summoned - Set Npc Flags None'),
(16254,0,1,0,61,0,100,0,0,0,0,0,0,0,80,1625400,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Field Marshal Chambers - On Just Summoned - Run Script'),
(16254,0,2,3,62,0,100,0,900161,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Field Marshal Chambers - On Gossip Option 0 Selected - Close Gossip'),
(16254,0,3,4,61,0,100,0,0,0,0,0,0,0,1,2,0,1,0,0,0,7,0,0,0,0,0,0,0,0,'Field Marshal Chambers - On Gossip Option 0 Selected - Say Line 2'),
(16254,0,4,0,61,0,100,0,0,0,0,0,0,0,33,16254,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Field Marshal Chambers - On Gossip Option 0 Selected - Quest Credit ''Writ of Safe Passage'''),
(1625400,9,0,0,0,0,100,0,2000,2000,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Field Marshal Chambers - Script - Say Line 0'),
(1625400,9,1,0,0,0,100,0,4000,4000,0,0,0,0,1,3,0,0,0,0,0,19,16226,60,0,0,0,0,0,0,'Field Marshal Chambers - Script - Guard Didier Say Line 3'),
(1625400,9,2,0,0,0,100,0,4000,4000,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Field Marshal Chambers - Script - Yell Line 1'),
(1625400,9,3,0,0,0,100,0,0,0,0,0,0,0,81,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Field Marshal Chambers - Script - Set Npc Flags Gossip');
