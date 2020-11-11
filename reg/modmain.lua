local STRINGS = GLOBAL.STRINGS
local require = GLOBAL.require
local Action = GLOBAL.Action
local xz_exp = require("widgets/xz_exp")

PrefabFiles = {"reger", "regercloak", "regerhat", "abyssweapon", "regerweapon", "reger_projectile"}
Assets = {Asset("ANIM", "anim/xz_exp.zip"), Asset("ATLAS", "images/status_bgs.xml")}
TUNING.REGBOMB_HEALTH = 40
TUNING.REGBOMB_HUNGER = 40
TUNING.REGBOMB_SANITY = 40
TUNING.REGBOMB_DAMAGE = 800
TUNING.REGBOMB_CONSUME = 1
TUNING.REGERMAXTIME = 5
TUNING.ABYSSUSES = 200
TUNING.REGER_SLOW_HUNGER = 0.6

AddMinimapAtlas("images/map_icons/reger.xml")
AddModCharacter("reger", "MALE")

STRINGS.CHARACTER_TITLES.reger = "雷格"
STRINGS.CHARACTER_NAMES.reger = "雷格"
STRINGS.CHARACTER_DESCRIPTIONS.reger = "*失去记忆的小机器人\n*强大的战斗能力\n*吃莉可料理升级"
STRINGS.CHARACTER_QUOTES.reger = '"我一定要保护莉可"'
STRINGS.CHARACTERS.REGER = require "speech_reger"
STRINGS.NAMES.REGER = "雷格"
STRINGS.CHARACTER_SURVIVABILITY.reger = "Slim"

TUNING.REGER_HEALTH = GetModConfigData("health")
TUNING.REGER_HUNGER = GetModConfigData("hunger")
TUNING.REGER_SANITY = GetModConfigData("sanity")

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.REGER = { "abyssweapon", "regercloak", "regerhat" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["abyssweapon"] = {
    atlas = "images/inventoryimages/abyssweapon.xml",
    image = "abyssweapon.tex",
}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["regercloak"] = {
    atlas = "images/inventoryimages/regercloak.xml",
    image = "regercloak.tex",
}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["regerhat"] = {
    atlas = "images/inventoryimages/regerhat.xml",
    image = "regerhat.tex",
}

local function AddExp(self)
    if self.owner and self.owner:HasTag("reger") then
        self.xz_exp = self.status:AddChild(xz_exp(self.owner))
        self.xz_exp:SetPosition(-80, -40, 0)
    end
end
AddClassPostConstruct("widgets/controls", AddExp)
local function onupdate(inst)
    inst.components.health:SetMaxHealth(TUNING.REGER_HEALTH) --+ inst.components.exp.levelpoint * 50)
    inst.components.hunger:SetMax(TUNING.REGER_HUNGER) --+ inst.components.exp.levelpoint * 25)
    inst.components.sanity:SetMax(TUNING.REGER_SANITY) --+ inst.components.exp.levelpoint * 25)
    inst.components.combat.damagemultiplier = 1 --+ inst.components.exp.levelpoint * 0.25
    inst.components.exp.maxtimepiont = inst.components.exp.levelpoint * 20 + 20
