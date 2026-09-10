--
-- Judgement (54158): bind spell_pal_judgement_damage.
--
-- 54158 is the generic judgement damage used by Seal of Justice / Light / Wisdom, and
-- its attack power / spell power scaling comes from spell_bonus_data. That stays as it
-- is - it is the WotLK design and every seal is meant to judge for damage.
--
-- Seal of Command is the exception: spell_pal_judgement computes Judgement of Command's
-- classic formula itself (0.19 * weapon damage + 0.08 * AP + 0.13 * holy spell power,
-- doubled against a stunned or incapacitated target) and passes the finished number as
-- SPELLVALUE_BASE_POINT0. Without this script Unit::SpellDamageBonusDone would add the
-- coefficients on top of it, landing attack power at 0.08 + 0.16 and spell power at
-- 0.13 + 0.25 - roughly three times the intended scaling.
--
DELETE FROM `spell_script_names` WHERE `spell_id` = 54158 AND `ScriptName` = 'spell_pal_judgement_damage';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(54158, 'spell_pal_judgement_damage');
