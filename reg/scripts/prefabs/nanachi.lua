
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),

        Asset( "SOUNDPACKAGE", "sound/nanachi.fev" ),
        Asset( "SOUND", "sound/nanachi.fsb" ),

        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/nanachi.zip" ),
        Asset( "ANIM", "anim/nanachihair.zip" ),
        Asset( "ANIM", "anim/ghost_nanachi_build.zip" ),
        Asset( "IMAGE", "images/saveslot_portraits/nanachi.tex" ),
        Asset( "ATLAS", "images/saveslot_portraits/nanachi.xml" ),

        Asset( "IMAGE", "images/selectscreen_portraits/nanachi.tex" ),
        Asset( "ATLAS", "images/selectscreen_portraits/nanachi.xml" ),
        
        Asset( "IMAGE", "images/selectscreen_portraits/nanachi_silho.tex" ),
        Asset( "ATLAS", "images/selectscreen_portraits/nanachi_silho.xml" ),

        Asset( "IMAGE", "bigportraits/nanachi.tex" ),
        Asset( "ATLAS", "bigportraits/nanachi.xml" ),
        
        Asset( "IMAGE", "images/map_icons/nanachi.tex" ),
        Asset( "ATLAS", "images/map_icons/nanachi.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_nanachi.tex" ),
        Asset( "ATLAS", "images/avatars/avatar_nanachi.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_ghost_nanachi.tex" ),
        Asset( "ATLAS", "images/avatars/avatar_ghost_nanachi.xml" ),
}
local prefabs = {
        "nanachihat",
}
local start_inv = {
        "nanachihat",
}

STRINGS.CHARACTERS.GENERIC.DESCRIBE.ESCTEMPLATE = 
{
        GENERIC = "It's Nanachi!",
        ATTACKER = "That Nanachi looks shifty...",
        MURDERER = "Murderer!",
        REVIVER = "Nanachi, friend of ghosts.",
        GHOST = "Nanachi could use a heart.",
}

local function FindFriend(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 3, {"pig"}, {"player","werepig","guard","nanachifriend"})
    for k, v in pairs(ents) do
        if not v:IsAsleep() and not v.components.sleeper:IsAsleep() then
            if inst.components.leader:CountFollowers() >= 1 then return end
            if v.components.health and not v.components.health:IsDead() then
                inst:PushEvent("makefriend")
                inst.components.leader:AddFollower(v)
                v.components.follower:AddLoyaltyTime(240)
                v:AddTag("nanachifriend")
                v:DoTaskInTime(480,function()
                    v:RemoveTag("nanachifriend")
                    end)
            end
        end
    end
end

local function onbecamehuman(inst)
    inst.components.locomotor.walkspeed = 4*1.35
    inst.components.locomotor.runspeed = 6*1.35

    local hat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
    if hat ~= nil and hat:HasTag("nanachihat") then
        inst.AnimState:AddOverrideBuild("nanachihair")
        inst.AnimState:OverrideSymbol("swap_hat", "hat_nanachihat", "swap_hat")
        inst.AnimState:Show("HAT")
        inst.AnimState:Show("HAT_HAIR")
    end
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:RemoveTag("scarytoprey")
    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end

local common_postinit = function(inst) 
	inst.MiniMapEntity:SetIcon( "nanachi.tex" )
    inst:AddTag("nanachi")
    inst:RemoveTag("scarytoprey")
end

local master_postinit = function(inst)
	inst.soundsname = "nanachi"
    inst.talker_path_override = "nanachi/"
	inst.components.health:SetMaxHealth(TUNING.NANACHI_HEALTH)
	inst.components.hunger:SetMax(TUNING.NANACHI_HUNGER)
	inst.components.sanity:SetMax(TUNING.NANACHI_SANITY)
	inst.components.combat.damagemultiplier = 1
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_MED

    inst.components.locomotor.walkspeed = 4*1.35
    inst.components.locomotor.runspeed = 6*1.35

    if TUNING.NANACHIFRIEND == 1 and inst.task == nil then
        inst.task = inst:DoPeriodicTask(1, FindFriend)
    end

    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("nanachi", prefabs, assets, common_postinit, master_postinit, start_inv)