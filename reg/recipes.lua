local DST = GLOBAL.TheSim and GLOBAL.TheSim:GetGameID()=="DST"
local ROG = DST or GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local MakeRecipe = DST and AddRecipe or function(name,ingr,tab,tech,placer,spacing,nounlock,num,_,atlas,image)
local rec = GLOBAL.Recipe(name,ingr,tab,tech,placer,spacing,nounlock,num,_)
rec.atlas = atlas
rec.image = image
end
--local Ingredient = GLOBAL.Ingredient --already in environment

MakeRecipe("abyssweapon", 
{Ingredient("goldenpickaxe", 1), Ingredient("goldnugget", 2), Ingredient("nightmarefuel", 5) }, 
RECIPETABS.WAR, 
TECH.SCIENCE_TWO, 
nil, 
nil, 
nil, 
nil, 
nil, 
"images/inventoryimages/abyssweapon.xml",
"abyssweapon.tex") 