--玩家信息
PlayerData={}

PlayerData.equips={}
PlayerData.items={}
PlayerData.gems={}


--写一个数据初始化方法，后面可以改成从其他地方获取数据
function    PlayerData:Init()
    --道具信息只需要存ID和道具数量即可
    table.insert(self.equips,{id=1,num=1})
    table.insert(self.equips,{id=2,num=2})
    table.insert(self.items,{id=3,num=66})
    table.insert(self.items,{id=4,num=37})
    table.insert(self.gems,{id=5,num=21})
    table.insert(self.gems,{id=6,num=31})

end










