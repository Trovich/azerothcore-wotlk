--
-- Burster worms: root them while they are above ground.
--
-- Crust Burster (16844), Greater Crust Burster (21380), Nethermine Burster
-- (23285) and Tunneler (16968) burrow under the ground and surface when they
-- aggro. Once surfaced they must stay put and fight at range - on retail they
-- never slide/crawl after a kiting player while sticking out of the ground.
--
-- 16844/21380/23285 tried to achieve that with SMART_ACTION_STOP_MOTION (212),
-- which only cancels the *current* spline: the chase motion generator simply
-- issues a new one on the next reposition tick, so the worm creeps after the
-- player anyway. Tunneler (16968) had no stationary handling at all.
--
-- The working pattern is already in the DB on the three sibling worms that were
-- fixed earlier - Marauding Crust Burster (16857), Fulgorge (18678) and Serfex
-- the Reaver (28083): SMART_ACTION_SET_ROOT (103) on aggro, cleared again on
-- reset. Rooting makes Unit::CanFreeMove() false, so the reposition handler
-- never fires. Evade is unaffected: HomeMovementGenerator::DoInitialize() clears
-- UNIT_STATE_ROOT before launching the walk home.
--
-- Upstream reports: azerothcore/azerothcore-wotlk#19001 (Crust Burster moving in
-- melee range, same SQL approach proposed there), #23088 (Nethermine Burster
-- shouldn't move while above ground), #14473 (sandworm behaviour).
--

