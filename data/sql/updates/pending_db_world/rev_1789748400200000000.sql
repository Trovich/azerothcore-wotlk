--
-- Every campfire gives Cozy Fire, and the Rod of Purification stops being wasted.
--
-- 1. Cozy Fire. The cooking-made Basic Campfire (29784) carries a linked trap that casts Cozy Fire on
--    everyone around it; the 843 campfire objects standing in the world carry none, so sitting at one
--    of them did nothing. They now link the same kind of trap. 31510 is the one to link, not 31442:
--    both cast Cozy Fire (7358 / 7353 are the same spell twice), but 31442 carries a visible rock model
--    that would appear next to every fire, while 31510 has no model at all. Restricted to objects that
--    really are campfires - a cooking fire (spellFocus 4) named "... Campfire" with no trap of its own.
--
UPDATE `gameobject_template` SET `Data2` = 31510
WHERE `type` = 8 AND `Data0` = 4 AND `Data2` = 0 AND `name` LIKE '%Campfire%';

--
-- 2. Veil Skith: Darkstone of Terokk (10839). The rod's aura lands on a trigger creature that stands
--    there whether the stone does or not, so the rod could be "used" on a stone somebody else had
--    already purified - nothing happened and the player had no way of telling why. The stone is also
--    one object for a whole party, and it stays down for three minutes, so only the first one through
--    got the quest. Two scripts fix both: the item spell refuses to fire without a stone in
--    range, and the purification credits every party member standing by it.
--
DELETE FROM `spell_script_names` WHERE `spell_id` IN (38736, 38729)
    AND `ScriptName` IN ('spell_q10839_rod_of_purification', 'spell_q10839_purify_darkstone');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(38736, 'spell_q10839_rod_of_purification'),
(38729, 'spell_q10839_purify_darkstone');
