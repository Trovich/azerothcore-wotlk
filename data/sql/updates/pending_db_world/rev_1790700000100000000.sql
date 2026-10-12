--
-- Clefthoofs: melee range in front of the beast.
--
-- A creature's combat reach is a circle around the origin of its model. The origin of the clefthoof model
-- (Creature\CleftHoove\CleftHoove.m2) is at the shoulders: at model scale 1 the muzzle is 3.26 yd ahead of
-- it and the rump 7.09 yd behind. A reach that is right behind the beast (CombatReach, 4 yd per unit of
-- scale) therefore lets it fight an enemy standing several yards in front of its muzzle.
--
-- New table creature_model_reach: the reach of a display for what stands IN FRONT of it. The core turns the
-- two numbers into one circle shifted backwards (Unit::GetCombatReachToward): CombatReachFront ahead,
-- creature_model_info.CombatReach behind, sqrt(front * rear) to the sides. Like CombatReach it is multiplied
-- by the creature's object scale. The client only knows CombatReach, so keep that one the larger of the two.
-- Needs the rebuilt worldserver; the old one does not read the table.
--
CREATE TABLE IF NOT EXISTS `creature_model_reach` (
  `DisplayID` int unsigned NOT NULL,
  `CombatReachFront` float NOT NULL DEFAULT '0',
  `Comment` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`DisplayID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Combat reach of a creature display towards what is in front of it';

--
-- Front reach = 3.26 * display scale - 1.33: an attacker with the usual reach of 1.5 can strike from 1.5 yd
-- in front of the muzzle at most (distance to the origin = front reach + 1.5 + 4/3), and the beast itself
-- stops with its muzzle at its victim.
--
DELETE FROM `creature_model_reach` WHERE `DisplayID` IN (19581, 19582, 19583, 19584, 19585, 19797, 20822, 20823, 20824, 20825, 20924);
INSERT INTO `creature_model_reach` (`DisplayID`, `CombatReachFront`, `Comment`) VALUES
(19582, 3.5,  'CleftHoove x1.5 (rear 6): Clefthoof, Decrepit Clefthoof'),
(20924, 3.5,  'CleftHoove x1.5 (rear 6): Decrepit Clefthoof'),
(20822, 4.5,  'CleftHoove x1.8 (rear 7.2): Tame Clefthoof'),
(20823, 4.5,  'CleftHoove x1.8 (rear 7.2): Tame Clefthoof'),
(20824, 4.5,  'CleftHoove x1.8 (rear 7.2): Tame Clefthoof'),
(20825, 4.5,  'CleftHoove x1.8 (rear 7.2): Tame Clefthoof'),
(19583, 5.2,  'CleftHoove x2.0 (rear 8): Clefthoof Bull'),
(19581, 6.8,  'CleftHoove x2.5 (rear 10): Aged Clefthoof, Dead Clefthoof'),
(19797, 6.8,  'CleftHoove x2.5 (rear 10): Amberpelt Clefthoof, Bluff Behemoth, Brokentoe'),
(19585, 10.1, 'CleftHoove x3.5 (rear 14): Banthar'),
(19584, 1.1,  'CleftHoove x0.75 (rear 3): Clefthoof Calf');
