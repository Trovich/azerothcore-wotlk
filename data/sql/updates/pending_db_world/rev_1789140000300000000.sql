--
-- Ironspine Chomper (21816) and Dampscale Devourer (18463) push their heads into the
-- player in melee.
--
-- A chasing creature stops once its centre is CombatReach(self) + CombatReach(target)
-- + CONTACT_DISTANCE away (ChaseMovementGenerator, 1.5 + 0.5 for a player), so a model
-- whose head reaches further forward than its own combat reach ends up inside whatever
-- it is biting. Both use Basilisk_Outland.mdx, whose head sits 2.65 yd in front of the
-- pivot at scale 1 (CreatureModelData 2285 GeoBox), while every basilisk display was
-- given a combat reach of just 1.0 x its scale:
--
--   display  scale  head reach  CombatReach  stops at   -> head inside the player by
--   19695    1.5    3.98 yd     1.5          3.5 yd        ~0.5 yd + body
--   17812    1.15   3.05 yd     1.15         3.15 yd       ~0.4 yd (body)
--
-- Combat reach set to 2.0 x scale, which stops them with the head just clear of the
-- target (19695 at 5.0 yd, 17812 at 4.3 yd). Display 19695 is shared with Craghide
-- Basilisk, which gets the same correction.
--

UPDATE `creature_model_info` SET `CombatReach` = 3.0 WHERE `DisplayID` = 19695;
UPDATE `creature_model_info` SET `CombatReach` = 2.3 WHERE `DisplayID` = 17812;
