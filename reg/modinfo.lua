name = "Reg"
description = "莉可在深渊里发现的，拥有和人类相似外形的机器人，失去了记忆。"
author = "羽织Haori & 宵征"
version = "1.0"
api_version = 6
api_version_dst = 10
dst_compatible = true
priority = 0
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
server_filter_tags = {
	"character", 
	"art"
}

configuration_options = {
	{
	name = "health",
    label = "health",
    hover = "",
    options = 
        {
			{description = "100", data = 100},
            {description = "125", data = 125},
            {description = "150", data = 150},
        },
        default = 125,
    },
	{
	name = "hunger",
    label = "hunger",
    hover = "",
    options = 
        {   {description = "125", data = 125},      
            {description = "150", data = 150},
            {description = "175", data = 175},
        },
        default = 150,
    },
	{
	name = "sanity",
    label = "sanity",
    hover = "",
    options = 
        {   
			{description = "100", data = 100}, 
			{description = "125", data = 125},
            {description = "150", data = 150},
            {description = "175", data = 175},
        },
        default = 125,
    },
	{
	name = "abyss_weapon_explosion_activation",
    label = "activation explosion abyss weapon",
    hover = "",
    options = 
        {   
			{description = "yes", data = 1}, 
			{description = "no", data = 2},
        },
        default = 2,
    },
	{
	name = "abyss_weapon_reg_dammage_explosion",
    label = "abyss weapon reg dammage on explosion",
    hover = "",
    options = 
        {   
            {description = "80", data = 80},
			{description = "100", data = 100},
        },
        default = 80,
    },
	{
	name = "abyss_weapon_riko_dammage_explosion",
    label = "abyss weapon riko dammage on explosion",
    hover = "",
    options = 
        {   
            {description = "50", data = 50},
            {description = "60", data = 60},
        },
        default = 50,
    },
	{
	name = "abyss_weapon_reg_dammage",
    label = "abyss weapon reg dammage",
    hover = "",
    options = 
        {   
			{description = "40", data = 40},
			{description = "50", data = 50},      
            {description = "60", data = 60},
            {description = "80", data = 80},
			{description = "100", data = 100},
        },
        default = 60,
    },
	{
	name = "abyss_weapon_riko_dammage",
    label = "abyss weapon riko dammage",
    hover = "",
    options = 
        {   
			{description = "15", data = 15}, 
			{description = "30", data = 30},
			{description = "40", data = 40},
            {description = "50", data = 50},
            {description = "60", data = 60},
        },
        default = 15,
    },
}
