--
-- The Dark Portal: Darnassian Archers (18965) and Darkspear Axe Throwers (18970) fight at range only.
--
-- Shoot (15620) and Throw (10277) have a 5 yd minimum range. Whenever a demon got inside it, the
-- SmartAI cast handler gave up on the spell and sent the defender in to melee (chase distance 0), so
-- they shot at whatever was far away and brawled with whatever came close.
--
-- Cast flags on their only attack: SMARTCAST_COMBAT_MOVE (0x040, as before) + SMARTCAST_MAIN_SPELL
-- (0x400, the ranged attack sets their chase distance) + SMARTCAST_KEEP_DISTANCE (0x800, new in the
-- core: a victim that is too close makes them back off to the middle of the spell's range instead of
-- drawing a melee weapon; only when cornered do they fight in melee for a few seconds).
--
UPDATE `smart_scripts` SET `action_param2` = 3136
WHERE `entryorguid` IN (18965, 18970) AND `source_type` = 0 AND `id` = 10 AND `action_type` = 11;
