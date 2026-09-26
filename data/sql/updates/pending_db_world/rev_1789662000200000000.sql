--
-- Patrols that walked as a crowd of independent copies instead of a group (audit of the whole world DB).
--
-- 1. Escorts without a formation. Two or three NPCs, spawned side by side, each walking its own copy of
--    one route (the same points, or parallel copies a few yards apart). They start inside one another
--    or drift apart at the first pause, and the first fight takes whoever joined it off the schedule for
--    good. Now one of them leads (never a rare spawn; the unique or front-most one otherwise) and the
--    rest follow in formation at the place they held on the copied route (behind the leader when that
--    place was on top of him); their own paths are removed, and those that spawned away from their
--    place now spawn in it. Civilians get follow only (512), everyone else follow + mutual assist (515).
--    Left alone: Soridormi / Arazmodu (own pauses), and the scripted mod-individual-progression groups
--    (Dark Portal invasion, Sun's Reach arrivals, Stonespine - fixed in the module).
--
-- 2. Formations that could not work as written: members sharing one place, a member spawned 200+ yd
--    from its leader, a row pointing at a creature on another map, NPCs with a waypoint movement type
--    but no path.
--

-- The Barrens: Erk 13166, Fang 13578 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (13166, 13578) OR `memberGUID` IN (13166, 13578);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(13166, 13166, 0, 0, 512, 0, 0),
(13166, 13578, 2.97, 147.4, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (13578);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (13578);
DELETE FROM `waypoint_data` WHERE `id` IN (135780);

-- The Barrens: Venture Co. Drone 15094, Venture Co. Drone 15095 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (15094, 15095) OR `memberGUID` IN (15094, 15095);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(15094, 15094, 0, 0, 515, 0, 0),
(15094, 15095, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (15095);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (15095);
DELETE FROM `waypoint_data` WHERE `id` IN (150950);

-- Alterac Mountains / The Headland: Stormpike Battleguard 16595, Stormpike Battleguard 16594 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (16594, 16595) OR `memberGUID` IN (16594, 16595);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(16595, 16595, 0, 0, 515, 0, 0),
(16595, 16594, 4.79, 126.8, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (16594);
UPDATE `creature` SET `position_x` = 28.228, `position_y` = -290.015, `position_z` = 133.085, `orientation` = 3.020 WHERE `guid` = 16594;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (16594);
DELETE FROM `waypoint_data` WHERE `id` IN (165940);

-- Alterac Mountains / Ruins of Alterac: Crushridge Warmonger 16983, Crushridge Warmonger 16982 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (16982, 16983) OR `memberGUID` IN (16982, 16983);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(16983, 16983, 0, 0, 515, 0, 0),
(16983, 16982, 7.00, 181.7, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (16982);
UPDATE `creature` SET `position_x` = 484.061, `position_y` = -214.241, `position_z` = 152.239, `orientation` = 5.029 WHERE `guid` = 16982;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (16982);
DELETE FROM `waypoint_data` WHERE `id` IN (169820);

-- Tanaris: Warden of Time 23473, Warden of Time 23472 (same route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (23472, 23473) OR `memberGUID` IN (23472, 23473);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(23473, 23473, 0, 0, 512, 0, 0),
(23473, 23472, 7.00, 147.5, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (23472);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (23472);
DELETE FROM `waypoint_data` WHERE `id` IN (234720);

-- Desolace / Gelkis Village: Gelkis Rumbler 27589, Gelkis Earthcaller 27259 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (27259, 27589) OR `memberGUID` IN (27259, 27589);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(27589, 27589, 0, 0, 515, 0, 0),
(27589, 27259, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (27259);
UPDATE `creature` SET `position_x` = -2173.245, `position_y` = 2477.897, `position_z` = 20.856, `orientation` = 5.696 WHERE `guid` = 27259;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (27259);
DELETE FROM `waypoint_data` WHERE `id` IN (272590);

-- Gnomeregan: Dark Iron Agent 30132, Dark Iron Ambassador 300376 (same route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (300376, 30132) OR `memberGUID` IN (300376, 30132);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(30132, 30132, 0, 0, 515, 0, 0),
(30132, 300376, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (300376);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (300376);
DELETE FROM `waypoint_data` WHERE `id` IN (3000376);

-- Winterspring: Winterfall Runner 42251, Winterfall Runner 42250, Winterfall Runner 42252 (same route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (42250, 42251, 42252) OR `memberGUID` IN (42250, 42251, 42252);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(42251, 42251, 0, 0, 512, 0, 0),
(42251, 42250, 2.97, 147.4, 512, 0, 0),
(42251, 42252, 7.00, 183.2, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (42250, 42252);
UPDATE `creature` SET `position_x` = 6895.974, `position_y` = -4091.479, `position_z` = 691.937, `orientation` = 5.525 WHERE `guid` = 42250;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (42250, 42252);
DELETE FROM `waypoint_data` WHERE `id` IN (422500, 422520);

-- Zul'Farrak (Zul'Farrak): Sandfury Shadowcaster 42626, Sandfury Blood Drinker 42619 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (42619, 42626) OR `memberGUID` IN (42619, 42626);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(42626, 42626, 0, 0, 515, 0, 0),
(42626, 42619, 1.93, 99.9, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (42619);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (42619);
DELETE FROM `waypoint_data` WHERE `id` IN (426190);

-- Razorfen Downs (Razorfen Downs): Skeletal Frostweaver 42681, Frozen Soul 42678 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (42678, 42681) OR `memberGUID` IN (42678, 42681);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(42681, 42681, 0, 0, 515, 0, 0),
(42681, 42678, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (42678);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (42678);
DELETE FROM `waypoint_data` WHERE `id` IN (426780);

-- Razorfen Downs (Razorfen Downs): Splinterbone Skeleton 42709, Splinterbone Skeleton 42710 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (42709, 42710) OR `memberGUID` IN (42709, 42710);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(42709, 42709, 0, 0, 515, 0, 0),
(42709, 42710, 2.17, 262.5, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (42710);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (42710);
DELETE FROM `waypoint_data` WHERE `id` IN (427100);

-- Silithus / Cenarion Hold: Cenarion Hold Infantry 42895, Cenarion Hold Infantry 42896 (same route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (42895, 42896) OR `memberGUID` IN (42895, 42896);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(42895, 42895, 0, 0, 515, 0, 0),
(42895, 42896, 6.31, 162.1, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (42896);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (42896);
DELETE FROM `waypoint_data` WHERE `id` IN (428960);

-- Silithus / Cenarion Hold: Cenarion Hold Infantry 42898, Cenarion Hold Infantry 42897 (same route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (42897, 42898) OR `memberGUID` IN (42897, 42898);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(42898, 42898, 0, 0, 515, 0, 0),
(42898, 42897, 5.55, 185.0, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (42897);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (42897);
DELETE FROM `waypoint_data` WHERE `id` IN (428970);

-- Stratholme (Stratholme): Crimson Guardsman 54053, Crimson Conjuror 54081 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (54053, 54081) OR `memberGUID` IN (54053, 54081);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(54053, 54053, 0, 0, 515, 0, 0),
(54053, 54081, 5.15, 269.0, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (54081);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (54081);
DELETE FROM `waypoint_data` WHERE `id` IN (540810);

-- Nagrand / Garadar: Bleeding Hollow Refugee 65611, Sunspring Post Refugee 65621 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (65611, 65621) OR `memberGUID` IN (65611, 65621);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(65611, 65611, 0, 0, 512, 0, 0),
(65611, 65621, 1.91, 89.5, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (65621);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (65621);
DELETE FROM `waypoint_data` WHERE `id` IN (656210);

-- Zangarmarsh: Zabra'jin Guard 67883, Zabra'jin Guard 67884 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (67883, 67884) OR `memberGUID` IN (67883, 67884);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(67883, 67883, 0, 0, 515, 0, 0),
(67883, 67884, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (67884);
UPDATE `creature` SET `position_x` = 250.778, `position_y` = 7754.942, `position_z` = 23.151, `orientation` = 3.878 WHERE `guid` = 67884;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (67884);
DELETE FROM `waypoint_data` WHERE `id` IN (678840);

-- Zangarmarsh: Zabra'jin Guard 67904, Zabra'jin Guard 67905 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (67904, 67905) OR `memberGUID` IN (67904, 67905);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(67904, 67904, 0, 0, 515, 0, 0),
(67904, 67905, 3.16, 101.6, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (67905);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (67905);
DELETE FROM `waypoint_data` WHERE `id` IN (679050);

-- Shattrath City / Lower City: Dwarf Refugee 68394, Dwarf Refugee 68393, Dwarf Refugee 68395 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (68393, 68394, 68395) OR `memberGUID` IN (68393, 68394, 68395);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(68394, 68394, 0, 0, 512, 0, 0),
(68394, 68393, 2.57, 231.2, 512, 0, 0),
(68394, 68395, 2.38, 3.4, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (68393, 68395);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (68393, 68395);
DELETE FROM `waypoint_data` WHERE `id` IN (683930, 683950);

-- Blade's Edge Mountains / Dragonspine Ridge: Wyrmcult Hewer 76262, Draaca Longtail 78731 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (76262, 78731) OR `memberGUID` IN (76262, 78731);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(76262, 76262, 0, 0, 515, 0, 0),
(76262, 78731, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (78731);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (78731);
DELETE FROM `waypoint_data` WHERE `id` IN (787310);

-- Netherstorm / Area 52: Soren 78315, Nadja 78314 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (78314, 78315) OR `memberGUID` IN (78314, 78315);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(78315, 78315, 0, 0, 512, 0, 0),
(78315, 78314, 3.75, 185.6, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (78314);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (78314);
DELETE FROM `waypoint_data` WHERE `id` IN (783140);

-- Elwynn Forest / Jerod's Landing: Defias Dockworker 80732, Defias Dockworker 80730, Defias Dockworker 84587 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (80730, 80732, 84587) OR `memberGUID` IN (80730, 80732, 84587);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(80732, 80732, 0, 0, 515, 0, 0),
(80732, 80730, 2.97, 212.6, 515, 0, 0),
(80732, 84587, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (80730, 84587);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (80730, 84587);
DELETE FROM `waypoint_data` WHERE `id` IN (807300, 845870);

-- Zul'Farrak (Zul'Farrak): Sandfury Blood Drinker 81457, Sandfury Soul Eater 81456 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (81456, 81457) OR `memberGUID` IN (81456, 81457);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(81457, 81457, 0, 0, 515, 0, 0),
(81457, 81456, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (81456);
UPDATE `creature` SET `position_x` = 1769.502, `position_y` = 856.793, `position_z` = 8.927, `orientation` = 3.923 WHERE `guid` = 81456;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (81456);
DELETE FROM `waypoint_data` WHERE `id` IN (814560);

-- Nagrand / Garadar: Sunspring Post Orphan 84588, Sunspring Post Orphan 84718 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (84588, 84718) OR `memberGUID` IN (84588, 84718);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(84588, 84588, 0, 0, 512, 0, 0),
(84588, 84718, 2.09, 188.8, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (84718);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (84718);
DELETE FROM `waypoint_data` WHERE `id` IN (847180);

-- Razorfen Downs (Razorfen Downs): Splinterbone Skeleton 87210, Splinterbone Skeleton 87211 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (87210, 87211) OR `memberGUID` IN (87210, 87211);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(87210, 87210, 0, 0, 515, 0, 0),
(87210, 87211, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (87211);
UPDATE `creature` SET `position_x` = 2449.078, `position_y` = 989.918, `position_z` = 36.533, `orientation` = 5.725 WHERE `guid` = 87211;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (87211);
DELETE FROM `waypoint_data` WHERE `id` IN (872110);

-- Razorfen Downs (Razorfen Downs): Thorn Eater Ghoul 87227, Skeletal Frostweaver 87226 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (87226, 87227) OR `memberGUID` IN (87226, 87227);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(87227, 87227, 0, 0, 515, 0, 0),
(87227, 87226, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (87226);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (87226);
DELETE FROM `waypoint_data` WHERE `id` IN (872260);

-- Razorfen Kraul (Razorfen Kraul): Quilguard Champion 87430, Quilguard Champion 87431 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (87430, 87431) OR `memberGUID` IN (87430, 87431);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(87430, 87430, 0, 0, 515, 0, 0),
(87430, 87431, 2.70, 92.2, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (87431);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (87431);
DELETE FROM `waypoint_data` WHERE `id` IN (874310);

-- Stormwind City: Kelly Grant 90482, Kimberly Grant 90481 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (90481, 90482) OR `memberGUID` IN (90481, 90482);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(90482, 90482, 0, 0, 512, 0, 0),
(90482, 90481, 2.88, 93.5, 512, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (90481);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (90481);
DELETE FROM `waypoint_data` WHERE `id` IN (904810);

-- Arathi Highlands: Hitah'ya the Keeper 93582, Vilebranch Aman'zasi Guard 93584 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (93582, 93584) OR `memberGUID` IN (93582, 93584);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(93582, 93582, 0, 0, 515, 0, 0),
(93582, 93584, 5.49, 179.3, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (93584);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (93584);
DELETE FROM `waypoint_data` WHERE `id` IN (935840);

-- Howling Fjord / Gjalerbron: Necrolord 115180, Necrolord 97230 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (97230, 115180) OR `memberGUID` IN (97230, 115180);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(115180, 115180, 0, 0, 515, 0, 0),
(115180, 97230, 7.00, 165.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (97230);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (97230);
DELETE FROM `waypoint_data` WHERE `id` IN (972300);

-- Zul'Drak / Reliquary of Pain: Drakuru's Guard 107817, Drakuru's Guard 107837 (same route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (107817, 107837) OR `memberGUID` IN (107817, 107837);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(107817, 107817, 0, 0, 515, 0, 0),
(107817, 107837, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (107837);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (107837);
DELETE FROM `waypoint_data` WHERE `id` IN (1078370);

-- Crystalsong Forest / The Twilight Rivulet: Warmage Mumplina 115886, Warmage Lukems 115706 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (115706, 115886) OR `memberGUID` IN (115706, 115886);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(115886, 115886, 0, 0, 515, 0, 0),
(115886, 115706, 2.61, 219.3, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (115706);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (115706);
DELETE FROM `waypoint_data` WHERE `id` IN (1157060);

-- Halls of Stone (Halls of Stone): Dark Rune Warrior 126689, Dark Rune Warrior 126688 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (126688, 126689) OR `memberGUID` IN (126688, 126689);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(126689, 126689, 0, 0, 515, 0, 0),
(126689, 126688, 2.43, 174.8, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (126688);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (126688);
DELETE FROM `waypoint_data` WHERE `id` IN (1266880);

-- Halls of Stone (Halls of Stone): Crystalline Shardling 126787, Crystalline Shardling 126788 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (126787, 126788) OR `memberGUID` IN (126787, 126788);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(126787, 126787, 0, 0, 515, 0, 0),
(126787, 126788, 5.97, 270.0, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (126788);
UPDATE `creature` SET `position_x` = 939.747, `position_y` = 807.931, `position_z` = 189.993, `orientation` = 0.213 WHERE `guid` = 126788;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (126788);
DELETE FROM `waypoint_data` WHERE `id` IN (1267880);

-- Ulduar (Ulduar): Dark Rune Thunderer 137481, Dark Rune Ravager 137483 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (137481, 137483) OR `memberGUID` IN (137481, 137483);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(137481, 137481, 0, 0, 515, 0, 0),
(137481, 137483, 7.00, 269.6, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (137483);
UPDATE `creature` SET `position_x` = 2104.663, `position_y` = -115.691, `position_z` = 411.763, `orientation` = 2.454 WHERE `guid` = 137483;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (137483);
DELETE FROM `waypoint_data` WHERE `id` IN (1374830);

-- Ulduar (Ulduar): Dark Rune Ravager 137484, Dark Rune Thunderer 137482 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (137482, 137484) OR `memberGUID` IN (137482, 137484);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(137484, 137484, 0, 0, 515, 0, 0),
(137484, 137482, 7.00, 90.0, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (137482);
UPDATE `creature` SET `position_x` = 2122.892, `position_y` = -193.277, `position_z` = 412.300, `orientation` = 1.595 WHERE `guid` = 137482;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (137482);
DELETE FROM `waypoint_data` WHERE `id` IN (1374820);

-- Shadowmoon Valley / Invasion Point: Cataclysm: Shadow Council Felsworn 213322, Shadow Council Zealot 213350 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (213322, 213350) OR `memberGUID` IN (213322, 213350);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(213322, 213322, 0, 0, 515, 0, 0),
(213322, 213350, 2.97, 147.4, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (213350);
UPDATE `creature` SET `position_x` = -2680.931, `position_y` = 2061.174, `position_z` = 116.966, `orientation` = 1.538 WHERE `guid` = 213350;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (213350);
DELETE FROM `waypoint_data` WHERE `id` IN (2133500);

-- Shadowmoon Valley / Invasion Point: Cataclysm: Shadow Council Felsworn 213334, Shadow Council Zealot 213355 (parallel copies of one route)
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (213334, 213355) OR `memberGUID` IN (213334, 213355);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(213334, 213334, 0, 0, 515, 0, 0),
(213334, 213355, 7.00, 90.0, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (213355);
UPDATE `creature` SET `position_x` = -2736.750, `position_y` = 2466.905, `position_z` = 93.328, `orientation` = 1.565 WHERE `guid` = 213355;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (213355);
DELETE FROM `waypoint_data` WHERE `id` IN (2133550);

-- Mulgore: two Galak Centaurs (25999, 26000) on one route, each leading a Galak Outrunner from the same
-- spot and slot: four models in one. One group now.
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (25999, 26000) OR `memberGUID` IN (25999, 26000, 26002, 26019);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(25999, 25999, 0, 0, 515, 0, 0),
(25999, 26002, 3.5, 90, 515, 0, 0),
(25999, 26019, 3.5, 270, 515, 0, 0),
(25999, 26000, 4, 180, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 26000;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` = 26000;
DELETE FROM `waypoint_data` WHERE `id` = 260000;

-- Coldarra: two Coldarra Spellbinders (122681, 122683) on one route, each with a Coldarra Mage Slayer
-- in front - and the Mage Slayers spawned 60-70 yd away. One group, spawned together.
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (122681, 122683) OR `memberGUID` IN (122681, 122683, 122666, 122668);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(122681, 122681, 0, 0, 515, 0, 0),
(122681, 122666, 4, 20, 515, 0, 0),
(122681, 122668, 4, 340, 515, 0, 0),
(122681, 122683, 3, 180, 515, 0, 0);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (122666, 122668, 122683);
UPDATE `creature` SET `position_x` = 3855.074, `position_y` = 6588.772, `position_z` = 166.157, `orientation` = 3.953 WHERE `guid` = 122666;
UPDATE `creature` SET `position_x` = 3853.090, `position_y` = 6590.657, `position_z` = 165.986, `orientation` = 3.953 WHERE `guid` = 122668;
UPDATE `creature` SET `position_x` = 3858.736, `position_y` = 6594.615, `position_z` = 165.623, `orientation` = 3.953 WHERE `guid` = 122683;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` = 122683;
DELETE FROM `waypoint_data` WHERE `id` = 1226830;

-- Hellfire Peninsula: the Honor Hold Cavalryman column (leader 57965). The three riders spawned 200 yd
-- down the road, with stub paths of 1-3 points, and their slots were 5 / 10 / 15 yd *ahead* of the
-- leader although the sniffed column had them behind him. Behind him now, spawned in line.
UPDATE `creature_formations` SET `angle` = 180 WHERE `leaderGUID` = 57965 AND `memberGUID` IN (57966, 57967, 57968);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (57966, 57967, 57968);
UPDATE `creature` SET `position_x` = -696.511, `position_y` = 2679.456, `position_z` = 93.357, `orientation` = 5.323 WHERE `guid` = 57966;
UPDATE `creature` SET `position_x` = -699.379, `position_y` = 2683.552, `position_z` = 93.811, `orientation` = 5.323 WHERE `guid` = 57967;
UPDATE `creature` SET `position_x` = -702.246, `position_y` = 2687.647, `position_z` = 93.991, `orientation` = 5.323 WHERE `guid` = 57968;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (57966, 57967, 57968);
DELETE FROM `waypoint_data` WHERE `id` IN (579660, 579670, 579680);

-- Hellfire Peninsula, Ruins of Sha'naar: the two Dreghood Geomancers escorting Illidari Taskmaster 59461
-- spawned 230 yd from him, by the middle of his route. They spawn at his side now.
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (58902, 58903);
UPDATE `creature` SET `position_x` = -738.619, `position_y` = 4709.463, `position_z` = 59.072, `orientation` = 0.388 WHERE `guid` = 58902;
UPDATE `creature` SET `position_x` = -736.652, `position_y` = 4704.653, `position_z` = 59.371, `orientation` = 0.388 WHERE `guid` = 58903;

-- Zul'Gurub: Razzashi Skitterer packs and a Bloodseeker Bat pack with two members on one slot.
UPDATE `creature_formations` SET `angle` = 150 WHERE `memberGUID` IN (49056, 49137, 49138, 49196);
UPDATE `creature_formations` SET `angle` = 210 WHERE `memberGUID` IN (49763, 49767, 49202, 49197);
UPDATE `creature_formations` SET `angle` = 155 WHERE `memberGUID` = 49140;

-- Zul'Gurub: Gurubashi Champion 51974's group lists 51983, since reused for a Witch Light in Kalimdor.
DELETE FROM `creature_formations` WHERE `leaderGUID` = 51974 AND `memberGUID` = 51983;

-- Ulduar: Auriaya's six Sanctum Sentries used four slots; the second pair gets its own, between the others.
UPDATE `creature_formations` SET `dist` = 9.5, `angle` = 157 WHERE `leaderGUID` = 137496 AND `memberGUID` = 137534;
UPDATE `creature_formations` SET `dist` = 9.5, `angle` = 203 WHERE `leaderGUID` = 137496 AND `memberGUID` = 137535;

-- Ironforge / Orgrimmar: War Effort Volunteers and Recruits (event 22) have waypoint movement and no
-- path: they stood still and logged an error on every spawn.
UPDATE `creature` SET `MovementType` = 0 WHERE `guid` IN (83135, 83136, 83137, 83138, 83139, 83163, 83164, 83165, 83166);
