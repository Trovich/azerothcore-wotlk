--
-- Aedis Brom and Christoph Faral - real route, and the RP dialogue AzerothCore never shipped.
--
-- 1. Route. rev_1789748400100000000.sql cloned Officer Brady's whole 151-point beat (Old Town,
--    Cathedral Square, the Canals, Trade District and back) because 36 of 47 Wowhead sightings fell
--    within 20 yd of it - but a beat cop's patrol and two regulars stumbling out of a tavern are not
--    the same walk, and Brady's loop cuts through the Cathedral Square detour and past the bank's own
--    door. Wowpedia is explicit about the real pair: "found wandering between Old Town and the Canals",
--    and both NPCs' own Wowhead pages quote them at the Pig and Whistle Tavern ("A warm tavern and a
--    cold ale...", "Hey Reese, give me an' Christoph another round" - Reese Langston, guid 79751, is
--    the innkeeper right at their spawn). No sniff of their exact path exists (confirmed on the
--    AzerothCore issue tracker, #16564: "No source documents their actual route, so that part still
--    needs a sniff (or someone's best-guess patrol)") - this is that best-guess patrol, built from the
--    Wowhead sighting cloud itself rather than Brady's beat: it traces Old Town street, the Canal, and
--    stops in the open plaza in front of the Trade District Auction House/Bank (where the AH's own
--    auctioneers stand, guids 79705-79707) without ever reaching the bank's door. Long pause at the
--    tavern (they are, after all, propped at the bar), a shorter one on the square, then back the same
--    way - an out-and-back stroll, not Brady's big one-way beat.
--
DELETE FROM `waypoint_data` WHERE `id` = 797520;
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `velocity`, `delay`, `smoothTransition`, `move_type`, `action`, `action_chance`, `wpguid`) VALUES
(797520, 1, -8606.00, 388.00, 103.03, NULL, 0, 600000, 0, 0, 0, 100, 0),
(797520, 2, -8621.30, 402.40, 102.93, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 3, -8635.20, 444.10, 101.26, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 4, -8646.00, 472.00, 100.00, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 5, -8697.80, 471.90, 98.80, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 6, -8707.10, 496.20, 98.80, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 7, -8716.30, 520.60, 99.50, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 8, -8723.30, 534.50, 100.27, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 9, -8734.90, 544.90, 100.27, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 10, -8741.80, 555.30, 98.05, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 11, -8744.10, 579.60, 98.01, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 12, -8748.80, 586.60, 98.01, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 13, -8790.50, 597.00, 97.81, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 14, -8806.70, 597.00, 96.60, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 15, -8812.10, 645.60, 94.31, NULL, 0, 60000, 0, 0, 0, 100, 0),
(797520, 16, -8818.90, 642.20, 94.31, NULL, 0, 60000, 0, 0, 0, 100, 0),
(797520, 17, -8806.70, 597.00, 96.60, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 18, -8790.50, 597.00, 97.81, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 19, -8748.80, 586.60, 98.01, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 20, -8744.10, 579.60, 98.01, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 21, -8741.80, 555.30, 98.05, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 22, -8734.90, 544.90, 100.27, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 23, -8723.30, 534.50, 100.27, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 24, -8716.30, 520.60, 99.50, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 25, -8707.10, 496.20, 98.80, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 26, -8697.80, 471.90, 98.80, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 27, -8646.00, 472.00, 100.00, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 28, -8635.20, 444.10, 101.26, NULL, 0, 0, 0, 0, 0, 100, 0),
(797520, 29, -8621.30, 402.40, 102.93, NULL, 0, 0, 0, 0, 0, 100, 0);

UPDATE `creature` SET `position_x` = -8606.00, `position_y` = 388.00, `position_z` = 103.03, `orientation` = 0.78,
    `currentwaypoint` = 0 WHERE `guid` = 79752;
UPDATE `creature` SET `position_x` = -8607.41, `position_y` = 389.41, `position_z` = 103.03, `orientation` = 0.78,
    `currentwaypoint` = 0 WHERE `guid` = 79753;

--
-- 2. Dialogue. Upstream AzerothCore issue #16564 tracked this and a contributor (Chinoske) landed a
--    fully-tested fix: 23 lines (7 story exchanges + one tavern line each), matched against real
--    Wowhead-comment testimony, cycled deterministically through a SmartAI event-phase chain so nothing
--    repeats within a lap and nothing overlaps mid-story. Taken essentially verbatim from that PR
--    (source text + English creature_text + smart_scripts; the PR's own multi-locale translations exist
--    too but only ruRU is carried over here to keep this patch focused). The PR keeps both NPCs static
--    at their spawn - the waypoint path above is this server's own addition on top of it.
--
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (1477, 1478);

DELETE FROM `creature_text` WHERE `CreatureID` IN (1477, 1478);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(1477, 20, 0, 'I still have the scars from that night.', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 0 - response'),
(1477, 21, 0, 'Was that the third or fourth time you nearly got me gutted trying one of your crazy stunts?', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 1 - response'),
(1477, 22, 0, 'I have a piece of iron in my back that will remind me of that night for the rest of my days.', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 2 - response'),
(1477, 23, 0, 'Aye and thanks for letting me carry my own hand back to the priests that night.', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 3 - response'),
(1477, 24, 0, 'Broke both me legs that night. How could I forget?', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 4 - response'),
(1477, 25, 0, 'Wasn''t that the night we had to pick up my thumb and carry it in your smoke pouch?', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 5 - response'),
(1477, 26, 0, 'I woke up in a bed in Northshire three weeks later. Don''t remember a damn thing.', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 6 - response'),
(1477, 50, 0, 'A warm tavern and a cold ale. What more could we ask for?', 12, 0, 1, 0, 0, 0, 0, 0, 'Christoph Faral - RP tavern line'),
(1478, 20, 0, 'Ahh the Glustewelt twins!', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 0 - opener'),
(1478, 21, 0, 'Battling that band of Twilight Hammer in the Morass, I could think of better places for a war.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 1 - opener'),
(1478, 22, 0, 'I miss the dwarven ale we used to get at that inn in Lordaeron. Remember that fight we started there?', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 2 - opener'),
(1478, 23, 0, 'Less than a hundred of us, and over a thousand orcs. Only a handful of us managed to walk away from that one.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 3 - opener'),
(1478, 24, 0, 'Remember when Danath gathered all the mercenaries of Stormwind together and we marched to fight at Nethergarde?', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 4 - opener'),
(1478, 25, 0, 'The best had to have been the look on Perenolde''s face when our army comes marchin'' right up to his front door. What a battle!', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 5 - opener'),
(1478, 26, 0, 'I tell ye, I don''t miss the Great War at all. I remember when we fought at Darrowmere. All night in the fog, lying in a muddy trench.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 6 - opener'),
(1478, 30, 0, 'Well, you''re still here. I''d say that is something worth drinking to.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 0 - closer'),
(1478, 31, 0, 'You screamed like a little girl, funniest thing I ever saw.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 1 - closer'),
(1478, 32, 0, 'Never seen anyone move so fast in my whole life.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 2 - closer'),
(1478, 33, 0, 'Let''s not even begin comparing battle scars, my friend.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 3 - closer'),
(1478, 34, 0, 'Hehe, wimp.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 4 - closer'),
(1478, 35, 0, 'You are constantly surprising me with what a person can live through.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 5 - closer'),
(1478, 36, 0, 'It all worked out in the end.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 6 - closer'),
(1478, 50, 0, 'Hey Reese, give me an'' Christoph another round.', 12, 0, 1, 0, 0, 0, 0, 0, 'Aedis Brom - RP tavern line');

DELETE FROM `creature_text_locale` WHERE `CreatureID` IN (1477, 1478);
INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `Locale`, `Text`) VALUES
(1477, 20, 0, 'ruRU', 'У меня до сих пор остались шрамы с той ночи.'),
(1477, 21, 0, 'ruRU', 'Это был третий или четвёртый раз, когда меня чуть не выпотрошили во время одной из твоих безумных выходок?'),
(1477, 22, 0, 'ruRU', 'У меня в спине застрял кусок железа, который будет напоминать мне о той ночи до конца моих дней.'),
(1477, 23, 0, 'ruRU', 'Ага, и спасибо, что позволил мне самому донести свою руку до жрецов той ночью.'),
(1477, 24, 0, 'ruRU', 'Сломал обе ноги в ту ночь. Как я могу забыть?'),
(1477, 25, 0, 'ruRU', 'Не в ту ли ночь нам пришлось подобрать мой большой палец и нести его в твоём кисете для табака?'),
(1477, 26, 0, 'ruRU', 'Я очнулся в постели в Северном Крае три недели спустя. Ничего не помню.'),
(1477, 50, 0, 'ruRU', 'Тёплая таверна и холодный эль. Что ещё нам нужно?'),
(1478, 20, 0, 'ruRU', 'Ах, близнецы Глюствельт!'),
(1478, 21, 0, 'ruRU', 'Сражаясь с той бандой Сумеречного Молота в Трясине, я бы придумал место получше для войны.'),
(1478, 22, 0, 'ruRU', 'Скучаю по дворфийскому элю, который мы пили в той таверне в Лордероне. Помнишь драку, что мы там затеяли?'),
(1478, 23, 0, 'ruRU', 'Меньше сотни нас против более чем тысячи орков. Лишь горстке из нас удалось выбраться живыми.'),
(1478, 24, 0, 'ruRU', 'Помнишь, как Данат собрал всех наёмников Штормграда, и мы отправились сражаться к Нетергарде?'),
(1478, 25, 0, 'ruRU', 'Лучше всего было выражение лица Перенольда, когда наша армия подошла прямо к его порогу. Вот это была битва!'),
(1478, 26, 0, 'ruRU', 'Скажу тебе, Великую войну я совсем не скучаю. Помню, как мы сражались у Дарроумера. Всю ночь в тумане, лёжа в грязном окопе.'),
(1478, 30, 0, 'ruRU', 'Что ж, ты всё ещё здесь. Я бы сказал, за это стоит выпить.'),
(1478, 31, 0, 'ruRU', 'Ты визжал как девчонка, самое смешное, что я видел.'),
(1478, 32, 0, 'ruRU', 'Никогда не видел, чтобы кто-то двигался так быстро.'),
(1478, 33, 0, 'ruRU', 'Давай даже не будем сравнивать боевые шрамы, друг мой.'),
(1478, 34, 0, 'ruRU', 'Хе-хе, слабак.'),
(1478, 35, 0, 'ruRU', 'Ты не перестаёшь удивлять меня тем, что может пережить человек.'),
(1478, 36, 0, 'ruRU', 'В конце концов всё обошлось.'),
(1478, 50, 0, 'ruRU', 'Эй, Риз, налей нам с Кристофом ещё по одной.');

DELETE FROM `smart_scripts` WHERE (`entryorguid` IN (1477, 1478) AND `source_type` = 0) OR (`entryorguid` BETWEEN 147710 AND 147746 AND `source_type` = 9);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(1477, 0, 0, 0, 37, 0, 100, 0, 0, 0, 0, 0, 0, 0, 48, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - AI Init - stay active'),
(147727, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 50, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP tavern line'),
(1478, 0, 0, 0, 1, 0, 100, 0, 3000, 8000, 900000, 1200000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Out of combat - Advance RP cycle'),
(1478, 0, 1, 0, 60, 1, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147730, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 1 - Call RP story 0'),
(1478, 0, 11, 0, 60, 1, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 1 - Advance to phase 2'),
(1478, 0, 2, 0, 60, 2, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147731, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 2 - Call RP story 1'),
(1478, 0, 12, 0, 60, 2, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 2 - Advance to phase 3'),
(1478, 0, 3, 0, 60, 4, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147732, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 3 - Call RP story 2'),
(1478, 0, 13, 0, 60, 4, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 3 - Advance to phase 4'),
(1478, 0, 4, 0, 60, 8, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147733, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 4 - Call RP story 3'),
(1478, 0, 14, 0, 60, 8, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 4 - Advance to phase 5'),
(1478, 0, 5, 0, 60, 16, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147734, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 5 - Call RP story 4'),
(1478, 0, 15, 0, 60, 16, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 5 - Advance to phase 6'),
(1478, 0, 6, 0, 60, 32, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147735, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 6 - Call RP story 5'),
(1478, 0, 16, 0, 60, 32, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 6 - Advance to phase 7'),
(1478, 0, 7, 0, 60, 64, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147736, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 7 - Call RP story 6'),
(1478, 0, 17, 0, 60, 64, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 7 - Advance to phase 8'),
(1478, 0, 8, 0, 60, 128, 100, 0, 0, 100, 85000, 90000, 0, 0, 1, 50, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 8 - Talk tavern line'),
(1478, 0, 18, 0, 60, 128, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 8 - Advance to phase 9'),
(1478, 0, 9, 0, 60, 256, 100, 0, 0, 100, 85000, 90000, 0, 0, 80, 147727, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 9 - Call Christoph Faral tavern line'),
(1478, 0, 10, 0, 60, 256, 100, 0, 70000, 75000, 85000, 90000, 0, 0, 22, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - Phase 9 - Reset RP cycle'),
(147730, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 20, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 0 - Talk opener'),
(147730, 9, 1, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 80, 147740, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 0 - Call Christoph Faral response'),
(147730, 9, 2, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 1, 30, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 0 - Talk closer'),
(147740, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 20, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 0 - Talk response'),
(147731, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 21, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 1 - Talk opener'),
(147731, 9, 1, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 80, 147741, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 1 - Call Christoph Faral response'),
(147731, 9, 2, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 1, 31, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 1 - Talk closer'),
(147741, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 21, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 1 - Talk response'),
(147732, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 22, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 2 - Talk opener'),
(147732, 9, 1, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 80, 147742, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 2 - Call Christoph Faral response'),
(147732, 9, 2, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 1, 32, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 2 - Talk closer'),
(147742, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 22, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 2 - Talk response'),
(147733, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 23, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 3 - Talk opener'),
(147733, 9, 1, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 80, 147743, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 3 - Call Christoph Faral response'),
(147733, 9, 2, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 1, 33, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 3 - Talk closer'),
(147743, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 23, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 3 - Talk response'),
(147734, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 24, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 4 - Talk opener'),
(147734, 9, 1, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 80, 147744, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 4 - Call Christoph Faral response'),
(147734, 9, 2, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 1, 34, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 4 - Talk closer'),
(147744, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 24, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 4 - Talk response'),
(147735, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 25, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 5 - Talk opener'),
(147735, 9, 1, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 80, 147745, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 5 - Call Christoph Faral response'),
(147735, 9, 2, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 1, 35, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 5 - Talk closer'),
(147745, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 25, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 5 - Talk response'),
(147736, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 26, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 6 - Talk opener'),
(147736, 9, 1, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 80, 147746, 0, 0, 0, 0, 0, 19, 1477, 15, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 6 - Call Christoph Faral response'),
(147736, 9, 2, 0, 0, 0, 100, 0, 4000, 6000, 0, 0, 0, 0, 1, 36, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Aedis Brom - RP story 6 - Talk closer'),
(147746, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 26, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Christoph Faral - RP story 6 - Talk response');
