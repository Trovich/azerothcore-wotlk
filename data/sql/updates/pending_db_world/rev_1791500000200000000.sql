--
-- Durn the Hungerer (18411, Nagrand): seen from as far off as the Fel Reaver (18733, Hellfire Peninsula).
--
-- The Fel Reaver has visibilityDistanceType 5 (Infinite, 533 yd) on its template and on both spawns. Durn had
-- 3 (Large, 200 yd) on the template - but his one spawn (guid 65801) has a creature_addon row of its own (it
-- carries his path), and that row wins over the template's with 0: Normal, 100 yd.
--
UPDATE `creature_template_addon` SET `visibilityDistanceType` = 5 WHERE `entry` = 18411;
UPDATE `creature_addon` SET `visibilityDistanceType` = 5 WHERE `guid` = 65801;
