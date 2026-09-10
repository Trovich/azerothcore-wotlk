--
-- Gryphon Rider Guard (15241) hovers in place instead of flying a patrol.
--
-- creature_template_movement has `Rooted` = 1 for this NPC, so the core forbids
-- it any movement at all - it just hangs in the air over the camp. Every other
-- Flight = 1 / Rooted = 1 row in that table is a totem, a trigger, a boss meant
-- to stay put or a piece of scenery; the Alliance flying guard is the only
-- mobile NPC in the list, and its direct Horde counterpart Bat Rider Guard
-- (15242) has Rooted = 0.
--
-- Its single spawn is also MovementType 0 (idle) with wander_distance 0. The
-- twelve non-patrolling Bat Rider Guards are all MovementType 1 with
-- wander_distance 5, so the spawn is aligned with them.
--
-- Note: this NPC has exactly one spawn in the whole world (Telaar, Nagrand)
-- against sixteen Bat Rider Guards - four of which fly real waypoint patrols
-- (creature_addon.path_id 548400/548410/548420/548430). Adding matching
-- Alliance patrol routes is a separate, larger change and is not done here.
--
-- Related upstream report: azerothcore/azerothcore-wotlk#19589 (flying guards do
-- not attack opposite faction players) - a different defect on the same NPCs.
--

UPDATE `creature_template_movement` SET `Rooted` = 0 WHERE `CreatureId` = 15241;

UPDATE `creature` SET `MovementType` = 1, `wander_distance` = 5 WHERE `id` = 15241 AND `MovementType` = 0;
