--
-- An Improper Burial (10913): a burnt corpse stays away for 20 seconds.
--
-- Torching a Slain Auchenai Warrior (21846) or Slain Sha'tar Vindicator (21859) sets it on fire and despawns
-- it 10 s later; it then came back after the spawn's own respawn time, 7 s. The despawn action
-- (SMART_ACTION_FORCE_DESPAWN) takes a forced respawn time in seconds as its second parameter: 20 now.
-- The 10 s of burning before it disappears are unchanged, and so are the spawns' own respawn times.
--
UPDATE `smart_scripts` SET `action_param2` = 20
WHERE `entryorguid` IN (21846, 21859) AND `source_type` = 0 AND `id` = 1 AND `action_type` = 41;
