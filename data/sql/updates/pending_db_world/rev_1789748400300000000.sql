--
-- Gryphon Rider Guards at Honor Hold and Wildhammer Stronghold.
--
-- Retail has 39 of them spread over every Alliance holding in Outland (Wowhead: 9 in Hellfire, 10 in
-- Shadowmoon, 8 in Terokkar, 6 in Nagrand, 5 in Zangarmarsh, 1 in Blade's Edge). The world DB has
-- exactly one, the Allerian Stronghold guard (84492) - the other bases never had any, which is why
-- Honor Hold and Wildhammer Stronghold look unguarded.
--
-- Three at each, same as that one guard: standing garrison, random movement, two minute respawn. The
-- coordinates are Wowhead sightings for Honor Hold and, for the terraced Wildhammer Stronghold, spots
-- taken from the ground NPCs already standing there (Kurdran's courtyard at 94.9, Salle Sunforge's
-- terrace at 102.0, the upper guard post at 110.7) so nobody spawns inside a cliff.
--
DELETE FROM `creature` WHERE `guid` BETWEEN 5330001 AND 5330006;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`,
    `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`,
    `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`) VALUES
(5330001, 15241, 530, 0, 0, 1, 1, 0, -688.30, 2740.40,  93.99, 3.93, 120, 10, 0, 1, 0, 1, 0, 0, 0),
(5330002, 15241, 530, 0, 0, 1, 1, 0, -709.00, 2730.00,  94.19, 5.50, 120, 10, 0, 1, 0, 1, 0, 0, 0),
(5330003, 15241, 530, 0, 0, 1, 1, 0, -709.00, 2606.10,  91.11, 1.57, 120, 10, 0, 1, 0, 1, 0, 0, 0),
(5330004, 15241, 530, 0, 0, 1, 1, 0, -4063.60, 2250.00,  94.91, 1.57, 120, 10, 0, 1, 0, 1, 0, 0, 0),
(5330005, 15241, 530, 0, 0, 1, 1, 0, -3981.60, 2232.00, 101.97, 3.14, 120, 10, 0, 1, 0, 1, 0, 0, 0),
(5330006, 15241, 530, 0, 0, 1, 1, 0, -4021.00, 2226.00, 110.70, 0.00, 120, 10, 0, 1, 0, 1, 0, 0, 0);
