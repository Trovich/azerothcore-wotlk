--
-- Starting zones and the level 10 flight path chains: every quest is open to every race of its faction.
--
-- Most starting-zone quests already allow the whole faction (AllowableRaces 690 = Horde, 1101 = Alliance,
-- 0 = everyone). The ones below were bound to the zone's own race:
--   2 orc, 4 dwarf, 8 night elf, 16 undead, 32 tauren, 64 gnome, 128 troll, 512 blood elf, 1024 draenei.
--

-- Horde ------------------------------------------------------------------------------------------------------
-- Deathknell: Rude Awakening. Mulgore: the three well cleansings, Journey to the Crossroads.
-- Sunstrider Isle: the whole zone chain and the per-class "Well Watcher Solanian" (10068-10073, each still
-- bound to its class).
UPDATE `quest_template` SET `AllowableRaces` = 690 WHERE `AllowableRaces` IN (16, 32, 512) AND `ID` IN
(363,
 754, 758, 760, 854,
 8325, 8326, 8327, 8330, 8334, 8335, 8336, 8338, 8345, 8347, 10068, 10069, 10070, 10071, 10072, 10073);

-- Alliance ---------------------------------------------------------------------------------------------------
-- Azuremyst Isle: Medicinal Purpose -> An Alternative Alternative -> The Prophecy of Velen.
UPDATE `quest_template` SET `AllowableRaces` = 1101 WHERE `AllowableRaces` = 1024 AND `ID` IN (9463, 9473, 9505);

--
-- The level 1-2 "go to your class trainer" quests (each stays bound to its class).
--
-- One race in the zone: its quests go to the whole faction.
--   Northshire (human):          3100 warrior, 3101 paladin, 3102 rogue, 3103 priest, 3104 mage, 3105 warlock
--   Sunstrider Isle (blood elf): 8328 mage, 8563 warlock, 8564 priest, 9392 rogue, 9393 hunter, 9676 paladin
-- Two races in the zone, each with its own quest from the same NPC: where a class has both versions, the
-- zone's "second" race (gnome, troll) keeps its own and everybody else gets the other one, so that nobody is
-- offered the same quest twice.
--   Coldridge Valley: dwarf 3106 warrior, 3109 rogue -> all but gnomes (1101 - 64 = 1037);
--                     gnome 3112 warrior, 3113 rogue unchanged;
--                     dwarf 3107 paladin, 3108 hunter, 3110 priest, gnome 3114 mage, 3115 warlock -> 1101
--   Valley of Trials: orc 2383 warrior, 3087 hunter, 3088 rogue, 3089 shaman -> all but trolls (690 - 128 = 562);
--                     troll 3065 warrior, 3082 hunter, 3083 rogue, 3084 shaman unchanged;
--                     orc 3090 warlock, troll 3085 priest, 3086 mage -> 690
--
UPDATE `quest_template` SET `AllowableRaces` = 1101 WHERE `AllowableRaces` IN (1, 4, 64) AND `ID` IN
(3100, 3101, 3102, 3103, 3104, 3105, 3107, 3108, 3110, 3114, 3115);
UPDATE `quest_template` SET `AllowableRaces` = 1037 WHERE `AllowableRaces` = 4 AND `ID` IN (3106, 3109);
UPDATE `quest_template` SET `AllowableRaces` = 690 WHERE `AllowableRaces` IN (2, 128, 512) AND `ID` IN
(3085, 3086, 3090, 8328, 8563, 8564, 9392, 9393, 9676);
UPDATE `quest_template` SET `AllowableRaces` = 562 WHERE `AllowableRaces` = 2 AND `ID` IN (2383, 3087, 3088, 3089);

