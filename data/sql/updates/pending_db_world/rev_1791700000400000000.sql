--
-- Blackrock Depths: two orphaned Anvilrage formations ("creature_formations table leader guid 45875 / 47799
-- incorrect (does not exist)" at startup).
--
-- The packs (Officer 45875 / 47799 with Soldiers, Medic, Footman 45876-45879 / 47800-47803) were spawned by
-- mod-individual-progression (data/sql/world/base/dungeon_blackrock_depths.sql), which also gave them these
-- formations. AzerothCore's 2026_09_24_09 ("BRD Bael'Gar corridor patrols from 2.5.6.69110 sniff") deleted the
-- ten creatures as duplicate snapshots of the long patrol 47786 / path 4778600 and their addons, but not the
-- module's formation rows. No other formation in acore_world has a missing leader or member.
--
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (45875, 47799);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (45875, 45876, 45877, 45878, 45879, 47799, 47800, 47801, 47802, 47803);
