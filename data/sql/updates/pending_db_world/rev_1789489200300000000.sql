--
-- Outland basilisks walk their heads into the player in melee - the rest of the family.
--
-- rev_1789140000300000000.sql fixed the two reported displays (Ironspine Chomper 19695,
-- Dampscale Devourer 17812). Every other display of Basilisk_Outland.mdx
-- (CreatureModelData 2285, head 2.65 yd in front of the pivot at scale 1) has the same
-- combat reach of 1.0 x scale - or none at all - so the rest of the family (Ironspine
-- Petrifier included) stops with its head inside its target. Same correction: combat reach
-- 2.0 x the display scale.
--
--   display  scale  creatures                                                  reach
--   16876    1.0    Dampscale Basilisk, Ruuan Weald Basilisk, ...               1.0 -> 2.0
--   16877    1.0    Scalded Basilisk, ...                                       1.0 -> 2.0
--   16878    1.0    Ironspine Petrifier, ...                                    1.0 -> 2.0
--   16879    1.0    Grishnath Basilisk, Ironspine/Marshrock/Ragestone ...       1.0 -> 2.0
--   18042    1.5    Stonegazer                                                  1.5 -> 3.0
--   19163    1.3    Ironspine Gazer                                             1.3 -> 2.6
--   19875    2.0    Mutated Netherlisk                                          0   -> 4.0
--   20844    2.5    Outland Basilisk Giant (Violet)                             0   -> 5.0
--   20848    2.5    Outland Basilisk Giant (Yellow)                             0   -> 5.0
--   20849    2.5    Bladespine Basilisk, Ironclaw Basilisk                      2.5 -> 5.0
--
-- 20530 also points at model 2285 but belongs to the Proto-Nether Drake; left alone.
--

UPDATE `creature_model_info` SET `CombatReach` = 2.0 WHERE `DisplayID` IN (16876, 16877, 16878, 16879);
UPDATE `creature_model_info` SET `CombatReach` = 3.0 WHERE `DisplayID` = 18042;
UPDATE `creature_model_info` SET `CombatReach` = 2.6 WHERE `DisplayID` = 19163;
UPDATE `creature_model_info` SET `CombatReach` = 4.0 WHERE `DisplayID` = 19875;
UPDATE `creature_model_info` SET `CombatReach` = 5.0 WHERE `DisplayID` IN (20844, 20848, 20849);
