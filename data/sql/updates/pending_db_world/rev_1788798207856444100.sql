--
-- Gryphon Rider Guard (15241) still reads as parked in the air after the
-- Rooted=1 fix (rev_1788746493874008700.sql) - it patrols, but a 5 yd random
-- wander radius produces small, slow, paused drifts that don't read as
-- movement at a normal viewing distance. That 5 yd figure matched the twelve
-- non-waypoint Bat Rider Guard (15242) spawns, which turn out to have the
-- same problem; they're just less noticeable in a screen full of other Bat
-- Riders.
--
-- Widened to 20 yd for both, which is still comfortably inside
-- RandomMovementGenerator's flight-aware pathing and well short of the four
-- Bat Rider Guards that already fly real waypoint patrols.
--

UPDATE `creature` SET `wander_distance` = 20 WHERE `id` IN (15241, 15242) AND `MovementType` = 1;
