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

/*
 * Ordered alphabetically using scriptname.
 * Scriptnames of files in this file should be prefixed with "npc_pet_hun_".
 */

#include "CharmInfo.h"
#include "CombatManager.h"
#include "Containers.h"
#include "CreatureScript.h"
#include "Map.h"
#include "ModelIgnoreFlags.h"
#include "ObjectAccessor.h"
#include "Opcodes.h"
#include "PetDefines.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include "SpellAuraEffects.h"
#include "SpellMgr.h"
#include "SpellScript.h"
#include "SpellScriptLoader.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "WorldPacket.h"
#include <array>
#include <cmath>

enum HunterSpells
{
    SPELL_HUNTER_CRIPPLING_POISON       = 30981, // Viper
    SPELL_HUNTER_DEADLY_POISON_PASSIVE  = 34657, // Venomous Snake
    SPELL_HUNTER_MIND_NUMBING_POISON    = 25810, // Viper
    SPELL_HUNTER_GLYPH_OF_SNAKE_TRAP    = 56849,
    SPELL_HUNTER_PET_SCALING            = 62915
};

enum PetSpellsMisc
{
    SPELL_PET_GUARD_DOG_HAPPINESS   = 54445,
    SPELL_PET_SILVERBACK_RANK_1     = 62800,
    SPELL_PET_SILVERBACK_RANK_2     = 62801,

    PET_ICON_ID_GROWL               = 201,
    PET_ICON_ID_CLAW                = 262,
    PET_ICON_ID_BITE                = 1680,
    PET_ICON_ID_SMACK               = 473
};

struct npc_pet_hunter_snake_trap : public ScriptedAI
{
    npc_pet_hunter_snake_trap(Creature* creature) : ScriptedAI(creature), _isViper(false), _spellTimer(0) { }

    void JustEngagedWith(Unit* /*who*/) override { }

    void InitializeAI() override
    {
        _isViper = me->GetEntry() == NPC_VIPER;

        me->SetMaxHealth(uint32(107 * (me->GetLevel() - 40) * 0.025f));
        // Add delta to make them not all hit the same time
        me->SetAttackTime(BASE_ATTACK, me->GetAttackTime(BASE_ATTACK) + urandms(0, 6));

        if (!_isViper && !me->HasAura(SPELL_HUNTER_DEADLY_POISON_PASSIVE))
            DoCast(me, SPELL_HUNTER_DEADLY_POISON_PASSIVE, true);

        // Glyph of Snake Trap — apply AoE damage reduction scaling
        if (Unit* owner = me->GetOwner())
            if (owner->GetAuraEffectDummy(SPELL_HUNTER_GLYPH_OF_SNAKE_TRAP))
                me->CastSpell(me, SPELL_HUNTER_PET_SCALING, true);
    }

    // Redefined for random target selection:
    void MoveInLineOfSight(Unit* /*who*/) override { }

    void UpdateAI(uint32 diff) override
    {
        if (me->GetVictim() && me->GetVictim()->HasBreakableByDamageCrowdControlAura(me))
        {
            me->GetThreatMgr().ClearFixate();
            me->InterruptNonMeleeSpells(false);
            me->AttackStop();
            return;
        }

        if (me->IsSummon() && !me->GetThreatMgr().GetFixateTarget())
        {
            Unit* summoner = me->ToTempSummon()->GetSummonerUnit();
            if (summoner)
            {
                std::vector<Unit*> targets;

                auto addTargetIfValid = [this, &targets, summoner](CombatReference* ref) mutable
                {
                    Unit* enemy = ref->GetOther(summoner);
                    if (!enemy->HasBreakableByDamageCrowdControlAura(me) && me->CanCreatureAttack(enemy) && me->IsWithinDistInMap(enemy, me->GetAttackDistance(enemy)))
                        targets.push_back(enemy);
                };

                for (auto const& [guid, ref] : summoner->GetCombatManager().GetPvPCombatRefs())
                    addTargetIfValid(ref);

                if (targets.empty())
                    for (auto const& [guid, ref] : summoner->GetCombatManager().GetPvECombatRefs())
                        addTargetIfValid(ref);

                for (Unit* target : targets)
                    me->EngageWithTarget(target);

                if (!targets.empty())
                {
                    Unit* target = Acore::Containers::SelectRandomContainerElement(targets);
                    me->GetThreatMgr().FixateTarget(target);
                }
            }
        }

        if (!UpdateVictim())
            return;

        // Viper
        if (_isViper)
        {
            if (_spellTimer <= diff)
            {
                if (!urand(0, 2)) // 33% chance to cast
                    DoCastVictim(RAND(SPELL_HUNTER_MIND_NUMBING_POISON, SPELL_HUNTER_CRIPPLING_POISON));

                _spellTimer = 3000;
            }
            else
                _spellTimer -= diff;
        }

        DoMeleeAttackIfReady();
    }

private:
    bool _isViper;
    uint32 _spellTimer;
};

