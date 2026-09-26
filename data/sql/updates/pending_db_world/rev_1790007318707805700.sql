--
-- Zombie Infestation: remove the Conspicuous Crates entirely (both the original Booty Bay set and the
-- capital/port set added earlier this event) and stop scripting the shared gameobject_template entry -
-- crates are no longer part of how the plague spreads.
--
DELETE FROM `game_event_gameobject` WHERE `guid` IN (
    5320000, 5320001, 5320002, 5320003, 5320004, 5320005, 5320006,
    5320007, 5320008, 5320009, 5320011, 5320012, 5320013, 5320014, 5320015, 5320016, 5320017
);
DELETE FROM `gameobject` WHERE `guid` IN (
    5320000, 5320001, 5320002, 5320003, 5320004, 5320005, 5320006,
    5320007, 5320008, 5320009, 5320011, 5320012, 5320013, 5320014, 5320015, 5320016, 5320017
);
UPDATE `gameobject_template` SET `ScriptName` = '' WHERE `entry` = 186799;
