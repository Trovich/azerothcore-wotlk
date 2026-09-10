--
-- Seal of Command (20375): proc as a classic-style 7 PPM per swing.
--
-- History: this rev previously used a flat Chance = 35 because an earlier
-- PPM = 7 attempt (rev_1788590290527859100) appeared not to proc at all. That
-- turned out to be a side effect of the extra strike re-entering the proc
-- system: the triggered hit (20424) was cast non-triggered, so Seal of Command
-- chain-procced off its own strikes and the per-swing rate read as noise. With
-- the C++ fix (spell_pal_seal_of_command_aura now casts the strike fully
-- triggered and CheckProc rejects the trigger spell) a plain PPM entry behaves
-- correctly.
--
-- PPM path: Aura::CalcProcChance takes chance = weapon_speed_ms * PPM / 600
-- whenever ProcsPerMinute != 0 and the event carries damage/heal info (every
-- melee swing does). Per-swing chance at PPM 7:
--     2.4 sec 1H   28%
--     3.0 sec      35%
--     3.6 sec 2H   42%
-- Classic behaviour: the chance scales with weapon speed so procs-per-minute
-- stay roughly constant, and a slow weapon's proc (70% of a bigger swing) hits
-- harder. Chance stays 0 so the PPM branch is the only path.
--
-- ProcFlags/family fields are unchanged from the stock row: ProcFlags = 0
-- inherits the DBC flags (white swing + melee specials), and SpellFamilyMask1
-- 1474560 keeps it proccing from Crusader Strike / Divine Storm / Hammer of
-- the Righteous.
DELETE FROM `spell_proc` WHERE `SpellId` = 20375;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `ProcFlags`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(20375, 0, 10, 0, 1474560, 0, 0, 1, 2, 0, 0, 0, 7, 0, 0, 0);