// -53178 - Guard Dog
class spell_pet_guard_dog : public AuraScript
{
    PrepareAuraScript(spell_pet_guard_dog);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return ValidateSpellInfo({ SPELL_PET_GUARD_DOG_HAPPINESS });
    }

    bool CheckProc(ProcEventInfo& eventInfo)
    {
        // Growl shares family flags with other spells
        // filter by spellIcon instead
        SpellInfo const* spellInfo = eventInfo.GetSpellInfo();
        if (!spellInfo || spellInfo->SpellIconID != PET_ICON_ID_GROWL)
            return false;

        return true;
    }

    void HandleProc(AuraEffect const* aurEff, ProcEventInfo& eventInfo)
    {
        PreventDefaultAction();

        Unit* caster = eventInfo.GetActor();
        caster->CastSpell(nullptr, SPELL_PET_GUARD_DOG_HAPPINESS, true, nullptr, aurEff);

        Unit* target = eventInfo.GetActionTarget();
        if (!target->CanHaveThreatList())
            return;

        SpellInfo const* procSpellInfo = eventInfo.GetSpellInfo();
        if (!procSpellInfo)
            return;

        float addThreat = CalculatePct(static_cast<float>(procSpellInfo->Effects[EFFECT_0].CalcValue(caster)), aurEff->GetAmount());
        target->GetThreatMgr().AddThreat(caster, addThreat, GetSpellInfo());
    }

    void Register() override
    {
        DoCheckProc += AuraCheckProcFn(spell_pet_guard_dog::CheckProc);
        OnEffectProc += AuraEffectProcFn(spell_pet_guard_dog::HandleProc, EFFECT_0, SPELL_AURA_DUMMY);
    }
};

// -62764 - Silverback
class spell_pet_silverback : public AuraScript
{
    PrepareAuraScript(spell_pet_silverback);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return ValidateSpellInfo({ SPELL_PET_SILVERBACK_RANK_1, SPELL_PET_SILVERBACK_RANK_2 });
    }

    bool CheckProc(ProcEventInfo& eventInfo)
    {
        // Growl shares family flags with other spells
        // filter by spellIcon instead
        SpellInfo const* spellInfo = eventInfo.GetSpellInfo();
        if (!spellInfo || spellInfo->SpellIconID != PET_ICON_ID_GROWL)
            return false;

        return true;
    }

    void HandleProc(AuraEffect const* aurEff, ProcEventInfo& eventInfo)
    {
        static uint32 const triggerSpell[2] = { SPELL_PET_SILVERBACK_RANK_1, SPELL_PET_SILVERBACK_RANK_2 };

        PreventDefaultAction();

        uint8 rank = GetSpellInfo()->GetRank();
        if (rank > 0 && rank <= 2)
        {
            uint32 spellId = triggerSpell[rank - 1];
            eventInfo.GetActor()->CastSpell(nullptr, spellId, true, nullptr, aurEff);
        }
    }

    void Register() override
    {
        DoCheckProc += AuraCheckProcFn(spell_pet_silverback::CheckProc);
        OnEffectProc += AuraEffectProcFn(spell_pet_silverback::HandleProc, EFFECT_0, SPELL_AURA_DUMMY);
    }
};

// -61680 - Culling the Herd
class spell_pet_culling_the_herd : public AuraScript
{
    PrepareAuraScript(spell_pet_culling_the_herd);

    bool CheckProc(ProcEventInfo& eventInfo)
    {
        // Claw, Bite and Smack share FamilyFlags with other spells
        // filter by spellIcon instead
        SpellInfo const* spellInfo = eventInfo.GetSpellInfo();
        if (!spellInfo)
            return false;

        switch (spellInfo->SpellIconID)
        {
            case PET_ICON_ID_CLAW:
            case PET_ICON_ID_BITE:
            case PET_ICON_ID_SMACK:
                break;
            default:
                return false;
        }

        return true;
    }

