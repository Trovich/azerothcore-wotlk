--
-- Large creatures with an empty creature_model_info row: melee range of a creature the size of a man.
--
-- Follow-up to rev_1790600000200000000 (clefthoofs). Same defect on other displays: BoundingRadius 0 and
-- CombatReach 0, which the core replaces with the default combat reach of 1.5 yd, so a big creature and its
-- attacker had to stand inside the model. Only displays used by creatures that are actually spawned are touched.
--
-- Values are taken from sibling displays of the same model (CreatureDisplayInfo.dbc ModelID). In this table
-- both columns grow linearly with the display scale, so: sibling value / sibling scale * scale of this display;
-- where a sibling of the very same scale exists, its exact values are used.
-- Kept only where the result is 2.5 yd or more, so normal-sized humanoids and critters stay at 1.5.
-- Left alone: triggers, bunnies, targets and other unselectable helpers.
-- Trailing comment: creature (entry), model and display scale.
--

-- Beasts, giants, dragons, demons and other creature models
UPDATE `creature_model_info` SET `BoundingRadius` = 3, `CombatReach` = 6 WHERE `DisplayID` = 20810; -- Kraator (18696), Abyssal_Outland x6
UPDATE `creature_model_info` SET `BoundingRadius` = 7.602, `CombatReach` = 7.5 WHERE `DisplayID` = 17846; -- Night Elf Ancient Protector (18487), AncientProtector x3
UPDATE `creature_model_info` SET `BoundingRadius` = 3.801, `CombatReach` = 3.75 WHERE `DisplayID` = 20882; -- Unsuspecting Leafbeard (22233), AncientProtector x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 1.5, `CombatReach` = 3 WHERE `DisplayID` = 20764; -- Ever-Core the Punisher (18698), ArcaneGolem x3
UPDATE `creature_model_info` SET `BoundingRadius` = 0.93, `CombatReach` = 3 WHERE `DisplayID` = 28578; -- Mimiron (33350), ClockworkGnome_D x3
UPDATE `creature_model_info` SET `BoundingRadius` = 2.5, `CombatReach` = 3 WHERE `DisplayID` = 17095; -- Fear Fiend (22204), DoomGuardOutland x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8, `CombatReach` = 8 WHERE `DisplayID` = 8574; -- Hemathion (18692); Blackscale (21497), NorthrendDragon x0.8
UPDATE `creature_model_info` SET `BoundingRadius` = 1, `CombatReach` = 10 WHERE `DisplayID` = 21446; -- Toranaku (23164), Taerar_q x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9167, `CombatReach` = 3 WHERE `DisplayID` = 19950; -- Eredar Soul-Eater (20879), Eredar x3
UPDATE `creature_model_info` SET `BoundingRadius` = 3.0556, `CombatReach` = 10 WHERE `DisplayID` = 20952; -- Reth'hedron the Subduer (22357), Eredar x10
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9, `CombatReach` = 3 WHERE `DisplayID` = 19251; -- Ythyar (17518), Etherial x3
UPDATE `creature_model_info` SET `BoundingRadius` = 0.775, `CombatReach` = 2.5 WHERE `DisplayID` = 21078; -- Ethereal Spellfilcher (16545), EtherialRobe x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 1.24, `CombatReach` = 8 WHERE `DisplayID` = 28844; -- Faceless Horror (33772), FacelessOne x4
UPDATE `creature_model_info` SET `BoundingRadius` = 1.5, `CombatReach` = 3 WHERE `DisplayID` = 22748; -- Incandescent Fel Spark (22323), FireElemental x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7285, `CombatReach` = 7.05 WHERE `DisplayID` = 20812; -- Underbog Colossus (21251), FungalGiant x2.35
UPDATE `creature_model_info` SET `BoundingRadius` = 0.875, `CombatReach` = 2.625 WHERE `DisplayID` = 26973; -- Savage Cave Beast (30329), FungalMonster x1.75
UPDATE `creature_model_info` SET `BoundingRadius` = 3.15, `CombatReach` = 3.75 WHERE `DisplayID` = 25120; -- Longneck Grazer (28129), Giraffe x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 1.8025, `CombatReach` = 2.625 WHERE `DisplayID` = 23754; -- Runic Battle Golem (26284), GolemStone x1.75
UPDATE `creature_model_info` SET `BoundingRadius` = 0.48, `CombatReach` = 3 WHERE `DisplayID` = 1231; -- Infected Kodo Beast (25596), KodoBeast x1.2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7, `CombatReach` = 4.375 WHERE `DisplayID` = 2768; -- Ancient Kodo (4702), KodoBeast x1.75
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7, `CombatReach` = 4.375 WHERE `DisplayID` = 10915; -- Ancient Kodo (4702), KodoBeast x1.75
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6, `CombatReach` = 3.75 WHERE `DisplayID` = 23265; -- Infected Kodo Beast (25596), KodoBeast x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.5, `CombatReach` = 3.125 WHERE `DisplayID` = 6270; -- War Party Kodo (5523), KodoBeastTame x1.25
UPDATE `creature_model_info` SET `BoundingRadius` = 0.31, `CombatReach` = 3 WHERE `DisplayID` = 24859; -- Magnataur Youngling (26480), magnataur x1
UPDATE `creature_model_info` SET `BoundingRadius` = 2, `CombatReach` = 6 WHERE `DisplayID` = 20737; -- Warden of the Chamber (30058), NetherDrakonidBoss x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.775, `CombatReach` = 2.5 WHERE `DisplayID` = 28051; -- Perobas the Bloodthirster (32377), NorthrendWorgen x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 2.0985, `CombatReach` = 3.525 WHERE `DisplayID` = 13130; -- Gordok Spirit (11446), Ogre x2.35
UPDATE `creature_model_info` SET `BoundingRadius` = 2.35, `CombatReach` = 3.525 WHERE `DisplayID` = 13132; -- Gordok Spirit (11446), OgreWarlord x2.35
UPDATE `creature_model_info` SET `BoundingRadius` = 2.345, `CombatReach` = 3.5 WHERE `DisplayID` = 20762; -- Speaker Mar'grom (18693), OgreMageLord x3.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.875, `CombatReach` = 2.5 WHERE `DisplayID` = 27975; -- Aotona (32481), Parrot x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.63, `CombatReach` = 10.5 WHERE `DisplayID` = 27013; -- Veranus (30420), ProtoDragon x2.1
UPDATE `creature_model_info` SET `BoundingRadius` = 2.5, `CombatReach` = 2.5 WHERE `DisplayID` = 20238; -- Ravenous Flayer (21196), RockFlayer x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 1.55, `CombatReach` = 5 WHERE `DisplayID` = 20239; -- Ravenous Flayer Matriarch (21205); Barash the Den Mother (23269), RockFlayerElite x5
UPDATE `creature_model_info` SET `BoundingRadius` = 1.0125, `CombatReach` = 2.8125 WHERE `DisplayID` = 11347; -- Ambassador Jerrikar (18695), Satyr x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 2.5, `CombatReach` = 3.75 WHERE `DisplayID` = 14699; -- Lord Blackwood (14695); Lord Blackwood (614695), SkeletonNaked x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 1.685, `CombatReach` = 3.75 WHERE `DisplayID` = 21087; -- Lost Torranche (22807), TallStrider x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 2.5, `CombatReach` = 5 WHERE `DisplayID` = 28052; -- King Krush (32485), trex x2.5

