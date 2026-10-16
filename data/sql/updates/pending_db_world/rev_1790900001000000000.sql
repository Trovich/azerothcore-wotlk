--
-- Nagrand, "Survey the Land" (9991), Altruis the Sufferer (18417): the dragon takes off when the quest is accepted.
--
-- AzerothCore started the flight (taxi path 532) and gave the credit only at the end of Altruis's lore talk -
-- "I see twisted steel..." -> "Legion?" -> "And now?" -> "How do you see them now?" -> "Forge camps?" - five windows,
-- while the quest says "Sit back and enjoy the ride". The cMaNGOS TBC database (the 2.4.3 state) starts the flight
-- from the quest itself, two seconds after it is accepted (dbscripts_on_quest_start 9991: taxi 532), and while the
-- quest is in the log Altruis offers "Ready to survey the land." (gossip 7719 option 2) - here: to fly again.
-- The lore talk stays, as lore only.
--

-- Altruis: no flight and no credit at the end of the talk any more; flight and credit on accepting the quest,
-- and again from the new gossip option
DELETE FROM `smart_scripts` WHERE `entryorguid` = 18417 AND `source_type` = 0 AND `id` IN (0, 1, 7, 8, 9, 10);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
    `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`,
    `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`,
    `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18417, 0, 0, 1, 19, 0, 100, 0, 9991, 0, 0, 0, 0, 0, 52, 532, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Altruis the Sufferer - On Quest ''Survey the Land'' Accepted - Activate Taxi Path 532'),
(18417, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 26, 9991, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Altruis the Sufferer - On Quest ''Survey the Land'' Accepted - Quest Credit ''Survey the Land'''),
(18417, 0, 7, 8, 62, 0, 100, 0, 7719, 2, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Altruis the Sufferer - On Gossip ''Ready to survey the land.'' - Close Gossip'),
(18417, 0, 8, 9, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 52, 532, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Altruis the Sufferer - On Gossip ''Ready to survey the land.'' - Activate Taxi Path 532'),
(18417, 0, 9, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 26, 9991, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Altruis the Sufferer - On Gossip ''Ready to survey the land.'' - Quest Credit ''Survey the Land''');

-- "Ready to survey the land." - while the quest is in the log (text of the cMaNGOS menu 7719, option 2)
DELETE FROM `gossip_menu_option` WHERE `MenuID` = 7719 AND `OptionID` = 2;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`,
    `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(7719, 2, 0, 'Ready to survey the land.', 0, 1, 1, 0, 0, 0, 0, '', 0, 0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 7719 AND `SourceEntry` = 2;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
    `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 7719, 2, 0, 0, 9, 0, 9991, 0, 0, 0, 0, 0, '', 'Show gossip option if player has taken quest 9991');
