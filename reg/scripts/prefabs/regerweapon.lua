local assets = {}
local function simple(name)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("weapon")
    return inst
end
local function fn()
    local inst = simple("regerweapon")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.weapon:SetDamage(5000)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetProjectile("reger_projectile")
    return inst
end
return Prefab("regerweapon", fn, assets)
