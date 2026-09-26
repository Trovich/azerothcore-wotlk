--
-- Two waypoint scripts left without a waypoint by rev_1789662000200000000.sql.
--
-- Both groups had the follower carry the flavour, not the leader: point 5 of the Sunspring Post Orphan's
-- own route said broadcast text 15119 ("Don't go close to the lake! It's haunted!", script 333), and
-- point 5 of Draaca Longtail's route played a talk emote (script 1026). Turning the pairs into formations
-- deleted those follower routes, so the two scripts ended up pointing at nothing and the world loader
-- complained about them at startup.
--
-- The leader walks the same points (its point 5 is within two yards of the deleted one, same pause), so
-- the actions move onto the leader's waypoint: the line and the emote still happen in the same spot at
-- the same moment, and nothing references a missing waypoint any more.
--
UPDATE `waypoint_data` SET `action` = 1026, `action_chance` = 100 WHERE `id` = 762620 AND `point` = 5;
UPDATE `waypoint_data` SET `action` = 333, `action_chance` = 100 WHERE `id` = 845880 AND `point` = 5;
