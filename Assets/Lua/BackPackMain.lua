print("BackPackMain，启动！")
--初始化准备好的类
require("InitClass")

require("ItemData")

require("PlayerData")
PlayerData:Init()

require("MainPanel")
require("BagPanel")
require("ItemGrid")
--MainPanel:Init()
MainPanel:ShowMe()

