--
-- Bat Rider Guard / Gryphon Rider Guard still never fire their ranged weapon.
--
-- rev_1788798208085417800.sql gave both guards a Shoot (6660) row and
-- rev_1788883343410155100.sql moved it onto the canonical SMART_EVENT_RANGE 5-30 shape
-- copied from Redridge Poacher (424) and Dun Garok Rifleman (2345), plus the ranged
-- weapon in creature_equip_template. The event itself is fine - what is missing is the
-- other half of that pattern, the three SMART_ACTION_ALLOW_COMBAT_MOVEMENT bands:
--
--   30-60 yd  -> combat movement on   (close the distance)
--    5-30 yd  -> combat movement off  (stand still and shoot)
--    0-5  yd  -> combat movement on   (fall back to melee)
--
-- Without them AttackStart() hands the guard to MoveChase, which drives straight to
-- melee range and parks there. SMART_EVENT_RANGE tests me->IsInRange(victim, 5, 30),
-- so the shoot row only ever had the fraction of a second the guard spent crossing the
-- band on its way in - which is exactly what was reported: the guards engage, apply
-- Guard's Mark and then melee.
--
-- Rows re-inserted in full so the ordering matches 424/2345.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (15241, 15242) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(15241,0,0,0,9,0,100,0,0,0,4000,4000,30,60,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gryphon Rider Guard - Outside 30 Range - Start Combat Movement'),
(15241,0,1,0,9,0,100,0,0,0,4000,4000,5,30,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gryphon Rider Guard - Within 5-30 Range - Stop Combat Movement'),
(15241,0,2,0,9,0,100,0,0,0,4000,4000,0,5,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gryphon Rider Guard - Within 0-5 Range - Start Combat Movement'),
(15241,0,3,0,9,0,100,0,0,0,2000,4000,5,30,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gryphon Rider Guard - Within 5-30 Range - Cast Shoot'),
(15242,0,0,0,9,0,100,0,0,0,4000,4000,30,60,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bat Rider Guard - Outside 30 Range - Start Combat Movement'),
(15242,0,1,0,9,0,100,0,0,0,4000,4000,5,30,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bat Rider Guard - Within 5-30 Range - Stop Combat Movement'),
(15242,0,2,0,9,0,100,0,0,0,4000,4000,0,5,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bat Rider Guard - Within 0-5 Range - Start Combat Movement'),
(15242,0,3,0,9,0,100,0,0,0,2000,4000,5,30,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bat Rider Guard - Within 5-30 Range - Cast Shoot');