end
AddPlayerPostInit(
    function(inst)
        if inst:HasTag("reger") then
            inst.exp_max = GLOBAL.net_shortint(inst.GUID, "exp_max", "exp_maxdirty")
            inst.exp_current = GLOBAL.net_shortint(inst.GUID, "exp_current", "exp_currentdirty")
            inst.exp_level = GLOBAL.net_shortint(inst.GUID, "exp_level", "exp_leveldirty")
            if GLOBAL.TheWorld.ismastersim then
                inst:AddComponent("exp")
                inst.components.exp.updatefn = onupdate
                inst.components.exp.maxlevel = 2
            end
        end
    end
)
GLOBAL.FUELTYPE.POWER = "power"
table.insert(GLOBAL.FUELTYPE, GLOBAL.FUELTYPE.POWER)
AddPrefabPostInit(
    "gunpowder",
    function(inst)
        inst:AddComponent("fuel")
        inst:AddTag("power_fuel")
        if inst.components.fuel then
            inst.components.fuel.fuelvalue = 10
            inst.components.fuel.fueltype = GLOBAL.FUELTYPE.POWER
        end
    end
)
local REGBOMB = Action({distance = 36})
REGBOMB.id = "REGBOMB"
REGBOMB.str = "bomb"
REGBOMB.fn = function(act)
    if
        act.doer ~= nil and act.doer:HasTag("regerbomb") and act.target ~= nil and act.doer:HasTag("player") and
            act.target.components.combat and
            act.target.components.health
     then
        local headitem = nil
        if act.doer.components.inventory then
            headitem = act.doer.components.inventory.equipslots[GLOBAL.EQUIPSLOTS.HEAD]
        elseif act.doer.replica.inventory then
            headitem = act.doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
        end
        act.doer.target = act.target
        act.doer.components.health:DoDelta(-TUNING.REGBOMB_HEALTH)
        act.doer.components.hunger:DoDelta(-TUNING.REGBOMB_HUNGER)
        act.doer.components.sanity:DoDelta(-TUNING.REGBOMB_SANITY)
        headitem.components.fueled:DoDelta(-TUNING.REGBOMB_CONSUME)
        return true
    else
        return false
    end
end
AddAction(REGBOMB)
AddComponentAction(
    "SCENE",
    "combat",
    function(inst, doer, actions, right)
        if right then
            if
                doer:HasTag("regerbomb") and inst.replica.health ~= nil and not inst:HasTag("player") and
                    doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS) == nil
             then
                table.insert(actions, GLOBAL.ACTIONS.REGBOMB)
            end
        end
    end
)
local state_regbomb =
    GLOBAL.State {
    name = "regbomb",
    tags = {"doing", "busy"},
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:OverrideSymbol("swap_object", "reagerweapon", "reagerweapon")
        inst.AnimState:SetPercent("dart_pre", 1)
        inst.sg.statemem.action = inst.bufferedaction
        inst.sg:SetTimeout(2)
        if not GLOBAL.TheWorld.ismastersim then
            inst:PerformPreviewBufferedAction()
        end
    end,
    timeline = {
        GLOBAL.TimeEvent(
            0 * GLOBAL.FRAMES,
            function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/charge")
            end
        ),
        GLOBAL.TimeEvent(
            8 * GLOBAL.FRAMES,
            function(inst)
                if GLOBAL.TheWorld.ismastersim then
                    inst:PerformBufferedAction()
                end
            end
        ),
        GLOBAL.TimeEvent(
            15 * GLOBAL.FRAMES,
            function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/explode")
                if GLOBAL.TheWorld.ismastersim then
                    inst.regerweapon.components.weapon:LaunchProjectile(inst.regerweapon, inst.target, inst)
                    for i, v in ipairs(GLOBAL.AllPlayers) do
                        local distSq = v:GetDistanceSqToInst(inst)
                        local k = math.max(0, math.min(1, distSq / 1600))
                        local intensity = k * (k - 2) + 1
                        if intensity > 0 then
                            v:ScreenFlash(intensity)
                            v:ShakeCamera(GLOBAL.CAMERASHAKE.FULL, .7, .02, intensity / 2)
                        end
                    end
                    inst:PushEvent("yawn", {grogginess = 4, knockoutduration = 10})
                end
            end
        )
    },
    onupdate = function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle", true)
            end
        end
    end,
    ontimeout = function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            inst:ClearBufferedAction()
        end
        inst.sg:GoToState("idle")
    end,
    onexit = function(inst)
        if inst.bufferedaction == inst.sg.statemem.action then
            inst:ClearBufferedAction()
        end
        inst.sg.statemem.action = nil
    end
}
AddStategraphState("wilson", state_regbomb)
AddStategraphState("wilson_client", state_regbomb)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.REGBOMB, "regbomb"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.REGBOMB, "regbomb"))
