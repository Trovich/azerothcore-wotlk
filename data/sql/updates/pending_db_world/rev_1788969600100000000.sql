--
-- Gryphon Rider Guard (15241) flies its patrol at a crawl.
--
-- Both air-force guards patrol on walk speed: they are TempSummons, so they take
-- `creature_template_movement`.Random = 0 (CreatureRandomMovementType::Walk) for the
-- random movement added in npc_air_force_bots::SummonGuard(). Walk speed is the
-- creature_template multiplier x 2.5 yd/s, and the two faction mirrors disagree:
--
--   15242 Bat Rider Guard      speed_walk 2.8   -> 7.00 yd/s
--   15241 Gryphon Rider Guard  speed_walk 1.0   -> 2.50 yd/s
--
-- 2.5 yd/s is a third of a walking player, and the gryphon's wing-beat animation is
-- driven by the movement speed, hence the slow-motion flapping. Nothing else about the
-- two guards differs, so bring 15241 in line with its mirror. (speed_run is left alone;
-- it is only used once a guard engages and MoveChase takes over.)
--

UPDATE `creature_template` SET `speed_walk` = 2.8 WHERE `entry` = 15241;
