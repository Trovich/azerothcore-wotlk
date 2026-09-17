--
-- Quest 10935 "The Exorcism of Colonel Jules", part 4: still too many skulls.
--
-- With the despawn fix from rev_1788969600400000000.sql the skulls no longer pile up,
-- but at one Darkness Released every 9-14 s over a ~150 s ritual a group still faces
-- about a dozen of them in sequence, faster than they can be killed. Spawn rate cut to
-- a third: first skull after 15-25 s, then one every 30-40 s (was 5-10 s / 9-14 s).
-- With the unchanged 30 s lifetime that is 4-5 skulls over the whole ritual instead of
-- ~13, and rarely more than one alive at a time.
--

UPDATE `smart_scripts` SET `event_param1` = 15000, `event_param2` = 25000, `event_param3` = 30000, `event_param4` = 40000
WHERE `entryorguid` = 22432 AND `source_type` = 0 AND `id` = 7;
