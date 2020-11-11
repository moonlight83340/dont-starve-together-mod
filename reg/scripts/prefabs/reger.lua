local MakePlayerCharacter = require "prefabs/player_common"
local assets = {
    Asset("ANIM", "anim/player_basic.zip"),
    Asset("ANIM", "anim/player_idles_shiver.zip"),
    Asset("ANIM", "anim/player_actions.zip"),
    Asset("ANIM", "anim/player_actions_axe.zip"),
    Asset("ANIM", "anim/player_actions_pickaxe.zip"),
    Asset("ANIM", "anim/player_actions_shovel.zip"),
    Asset("ANIM", "anim/player_actions_blowdart.zip"),
    Asset("ANIM", "anim/player_actions_eat.zip"),
    Asset("ANIM", "anim/player_actions_item.zip"),
    Asset("ANIM", "anim/player_actions_uniqueitem.zip"),
    Asset("ANIM", "anim/player_actions_bugnet.zip"),
    Asset("ANIM", "anim/player_actions_fishing.zip"),
    Asset("ANIM", "anim/player_actions_boomerang.zip"),
    Asset("ANIM", "anim/player_bush_hat.zip"),
    Asset("ANIM", "anim/player_attacks.zip"),
    Asset("ANIM", "anim/player_idles.zip"),
    Asset("ANIM", "anim/player_rebirth.zip"),
    Asset("ANIM", "anim/player_jump.zip"),
    Asset("ANIM", "anim/player_amulet_resurrect.zip"),
    Asset("ANIM", "anim/player_teleport.zip"),
    Asset("ANIM", "anim/wilson_fx.zip"),
    Asset("ANIM", "anim/player_one_man_band.zip"),
    Asset("ANIM", "anim/shadow_hands.zip"),
    Asset("SOUND", "sound/sfx.fsb"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset("ANIM", "anim/beard.zip"),
    Asset("ANIM", "anim/reger.zip"),
    Asset("ANIM", "anim/ghost_reger_build.zip"),
    Asset("IMAGE", "images/saveslot_portraits/reger.tex"),
    Asset("ATLAS", "images/saveslot_portraits/reger.xml"),
    Asset("IMAGE", "images/selectscreen_portraits/reger.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/reger.xml"),
    Asset("IMAGE", "images/selectscreen_portraits/reger_silho.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/reger_silho.xml"),
    Asset("IMAGE", "bigportraits/reger.tex"),
    Asset("ATLAS", "bigportraits/reger.xml"),
    Asset("IMAGE", "images/map_icons/reger.tex"),
    Asset("ATLAS", "images/map_icons/reger.xml"),
    Asset("IMAGE", "images/avatars/avatar_reger.tex"),
    Asset("ATLAS", "images/avatars/avatar_reger.xml"),
    Asset("IMAGE", "images/avatars/avatar_ghost_reger.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_reger.xml")
}
local prefabs = {}
local start_inv = {"regercloak", "regerhat", "abyssweapon"}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ESCTEMPLATE = {
    GENERIC = "It's Esc!",
    ATTACKER = "That Esc looks shifty...",
    MURDERER = "Murderer!",
    REVIVER = "Esc, friend of ghosts.",
    GHOST = "Esc could use a heart."
}
local function onload(inst, data)
    if inst.components and inst.components.exp then
        inst.components.exp:ApplyUpgrades()
    end
end
local function oneat(inst, food)
    if food:HasTag("rikofood") then
        inst.components.exp:DoDelta(1)
    end
end
local function onupdate(inst)
    inst.components.health:SetMaxHealth(TUNING.REGER_HEALTH)
    inst.components.hunger:SetMax(TUNING.REGER_HUNGER)
    inst.components.sanity:SetMax(TUNING.REGER_SANITY)
    --inst.components.health:SetMaxHealth(150 + inst.components.exp.levelpoint * 50)
    --inst.components.hunger:SetMax(100 + inst.components.exp.levelpoint * 25)
    --inst.components.sanity:SetMax(100 + inst.components.exp.levelpoint * 25)
    inst.components.combat.damagemultiplier = 1 --+ inst.components.exp.levelpoint * 0.1
end
local function onlightingstrike(inst)
    local headitem = nil
    if inst.components.inventory then
        headitem = inst.components.inventory.equipslots[EQUIPSLOTS.HEAD]
    elseif inst.replica.inventory then
        headitem = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
    end
    if inst.components.health ~= nil and not (inst.components.health:IsDead() or inst.components.health:IsInvincible()) then
        if inst.components.inventory:IsInsulated() then
            inst:PushEvent("lightningdamageavoided")
        else
            inst.components.health:DoDelta(TUNING.HEALING_SUPERHUGE, false, "lightning")
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
            if headitem and headitem:HasTag("regerhat") then
                headitem.components.fueled:DoDelta(TUNING.REGBOMB_CONSUME)
                headitem.components.fueled.ontakefuelfn(headitem)
            end
        end
    end
end
local common_postinit = function(inst)
    inst.MiniMapEntity:SetIcon("reger.tex")
    inst:AddTag("reger")
end
local master_postinit = function(inst)
    inst.soundsname = "wilson"
    inst.components.health:SetMaxHealth(TUNING.REGER_HEALTH)
    inst.components.hunger:SetMax(TUNING.REGER_HUNGER)
    inst.components.sanity:SetMax(TUNING.REGER_SANITY)
    inst.components.combat.damagemultiplier = 1
    inst.components.health:SetAbsorptionAmount(0.4)
    inst.components.health.fire_damage_scale = 0
    inst.components.eater:SetOnEatFn(oneat)
    inst.components.playerlightningtarget:SetHitChance(1)
    inst.components.playerlightningtarget:SetOnStrikeFn(onlightingstrike)
    inst.components.hunger.hungerrate = 1.7 * TUNING.WILSON_HUNGER_RATE
    inst.regerweapon = SpawnPrefab("regerweapon")
    inst.regerweapon.entity:SetParent(inst.entity)
	
    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end
return MakePlayerCharacter("reger", prefabs, assets, common_postinit, master_postinit, start_inv)
