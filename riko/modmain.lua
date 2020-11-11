PrefabFiles = {"riko", "rikohat", "riko_sack", "rikocookpot", "rikofoods"}
Assets = {
    Asset("IMAGE", "images/inventoryimages/riko_sack.tex"),
    Asset("ATLAS", "images/inventoryimages/riko_sack.xml"),
    Asset("IMAGE", "images/map_icons/rikocookpot.tex"),
    Asset("ATLAS", "images/map_icons/rikocookpot.xml")
}
AddMinimapAtlas("images/map_icons/riko.xml")
AddModCharacter("riko", "FEMALE")

TUNING.RIKO_HEALTH = GetModConfigData("health")
TUNING.RIKO_HUNGER = GetModConfigData("hunger")
TUNING.RIKO_SANITY = GetModConfigData("sanity")

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.NANACHI = { "rikohat", "rikocookpot"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["rikohat"] = {
    atlas = "images/inventoryimages/rikohat.xml",
    image = "rikohat.tex",
}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["rikocookpot"] = {
    atlas = "images/inventoryimages/rikocookpot.xml",
    image = "rikocookpot.tex",
}

local rikofoods = {
    riko_onigiri = {
        test = function(cooker, names, tags)
            return not tags.meat and tags.veggie and not tags.inedible
        end,
        priority = 1,
        weight = 1,
        foodtype = GLOBAL.FOODTYPE.VEGGIE,
        health = 12,
        hunger = 62.5,
        perishtime = TUNING.PERISH_MED,
        sanity = 5,
        cooktime = .5
    },
    riko_dashi = {
        test = function(cooker, names, tags)
            return tags.fish and tags.fish >= 1.5 and tags.meat and tags.meat >= 2 and names.cutlichen
        end,
        priority = 50,
        weight = 1,
        foodtype = GLOBAL.FOODTYPE.MEAT,
        health = 60,
        hunger = 37.5,
        perishtime = TUNING.PERISH_MED,
        sanity = 33,
        cooktime = 2
    },
    riko_grill = {
        test = function(cooker, names, tags)
            return tags.meat and names.twigs and not tags.fish
        end,
        priority = 10,
        weight = 1,
        foodtype = GLOBAL.FOODTYPE.MEAT,
        health = 3,
        hunger = 37.5,
        perishtime = TUNING.PERISH_MED,
        sanity = 5,
        cooktime = .25
    },
    riko_friedfish = {
        test = function(cooker, names, tags)
            return tags.fish and tags.fish >= 1.5 and (names.green_cap or names.red_cap or names.blue_cap) and
                tags.sweetener
        end,
        priority = 50,
        weight = 1,
        foodtype = GLOBAL.FOODTYPE.MEAT,
        health = 80,
        hunger = 50,
        perishtime = nil,
        sanity = 15,
        cooktime = 2
    },
    riko_snack = {
        test = function(cooker, names, tags)
            return tags.fruit and tags.egg and tags.egg > 1
        end,
        priority = 50,
        weight = 1,
        foodtype = GLOBAL.FOODTYPE.VEGGIE,
        health = 10,
        hunger = 12.5,
        perishtime = TUNING.PERISH_MED,
        sanity = 50,
        cooktime = 2
    }
}
for k, v in pairs(rikofoods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
end
for k, recipe in pairs(rikofoods) do
    AddCookerRecipe("rikocookpot", recipe)
end
AddMinimapAtlas("images/map_icons/rikocookpot.xml")
local oldactionstore = GLOBAL.ACTIONS.STORE.fn
GLOBAL.ACTIONS.STORE.fn = function(act)
    if
        act.target.prefab == "rikocookpot" and act.target.components.container ~= nil and
            act.invobject.components.inventoryitem ~= nil and
            act.doer.components.inventory ~= nil
     then
        if act.target.components.container:IsOpen() and not act.target.components.container:IsOpenedBy(act.doer) then
            return false, "INUSE"
        elseif not act.target.components.container:CanTakeItemInSlot(act.invobject) then
            return false, "NOTALLOWED"
        end
        local item =
            act.invobject.components.inventoryitem:RemoveFromOwner(act.target.components.container.acceptsstacks)
        if item ~= nil then
            act.target.components.container:Open(act.doer)
            if not act.target.components.container:GiveItem(item, nil, nil, false) then
                if
                    act.doer.components.playercontroller ~= nil and
                        act.doer.components.playercontroller.isclientcontrollerattached
                 then
                    act.doer.components.inventory:GiveItem(item)
                else
                    act.doer.components.inventory:GiveActiveItem(item)
                end
                return false
            end
            return true
        end
    end
    return oldactionstore(act)
end
local oldactionstorestr = GLOBAL.ACTIONS.STORE.strfn
GLOBAL.ACTIONS.STORE.strfn = function(act)
    if act.target ~= nil then
        if act.target.prefab == "rikocookpot" then
            return "COOK"
        end
    end
    return oldactionstorestr(act)
end
local oldactionpickup = GLOBAL.ACTIONS.PICKUP.fn
GLOBAL.ACTIONS.PICKUP.fn = function(act)
    if
        act.doer.components.inventory ~= nil and act.target ~= nil and act.target.components.pickupable ~= nil and
            not act.target:IsInLimbo()
     then
        act.doer:PushEvent("onpickupitem", {item = act.target})
        return act.target.components.pickupable:OnPickup(act.doer)
    end
    return oldactionpickup(act)
end
AddPrefabPostInit(
    "shadowmeteor",
    function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return inst
        end
        local oldSetSize = inst.SetSize
        inst.SetSize = function(inst, sz, mod)
            local size = 0.7
            if sz ~= nil then
                if sz == "medium" then
                    size = 1
                elseif sz == "large" then
                    size = 1.3
                end
            end
            local x1, y1, z1 = inst.Transform:GetWorldPosition()
            local entis = GLOBAL.TheSim:FindEntities(x1, y1, z1, size * GLOBAL.TUNING.METEOR_RADIUS)
            for i, v in ipairs(entis) do
                if v.prefab == "rikocookpot" then
                    return
                end
            end
            oldSetSize(inst, sz, mod)
        end
    end
)
local function stewerfix(inst, doer, actions, right)
    local function CanBePickUp(inst)
        return not inst:HasTag("donecooking") and not inst:HasTag("readytocook") and inst.replica.container ~= nil and
            #inst.replica.container:GetItems() == 0 and
            not inst:HasTag("isopen") and
            not inst:HasTag("iscooking")
    end
    if inst.prefab == "rikocookpot" and right and CanBePickUp(inst) then
        table.insert(actions, GLOBAL.ACTIONS.PICKUP)
    end
end
AddComponentAction("SCENE", "stewer", stewerfix)
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
local riko_sack =
    Recipe(
    "riko_sack",
    {Ingredient("bearger_fur", 1), Ingredient("papyrus", 4), Ingredient("rope", 2)},
    RECIPETABS.SURVIVAL,
    TECH.NONE,
    nil,
    nil,
    nil,
    nil,
    "riko"
)
riko_sack.atlas = "images/inventoryimages/riko_sack.xml"
