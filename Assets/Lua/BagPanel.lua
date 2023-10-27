BagPanel={}

--控件
BagPanel.panelObj=nil
BagPanel.btnClose=nil
BagPanel.togEquip=nil
BagPanel.togItem=nil
BagPanel.togGem=nil
BagPanel.svBag=nil
BagPanel.Content=nil

--用来存储当前显示的格子
BagPanel.items={}


function BagPanel:Init()
    self.panelObj=ABMgr:LoadRes("ui","BagPanel",typeof(GameObject))
    self.panelObj.transform:SetParent(Canvas,false)

    self.btnClose=self.panelObj.transform:Find("btnClose"):GetComponent(typeof(Button))
    --获取多选框控件
    local group=self.panelObj.transform:Find("toggleGroup")
    self.togEquip=group:Find("togEquip"):GetComponent(typeof(Toggle))
    self.togItem=group:Find("togItem"):GetComponent(typeof(Toggle))
    self.togGem=group:Find("togGem"):GetComponent(typeof(Toggle))
    --获取滚动框控件
    self.svBag=self.panelObj.transform:Find("svBag"):GetComponent(typeof(ScrollRect))
    self.Content=self.svBag.transform:Find("Viewport"):Find("Content")
    
    --为了和唐老师课程一致，将挂载的group组件失活,后续用代码排列Item
    self.Content:GetComponent(typeof(GridLayoutGroup)).enabled=false
    self.Content:GetComponent(typeof(ContentSizeFitter)).enabled=false



    --关闭事件
    self.btnClose.onClick:AddListener(function ()
        self:HideMe()
    end)

    --多选框事件
    self.togEquip.onValueChanged:AddListener(function(value)
        if value==true then
            self:ChangeType(1)
        end
    end)
    self.togItem.onValueChanged:AddListener(function(value)
        if value==true then
            self:ChangeType(2)
        end
    end)
    self.togGem.onValueChanged:AddListener(function(value)
        if value==true then
            self:ChangeType(3)
        end
    end)
end

function BagPanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)
end

function BagPanel:HideMe()
    self.panelObj:SetActive(false)
end


--切换页签方法
--type：1装备，2物品，3宝石
function BagPanel:ChangeType(type)
    print("类型切换为:"..type)

    --更新前，删掉老的格子items
    for i=1 ,#self.items do
        GameObject.Destroy(self.items[i].obj)
    end
    --要根据传入的type来选择显示的数据

    --先记录当前要显示的信息表
    local nowItems=nil
    if type==1 then
        nowItems=PlayerData.equips
    elseif type==2 then
        nowItems=PlayerData.items
    else 
        nowItems=PlayerData.gems
    end

    for i=1 ,#nowItems do
        --物品栏格子表
        local grid={}
        --用一张新表代表格子对象里的属性，存储对应想要的信息
        grid.obj=ABMgr:LoadRes("ui","ItemGrid",typeof(GameObject));
        --设置父对象
        grid.obj.transform:SetParent(self.Content,false)
        --设置位置
        grid.obj.transform.localPosition=Vector3((i-1)%4*114,math.floor((i-1)/4)*114,0)
        --找到控件
        grid.icon=grid.obj.transform:Find("icon"):GetComponent(typeof(Image))
        grid.num=grid.obj.transform:Find("num"):GetComponent(typeof(Text))

        --设置图标
        --用id从表中找到对应的物品信息
        local data=ItemData[nowItems[i].id]
        --从物品信息中找到icon名称，并使用`——`分割成多个字符串
        local strs=string.split(data.icon,"_")
        --加载图集
        local spriteAtlas=ABMgr:LoadRes("ui",strs[1],typeof(SpriteAtlas))
        --加载图标
        grid.icon.sprite=spriteAtlas:GetSprite(strs[2])

        --设置数量
        grid.num.text=nowItems[i].num

        --存放格子
        table.insert(self.items,grid)
    end

end





