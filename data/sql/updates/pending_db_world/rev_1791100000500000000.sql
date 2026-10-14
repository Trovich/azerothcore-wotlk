--
-- Clefthoofs: the melee reach follows the outline of the body (was: a circle shifted back).
--
-- Reported with the shifted circle (front 3.5 / rear 6 at display scale 1.5): Shadowstep puts the rogue under
-- the beast's tail, and in front one can still fight from too far off the muzzle. Both come from the shape:
-- the circle is 4.6 yd wide at the flanks of a body 3.15 yd wide, bulges ahead of the narrow head, and the
-- rump (7.95 yd behind the origin) lies outside it - "just past the reach" behind the beast is inside the beast.
--
-- The body, measured on Creature\CleftHoove\CleftHoove.m2 at model scale 1, origin at the shoulders:
--   head to x = +3.26 (the last quarter yard is the tips of the tusks: 3.0 is used), torso half-width 2.1,
--   rump at x = -5.3, the tail on to -7.1 (not counted).
-- An attacker with the usual reach of 1.5 strikes from reach + 1.5 + 4/3 yd. "Ideal" behind the beast was reach 6
-- at scale 1.5, i.e. 0.9 yd off the rump; now it is that same distance off the body from every side:
--   reach = body extent - 1.9      (front 3.0 x scale - 1.9, side 2.1 x scale - 1.9, rear 5.3 x scale - 1.9)
-- BodyMargin = those 1.9: how far the body lies outside the reach. The core rebuilds the outline of the body
-- from the three reaches + the margin (half an ellipse ahead of the origin, a rounded box behind it) and takes
-- the reach at an angle as the distance to the outline less the margin (Unit::GetCombatReachAtAngle).
-- Shadowstep and the other "behind the target" destinations land half a yard clear of the body: reach + margin
-- + 0.5 = 8.5 yd behind the origin at scale 1.5, the rump being at 7.95 and melee reaching to 8.83.
--
-- creature_model_reach gets two more columns (CombatReachSide, BodyMargin); the rear end of the oval is
-- creature_model_info.CombatReach, the value the client knows - set here by the same formula (a little longer
-- than stock on the big displays, shorter on the calf). Needs the rebuilt worldserver.
--
DROP TABLE IF EXISTS `creature_model_reach`;
CREATE TABLE `creature_model_reach` (
  `DisplayID` int unsigned NOT NULL,
  `CombatReachFront` float NOT NULL DEFAULT '0' COMMENT 'reach ahead of the model origin; the rear one is creature_model_info.CombatReach',
  `CombatReachSide` float NOT NULL DEFAULT '0' COMMENT 'reach to the left / right of the origin; 0 = sqrt(front * rear)',
  `BodyMargin` float NOT NULL DEFAULT '0' COMMENT 'how far the body outline lies outside the reach',
  `Comment` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`DisplayID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Combat reach of a creature display that follows the outline of its body';

INSERT INTO `creature_model_reach` (`DisplayID`, `CombatReachFront`, `CombatReachSide`, `BodyMargin`, `Comment`) VALUES
(19584, 0.35, 0.3,  1.9, 'CleftHoove x0.75: Clefthoof Calf'),
(19582, 2.6,  1.25, 1.9, 'CleftHoove x1.5: Clefthoof, Decrepit Clefthoof'),
(20924, 2.6,  1.25, 1.9, 'CleftHoove x1.5: Decrepit Clefthoof'),
(20822, 3.5,  1.9,  1.9, 'CleftHoove x1.8: Tame Clefthoof'),
(20823, 3.5,  1.9,  1.9, 'CleftHoove x1.8: Tame Clefthoof'),
(20824, 3.5,  1.9,  1.9, 'CleftHoove x1.8: Tame Clefthoof'),
(20825, 3.5,  1.9,  1.9, 'CleftHoove x1.8: Tame Clefthoof'),
(19583, 4.1,  2.3,  1.9, 'CleftHoove x2.0: Clefthoof Bull'),
(19581, 5.6,  3.4,  1.9, 'CleftHoove x2.5: Aged Clefthoof, Dead Clefthoof'),
(19797, 5.6,  3.4,  1.9, 'CleftHoove x2.5: Amberpelt Clefthoof, Bluff Behemoth, Brokentoe'),
(19585, 8.6,  5.5,  1.9, 'CleftHoove x3.5: Banthar');

-- the rear end of the oval (stock: 3, 6, 7.2, 8, 10, 14)
UPDATE `creature_model_info` SET `CombatReach` = 2.1  WHERE `DisplayID` = 19584;
UPDATE `creature_model_info` SET `CombatReach` = 6    WHERE `DisplayID` IN (19582, 20924);
UPDATE `creature_model_info` SET `CombatReach` = 7.6  WHERE `DisplayID` IN (20822, 20823, 20824, 20825);
UPDATE `creature_model_info` SET `CombatReach` = 8.7  WHERE `DisplayID` = 19583;
UPDATE `creature_model_info` SET `CombatReach` = 11.4 WHERE `DisplayID` IN (19581, 19797);
UPDATE `creature_model_info` SET `CombatReach` = 16.7 WHERE `DisplayID` = 19585;
