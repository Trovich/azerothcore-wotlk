--
-- Two Outland quest fixes.
--
-- 1. What Book? I Don't See Any Book. (10231): only the player who talked "Dirty" Larry into the fight got
--    the quest. Larry's script credited it with SMART_ACTION_CALL_AREAEXPLOREDOREVENTHAPPENS (15) on the stored
--    gossip player alone. SMART_ACTION_CALL_GROUPEVENTHAPPENS (26) on the same target calls
--    Player::GroupEventHappens(): every group member within group reward distance who has the quest gets it;
--    without a group it falls back to the single player, as before.
--
UPDATE `smart_scripts` SET `action_type` = 26,
    `comment` = '''Dirty'' Larry - Between 0-20% Health - Quest Credit ''What Book? I Don''t See Any Book.'' (group)'
WHERE `entryorguid` = 19720 AND `source_type` = 0 AND `id` = 22 AND `action_type` = 15;

--
-- 2. Taken in the Night (10873): the chance that a Netherweb Victim (22355) holds a Freed Sha'tar Warrior is
--    now ONE number - the event_chance of row 0 below (percent).
--
--    Before, a victim's death made two random draws of "timed event" ids: one from 1-3 (1 = the warrior,
--    2 = Broken Skeleton, 3 = Auchenai Death-Speaker) and one from 2-6 (the five hostile creatures). The
--    warrior came from the first draw only, 1 in 3, and that could not be tuned without adding rows.
--    Row 0 now casts the warrior's summon spell (38978) directly with event_chance percent; row 1 still
--    draws one hostile creature from 2-6 for every victim. Timed event row 2 (id 1, the warrior) stays in
--    place but nothing draws it any more.
--
--    To change the chance later:
--      UPDATE smart_scripts SET event_chance = <percent> WHERE entryorguid = 22355 AND source_type = 0 AND id = 0;
--    then ".reload smart_scripts" in game (applies to victims spawned after it).
--
UPDATE `smart_scripts` SET `event_chance` = 50, `action_type` = 11, `action_param1` = 38978, `action_param2` = 2,
    `comment` = 'Netherweb Victim - On Death - Cast Terokkar Free Webbed Creature (Freed Sha''tar Warrior, event_chance = chance in %)'
WHERE `entryorguid` = 22355 AND `source_type` = 0 AND `id` = 0;
