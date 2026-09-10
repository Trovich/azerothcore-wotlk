--
-- Judgement of Light (20185) / Judgement of Wisdom (20186): add a 1 sec internal
-- proc cooldown.
--
-- These are TAKEN-damage procs sitting on the judged target, so every separate
-- damage instance that lands on it rolls independently - auto-attack, seal
-- procs, Crusader Strike/Divine Storm, DoT ticks, and every other attacker on
-- the same target. Without an internal cooldown they can fire several times in
-- one instant, which reads as "several heals per swing".
--
-- Cooldown caps it at one proc per second per aura, so a single swing can only
-- ever produce one heal/mana tick.
--
-- ProcsPerMinute is also lowered from the stock 15 to 10, since at 15 it was
-- near-guaranteed on slower weapons. Per-swing chance is:
--   chance% = weapon_speed_ms * PPM / 600
--            PPM 15        PPM 10
--   2.6 sec   65%           43%
--   3.6 sec   90%           60%
--   instants  37.5%         25%
DELETE FROM `spell_proc` WHERE `SpellId` IN (20185, 20186);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `ProcFlags`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(20185, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 10, 0, 1000, 0),
(20186, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 10, 0, 1000, 0);
