--
-- Custom light objects (gameobject entries 900100-900199): visible in every phase.
--
-- Other characters saw part of the lights only in GM mode. ".gobject add" spawns in the phase of the GM who
-- places the object (Player::GetPhaseMaskForSpawn), and that function drops the normal phase whenever the GM
-- has a phase aura. mod-individual-progression keeps such an aura on every character - "Phase Shift: IPP",
-- masks 65537, 131073, 262145, ... = normal phase + the character's progression bit - so a light placed by a
-- character in progression phase III went into phase 262144 alone: seen by him and by whoever shares that
-- progression, by nobody else. In the table at the time of writing: 287 lights in phase 262144 (Stormwind),
-- 181 in phase 128 and 1 in 131200 (Tirisfal / the Plaguelands), 2118 in the normal phase.
--
-- A light is scenery: it belongs to all phases (4294967295 = PHASEMASK_ANYWHERE).
--
UPDATE `gameobject` SET `phaseMask` = 4294967295 WHERE `id` BETWEEN 900100 AND 900199;

--
-- And for the lights placed from now on: the row is corrected as it is written. ".gobject add" saves the new
-- object and loads it back from the table straight away, so the light is in every phase the moment it is
-- placed (the same on ".gobject move" / ".gobject turn", which save the row again). Only for these entries.
--
DROP TRIGGER IF EXISTS `gameobject_custom_lights_all_phases`;
CREATE TRIGGER `gameobject_custom_lights_all_phases` BEFORE INSERT ON `gameobject` FOR EACH ROW
    SET NEW.`phaseMask` = IF(NEW.`id` BETWEEN 900100 AND 900199, 4294967295, NEW.`phaseMask`);