    void Register() override
    {
        DoCheckProc += AuraCheckProcFn(spell_pet_culling_the_herd::CheckProc);
    }
};

// 130774 - Stone Form (gargoyle pets), 130775 - Stone Sleep (wild gargoyles perched as statues)
// The look of a gargoyle turned to stone: the statue pose and the stone skin of its own colour.
// The gargoyle displays of client-patches/gargoyle-pet come in pairs: living skin = even id, its stone
// twin = that id + 1. Any other display keeps its skin and only takes the pose.
enum GargoyleStone
{
    DISPLAY_GARGOYLE_FIRST = 45000,
    DISPLAY_GARGOYLE_LAST  = 45007
};

class spell_pet_gargoyle_stone_form : public AuraScript
{
    PrepareAuraScript(spell_pet_gargoyle_stone_form);

    void OnApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* target = GetTarget();
        uint32 display = target->GetNativeDisplayId();
        if (display >= DISPLAY_GARGOYLE_FIRST && display < DISPLAY_GARGOYLE_LAST && !(display & 1))
            target->SetDisplayId(display + 1);

        target->SetStandState(UNIT_STAND_STATE_SUBMERGED);
    }

    void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* target = GetTarget();
        target->SetStandState(UNIT_STAND_STATE_STAND);
        target->RestoreDisplayId();
        // the model has an animation into the statue pose and none out of it: its lift-off, wings thrown open, stands in
        if (target->IsAlive())
            target->HandleEmoteCommand(EMOTE_ONESHOT_LIFTOFF);
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_pet_gargoyle_stone_form::OnApply, EFFECT_FIRST_FOUND, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
        AfterEffectRemove += AuraEffectRemoveFn(spell_pet_gargoyle_stone_form::OnRemove, EFFECT_FIRST_FOUND, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// ---- Gargoyle's Grip ------------------------------------------------------------------------------
// The gargoyle seizes an enemy and holds it in its claws: the prey rides the gargoyle as a passenger
// (the way the Val'kyr of the Lich King carry players), cannot move, but can fight. It breaks free by
// damage done to the gargoyle; the hunter may walk the gargoyle about (follow, or Eyes of the Beast),
// and once the wings are free the gargoyle can fly: Take Off lifts the prey and drops it.
// Spells, the vehicle and the seat: client-patches/gargoyle-pet/build_gargoyle_pet.py.
enum GargoyleGrip
{
    SPELL_GARGOYLE_GRIP          = 130778,  // on the prey: held (root)
    SPELL_GARGOYLE_GRIP_HOLD     = 130779,  // on the gargoyle while it holds: counts the damage it takes, ticks every second
    SPELL_GARGOYLE_WINGS_FREE    = 130780,  // on the gargoyle from the moment it may fly: flight, and what Take Off asks for
    SPELL_GARGOYLE_TAKE_OFF      = 130782,  // channelled by the gargoyle: up, then the drop

    VEHICLE_GARGOYLE_GRIP        = 800,
    SEAT_GARGOYLE_CLAWS          = 0,
    POINT_GARGOYLE_TAKE_OFF      = 130782,
    POINT_GARGOYLE_LAND          = 130783
};

static constexpr uint32 GRIP_WINGS_DELAY   = 4;      // seconds from the grab until the gargoyle may fly: the prey's window
static constexpr float  GRIP_ESCAPE_SHARE  = 0.8f;   // of what the prey is expected to deal in that window: a margin for reaction
static constexpr float  GRIP_LIFT_HEIGHT   = 40.0f;  // yards
static constexpr float  GRIP_LIFT_SPEED    = 9.0f;   // yards per second: the height is reached within the channel of Take Off
static constexpr float  GRIP_GLIDE_SPEED   = 7.0f;   // yards per second on the way back down, on the wing
static constexpr float  GRIP_FALL_SLOPE    = 0.018f; // the fall damage of players (Player::HandleFall), used for creatures
static constexpr float  GRIP_FALL_OFFSET   = -0.2426f;

// What a player of that level deals in one second with what he always has at hand - white hits, an instant,
// one cast - in plain levelling gear and whatever his class or spec. The weakest case on purpose: anyone
// who reacts in time must be able to tear free. { level, damage per second }
static constexpr std::array<std::pair<uint8, float>, 8> GripExpectedDamage =
{{
    { 10, 8.0f }, { 20, 20.0f }, { 30, 36.0f }, { 40, 60.0f }, { 50, 90.0f }, { 60, 135.0f }, { 70, 300.0f }, { 80, 800.0f }
}};

// damage the gargoyle has to take for the prey to break free
static uint32 GripEscapeDamage(uint8 level)
{
    float perSecond = GripExpectedDamage.back().second;
    if (level <= GripExpectedDamage.front().first)
        perSecond = GripExpectedDamage.front().second * level / GripExpectedDamage.front().first;
    else
        for (std::size_t i = 1; i < GripExpectedDamage.size(); ++i)
            if (level <= GripExpectedDamage[i].first)
            {
                auto const& [lowLevel, low] = GripExpectedDamage[i - 1];
                auto const& [highLevel, high] = GripExpectedDamage[i];
                perSecond = low + (high - low) * (level - lowLevel) / (highLevel - lowLevel);
                break;
            }

    return std::max<uint32>(1, uint32(perSecond * GRIP_WINGS_DELAY * GRIP_ESCAPE_SHARE));
}

static Unit* GripPrey(Unit* gargoyle)
{
    if (Vehicle* claws = gargoyle->GetVehicleKit())
        if (Unit* prey = claws->GetPassenger(SEAT_GARGOYLE_CLAWS))
            if (prey->HasAura(SPELL_GARGOYLE_GRIP))
                return prey;

    return nullptr;
}

// opens the claws: taking the grip off the prey does the rest (see spell_pet_gargoyle_grip_aura)
static void GripRelease(Unit* gargoyle)
{
    if (Unit* prey = GripPrey(gargoyle))
        prey->RemoveAurasDueToSpell(SPELL_GARGOYLE_GRIP);
    else
        gargoyle->RemoveAurasDueToSpell(SPELL_GARGOYLE_GRIP_HOLD);
}

// 130778 - Gargoyle's Grip
class spell_pet_gargoyle_grip : public SpellScript
{
    PrepareSpellScript(spell_pet_gargoyle_grip);

    SpellCastResult CheckCast()
    {
        Unit* caster = GetCaster();
        Unit* target = GetExplTargetUnit();
        if (!target || caster->HasAura(SPELL_GARGOYLE_GRIP_HOLD) || caster->GetVehicle())
            return SPELL_FAILED_BAD_TARGETS;

        // not what already rides or carries somebody, and nothing too heavy to lift
        if (target->GetVehicle() || target->GetVehicleKit() || target->IsTotem())
            return SPELL_FAILED_BAD_TARGETS;

        if (Creature* creature = target->ToCreature())
        {
            uint32 rank = creature->GetCreatureTemplate()->rank;
            if (creature->isWorldBoss() || creature->IsDungeonBoss() || (rank != CREATURE_ELITE_NORMAL && rank != CREATURE_ELITE_RARE))
                return SPELL_FAILED_BAD_TARGETS;
        }

        return SPELL_CAST_OK;
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_pet_gargoyle_grip::CheckCast);
    }
};

