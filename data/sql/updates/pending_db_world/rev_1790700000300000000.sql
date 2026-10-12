--
-- game_weather: the zones of Outland and Northrend added by hand, checked against what the zones are.
--
-- The three weather types of the table are rain, snow and "storm" - and storm is a SANDSTORM
-- (Weather::GetWeatherState: WEATHER_TYPE_STORM -> WEATHER_STATE_*_SANDSTORM; stock uses it for the Badlands,
-- Tanaris, Silithus and Ahn'Qiraj only). A snowstorm is the snow type at a high grade: the core picks the
-- grade itself, light to heavy.
--
-- Columns: rain / snow / storm chance in % for spring, summer, fall, winter (real-world seasons, by date).
-- Rows are written with ON DUPLICATE KEY UPDATE so that ScriptName (mod-capital-weather-sync) is left alone.
-- Read at startup: restart the worldserver.
--
INSERT INTO `game_weather` (`zone`,
    `spring_rain_chance`, `spring_snow_chance`, `spring_storm_chance`,
    `summer_rain_chance`, `summer_snow_chance`, `summer_storm_chance`,
    `fall_rain_chance`, `fall_snow_chance`, `fall_storm_chance`,
    `winter_rain_chance`, `winter_snow_chance`, `winter_storm_chance`, `ScriptName`) VALUES
-- Sandstorms over ice. The storm chance was meant as a blizzard: it goes into the snow chance (capped at 75,
-- Dragonblight had snow + storm = 100 in winter - never a clear day).
--   Dragonblight     was  0/25/35   0/25/35   0/35/45   0/45/55
(65,   0, 60, 0,    0, 60, 0,    0, 75, 0,    0, 75, 0,  ''),
--   The Storm Peaks  was  0/25/35   0/25/35   0/25/45   0/25/45
(67,   0, 60, 0,    0, 60, 0,    0, 70, 0,    0, 70, 0,  ''),
--   Icecrown         was  0/25/35   0/25/35   0/25/45   0/25/55
(210,  0, 60, 0,    0, 60, 0,    0, 70, 0,    0, 75, 0,  ''),
-- Green zones that had as much snow in July as in January. Snow is now a matter of the cold seasons, rain
-- of the warm ones.
--   Grizzly Hills (temperate pine forest)             was 25/25/0 all year
(394, 25, 10, 0,   30,  0, 0,   30, 10, 0,   15, 30, 0,  ''),
--   Howling Fjord (green coast, snow in the highlands) was 25/35/0 all year
(495, 25, 15, 0,   25,  0, 0,   30, 15, 0,   15, 35, 0,  ''),
--   Borean Tundra (thawed tundra by the sea)           was 15/25/0 all year
(3537, 15, 20, 0,  15,  5, 0,   15, 20, 0,    5, 30, 0,  ''),
-- Blade's Edge Mountains: the western half is forest (Sylvanaar, Ruuan Weald), only the east is bare rock and
-- dust. A sandstorm 40 % of the summer covered the forest too: an occasional one now.
--   was 0/0/20   0/0/40   0/0/25   0/0/25
(3522, 0, 0, 10,    0, 0, 15,    0, 0, 10,    0, 0, 10,  '')
ON DUPLICATE KEY UPDATE
    `spring_rain_chance` = VALUES(`spring_rain_chance`), `spring_snow_chance` = VALUES(`spring_snow_chance`), `spring_storm_chance` = VALUES(`spring_storm_chance`),
    `summer_rain_chance` = VALUES(`summer_rain_chance`), `summer_snow_chance` = VALUES(`summer_snow_chance`), `summer_storm_chance` = VALUES(`summer_storm_chance`),
    `fall_rain_chance` = VALUES(`fall_rain_chance`), `fall_snow_chance` = VALUES(`fall_snow_chance`), `fall_storm_chance` = VALUES(`fall_storm_chance`),
    `winter_rain_chance` = VALUES(`winter_rain_chance`), `winter_snow_chance` = VALUES(`winter_snow_chance`), `winter_storm_chance` = VALUES(`winter_storm_chance`);

--
-- Checked and left as they are:
--   Hellfire Peninsula 3483  0/0/25 all year      - a red dust waste, sandstorms belong there
--   Terokkar Forest    3519  rain 15-20           - forest (Shattrath takes its weather from it)
--   Sholazar Basin     3711  rain 25-45           - jungle
--   Crystalsong Forest 2817  snow 15              - light snow; borderline (the forest floor is not snowy)
--
