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
    Asset("ANIM", "anim/riko.zip"),
    Asset("ANIM", "anim/ghost_riko_build.zip"),
    Asset("IMAGE", "images/saveslot_portraits/riko.tex"),
    Asset("ATLAS", "images/saveslot_portraits/riko.xml"),
    Asset("IMAGE", "images/selectscreen_portraits/riko.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/riko.xml"),
    Asset("IMAGE", "images/selectscreen_portraits/riko_silho.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/riko_silho.xml"),
    Asset("IMAGE", "bigportraits/riko.tex"),
    Asset("ATLAS", "bigportraits/riko.xml"),
    Asset("IMAGE", "images/map_icons/riko.tex"),
    Asset("ATLAS", "images/map_icons/riko.xml"),
    Asset("IMAGE", "images/avatars/avatar_riko.tex"),
    Asset("ATLAS", "images/avatars/avatar_riko.xml"),
    Asset("IMAGE", "images/avatars/avatar_ghost_riko.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_riko.xml")
}
local prefabs = {}
local start_inv = {"rikohat", "rikocookpot_item"}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ESCTEMPLATE = {
    GENERIC = "It's Esc!",
    ATTACKER = "That Esc looks shifty...",
    MURDERER = "Murderer!",
    REVIVER = "Esc, friend of ghosts.",
    GHOST = "Esc could use a heart."
}
local common_postinit = function(inst)
    inst.MiniMapEntity:SetIcon("riko.tex")
    inst:AddTag("riko")
end
local master_postinit = function(inst)
    inst.soundsname = "willow"
    inst.components.health:SetMaxHealth(TUNING.RIKO_HEALTH)
    inst.components.hunger:SetMax(TUNING.RIKO_HUNGER)
    inst.components.sanity:SetMax(TUNING.RIKO_SANITY)
    inst.components.combat.damagemultiplier = 0.75
end
STRINGS.CHARACTER_TITLES.riko = "莉可"
STRINGS.CHARACTER_NAMES.riko = "莉可"
STRINGS.CHARACTER_DESCRIPTIONS.riko = "*精通厨艺\n*能制作一个大背包\n*不擅长战斗"
STRINGS.CHARACTER_QUOTES.riko = "妈妈在奈落之底等着我呢"
STRINGS.CHARACTERS.RIKO = require "speech_riko"
STRINGS.NAMES.RIKO = "莉可"
STRINGS.CHARACTER_SURVIVABILITY.riko = "Slim"
return MakePlayerCharacter("riko", prefabs, assets, common_postinit, master_postinit, start_inv)
