--
-- Quest 9718 "As the Crow Flies" - crow form hangs on for several seconds
-- after landing, before finally reverting.
--
-- Ysiel Windsinger's removal event (SMART_EVENT_OOC_LOS, entry 17841 row 0)
-- has cooldownMin/cooldownMax (event_param3/4) both set to 10000ms. The taxi
-- path (512) loops back close to her position during its final descent, well
-- before actual touchdown - so the very first in-range proximity check can
-- fire early and immediately re-arm a 10s cooldown, which can still be
-- counting down by the time the player actually lands. The observed lag
-- matches this: not a fixed amount, but "however much of that 10s window was
-- still left."
--
-- Dropped to 0/0. This is a one-shot removal (the action clears the aura, so
-- there is nothing left for a second trigger to do) - the cooldown was never
-- protecting against a repeat, only delaying the one trigger that matters.
--

DELETE FROM `smart_scripts` WHERE `entryorguid` = 17841 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(17841,0,0,0,10,0,100,512,1,30,0,0,0,0,28,31746,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ysiel Windsinger - Out of Combat - Remove Aura Stormcrow Shape');
