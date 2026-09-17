--
-- Eastern Plaguelands: the two Scarlet Crusade road patrols walk as a unit again.
--
-- 1. Crimson Courier (92287) and his four Crimson Bodyguards (92288-92291), on the road between
--    Tyr's Hand and Stratholme. There was no formation: each of the five walked its own copy of the
--    same 421-point, 6.7 km loop (922870-922910, identical points). All five head for point 1 on
--    spawn and end up standing inside one another, and the first fight takes whoever joined it off
--    the schedule for good - after that the "escort" is strung out along the road, each on its own.
--    Now the courier leads and the bodyguards follow him in formation (two ahead, two behind,
--    3.5 yd along the road and 1.5 yd to the side), assisting each other in combat; their own
--    paths are removed and their spawn points moved onto the formation slots.
--
-- 2. Demetria (42575, quest 6148) and her nine Scarlet Troopers (300007-300015). The troopers line
--    both sides of the road out of Tyr's Hand and fall in, pair by pair, as she walks past them -
--    but their formation slots were a 3 yd ring around her, a third of them in front of her, so
--    each pair that joined walked into her and through the pair ahead. The slots are now a
--    3 x 3 block behind her (ranks 2.5 / 4.5 / 6.5 yd back, files 2 yd apart): the pairs take the
--    outer files in the order they join, the last three the middle file.
--

-- 1. Crimson Courier
DELETE FROM `creature_formations` WHERE `leaderGUID` = 92287 OR `memberGUID` IN (92287, 92288, 92289, 92290, 92291);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(92287, 92287, 0, 0, 515, 0, 0),
(92287, 92288, 3.808, 23.2, 515, 0, 0),  -- ahead, left
(92287, 92291, 3.808, 336.8, 515, 0, 0), -- ahead, right
(92287, 92290, 3.808, 156.8, 515, 0, 0), -- behind, left
(92287, 92289, 3.808, 203.2, 515, 0, 0); -- behind, right

UPDATE `creature` SET `MovementType` = 0 WHERE `guid` IN (92288, 92289, 92290, 92291);
UPDATE `creature` SET `position_x` = 2813.43, `position_y` = -4470.46, `position_z` = 90.116 WHERE `guid` = 92288;
UPDATE `creature` SET `position_x` = 2811.23, `position_y` = -4468.41, `position_z` = 90.008 WHERE `guid` = 92291;
UPDATE `creature` SET `position_x` = 2818.21, `position_y` = -4465.35, `position_z` = 90.103 WHERE `guid` = 92290;
UPDATE `creature` SET `position_x` = 2816.01, `position_y` = -4463.30, `position_z` = 89.991 WHERE `guid` = 92289;
UPDATE `creature` SET `orientation` = 3.96079 WHERE `guid` IN (92288, 92289, 92290, 92291);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (92288, 92289, 92290, 92291);
DELETE FROM `waypoint_data` WHERE `id` IN (922880, 922890, 922900, 922910);

-- 2. Demetria
DELETE FROM `creature_formations` WHERE `leaderGUID` = 42575;
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(42575, 42575, 0, 0, 515, 0, 0),
(42575, 300007, 3.2016, 218.66, 515, 0, 0), -- rank 1, right
(42575, 300008, 3.2016, 141.34, 515, 0, 0), -- rank 1, left
(42575, 300015, 2.5, 180, 515, 0, 0),       -- rank 1, middle
(42575, 300009, 4.9244, 203.96, 515, 0, 0), -- rank 2, right
(42575, 300010, 4.9244, 156.04, 515, 0, 0), -- rank 2, left
(42575, 300013, 4.5, 180, 515, 0, 0),       -- rank 2, middle
(42575, 300011, 6.8007, 197.1, 515, 0, 0),  -- rank 3, right
(42575, 300012, 6.8007, 162.9, 515, 0, 0),  -- rank 3, left
(42575, 300014, 6.5, 180, 515, 0, 0);       -- rank 3, middle
