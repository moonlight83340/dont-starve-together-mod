name = "Nanachi"
description = "来自深渊底部的迷之生物，毛茸茸的闻起来很香很香。"
author = "Haori & 宵征"
version = "1.4"
--[[
    v1.4 : 新增娜娜奇嗯呐语音
]]
api_version = 6
api_version_dst = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true 
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
server_filter_tags = {
"character",
"art",
}

configuration_options = {
	{
    name = "language",
    label = "language",
    options = 
        {
            
            {description = "English", data = 1},
            {description = "中文", data = 2},
        },
        default = 2,
    },
	{
    name = "attract",
    label = "吸引伙伴attract",
    hover = "Nanachi will/won't attract pigman.",
    options = 
        {      
            {description = "开启On", data = 1},
            {description = "关闭Off", data = 2},
        },
        default = 2,
    },
	{
	name = "health",
    label = "health",
    hover = "",
    options = 
        {
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
        {         
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
			{description = "125", data = 125},
            {description = "150", data = 150},
            {description = "175", data = 175},
        },
        default = 150,
    },
}