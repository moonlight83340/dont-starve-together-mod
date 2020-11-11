name = "Riko"
description = "活泼而又好奇心旺盛的女孩子。\n见习探窟家。\n梦想追上母亲，成为传说中的探窟家“白笛”。"
author = "Haori & Mario"
version = "1.4"
forumthread = ""
priority = 1
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {"XZmodmaker"}
configuration_options = {
	{
	name = "health",
    label = "health",
    hover = "",
    options = 
        {
			{description = "75", data = 75},
			{description = "100", data = 100},
            {description = "125", data = 125},
            {description = "150", data = 150},
        },
        default = 75,
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
        default = 125,
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
