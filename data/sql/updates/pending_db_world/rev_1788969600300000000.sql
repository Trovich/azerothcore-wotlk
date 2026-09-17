--
-- Quest 9730 "Stealing Back the Mushrooms" - the Hungry Bog Lord (17955) plays his
-- second "eats the mushroom" emote while already running away.
--
-- Watcher Leesa'oh's timed action list 1783100 summons him at id 4 and then drives both
-- of his lines remotely (creature_text 17955, both Type 16 / Emote 36 ONESHOT_ATTACK1H):
--
--   list t+16.0s  summon 17955 at (-362.376, 8215.58, 25.2591)
--   list t+24.0s  group 0  "takes a piece of the mushroom tree"       = summon T+8s
--   list t+38.0s  group 1  "uproots the rest and makes off with it"   = summon T+22s
--
-- His own script starts waypoint path 17955 on SMART_EVENT_JUST_SUMMONED with
-- ForcedMovement = RUN and pauses 11500 ms on reaching point 9. Spawn point to point 9
-- is ~60 yd of path at speed_run 1.14286 x 7.0 = 8.0 yd/s, so he stands still from
-- roughly T+7.5s to T+19s: group 0 lands during the pause, group 1 lands 3 s after he
-- has already set off - the attack animation plays mid-stride, which is what was
-- reported.
--
-- Pause widened to 19000 ms so group 1 always fires while he is still standing at the
-- mushroom, and he leaves a couple of seconds later.
--
-- The summon lifetime has to grow with it. He is a TEMPSUMMON_TIMED_OR_DEAD_DESPAWN with
-- 30000 ms, and point 9 -> point 23 is ~130 yd = ~16 s of running: even at the current
-- 11.5 s pause he vanishes in mid-air at T+30s instead of reaching the end of his path,
-- and the despawn row on point 23 never runs. 50000 ms covers the whole walk out with a
-- few seconds to spare.
--

UPDATE `smart_scripts` SET `action_param1` = 19000
WHERE `entryorguid` = 17955 AND `source_type` = 0 AND `id` = 1;

UPDATE `smart_scripts` SET `action_param3` = 50000
WHERE `entryorguid` = 1783100 AND `source_type` = 9 AND `id` = 4;
