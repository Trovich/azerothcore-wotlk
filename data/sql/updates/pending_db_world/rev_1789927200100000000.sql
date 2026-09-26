--
-- Battle for Undercity: three confirmed bugs.
--
-- 1. Both Alliance Flying Machines (31637 in the earlier Wrathgate event, 32388 here) have no
--    creature_template_movement row at all, so they fall back to ground-only movement and sink to the
--    terrain instead of flying. Gunship Hull (37547), a comparable large flying mechanical unit already
--    in this DB, uses Ground=0/Swim=0/Flight=1 - the same here.
--
INSERT INTO `creature_template_movement` (`CreatureId`, `Ground`, `Swim`, `Flight`, `Rooted`, `Chase`, `Random`) VALUES
(31637, 0, 0, 1, 0, 0, 0),
(32388, 0, 0, 1, 0, 0, 0);

--
-- 2. King Varian Wrynn's speed_run (1.42857) is noticeably faster than a player's own run speed,
--    hard to keep up with during the escort. Thrall (32518), the same "hero escorting the party" role
--    on the Horde side of this same event, uses 1.14286 - match it for Varian too.
--
UPDATE `creature_template` SET `speed_run` = 1.14286 WHERE `entry` = 32401;

--
-- 3. Jaina's Water Elementals (10955, spell 20681 "Summon Water Elementals") are meant to fight
--    whatever she's fighting - instead their only smart_scripts row targets SMART_TARGET_CLOSEST_PLAYER
--    (21), so out of combat they beeline for and hover on whichever player is nearest (friendly, so
--    they can't actually land a hit - just permanently "stuck" following) instead of engaging the
--    undead defenders. SMART_TARGET_CLOSEST_ENEMY (25) targets the nearest hostile instead.
--
UPDATE `smart_scripts` SET `target_type` = 25
WHERE `entryorguid` = 10955 AND `source_type` = 0 AND `id` = 0 AND `action_type` = 49;
