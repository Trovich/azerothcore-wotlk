--
-- Digging Through Bones (10922): the researchers keep their places round Letoll, fight back, and the
-- Bone Sifter stays put.
--
-- 1. Formation. The four Explorers' League Researchers (22464) follow Chief Archaeologist Letoll (22458)
--    with SMART_ACTION_FOLLOW at angles 0/90/180/270 - but at distance 0 (the core adds 0.1 plus the
--    model's combat reach), i.e. all four aim ~1.6 yd from him. Standing at their spawn points they look
--    right (a ring of ~4 yd round him); the moment he walks off they close in and bunch up on him. Distance
--    3 puts them ~4.6 yd out, the ring they start in. Both places that start the follow (the start of the
--    escort and after the dig) use these same four rows.
--
-- 2. Fighting back. Letoll and the researchers are faction 35, friendly to everything - monsters
--    included - so the researchers never lift a hand against the Scorpid Bonecrawlers (faction 413) on
--    the way. When the escort sets off the researchers now take faction 250 (escortee, neutral, active:
--    friendly to players of both sides, hostile to monsters and they to it; FactionTemplate.dbc checked
--    both ways against 413 and the Bone Sifter's 14). Only for the escort: they despawn at its end and
--    respawn with 35, so at the camp they do not start fights with passing monsters. After a fight
--    SmartAI resumes the follow, and the follower catch-up in the core closes the gap again.
--
-- 3. Bone Sifter (22466), the worm Letoll's Fumper Trap (39217) summons at the end. It tunnels, not
--    selectable, to a fixed spot and only there surfaces and sets UNIT_FLAG_DISABLE_MOVE. It is aggressive
--    all the way, though: if it aggroes first (the player is right there), SmartAI::AttackStart drops the
--    point movement and starts MoveChase - the flag is not set yet - and it crawls after the player
--    underground, never reaching its spot. The standing Bone Wastes worms (Bone Crawler 21849, Mature Bone
--    Sifter 22482, Hai'shulud 22038) do not do this: their aggro event sets UNIT_FLAG_DISABLE_MOVE inside
--    Attack(), before AttackStart calls MoveChase, which then refuses to start. Bone Sifter now does the
--    same on aggro - surfaces where it is, sets the flag - and is also rooted like the Hellfire worms
--    (rev_1788746493319826600.sql: SMART_ACTION_SET_ROOT, root cleared on reset). Rooted on arrival as well.
--

-- 1. formation distance
UPDATE `smart_scripts` SET `action_param1` = 3
WHERE `entryorguid` = 22464 AND `source_type` = 0 AND `id` IN (0, 1, 2, 3) AND `action_type` = 29;

-- 2. researchers turn "active escortee" when the escort sets off (end of Letoll's first waypoint script)
DELETE FROM `smart_scripts` WHERE `entryorguid` = 2245800 AND `source_type` = 9 AND `id` = 7;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(2245800,9,7,0,0,0,100,0,0,0,0,0,0,0,2,250,0,0,0,0,0,11,22464,30,0,0,0,0,0,0,'Chief Archaeologist Letoll - On Script - Set Faction Escortee Active (Researchers)');

-- 3. Bone Sifter: surface and root on aggro, root on arrival, unroot on reset
UPDATE `smart_scripts` SET `link` = 18 WHERE `entryorguid` = 22466 AND `source_type` = 0 AND `id` = 8;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 22466 AND `source_type` = 0 AND `id` IN (9, 10, 14, 15, 16, 17, 18);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22466,0,9,10,4,0,100,512,0,0,0,0,0,0,19,33554432,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bone Sifter - On Aggro - Remove Unit Flag Not Selectable'),
(22466,0,10,14,61,0,100,512,0,0,0,0,0,0,18,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bone Sifter - On Aggro - Set Unit Flag Disable Move'),
(22466,0,14,15,61,0,100,512,0,0,0,0,0,0,28,37989,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bone Sifter - On Aggro - Remove Aura Tunnel Bore Passive'),
(22466,0,15,16,61,0,100,512,0,0,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bone Sifter - On Aggro - Remove Bytes0'),
(22466,0,16,0,61,0,100,512,0,0,0,0,0,0,103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bone Sifter - On Aggro - Set Rooted On'),
(22466,0,17,0,25,0,100,0,0,0,0,0,0,0,103,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bone Sifter - On Reset - Set Rooted Off'),
(22466,0,18,0,61,0,100,512,0,0,0,0,0,0,103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bone Sifter - Movement Inform - Set Rooted On');
