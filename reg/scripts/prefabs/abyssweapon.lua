local assets = {
    Asset("ANIM", "anim/abyssweapon.zip"),
    Asset("ANIM", "anim/swap_abyssweapon.zip"),
    Asset("IMAGE", "images/inventoryimages/abyssweapon.tex"),
    Asset("ATLAS", "images/inventoryimages/abyssweapon.xml")
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_abyssweapon", "abyssweapon")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, owner, target)
	if TUNING.ABYSS_WEAPON_EXPLOSION_ACTIVATION ~= 2 then
		if (inst.components.finiteuses:GetUses() % 30) == 0 then
			if target.components.health and not inst.components.fueled:IsEmpty() then
				if owner:HasTag("reger") then
					SpawnPrefab("explode_small").Transform:SetPosition(target.Transform:GetWorldPosition())
					target.components.health:DoDelta(-TUNING.ABYSS_WEAPON_REG_DAMMAGE_EXPLOSION)
					inst.components.finiteuses:Use(5)
					--inst.components.fueled:DoDelta(-10)
				elseif owner:HasTag("riko") then
					local explode = SpawnPrefab("explode_small")
					explode.Transform:SetScale(0.3, 0.3, 0.3)
					explode.Transform:SetPosition(target.Transform:GetWorldPosition())
					target.components.health:DoDelta(-TUNING.ABYSS_WEAPON_RIKO_DAMMAGE_EXPLOSION)
					inst.components.finiteuses:Use(2)
					--inst.components.fueled:DoDelta(-1)
				end
			end
		end
	end
end
local function simple(name)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("abyssweapon")
    inst:AddTag("power_fueled")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("weapon")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. name .. ".xml"
    inst.components.inventoryitem.imagename = name
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.ABYSSUSES)
    inst.components.finiteuses:SetUses(TUNING.ABYSSUSES)
	inst.components.finiteuses:SetOnFinished(onfinished)
	
	
    --inst:AddComponent("fueled")
    --inst.components.fueled.fueltype = FUELTYPE.POWER
    --inst.components.fueled:InitializeFuelLevel(TUNING.ABYSSUSES)
    --inst.components.fueled.accepting = true
    MakeHauntableLaunch(inst)
    return inst
end
local function fn()
    local inst = simple("abyssweapon")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.weapon:SetDamage(60)
	--if owner:HasTag("reger") then
	--	inst.components.weapon:SetDamage(ABYSS_WEAPON_REG_DAMMAGE)
	--elseif owner:HasTag("riko") then
	--	inst.components.weapon:SetDamage(ABYSS_WEAPON_RIKO_DAMMAGE)
	--end
    return inst
end
STRINGS.NAMES.ABYSSWEAPON = "无尽锤"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ABYSSWEAPON = "待定。"
return Prefab("abyssweapon", fn, assets)
