--
-- Decrepit Clefthoof (22105) and Tame Clefthoof (22135): melee range of a creature the size of a man.
--
-- Two clefthoof displays had an empty creature_model_info row (BoundingRadius 0, CombatReach 0); the core then
-- falls back to the default combat reach of 1.5 yd, so the beast and its attacker had to stand inside the
-- model. Half of the Decrepit Clefthoofs use display 20924 (the other half 19582, which was fine).
-- Both displays are the same CleftHoove model as their neighbours, at the same display scale:
--   20924: scale 1.5, like 19582 (Clefthoof)            -> 0.45 / 6
--   20825: scale 1.8, like 20822-20824 (Tame Clefthoof) -> 0.54 / 7.2
--
UPDATE `creature_model_info` SET `BoundingRadius` = 0.45, `CombatReach` = 6 WHERE `DisplayID` = 20924;
UPDATE `creature_model_info` SET `BoundingRadius` = 0.54, `CombatReach` = 7.2 WHERE `DisplayID` = 20825;
