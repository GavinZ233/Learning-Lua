
--声明对象
Object:subClass("ItemGrid")

--成员变量
ItemGrid.obj=nil
ItemGrid.icon=nil
ItemGrid.num=nil

--实例化各自对象
function ItemGrid:Init(father,posX,posY)
    self.obj=ABMgr:LoadRes("ui","ItemGrid",typeof(GameObject));
    --设置父对象
    self.obj.transform:SetParent(father,false)
    --设置位置
    self.obj.transform.localPosition=Vector3(posX,posY,0)
    --找到控件
    self.icon=self.obj.transform:Find("icon"):GetComponent(typeof(Image))
    self.num=self.obj.transform:Find("num"):GetComponent(typeof(Text))

end



--初始化格子信息
function ItemGrid:InitData(data)
    local itemInfo=ItemData[data.id]
    --从物品信息中找到icon名称，并使用`——`分割成多个字符串
    local strs=string.split(itemInfo.icon,"_")
    --加载图集
    local spriteAtlas=ABMgr:LoadRes("ui",strs[1],typeof(SpriteAtlas))
    --加载图标
    self.icon.sprite=spriteAtlas:GetSprite(strs[2])

    --设置数量
    self.num.text=data.num

end

--加逻辑
function ItemGrid:Destroy()
    GameObject.Destroy(self.obj)
    self.obj=nil
end

















