--
-- Gryphon Rider Guards - corrected positions, and Pit Commander's render distance.
--
-- 1. rev_1789748400300000000.sql placed three new guards each at Honor Hold and Wildhammer Stronghold
--    at street level, next to the infantry - invisible to a player looking for them, because a real
--    Gryphon Rider Guard perches above, over the wall. Proof is in our own data: the one guard that
--    already worked, Allerian Stronghold's 84492 (-2902.96, 3932.89, z=38.91), sits exactly on the X/Y
--    of gameobject-less trigger creature "Air Force Guard Post (Alliance - Gryphon)" 76888 (same X/Y,
--    z=23.82) - the landing-post marker for the Air Force Field ("Take to the Skies") gryphon check.
--    Every base has one such post per intended gryphon rider, at a consistent ~15.09 yd higher perch:
--    Allerian has 6 posts (1 already guarded), Honor Hold 4, Wildhammer Stronghold 3 - matching
--    Wowhead's zone sighting counts closely once the whole cluster per base is counted, not just the
--    ones near the exact fort building. The three misplaced Honor Hold/Wildhammer rows are replaced and
--    Allerian's five missing riders are added, all anchored on their own post's X/Y + 15.09 yd.
--
DELETE FROM `creature` WHERE `guid` BETWEEN 5330001 AND 5330012;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`,
    `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`,
    `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`) VALUES
-- Allerian Stronghold (Terokkar Forest) - posts 76889, 76890, 76891, 76892, 76893 (76888 already has 84492)
(5330001, 15241, 530, 0, 0, 1, 1, 0, -2897.60, 3979.81, 40.13, 3.66, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330002, 15241, 530, 0, 0, 1, 1, 0, -2917.44, 3996.81, 40.13, 4.10, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330003, 15241, 530, 0, 0, 1, 1, 0, -3004.95, 3991.58, 68.64, 5.64, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330004, 15241, 530, 0, 0, 1, 1, 0, -2989.65, 3867.69, 57.27, 1.12, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330005, 15241, 530, 0, 0, 1, 1, 0, -2996.56, 4036.64, 42.34, 5.21, 120, 5, 0, 1, 0, 1, 0, 0, 0),
-- Honor Hold (Hellfire Peninsula) - posts 76851, 76853, 76854, 76855
(5330006, 15241, 530, 0, 0, 1, 1, 0, -738.38, 2658.80, 147.88, 0.01, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330007, 15241, 530, 0, 0, 1, 1, 0, -707.74, 2723.40, 127.61, 5.66, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330008, 15241, 530, 0, 0, 1, 1, 0, -701.16, 2656.83, 119.01, 0.04, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330009, 15241, 530, 0, 0, 1, 1, 0, -714.09, 2603.27, 120.72, 0.54, 120, 5, 0, 1, 0, 1, 0, 0, 0),
-- Wildhammer Stronghold (Shadowmoon Valley) - posts 76873, 76875, 76876
(5330010, 15241, 530, 0, 0, 1, 1, 0, -3970.95, 2286.73, 188.82, 4.04, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330011, 15241, 530, 0, 0, 1, 1, 0, -4081.20, 2181.06, 163.72, 0.70, 120, 5, 0, 1, 0, 1, 0, 0, 0),
(5330012, 15241, 530, 0, 0, 1, 1, 0, -4041.43, 2235.01, 158.37, 0.35, 120, 5, 0, 1, 0, 1, 0, 0, 0);

--
-- 2. Pit Commander (18945, guid 68001, Dark Portal battle) rendered only at normal distance while the
--    Fel Reaver he stands next to is zone-wide visible (visibilityDistanceType 5) - a boss-sized demon
--    should be seen from as far as the reaver he commands.
--
DELETE FROM `creature_addon` WHERE `guid` = 68001;
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `visibilityDistanceType`, `auras`) VALUES
(68001, 0, 0, 0, 1, 0, 5, '');