-- Crust Burster
DELETE FROM `smart_scripts` WHERE `entryorguid` = 16844 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(16844,0,0,1,25,0,100,512,0,0,0,0,0,0,18,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Reset - Set Unit Flag'),
(16844,0,1,2,61,0,100,512,0,0,0,0,0,0,19,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Reset - Remove Unit Flag'),
(16844,0,2,3,61,0,100,512,0,0,0,0,0,0,11,29147,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Reset - Cast Tunnel Bore Passive'),
(16844,0,3,11,61,0,100,512,0,0,0,0,0,0,90,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Reset - Set Bytes0'),
(16844,0,4,5,4,0,100,512,0,0,0,0,0,0,19,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Aggro - Remove Unit Flag'),
(16844,0,5,6,61,0,100,512,0,0,0,0,0,0,18,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Aggro - Set Unit Flag'),
(16844,0,6,7,61,0,100,512,0,0,0,0,0,0,28,29147,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Aggro - Remove Aura Tunnel Bore Passive'),
(16844,0,7,0,61,0,100,512,0,0,0,0,0,0,103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Aggro - Set Rooted On'),
(16844,0,8,0,0,0,100,513,100,100,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - In Combat - Remove Bytes0'),
(16844,0,9,0,0,0,100,0,1000,6000,8000,11000,0,0,11,32738,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crust Burster - In Combat - Cast Bore'),
(16844,0,10,0,9,0,100,0,0,0,2000,3500,4,50,11,31747,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crust Burster - Within Range 5-50yd - Cast Poison'),
(16844,0,11,0,61,0,100,0,0,0,0,0,0,0,103,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crust Burster - On Reset - Set Rooted Off');

-- Greater Crust Burster
DELETE FROM `smart_scripts` WHERE `entryorguid` = 21380 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(21380,0,0,1,25,0,100,512,0,0,0,0,0,0,18,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Reset - Set Unit Flag'),
(21380,0,1,2,61,0,100,512,0,0,0,0,0,0,19,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Reset - Remove Unit Flag'),
(21380,0,2,3,61,0,100,512,0,0,0,0,0,0,11,29147,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Reset - Cast Tunnel Bore Passive'),
(21380,0,3,11,61,0,100,512,0,0,0,0,0,0,90,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Reset - Set Bytes0'),
(21380,0,4,5,4,0,100,512,0,0,0,0,0,0,19,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Aggro - Remove Unit Flag'),
(21380,0,5,6,61,0,100,512,0,0,0,0,0,0,18,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Aggro - Set Unit Flag'),
(21380,0,6,7,61,0,100,512,0,0,0,0,0,0,28,29147,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Aggro - Remove Aura Tunnel Bore Passive'),
(21380,0,7,0,61,0,100,512,0,0,0,0,0,0,103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Aggro - Set Rooted On'),
(21380,0,8,0,0,0,100,513,100,100,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - In Combat - Remove Bytes0'),
(21380,0,9,0,0,0,100,0,1000,6000,8000,11000,0,0,11,32738,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Greater Crust Burster - In Combat - Cast Bore'),
(21380,0,10,0,9,0,100,0,0,0,2000,3500,4,50,11,31747,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Greater Crust Burster - Within Range 5-50yd - Cast Poison'),
(21380,0,11,0,61,0,100,0,0,0,0,0,0,0,103,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greater Crust Burster - On Reset - Set Rooted Off');

-- Nethermine Burster
DELETE FROM `smart_scripts` WHERE `entryorguid` = 23285 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(23285,0,0,1,25,0,100,512,0,0,0,0,0,0,18,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Reset - Set Unit Flag'),
(23285,0,1,2,61,0,100,512,0,0,0,0,0,0,19,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Reset - Remove Unit Flag'),
(23285,0,2,3,61,0,100,512,0,0,0,0,0,0,11,29147,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Reset - Cast Tunnel Bore Passive'),
(23285,0,3,11,61,0,100,512,0,0,0,0,0,0,90,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Reset - Set Bytes0'),
(23285,0,4,5,4,0,100,512,0,0,0,0,0,0,19,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Aggro - Remove Unit Flag'),
(23285,0,5,6,61,0,100,512,0,0,0,0,0,0,18,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Aggro - Set Unit Flag'),
(23285,0,6,7,61,0,100,512,0,0,0,0,0,0,28,29147,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Aggro - Remove Aura Tunnel Bore Passive'),
(23285,0,7,0,61,0,100,512,0,0,0,0,0,0,103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Aggro - Set Rooted On'),
(23285,0,8,0,0,0,100,513,100,100,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - In Combat - Remove Bytes0'),
(23285,0,9,0,0,0,100,0,1000,6000,8000,11000,0,0,11,32738,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethermine Burster - In Combat - Cast Bore'),
(23285,0,10,0,9,0,100,0,0,0,2000,3500,4,50,11,31747,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethermine Burster - Within Range 5-50yd - Cast Poison'),
(23285,0,11,0,61,0,100,0,0,0,0,0,0,0,103,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethermine Burster - On Reset - Set Rooted Off');

-- Tunneler
DELETE FROM `smart_scripts` WHERE `entryorguid` = 16968 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(16968,0,0,1,25,0,100,512,0,0,0,0,0,0,18,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Reset - Set Flags Not Selectable'),
(16968,0,1,2,61,0,100,512,0,0,0,0,0,0,11,29147,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Reset - Cast \'Tunnel Bore Passive\''),
(16968,0,2,8,61,0,100,512,0,0,0,0,0,0,90,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Reset - Set Flag Standstate Submerged'),
(16968,0,3,4,4,0,100,512,0,0,0,0,0,0,19,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Aggro - Remove Flags Not Selectable'),
(16968,0,4,5,61,0,100,512,0,0,0,0,0,0,28,29147,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Aggro - Remove Aura \'Tunnel Bore Passive\''),
(16968,0,5,9,61,0,100,513,0,0,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Aggro - Remove FlagStandstate Submerged'),
(16968,0,6,0,0,0,100,0,1000,6000,8000,11000,0,0,11,32738,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tunneler - In Combat - Cast \'Bore\''),
(16968,0,7,0,9,0,100,0,0,0,2000,3500,4,50,11,31747,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tunneler - Within 4-50 Range - Cast \'Poison\''),
(16968,0,8,0,61,0,100,0,0,0,0,0,0,0,103,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Reset - Set Rooted Off'),
(16968,0,9,0,61,0,100,512,0,0,0,0,0,0,103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tunneler - On Aggro - Set Rooted On');
