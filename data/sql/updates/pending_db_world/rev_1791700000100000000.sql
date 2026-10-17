--
-- Digging Through Bones (10922), fourth pass: the way back repeated the opening lines.
--
-- The waypoint events of Letoll (22458) matched their point on ANY path (event_param2 = 0). The ending starts the
-- return path 2245801 (rev_1791100000400000000), and reaching ITS point 1 fired event 3 again: pause 10 s and
-- script 2245800 - "protect us" and "the dig site is to the north" a second time on the way home.
-- Now every point event of the walk out is bound to the path 22458 (2245801 has 11 points, so 15-17 never
-- fired there, but they get the same guard).
--
UPDATE `smart_scripts` SET `event_param2` = 22458
WHERE `entryorguid` = 22458 AND `source_type` = 0 AND `id` IN (3, 5, 6, 7, 8) AND `event_type` = 40;
