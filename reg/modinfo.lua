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
}
