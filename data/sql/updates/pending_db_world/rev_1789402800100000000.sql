--
-- Quest 10935 "The Exorcism of Colonel Jules": Darkness Released spawn rate, final pass.
--
-- With the ritual itself working, the skull cadence from rev_1789316400100000000.sql
-- (8-12 s, then one every 15-20 s) reads as too thin. Tripled: first skull after 3-4 s,
-- then one every 5-7 s. Over the ~150 s the summoning phase lasts that is roughly 25
-- skulls instead of 8-9, and with the unchanged 30 s lifetime about 5 of them are up at
-- any time - a steady stream for the prayer beads (39371 one-shots them) without the
-- twenty-strong swarm the 39280 trigger used to produce.
--

UPDATE `smart_scripts` SET `event_param1` = 3000, `event_param2` = 4000, `event_param3` = 5000, `event_param4` = 7000
WHERE `entryorguid` = 22432 AND `source_type` = 0 AND `id` = 7;