-- Oversized humanoid elites and bosses on character models (same per-unit values as their normal-sized siblings)
UPDATE `creature_model_info` SET `BoundingRadius` = 0.766, `CombatReach` = 3 WHERE `DisplayID` = 18929; -- Commander Sarannis (17976), BloodElfFemale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.766, `CombatReach` = 3 WHERE `DisplayID` = 19399; -- Tempest Falconer (20037), BloodElfFemale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.766, `CombatReach` = 3 WHERE `DisplayID` = 19424; -- Astromancer Lord (20046), BloodElfFemale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6894, `CombatReach` = 2.7 WHERE `DisplayID` = 19506; -- Crimson Hand Centurion (20048), BloodElfFemale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.766, `CombatReach` = 3 WHERE `DisplayID` = 19508; -- Crimson Hand Inquisitor (20050), BloodElfFemale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6894, `CombatReach` = 2.7 WHERE `DisplayID` = 21000; -- Bloodwarder Vindicator (20032), BloodElfFemale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8043, `CombatReach` = 3.15 WHERE `DisplayID` = 21420; -- Lady Malande (22951), BloodElfFemale x2.1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6894, `CombatReach` = 2.7 WHERE `DisplayID` = 21566; -- Illidari Archon (23400), BloodElfFemale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6703, `CombatReach` = 2.625 WHERE `DisplayID` = 26550; -- Death Knight Captain (16145), BloodElfFemale x1.75
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6894, `CombatReach` = 2.7 WHERE `DisplayID` = 19392; -- Star Scryer (20034), BloodElfMale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.766, `CombatReach` = 3 WHERE `DisplayID` = 19474; -- Nether Scryer (20045), BloodElfMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6894, `CombatReach` = 2.7 WHERE `DisplayID` = 19503; -- Crimson Hand Blood Knight (20049), BloodElfMale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.766, `CombatReach` = 3 WHERE `DisplayID` = 20033; -- Pathaleon the Calculator (19220), BloodElfMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8618, `CombatReach` = 3.375 WHERE `DisplayID` = 20514; -- Leotheras the Blind (21215), BloodElfMale x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6894, `CombatReach` = 2.7 WHERE `DisplayID` = 20978; -- Bloodwarder Marshal (20035), BloodElfMale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6894, `CombatReach` = 2.7 WHERE `DisplayID` = 21568; -- Illidari Assassin (23403), BloodElfMale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.5279, `CombatReach` = 2.5875 WHERE `DisplayID` = 30469; -- Skybreaker Sorcerer (37026), GnomeMale x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.5279, `CombatReach` = 2.5875 WHERE `DisplayID` = 30473; -- Skybreaker Assassin (37017), GnomeMale x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.612, `CombatReach` = 3 WHERE `DisplayID` = 31097; -- Alrin the Agile (38551), HumanMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6944, `CombatReach` = 3 WHERE `DisplayID` = 25485; -- Chulo the Mad (28496), IceTrollMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7812, `CombatReach` = 3.375 WHERE `DisplayID` = 27833; -- Kutube'sa (28494), IceTrollMale x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8681, `CombatReach` = 3.75 WHERE `DisplayID` = 20200; -- Vashj'ir Honor Guard (21218), Naga_Male x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7812, `CombatReach` = 3.375 WHERE `DisplayID` = 20201; -- Coilfang Beast-Tamer (21221), Naga_Male x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7812, `CombatReach` = 3.375 WHERE `DisplayID` = 20205; -- Coilfang Shatterer (21301), Naga_Male x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7812, `CombatReach` = 3.375 WHERE `DisplayID` = 20470; -- Coilfang Serpentguard (21298), Naga_Male x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 1.2153, `CombatReach` = 5.25 WHERE `DisplayID` = 20662; -- Fathom-Lord Karathress (21214), Naga_Male x3.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.7812, `CombatReach` = 3.375 WHERE `DisplayID` = 20671; -- Fathom-Guard Sharkkis (21966), Naga_Male x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 0.612, `CombatReach` = 3 WHERE `DisplayID` = 17873; -- Tyrande Whisperwind (17948), NightElfFemale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.472, `CombatReach` = 3 WHERE `DisplayID` = 20947; -- Deathshadow Acolyte (22341); Deathshadow Warlock (22363), OrcFemale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.837, `CombatReach` = 3.375 WHERE `DisplayID` = 17370; -- Thrall (17852), OrcMale x2.25
UPDATE `creature_model_info` SET `BoundingRadius` = 0.93, `CombatReach` = 3.75 WHERE `DisplayID` = 20949; -- Deathshadow Archon (22343), OrcMale x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.93, `CombatReach` = 3.75 WHERE `DisplayID` = 21254; -- Teron Gorefiend (22871), OrcMale x2.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6944, `CombatReach` = 3 WHERE `DisplayID` = 17992; -- Raging Skeleton (18521), SkeletonMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 1.0417, `CombatReach` = 4.5 WHERE `DisplayID` = 27988; -- High Thane Jorfus (32501), VrykulMale x3

