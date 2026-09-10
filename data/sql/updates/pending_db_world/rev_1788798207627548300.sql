--
-- Quest 9709 "Stealing Back the Mushrooms" - Watcher Leesa'oh (and Buddy,
-- following her) visibly double back on the final approach to camp.
--
-- Her escort path (`waypoints` entry 17831) has a near-duplicate cluster at
-- points 23/24/25, all within ~2 yd of each other while every other stride on
-- this path is 5-15 yd. Point 24 sits *behind* the 23-25 pair relative to camp
-- (dist-from-home 23=16.4, 24=17.9, 25=16.2 yd) - a stray waypoint that makes
-- her step backward for an instant before continuing on, reading as a sudden
-- about-face.
--
-- Point 24 is moved onto point 25's position instead of deleted, so no
-- SmartAI row that references a WP id (On Reached WP13/WP30 etc.) needs
-- renumbering.
--

UPDATE `waypoints` SET `position_x` = -281.482, `position_y` = 8286.71, `position_z` = 19.4253
WHERE `entry` = 17831 AND `pointid` = 24;
