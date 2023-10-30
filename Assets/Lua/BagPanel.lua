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

BagPanel.nowType=-1

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
    if self.nowType==-1 then
        self:ChangeType(1)
    end
end

function BagPanel:HideMe()
    self.panelObj:SetActive(false)
end


--切换页签方法
--type：1装备，2物品，3宝石
function BagPanel:ChangeType(type)
    print("类型切换为:"..type)
    --判断是否需要切页
    if self.nowType==type then
        return
    end

    --更新前，删掉老的格子items
    for i=1 ,#self.items do
        self.items[i]:Destroy()
    end
    self.items={}
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
        
        --根据数据创建格子，实例化对象
        local grid=ItemGrid:new()
        grid:Init(self.Content,(i-1)%4*114,math.floor((i-1)/4)*114)
        --初始化信息
        grid:InitData(nowItems[i])
        --存放格子
        table.insert(self.items,grid)
    end

end





