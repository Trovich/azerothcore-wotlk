/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "CreatureScript.h"
#include "InstanceScript.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include "TaskScheduler.h"
#include "stratholme.h"

enum Spells
{
    SPELL_BANSHEEWAIL           = 16565,
    SPELL_BANSHEECURSE          = 16867,
    SPELL_SILENCE               = 18327,
    SPELL_POSSESS               = 17244,    // the charm on player
    SPELL_POSSESSED             = 17246,    // the damage debuff on player
    SPELL_POSSESS_INV           = 17250     // baroness becomes invisible while possessing a target
};

class boss_baroness_anastari : public CreatureScript
{
public:
    boss_baroness_anastari() : CreatureScript("boss_baroness_anastari") { }

    struct boss_baroness_anastariAI : public BossAI
    {
        boss_baroness_anastariAI(Creature* creature) : BossAI(creature, TYPE_ZIGGURAT1)
        {
        }

        void Reset() override
        {
            _possessedTargetGuid.Clear();

            instance->DoRemoveAurasDueToSpellOnPlayers(SPELL_POSSESS);
            instance->DoRemoveAurasDueToSpellOnPlayers(SPELL_POSSESSED);
            me->RemoveAurasDueToSpell(SPELL_POSSESS_INV);

            _scheduler.CancelAll();

            _scheduler.SetValidator([this]
            {
                return !me->HasUnitState(UNIT_STATE_CASTING);
            });
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            _scheduler.Schedule(1s, [this](TaskContext context){
                DoCastVictim(SPELL_BANSHEEWAIL);
                context.Repeat(4s);
            })
            .Schedule(11s, [this](TaskContext context){
                DoCastVictim(SPELL_BANSHEECURSE);
                context.Repeat(18s);
            })
            .Schedule(13s, [this](TaskContext context){
                DoCastVictim(SPELL_SILENCE);
                context.Repeat(13s);
            });

            SchedulePossession();
        }

        void JustDied(Unit* /*killer*/) override
        {
            instance->SetData(TYPE_ZIGGURAT1, IN_PROGRESS);
        }

        // SPELL_POSSESS is a charm: it hands the victim's faction over to the Baroness
        // and takes their client control away, but nothing then drives them.
        // Unit::UpdateCharmAI() returns early for players, and a creature charmer issues
        // no orders of its own, so a possessed player simply stands there - and the group
        // is given no reason to beat the Baroness back out of them. Point them at one of
        // their own instead.
        void TurnPossessedOnGroup()
        {
            Player* possessed = ObjectAccessor::GetPlayer(*me, _possessedTargetGuid);
            if (!possessed || !possessed->IsAlive())
                return;

            // Leave them on their current victim while it is still worth attacking,
            // so the chase is not restarted on every tick.
            if (Unit* victim = possessed->GetVictim())
                if (victim->IsAlive() && possessed->IsValidAttackTarget(victim))
                    return;

            Unit* newVictim = SelectTarget(SelectTargetMethod::Random, 0, [possessed](Unit const* target)
            {
                return target != possessed && target->IsAlive() && possessed->IsValidAttackTarget(target);
            });

            if (!newVictim)
                return;

            possessed->Attack(newVictim, true);
            possessed->GetMotionMaster()->MoveChase(newVictim);
        }

        void SchedulePossession()
        {
            _scheduler.Schedule(20s, 30s, [this](TaskContext context){
                if (Unit* possessTarget = SelectTarget(SelectTargetMethod::Random, 1, 0, true, false))
                {
                    DoCast(possessTarget, SPELL_POSSESS, true);
                    DoCast(possessTarget, SPELL_POSSESSED, true);
                    DoCastSelf(SPELL_POSSESS_INV, true);
                    _possessedTargetGuid = possessTarget->GetGUID();

                    TurnPossessedOnGroup();

                    // We must keep track of the possessed player, the aura falls off when their health drops below 50%.
                    // The encounter resumes when the aura falls off.
                    _scheduler.Schedule(1s, [this](TaskContext possessionContext) {
                        Player* possessedTarget = ObjectAccessor::GetPlayer(*me, _possessedTargetGuid);
                        if (possessedTarget && possessedTarget->HasAura(SPELL_POSSESSED) && !possessedTarget->HealthBelowPct(50))
                        {
                            TurnPossessedOnGroup();
                            possessionContext.Repeat(1s);
                            return;
                        }

                        // Either the group beat the Baroness out of them, or the victim is
                        // no longer reachable (died, logged out, left the instance). Both
                        // have to end the possession, otherwise SPELL_POSSESS_INV is never
                        // removed and she stays invisible and idle for the rest of the fight.
                        if (possessedTarget)
                        {
                            possessedTarget->RemoveAurasDueToSpell(SPELL_POSSESS);
                            possessedTarget->RemoveAurasDueToSpell(SPELL_POSSESSED);
                        }

                        me->RemoveAurasDueToSpell(SPELL_POSSESS_INV);
                        _possessedTargetGuid.Clear();
                        SchedulePossession();
                    });
                }
                else
                {
                    // No valid possession targets found, retry.
                    context.Repeat(1s);
                }
            });
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
            {
                return;
            }

            _scheduler.Update(diff,
                std::bind(&ScriptedAI::DoMeleeAttackIfReady, this));
        }

    private:
        ObjectGuid _possessedTargetGuid;
        TaskScheduler _scheduler;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetStratholmeAI<boss_baroness_anastariAI>(creature);
    }
};

void AddSC_boss_baroness_anastari()
{
    new boss_baroness_anastari;
}
