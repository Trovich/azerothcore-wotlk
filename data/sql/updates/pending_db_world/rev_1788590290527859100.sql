--
-- Seal of Command (20375): revert the melee proc to classic/TBC style -
-- a PPM-based chance per swing instead of WotLK's guaranteed 100% (both
-- ProcsPerMinute and Chance were 0, which AC treats as "always procs").
-- Paired with the spell_pal_seal_of_command_aura C++ change that drops the
-- 3-target cleave back to a single target.
DELETE FROM `spell_proc` WHERE `SpellId` = 20375;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `ProcFlags`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(20375, 0, 10, 0, 1474560, 0, 0, 1, 2, 0, 0, 0, 7, 0, 0, 0);