-- Tauren: 4.05 (male) / 3.75 (female) yd at normal scale, like the other ~560 tauren displays
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 12084; -- Frostwolf Warrior (12052), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 13562; -- Coldmine Guard (113089), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 15472; -- Herbalist Proudfeather (15477), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 15541; -- Stoneguard Clayhoof (15532), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 15721; -- Thunder Bluff Commendation Officer (15739), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 19183; -- Tauren Commoner (19176), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 19425; -- Thunder Bluff Huntsman (19406), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9597, `CombatReach` = 4.125 WHERE `DisplayID` = 23175; -- Risen Longrunner (25350), TaurenFemale x1.1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 23452; -- Twilight Flameguard (25866), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 28314; -- Noblegarden Merchant (32837), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 28864; -- Thunder Bluff Champion (33748), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 29399; -- Mahara Goldwheat (34714), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.8725, `CombatReach` = 3.75 WHERE `DisplayID` = 29713; -- Ghostly Tauren Celebrant (35252), TaurenFemale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 1.3088, `CombatReach` = 5.625 WHERE `DisplayID` = 30474; -- Kor'kron Defender (37032), TaurenFemale x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 1.3088, `CombatReach` = 5.625 WHERE `DisplayID` = 30480; -- Kor'kron Primalist (37030), TaurenFemale x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 12083; -- Frostwolf Warrior (12052), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 13325; -- Coldmine Guard (113089), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 15544; -- Chief Sharpclaw (15535), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 15720; -- Thunder Bluff Commendation Officer (15739), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 1.4621, `CombatReach` = 6.075 WHERE `DisplayID` = 17332; -- Tauren Warrior (17933), TaurenMale x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 19184; -- Tauren Commoner (19176), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 19426; -- Thunder Bluff Huntsman (19406), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 19427; -- Thunder Bluff Huntsman (19406), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 23285; -- Scourge Prisoner (25610), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 25055; -- First Mate Hapana (28049), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 1.1696, `CombatReach` = 4.86 WHERE `DisplayID` = 28420; -- Elder Ezra Wheathoof (15580), TaurenMale x1.2
UPDATE `creature_model_info` SET `BoundingRadius` = 1.0722, `CombatReach` = 4.455 WHERE `DisplayID` = 28597; -- Runok Wildmane (33403), TaurenMale x1.1
UPDATE `creature_model_info` SET `BoundingRadius` = 1.4621, `CombatReach` = 6.075 WHERE `DisplayID` = 29048; -- Twilight Guardian (33822), TaurenMale x1.5
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 29232; -- Cheerful Tauren Spirit (34480), TaurenMale x1
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9747, `CombatReach` = 4.05 WHERE `DisplayID` = 29714; -- Ghostly Tauren Celebrant (35252), TaurenMale x1

