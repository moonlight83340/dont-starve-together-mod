local STRINGS = GLOBAL.STRINGS
local require = GLOBAL.require
local NanachiIndicator = require ("widgets/nanachiindicator")

Assets =
{
	Asset("ATLAS", "images/mod_nanachiindicators_icons.xml"),
	Asset("IMAGE", "images/mod_nanachiindicators_icons.tex"),

	Asset( "IMAGE", "images/map_icons/nanachitent.tex" ),
    Asset( "ATLAS", "images/map_icons/nanachitent.xml" ),

    Asset( "IMAGE", "images/inventoryimages/nanachitent.tex" ),
    Asset( "ATLAS", "images/inventoryimages/nanachitent.xml" ),

    Asset( "IMAGE", "images/inventoryimages/nanachi_mitty.tex" ),
    Asset( "ATLAS", "images/inventoryimages/nanachi_mitty.xml" ),
}


PrefabFiles = {
   "nanachi",
   "nanachi_soup",
   "nanachihat",
   "nanachitent",
   "nanachi_mitty",
}

GLOBAL.MOD_NANACHIINDICATORS = {}

GLOBAL.MOD_NANACHIINDICATORS.BOSSES = {}

local function RGB(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end

local BOSS_COLOURS =
{
	deerclops 			= RGB(255,255,255),
	bearger 			= RGB(100,100,100),
	dragonfly 			= RGB(0,220,60),
	moose 				= RGB(200,180,140),
	minotaur 			= RGB(180,160,120),
	toadstool			= RGB(170,80,255),
	toadstool_cap 		= RGB(170,80,255),
	antlion 			= RGB(255,140,0),
	klaus 				= RGB(240,70,70),
	klaus_sack 			= RGB(255,255,255),
	pigking 			= RGB(255,255,255),
}

AddMinimapAtlas("images/map_icons/nanachi.xml")
AddMinimapAtlas("images/map_icons/nanachitent.xml")
AddMinimapAtlas("images/map_icons/nanachi_mitty.xml")
AddModCharacter("nanachi", "FEMALE")

local nanachifoods =
{
nanachi_soup =
	{	
		test = function(cooker, names, tags) return tags.egg and tags.veggie and tags.veggie >=2 and tags.fish end,
		priority = 6,
		weight = 1,
		foodtype = GLOBAL.FOODTYPE.VEGGIE,
		health = 40,			
		hunger = 50,			
		perishtime = TUNING.PERISH_MED,			
		sanity = -20,			
		cooktime = 2,
	},
}

for k,v in pairs(nanachifoods) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
end
		 
for k,recipe in pairs(nanachifoods) do
	AddCookerRecipe("cookpot", recipe)
end

local Recipe = GLOBAL.Recipe
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

local nanachitent = Recipe("nanachitent",{ Ingredient("goose_feather", 5), Ingredient("cutgrass", 12), Ingredient("petals", 5) }, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, "nanachitent_placer", nil, nil, nil, "nanachi")
nanachitent.atlas = "images/inventoryimages/nanachitent.xml"
nanachitent.sortkey = 1

TUNING.MITTY_CD = 30 -- 480
TUNING.MITTY_NUM = 5

AddPrefabPostInit("beefalo", function(inst)
    if inst.components and inst.components.eater then
    	local OldOnEat = inst.components.eater.oneatfn
        inst.components.eater:SetOnEatFn(function(inst,food)
        	if food:HasTag("nanachisoup") then
        		inst.components.domesticatable:DeltaDomestication(0.05)
        	end
        	OldOnEat(inst,food)
         end)
    end
end)
--[[
local function SpawnMitty(inst)
	if GLOBAL.TheSim:FindFirstEntityWithTag("mitty") == nil then
		inst:DoTaskInTime(2,function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			local mitty = GLOBAL.SpawnPrefab("nanachi_mitty")
			mitty.Transform:SetPosition(x,y,z)
		end)
	end
end

AddPrefabPostInit("hutch_fishbowl",function(inst)
	inst.OnNewSpawn = SpawnMitty(inst)
end)]]

if GetModConfigData("language") == 2 then
	STRINGS.NAMES.NANACHI_SOUP= "奈落炖锅"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANACHI_SOUP= "不好吃就别吃嘛……"
	STRINGS.NAMES.NANACHIHAT= "娜娜奇的帽子"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANACHIHAT= "这是咱的帽子~"
	STRINGS.NAMES.NANACHITENT= "回忆之所"
	STRINGS.RECIPE_DESC.NANACHITENT = "请再稍微等咱一下吧……"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANACHITENT= "一个充满回忆的地方。"
	STRINGS.CHARACTER_TITLES.nanachi= "娜娜奇"
	STRINGS.CHARACTER_NAMES.nanachi= "娜娜奇"
	STRINGS.CHARACTER_DESCRIPTIONS.nanachi= "*手感毛茸茸的\n*闻起来很香"
	STRINGS.CHARACTER_QUOTES.nanachi= "不要靠那么近啦！"
	STRINGS.CHARACTERS.NANACHI= require "speech_nanachi_ch"
	STRINGS.NAMES.NANACHI = "娜娜奇"
else
	STRINGS.NAMES.NANACHI_SOUP= "nairobi stew"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANACHI_SOUP= "nairobi stew"
	STRINGS.NAMES.NANACHIHAT= "nanachi's hat"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANACHIHAT= "This is my hat."
	STRINGS.NAMES.NANACHITENT= "nanachi's tent"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANACHITENT= "This is my tent."
	STRINGS.CHARACTER_TITLES.nanachi= "Nanachi"
	STRINGS.CHARACTER_NAMES.nanachi= "Nanachi"
	STRINGS.CHARACTER_DESCRIPTIONS.nanachi= "*Nanachi!!"
	STRINGS.CHARACTER_QUOTES.nanachi= "Nanachi"
	STRINGS.CHARACTERS.NANACHI= require "speech_nanachi"
	STRINGS.NAMES.NANACHI = "Nanachi"
end

TUNING.NANACHIFRIEND = GetModConfigData("attract")

STRINGS.CHARACTER_SURVIVABILITY.nanachi= "Slim"
TUNING.NANACHI_HEALTH = GetModConfigData("health")
TUNING.NANACHI_HUNGER = GetModConfigData("hunger")
TUNING.NANACHI_SANITY = GetModConfigData("sanity")

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.REGER = { "nanachihat"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["nanachihat"] = {
    atlas = "images/inventoryimages/nanachihat.xml",
    image = "nanachihat.tex",
}

AddPlayerPostInit(function(inst)
	if inst:HasTag("nanachi") then
		inst:AddComponent("nanachiindicator")
	end
end)

AddClassPostConstruct("screens/playerhud", function(self)

	self.AddNanachiIndicator = function(self, target)
		if not self.nanachiindicators then
			self.nanachiindicators = {}
		end

		local bi = self.under_root:AddChild(NanachiIndicator(self.owner, target, BOSS_COLOURS["moose"]))
		table.insert(self.nanachiindicators, bi)
	end
		
	self.HasNanachiIndicator = function(self, target)
		if not self.nanachiindicators then return end

		for i,v in pairs(self.nanachiindicators) do
			if v and v:GetTarget() == target then
				return true
			end
		end
		return false
	end
	
	self.RemoveNanachiIndicator = function(self, target)
		 if not self.nanachiindicators then return end

		local index = nil
		for i,v in pairs(self.nanachiindicators) do
			if v and v:GetTarget() == target then
				index = i
				break
			end
		end
		if index then
			local bi = table.remove(self.nanachiindicators, index)
			if bi then bi:Kill() end
		end
	end
end)

local Bosses = {"deerclops", "bearger", "dragonfly", "moose", 
				"minotaur", "toadstool", "antlion", "klaus", "klaus_sack", 
				"pigking", "walrus_camp", "stagehand", "moonbase", "critterlab", "beequeenhive", "ancient_altar", 
				"knight", "rook", "bishop", "chester_eyebone", "sculpture_knighthead", "sculpture_bishophead", "sculpture_rooknose", 
			}

local function AddBossToIndicatorTable(inst)
	table.insert(GLOBAL.MOD_NANACHIINDICATORS.BOSSES, inst)
end

local function RemoveBossFromIndicatorTable(inst)
	local index = nil
	for i,v in ipairs(GLOBAL.MOD_NANACHIINDICATORS.BOSSES) do
		if v == inst then
			index = i
			break
		end
	end
	if index then table.remove(GLOBAL.MOD_NANACHIINDICATORS.BOSSES, index) end
end

local function SetupNanachiIndicator(inst)
	AddBossToIndicatorTable(inst)
	inst:ListenForEvent("onremove", function(inst)
		RemoveBossFromIndicatorTable(inst)
	end)
end

for i,v in ipairs(Bosses) do
	AddPrefabPostInit(v, function(inst)
		print("I exist", inst)
		SetupNanachiIndicator(inst)
	end)
end

local Toadstool_Cap = nil

AddPrefabPostInit("toadstool", function(inst)
	AddBossToIndicatorTable(inst)

	if Toadstool_Cap then
		RemoveBossFromIndicatorTable(Toadstool_Cap)
	end
	
	inst:ListenForEvent("onremove", function(inst)
		RemoveBossFromIndicatorTable(inst)
		
		if Toadstool_Cap then
			AddBossToIndicatorTable(Toadstool_Cap)
		end
	end)
end)

AddPrefabPostInit("toadstool_cap", function(inst)
	inst:DoTaskInTime(0.1, function(inst)
		if inst._state:value() > 0 then
			AddBossToIndicatorTable(inst)
			Toadstool_Cap = inst
		end
	end)
end)
--[[
local function FuckGlobalUsingMetatable()
	GLOBAL.setmetatable(env, {
		__index = function(t, k)
			return GLOBAL.rawget(GLOBAL, k)
		end,
	})	
end
FuckGlobalUsingMetatable()

local MITTYPUT = Action({ mount_valid=true })
MITTYPUT.id = "MITTYPUT"
MITTYPUT.str = "放入米缇"
MITTYPUT.fn = function(act)
	if act.doer and act.target then
		local position = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
		item = inst.components.inventory:GetEquippedItem(position)
		inst.components.inventory:DropItem(item)
		item.empty = true
		item.mitty_num = 0
		item:RemoveTag("sleep")
		item.AnimState:PlayAnimation("empty")
		local lefttime = item.components.timer:GetTimeLeft("sleep")
		if lefttime and lefttime > 0 then
			item.components.timer:StopTimer("sleep")
			act.target.components.timer:StartTimer("mittysleep",lefttime/3)
			act.target.AnimState:AddOverrideBuild("nanachitent_mitty")
		else
			act.target.AnimState:AddOverrideBuild("nanachitent_mittywake")
		end
		act.doer:RemoveTag("toadstool")
		act.target:AddTag("hassleeper")
		act.target:AddTag("mittysleep")
		return true
	end
	return false
end
AddAction(MITTYPUT)
AddComponentAction("SCENE", "sleepingbag", function(inst, doer, actions, right)
	--if right then
		--and inst:HasTag("nanachitent") and not inst:HasTag("hassleeper") then
		--and doer:HasTag("mittybasket") then
		table.insert(actions, GLOBAL.ACTIONS.MITTYPUT)
	--end
end)
AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(ACTIONS.MITTYPUT, "doshortaction"))
AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(ACTIONS.MITTYPUT, "doshortaction"))

local MITTYPICK = Action({ mount_valid=true })
MITTYPICK.id = "MITTYPICK"
MITTYPICK.str = "取出米缇"
MITTYPICK.fn = function(act)
	if act.doer and act.target then
		local position = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
		item = inst.components.inventory:GetEquippedItem(position)
		inst.components.inventory:DropItem(item)
		item.empty = false
		item.AnimState:PlayAnimation("idle")
		local lefttime = act.target.components.timer:GetTimeLeft("mittysleep")
		if lefttime and lefttime > 0 then
			act.target.components.timer:StopTimer("mittysleep")
			item:AddTag("sleep")
			item.mitty_num = TUNING.MITTY_NUM
			item.components.timer:StartTimer("sleep",lefttime*3)
			item.AnimState:PlayAnimation("sleep")
		end
		act.doer:AddTag("toadstool")
		act.target:RemoveTag("hassleeper")
		act.target:RemoveTag("mittysleep")
		act.target.AnimState:ClearOverrideBuild("nanachitent_mittywake")
		act.target.AnimState:ClearOverrideBuild("nanachitent_mitty")
		return true
	end
	return false
end
AddAction(MITTYPICK)
AddComponentAction("SCENE", "sleepingbag", function(inst, doer, actions, right)
	if right and inst:HasTag("nanachitent") and inst:HasTag("mittysleep") 
		and not doer:HasTag("toadstool") and doer:HasTag("mittybasket") then
		table.insert(actions, GLOBAL.ACTIONS.MITTYPICK)
	end
end)
AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(ACTIONS.MITTYPICK, "doshortaction"))
AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(ACTIONS.MITTYPICK, "doshortaction"))
]]