class spell_pet_gargoyle_grip_aura : public AuraScript
{
    PrepareAuraScript(spell_pet_gargoyle_grip_aura);

    void OnApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* prey = GetTarget();
        Unit* gargoyle = GetCaster();
        if (!gargoyle || !gargoyle->IsAlive() || prey->GetVehicle() || gargoyle->HasAura(SPELL_GARGOYLE_GRIP_HOLD))
        {
            prey->RemoveAurasDueToSpell(GetId());
            return;
        }

        if (!gargoyle->GetVehicleKit())
        {
            if (!gargoyle->CreateVehicleKit(VEHICLE_GARGOYLE_GRIP, gargoyle->GetEntry()))
            {
                prey->RemoveAurasDueToSpell(GetId());
                return;
            }

            // A client learns that a unit is a vehicle when the object is created for it, so the gargoyle is
            // shown anew to everyone around - unless a hunter is guiding it right now (Eyes of the Beast): his
            // client would lose the unit it is moving. For that case, and as a second way always, the packet
            // that tells the vehicle id of a unit already in view.
            if (!gargoyle->IsClientControlled())
            {
                gargoyle->DestroyForVisiblePlayers();
                gargoyle->UpdateObjectVisibility(true);
            }

            WorldPacket data(SMSG_PLAYER_VEHICLE_DATA, gargoyle->GetPackGUID().size() + 4);
            data << gargoyle->GetPackGUID();
            data << uint32(VEHICLE_GARGOYLE_GRIP);
            gargoyle->SendMessageToSet(&data, true);
        }