-- CHECK: siblings disagree or there is too little to compare with; the reason is on the line above the row(s)
-- BrokenMale: 3 siblings scale linearly (0.3472/1.5 per unit), 22 keep 1.5 at any scale
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6944, `CombatReach` = 3 WHERE `DisplayID` = 20670; -- Fathom-Guard Tidalvess (21965), BrokenMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6944, `CombatReach` = 3 WHERE `DisplayID` = 21115; -- Ashtongue Battlelord (22844), BrokenMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.625, `CombatReach` = 2.7 WHERE `DisplayID` = 21116; -- Ashtongue Mystic (22845), BrokenMale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.6944, `CombatReach` = 3 WHERE `DisplayID` = 21117; -- Ashtongue Primalist (22847), BrokenMale x2
UPDATE `creature_model_info` SET `BoundingRadius` = 0.625, `CombatReach` = 2.7 WHERE `DisplayID` = 21118; -- Ashtongue Stormcaller (22846), BrokenMale x1.8
UPDATE `creature_model_info` SET `BoundingRadius` = 0.625, `CombatReach` = 2.7 WHERE `DisplayID` = 21442; -- Ashtongue Stalker (23374), BrokenMale x1.8
-- siblings disagree: 2/3 at this scale vs 1/2 per unit; took the same-scale one
UPDATE `creature_model_info` SET `BoundingRadius` = 2, `CombatReach` = 3 WHERE `DisplayID` = 24960; -- Old Crystalbark (32357), AncientofArcane x2
-- 2 of 5 siblings give 1/1.5 per unit, the rest are junk
UPDATE `creature_model_info` SET `BoundingRadius` = 1.75, `CombatReach` = 2.625 WHERE `DisplayID` = 15710; -- Supreme Anubisath Warbringer (15758), Anubisath x1.75
-- siblings give radius 5/unit (-> 40); took 0.31 from the other ClockworkGnome models
UPDATE `creature_model_info` SET `BoundingRadius` = 2.48, `CombatReach` = 8 WHERE `DisplayID` = 27986; -- Dirkee (32500), ClockworkGnome x8
-- both siblings at one scale (0.75), no cross-check
UPDATE `creature_model_info` SET `BoundingRadius` = 4, `CombatReach` = 3 WHERE `DisplayID` = 27655; -- Horde Demolisher (31652), DemolisherVehicle x1
-- siblings 1.8/18 and 6/7; took 1/10 per unit like the other dragon models
UPDATE `creature_model_info` SET `BoundingRadius` = 1.35, `CombatReach` = 13.5 WHERE `DisplayID` = 21401; -- Lady Sinestra (23283), DragonOnyxia x1.35
-- only two siblings, both far larger (scale 7 and 10)
UPDATE `creature_model_info` SET `BoundingRadius` = 0.775, `CombatReach` = 2.5 WHERE `DisplayID` = 28010; -- Loque'nahak (32517), Harkoa x2.5
-- single sibling (0.522/1.5 at scale 1)
UPDATE `creature_model_info` SET `BoundingRadius` = 0.9135, `CombatReach` = 2.625 WHERE `DisplayID` = 16128; -- Kel'gash the Wicked (16358), TrollJungleBoss x1.75
-- single sibling (0.31/3 at scale 1)
UPDATE `creature_model_info` SET `BoundingRadius` = 0.93, `CombatReach` = 9 WHERE `DisplayID` = 27983; -- Hildana Deathstealer (32495), ValkierDark x3
