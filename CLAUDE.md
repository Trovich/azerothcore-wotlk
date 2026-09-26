# AzerothCore — контекст проекта

Приватный сервер AzerothCore WotLK 3.3.5a на Windows (Visual Studio), форк mod-playerbots.
Работа ведётся на уровне C++ core, SQL, DBC, модульной системы AzerothCore.
Git-иерархия: AzerothCore main → playerbots fork → личная ветка модов.

Подробная история решений и полные диалоги по каждой теме — в `docs/azerothcore-full-reference.md`.
Открывай его точечно по названию темы, не читай целиком без необходимости.

## Реализованные модули и патчи

- **mod-continent-exhaustion** — стакающийся дебафф, усложняющий Outland/Northrend: капы стаков по зонам, снятие у костров, сброс в rest-зонах, скрытый companion-spell с доп. эффектами (физ./магический урон отдельно, входящий урон вверх, входящий хил вниз через `MOD_DAMAGE_PERCENT_TAKEN`). Есть GM-команда `.cedebuff clear`, список `HealingExemptSpellIds` для исключения бинтов/зелий/Lay on Hands. Стаки паузятся у призраков через `IsAlive()`.
- **Мотоцикл-NPC (групповой транспорт)** — клон Salvaged Chopper (33062 → 90000000) с поломкой по Mechanical Repair Kit. Патчи: `Player::HandleVehicleFall()` для урона от падения, `IsVehicle()`-guard в `DamageTaken` от SmartAI-неуязвимости, фиксы флагов VehicleSeat.dbc для выбора пассажиров.
- **Персистентность костей/трупов** — новый конфиг `CONFIG_CORPSE_DECAY_BONES`. Фиксы: `SaveToDB()` в `Map::ConvertCorpseToBones()`, `DeleteFromDB` в `RemoveOldCorpses()`, убран пропуск `CORPSE_BONES` в `Map::LoadCorpseData()`. Открытый баг: тело игрока-призрака не видно на земле по пути к точке смерти.
- **Multi-tap добыча руды** — количество зарядов узла = выпавшее количество руды, лут round-robin, самоцветы только в последнем заряде. Новые таблицы: `mining_base_items`, `mining_bonus_items`, `mining_charge_nodes`. Критичные фиксы: `lootOwnerGUID` нужно ставить до `AddItem()`, guard `&& loot.isLooted()` в таймере `GO_ACTIVATED`.
- **mod-capital-weather-sync** — синхронизация погоды по зонам через `WeatherScript::OnChange()`, тематическое распределение погоды по зонам Northrend.
- **Скорость маунта от Riding skill** — через `UnitScript::OnAuraApply`, перехват `SPELL_AURA_MOD_INCREASE_MOUNTED_SPEED`/`..._FLIGHT_SPEED`.
- **Daze mechanic** — вынесен в конфиг: `CONFIG_DAZE_BASE_CHANCE`, `CONFIG_DAZE_MAX_CHANCE`, `CONFIG_DAZE_SKILL_FACTOR`.
- **Общий лут квестовых предметов в группе (cmangos-TBC)** — три патча в `LootMgr.cpp`: `GetSlotTypeForSharedLoot`, `CanLoot`, `SendItem`.

## В разработке / спроектировано, но не реализовано

- **Light's Hope defense mod** — зеркальный квест к DK-финалу «Battle for Light's Hope Chapel»: обычные классы защищают Argent Dawn от Acherus DK. Декоративный ивент без риска смерти, один общий фазовый слой на всех участников, глобальный state-machine менеджер (не таймеры на игрока), just-in-time запуск/сброс, intro через scout NPC для маскировки момента фазирования. Спека готова, ждёт реализации.

## Известные открытые баги

- Минимап-пинг: `CMSG_MINIMAP_PING` передаёт офсет пикселей от центра миникарты отправителя, а не мировые координаты — получатели видят метку не в том месте. Нужен кастомный опкод с мировыми координатами + Lua-оверлей на клиенте.
- Тело игрока-призрака не отображается на земле при беге к месту смерти (кости уже видны корректно).

## Окружение

- Windows, сборка через Visual Studio.
- Иногда используется WinDbg для дебага крашей (с загрузкой PDB-символов).
- Известная проблема: Claude Desktop Cowork/Hyper-V VM вызывал нестабильность системы при индексации папки с репозиторием — использовать с осторожностью на этой машине.
