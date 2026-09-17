--
-- Skithian Dreadhawk (18452) stops dead and never attacks when something is between it
-- and its target.
--
-- It still runs the legacy "thrower" SmartAI template: combat movement disabled out of
-- combat, then SMART_ACTION_ALLOW_COMBAT_MOVEMENT toggled by distance bands - 25-80 yd on,
-- 5-15 yd off (plus auto-attack off), 0-5 yd on - with Throw (10277) cast in the 5-30 yd
-- band. That leaves two traps:
--
--   * 15-25 yd has no band at all, so a Dreadhawk pulled from there keeps the movement
--     lock it spawned with;
--   * the bands only look at distance. Behind a tree or a rock Throw fails on line of
--     sight, but the 5-15 band keeps re-locking movement every tick, so nothing ever
--     walks it round the obstacle.
--
-- Either way it just stands there. Replaced with the current core pattern upstream uses
-- for throwers (Bloodscalp Hunter 595, Witherbark Scalper 2649): one in-combat Throw with
-- SMARTCAST_COMBAT_MOVE. SmartAI then keeps it at Throw range on its own, closes in when
-- the target is out of range or out of sight, and melees when it is in melee range. Wing
-- Clip and the 15% flee are kept; the phase bookkeeping and sheath swaps that only served
-- the bands are gone.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 18452 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18452,0,0,0,0,0,100,0,0,0,2300,3900,0,0,11,10277,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Skithian Dreadhawk - In Combat CMC - Cast \'Throw\''),
(18452,0,1,0,0,0,100,0,5000,8000,14000,18000,0,0,11,32908,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Skithian Dreadhawk - In Combat - Cast \'Wing Clip\''),
(18452,0,2,0,2,0,100,1,0,15,0,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Skithian Dreadhawk - Between 0-15% Health - Flee For Assist (No Repeat)');