        // it holds, it does not fight: no chasing of what hangs in its own claws (see PetAI::CanAttack)
        gargoyle->AttackStop();
        gargoyle->StopMoving();
        if (CharmInfo* charmInfo = gargoyle->GetCharmInfo())
        {
            charmInfo->SetIsCommandAttack(false);
            charmInfo->SetIsFollowing(false);
            charmInfo->SetIsReturning(false);
        }

        gargoyle->CastSpell(gargoyle, SPELL_GARGOYLE_GRIP_HOLD, true);
        // ... and it stays where it grabbed: it does not carry its prey after its master. It moves again for
        // Take Off, or in the hands of a hunter who guides it once its wings are free.
        gargoyle->SetControlled(true, UNIT_STATE_ROOT);
        // boards as Unit::EnterVehicle does, but fully triggered: the prey may be casting or stunned, and it is not asked
        prey->CastCustomSpell(VEHICLE_SPELL_RIDE_HARDCODED, SPELLVALUE_BASE_POINT0, SEAT_GARGOYLE_CLAWS + 1, gargoyle, true);
        if (prey->GetVehicleBase() != gargoyle)
            prey->RemoveAurasDueToSpell(GetId());
    }

    void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* prey = GetTarget();
        Unit* gargoyle = prey->GetVehicleBase();
        // In the claws = a passenger of the grip vehicle - and nothing else is asked: the hold aura on the gargoyle
        // may be gone already (it is what ends first when the time runs out), and the prey must get out all the same.
        if (!gargoyle || !gargoyle->GetVehicleKit() || gargoyle->GetVehicleKit()->GetVehicleInfo()->m_ID != VEHICLE_GARGOYLE_GRIP)
        {
            // never got into the claws
            if (Unit* caster = GetCaster())
                caster->RemoveAurasDueToSpell(SPELL_GARGOYLE_GRIP_HOLD);
            return;
        }

        prey->ExitVehicle();

        // A player falls by himself and his client reports the landing (Player::HandleFall). A creature is
        // sent down here and takes what a player would have taken for the same height.
        if (prey->IsCreature() && prey->IsAlive())
        {
            float height = prey->GetPositionZ() - prey->GetMapHeight(prey->GetPositionX(), prey->GetPositionY(), prey->GetPositionZ(), true, 100.0f);
            if (height > 1.0f)
            {
                prey->GetMotionMaster()->MoveFall();

                float share = GRIP_FALL_SLOPE * height + GRIP_FALL_OFFSET;
                if (share > 0.0f)
                {
                    uint32 damage = uint32(share * prey->GetMaxHealth());
                    ObjectGuid gargoyleGuid = gargoyle->GetGUID();
                    Milliseconds fall = Milliseconds(uint32(std::sqrt(2.0f * height / 19.29f) * 1000.0f));     // 19.29 = gravity
                    prey->m_Events.AddEventAtOffset([prey, gargoyleGuid, damage]
                    {
                        if (!prey->IsAlive())
                            return;

                        Unit* dealer = ObjectAccessor::GetUnit(*prey, gargoyleGuid);
                        if (!dealer)
                            dealer = prey;

                        if (SpellInfo const* grip = sSpellMgr->GetSpellInfo(SPELL_GARGOYLE_GRIP))
                            dealer->SendSpellNonMeleeDamageLog(prey, grip, damage, SPELL_SCHOOL_MASK_NORMAL, 0, 0, true, 0);

                        Unit::DealDamage(dealer, prey, damage, nullptr, DIRECT_DAMAGE, SPELL_SCHOOL_MASK_NORMAL, nullptr, false);
                    }, fall);
                }
            }
        }

        gargoyle->RemoveAurasDueToSpell(SPELL_GARGOYLE_GRIP_HOLD);
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_pet_gargoyle_grip_aura::OnApply, EFFECT_0, SPELL_AURA_MOD_ROOT, AURA_EFFECT_HANDLE_REAL);
        AfterEffectRemove += AuraEffectRemoveFn(spell_pet_gargoyle_grip_aura::OnRemove, EFFECT_0, SPELL_AURA_MOD_ROOT, AURA_EFFECT_HANDLE_REAL);
    }
};

