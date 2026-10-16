--
-- Nagrand: four Aged Clefthoof (17133) that are meant to be carcasses - spawns 670001-670004.
--
-- AzerothCore has them lying (stand state "dead", dead emote) and unattackable (unit_flags 258), but without the aura
-- that makes a creature a corpse, so they showed as living beasts lying on the grass: a name, selectable, nothing
-- to do with them. The cMaNGOS TBC database has the same four spawns (its guids 5304035-5304038, same places)
-- with Permanent Feign Death 29266, which gives the dead look: no name plate, not selectable.
--

UPDATE `creature_addon` SET `auras` = '29266' WHERE `guid` IN (670001, 670002, 670003, 670004) AND (`auras` IS NULL OR `auras` = '' OR `auras` = '29266');
