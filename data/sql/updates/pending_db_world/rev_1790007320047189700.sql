--
-- Hearthstone (8690): cooldown 30 minutes -> 1 hour. The spell itself has no per-spell RecoveryTime
-- (0) - the 30-minute lockout comes entirely from its shared CategoryRecoveryTime (Category 1176, so
-- it also shares cooldown with anything else using that category, e.g. some engineering trinkets).
-- StartRecoveryTime/StartRecoveryCategory (1500 / 133, the ordinary GCD) are carried over unchanged.
--
INSERT INTO `spell_cooldown_overrides` (`Id`, `RecoveryTime`, `CategoryRecoveryTime`, `StartRecoveryTime`, `StartRecoveryCategory`, `Comment`)
VALUES (8690, 0, 3600000, 1500, 133, 'Hearthstone cooldown 30 min -> 1 hour')
ON DUPLICATE KEY UPDATE
    `RecoveryTime` = VALUES(`RecoveryTime`),
    `CategoryRecoveryTime` = VALUES(`CategoryRecoveryTime`),
    `StartRecoveryTime` = VALUES(`StartRecoveryTime`),
    `StartRecoveryCategory` = VALUES(`StartRecoveryCategory`),
    `Comment` = VALUES(`Comment`);