// 130779 - Gargoyle's Grip (on the gargoyle while it holds its prey)
class spell_pet_gargoyle_grip_hold : public AuraScript
{
    PrepareAuraScript(spell_pet_gargoyle_grip_hold);

    void CalculateAmount(AuraEffect const* /*aurEff*/, int32& amount, bool& /*canBeRecalculated*/)
    {
        // absorbs nothing: the effect is only here to see every hit the gargoyle takes
        amount = -1;
    }

    void Absorb(AuraEffect* /*aurEff*/, DamageInfo& dmgInfo, uint32& absorbAmount)
    {
        absorbAmount = 0;
        if (_broken)
            return;

        Unit* gargoyle = GetTarget();
        Unit* prey = GripPrey(gargoyle);
        if (!prey)
            return;

        _taken += dmgInfo.GetDamage();
        if (_taken < GripEscapeDamage(prey->GetLevel()))
            return;

        // torn free - on the next update, not from inside the damage that is being dealt
        _broken = true;
        gargoyle->m_Events.AddEventAtOffset([gargoyle] { GripRelease(gargoyle); }, 1ms);
    }

    void Tick(AuraEffect const* /*aurEff*/)
    {
        Unit* gargoyle = GetTarget();
        if (!GripPrey(gargoyle))
        {
            Remove();
            return;
        }

        if (++_held == GRIP_WINGS_DELAY)
            gargoyle->CastSpell(gargoyle, SPELL_GARGOYLE_WINGS_FREE, true);

        // a hunter who takes the gargoyle over (Eyes of the Beast) after the wings are free has to be told it flies
        if (gargoyle->HasAura(SPELL_GARGOYLE_WINGS_FREE))
        {
            bool guided = gargoyle->IsClientControlled();
            if (guided && !_guided)
            {
                gargoyle->SetControlled(false, UNIT_STATE_ROOT);
                gargoyle->SetCanFly(true);
            }
            else if (!guided && _guided && !gargoyle->HasAura(SPELL_GARGOYLE_TAKE_OFF))
                gargoyle->GetMotionMaster()->MoveFall();    // let go of in the air: down to the ground, prey and all
            _guided = guided;
        }
    }

    void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* gargoyle = GetTarget();
        gargoyle->SetControlled(false, UNIT_STATE_ROOT);
        gargoyle->InterruptSpell(CURRENT_CHANNELED_SPELL);
        gargoyle->RemoveAurasDueToSpell(SPELL_GARGOYLE_TAKE_OFF);       // a lifted gargoyle starts gliding down there
        // ends the flight the wings gave. Gravity is not touched here: it is off only for a gargoyle that Take Off
        // lifted, and that one comes down on the wing; a creature left in the air any other way falls (aura handler)
        gargoyle->RemoveAurasDueToSpell(SPELL_GARGOYLE_WINGS_FREE);

        if (Unit* prey = GripPrey(gargoyle))
            prey->RemoveAurasDueToSpell(SPELL_GARGOYLE_GRIP);

        // a pet that is a vehicle is treated differently in a few places: it is one only while it holds
        gargoyle->m_Events.AddEventAtOffset([gargoyle]
        {
            if (Vehicle* claws = gargoyle->GetVehicleKit())
                if (!claws->GetPassenger(SEAT_GARGOYLE_CLAWS) && !gargoyle->HasAura(SPELL_GARGOYLE_GRIP_HOLD))
                    gargoyle->RemoveVehicleKit();
        }, 1s);
    }

    void Register() override
    {
        DoEffectCalcAmount += AuraEffectCalcAmountFn(spell_pet_gargoyle_grip_hold::CalculateAmount, EFFECT_0, SPELL_AURA_SCHOOL_ABSORB);
        OnEffectAbsorb += AuraEffectAbsorbFn(spell_pet_gargoyle_grip_hold::Absorb, EFFECT_0);
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_pet_gargoyle_grip_hold::Tick, EFFECT_1, SPELL_AURA_PERIODIC_DUMMY);
        AfterEffectRemove += AuraEffectRemoveFn(spell_pet_gargoyle_grip_hold::OnRemove, EFFECT_0, SPELL_AURA_SCHOOL_ABSORB, AURA_EFFECT_HANDLE_REAL);
    }

    uint32 _taken = 0;
    uint32 _held = 0;
    bool _broken = false;
    bool _guided = false;
};

// 130782 - Take Off
class spell_pet_gargoyle_take_off : public AuraScript
{
    PrepareAuraScript(spell_pet_gargoyle_take_off);

