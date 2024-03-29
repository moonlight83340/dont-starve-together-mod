local assets =
{
	Asset("ANIM", "anim/nanachi_soup.zip"),
    Asset("ATLAS", "images/inventoryimages/nanachi_soup.xml"),
}

local prefabs = 
{
	"spoiled_food",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	if TheSim:GetGameID() =="DST" then inst.entity:AddNetwork() end
	
	MakeInventoryPhysics(inst)
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	
	inst.AnimState:SetBank("nanachi_soup")
	inst.AnimState:SetBuild("nanachi_soup")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("preparedfood")
	inst:AddTag("nanachisoup")
    
	if TheSim:GetGameID()=="DST" then
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.entity:SetPristine()
	end
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = 40
	inst.components.edible.hungervalue = 50
	inst.components.edible.sanityvalue = -20

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/nanachi_soup.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	return inst
end

return Prefab( "nanachi_soup", fn, assets, prefabs )