--
-- Ammen Vale (draenei): the class training quests 9287 paladin, 9288 hunter, 9290 mage, 9291 priest, 9421 shaman
-- follow "Replenishing the Healing Crystals". That quest has two versions: 9280 for draenei (after "You
-- Survived!") and 9369 for the other Alliance races (stock data, AllowableRaces 77) - both are left as they
-- are. The training quests asked for 9280 through PrevQuestID; now they ask for either version, as a condition
-- (source type 19 = quest available, condition 8 = quest rewarded, the two ElseGroups are alternatives).
--
UPDATE `quest_template` SET `AllowableRaces` = 1101 WHERE `AllowableRaces` = 1024 AND `ID` IN (9287, 9288, 9290, 9291, 9421);
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `PrevQuestID` = 9280 AND `ID` IN (9287, 9288, 9290, 9291, 9421);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` IN (9287, 9288, 9290, 9291, 9421);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 9287, 0, 0, 8, 0, 9280, 0, 0, 0, 0, 0, '', 'Paladin Training (Ammen Vale): Replenishing the Healing Crystals rewarded, draenei version'),
(19, 0, 9287, 0, 1, 8, 0, 9369, 0, 0, 0, 0, 0, '', 'Paladin Training (Ammen Vale): or the version of the other Alliance races'),
(19, 0, 9288, 0, 0, 8, 0, 9280, 0, 0, 0, 0, 0, '', 'Hunter Training (Ammen Vale): Replenishing the Healing Crystals rewarded, draenei version'),
(19, 0, 9288, 0, 1, 8, 0, 9369, 0, 0, 0, 0, 0, '', 'Hunter Training (Ammen Vale): or the version of the other Alliance races'),
(19, 0, 9290, 0, 0, 8, 0, 9280, 0, 0, 0, 0, 0, '', 'Mage Training (Ammen Vale): Replenishing the Healing Crystals rewarded, draenei version'),
(19, 0, 9290, 0, 1, 8, 0, 9369, 0, 0, 0, 0, 0, '', 'Mage Training (Ammen Vale): or the version of the other Alliance races'),
(19, 0, 9291, 0, 0, 8, 0, 9280, 0, 0, 0, 0, 0, '', 'Priest Training (Ammen Vale): Replenishing the Healing Crystals rewarded, draenei version'),
(19, 0, 9291, 0, 1, 8, 0, 9369, 0, 0, 0, 0, 0, '', 'Priest Training (Ammen Vale): or the version of the other Alliance races'),
(19, 0, 9421, 0, 0, 8, 0, 9280, 0, 0, 0, 0, 0, '', 'Shaman Training (Ammen Vale): Replenishing the Healing Crystals rewarded, draenei version'),
(19, 0, 9421, 0, 1, 8, 0, 9369, 0, 0, 0, 0, 0, '', 'Shaman Training (Ammen Vale): or the version of the other Alliance races');

--
-- The level 10 flight path chains ("take this to the capital by wind rider / gryphon and come back"), one per
-- race, each in the race's second zone. They do not overlap: every chain has its own NPCs.
--   tauren      6361 A Bundle of Hides -> 6362 -> 6363 -> 6364                (the Crossroads <-> Thunder Bluff)
--   orc, troll  6365 Meats to Orgrimmar -> 6384 -> 6385 -> 6386               (the Crossroads <-> Orgrimmar)
--   undead      6321 Supplying the Sepulcher -> 6323 -> 6322 -> 6324          (the Sepulcher <-> Undercity)
--   blood elf   9130 Goods from Silvermoon City -> 9133 -> 9134 -> 9135       (Tranquillien <-> Silvermoon)
--   human       6181 A Swift Message -> 6281 -> 6261 -> 6285                  (Sentinel Hill <-> Stormwind)
--   dwarf, gnome 6387 Honor Students -> 6391 -> 6388 -> 6392                  (Thelsamar <-> Ironforge)
--   night elf   6344 Nessa Shadowsong -> 6341 -> 6342 -> 6343                 (Rut'theran <-> Auberdine)
--   draenei     9603 Beds, Bandages, and Beyond -> 9604 -> 9605 -> 9606       (Blood Watch <-> the Exodar)
-- The flight itself is an ordinary taxi ride: a character of another race has to know the flight point at the
-- far end (visit it once) before the flight master can send him there.
--
UPDATE `quest_template` SET `AllowableRaces` = 690 WHERE `AllowableRaces` IN (16, 32, 130, 512) AND `ID` IN
(6361, 6362, 6363, 6364,
 6365, 6384, 6385, 6386,
 6321, 6322, 6323, 6324,
 9130, 9133, 9134, 9135);
UPDATE `quest_template` SET `AllowableRaces` = 1101 WHERE `AllowableRaces` IN (1, 8, 68, 1024) AND `ID` IN
(6181, 6261, 6281, 6285,
 6387, 6388, 6391, 6392,
 6344, 6341, 6342, 6343,
 9603, 9604, 9605, 9606);

-- Goods from Silvermoon City (9130) follows "The Forsaken", which has a blood elf version (9327) and one for
-- the other Horde races (9329, stock data) - both left as they are. 9130 asked for 9327; now either will do.
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `PrevQuestID` = 9327 AND `ID` = 9130;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` = 9130;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 9130, 0, 0, 8, 0, 9327, 0, 0, 0, 0, 0, '', 'Goods from Silvermoon City: The Forsaken rewarded, blood elf version'),
(19, 0, 9130, 0, 1, 8, 0, 9329, 0, 0, 0, 0, 0, '', 'Goods from Silvermoon City: or the version of the other Horde races');

--
-- Left bound to their race on purpose:
--   8346 Thirst Unending (Sunstrider Isle)  - asks for Arcane Torrent, the blood elf racial
--   9283 Rescue the Survivors! (Ammen Vale) - asks for Gift of the Naaru, the draenei racial
--   9612 A Hearty Thanks! (Azuremyst)       - offered by the Draenei Youngling healed with Gift of the Naaru
--   9279 You Survived!, 9280 / 9369 Replenishing the Healing Crystals - the stock draenei / other races pair
--   "Welcome!" (5805, 5842, 5843, 5844, 5847) - started by the Collector's Edition voucher of the race
--   the class quests of level 4 and up that exist once per race (Call of Earth, Garments of the Moon, ...)
-- Nothing else depends on the first three (no quest names them as PrevQuestID).
--