    void OnApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* gargoyle = GetTarget();

        // guided by the hunter himself: he has flown it where he wanted, this only opens the claws
        if (gargoyle->IsClientControlled())
        {
            gargoyle->m_Events.AddEventAtOffset([gargoyle] { GripRelease(gargoyle); }, 1ms);
            return;
        }

        if (Creature* creature = gargoyle->ToCreature())
        {
            _react = creature->GetReactState();
            creature->SetReactState(REACT_PASSIVE);     // nobody draws it aside on the way up
        }

        gargoyle->AttackStop();
        gargoyle->SetControlled(false, UNIT_STATE_ROOT);

        // as high as there is room above
        float x = gargoyle->GetPositionX(), y = gargoyle->GetPositionY(), z = gargoyle->GetPositionZ();
        float height = GRIP_LIFT_HEIGHT;
        while (height > 5.0f && !gargoyle->GetMap()->isInLineOfSight(x, y, z + 2.0f, x, y, z + height + 2.0f, gargoyle->GetPhaseMask(),
            LINEOFSIGHT_ALL_CHECKS, VMAP::ModelIgnoreFlags::Nothing))
            height -= 5.0f;

        gargoyle->SetCanFly(true);
        gargoyle->SetDisableGravity(true);
        gargoyle->GetMotionMaster()->MovePoint(POINT_GARGOYLE_TAKE_OFF, Position(x, y, z + height, gargoyle->GetOrientation()),
            FORCED_MOVEMENT_NONE, GRIP_LIFT_SPEED, false);
        _lifted = true;
    }

    void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* gargoyle = GetTarget();
        if (!_lifted)
            return;

        GripRelease(gargoyle);      // the prey falls

        // ... and the gargoyle comes down on the wing: gravity stays off until it has landed
        float x = gargoyle->GetPositionX(), y = gargoyle->GetPositionY(), z = gargoyle->GetPositionZ();
        float ground = gargoyle->GetMapHeight(x, y, z, true, 100.0f);
        float height = z - ground;
        Milliseconds glide = 300ms;
        if (gargoyle->IsAlive() && height > 1.5f)
        {
            // the pet AI would send it back to its master at once, in a straight line through the air
            if (CharmInfo* charmInfo = gargoyle->GetCharmInfo())
                charmInfo->SetIsReturning(true);

            gargoyle->SetDisableGravity(true);
            gargoyle->GetMotionMaster()->MovePoint(POINT_GARGOYLE_LAND, Position(x, y, ground, gargoyle->GetOrientation()),
                FORCED_MOVEMENT_NONE, GRIP_GLIDE_SPEED, false);
            glide += Milliseconds(uint32(height / GRIP_GLIDE_SPEED * 1000.0f));
        }

        ReactStates react = _react;
        gargoyle->m_Events.AddEventAtOffset([gargoyle, react]
        {
            // landed: feet on the ground again, and back to what it was doing
            gargoyle->SetDisableGravity(false);
            gargoyle->SetCanFly(false);
            if (!gargoyle->IsAlive())
                return;

            if (Creature* creature = gargoyle->ToCreature())
                creature->SetReactState(react);

            // back to the hunter: the pet AI sets off again once it believes it is not on its way already
            if (CharmInfo* charmInfo = gargoyle->GetCharmInfo())
            {
                charmInfo->SetIsFollowing(false);
                charmInfo->SetIsReturning(false);
                charmInfo->SetIsAtStay(false);
            }
        }, glide);
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_pet_gargoyle_take_off::OnApply, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
        AfterEffectRemove += AuraEffectRemoveFn(spell_pet_gargoyle_take_off::OnRemove, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }

    ReactStates _react = REACT_DEFENSIVE;
    bool _lifted = false;
};

void AddSC_hunter_pet_scripts()
{
    RegisterSpellScript(spell_pet_gargoyle_stone_form);
    RegisterSpellAndAuraScriptPair(spell_pet_gargoyle_grip, spell_pet_gargoyle_grip_aura);
    RegisterSpellScript(spell_pet_gargoyle_grip_hold);
    RegisterSpellScript(spell_pet_gargoyle_take_off);
    RegisterCreatureAI(npc_pet_hunter_snake_trap);
    RegisterSpellScript(spell_pet_guard_dog);
    RegisterSpellScript(spell_pet_silverback);
    RegisterSpellScript(spell_pet_culling_the_herd);
}
