
BasePanel:subClass("BagPanel")



BagPanel.Content=nil

--用来存储当前显示的格子
BagPanel.items={}

BagPanel.nowType=-1

function BagPanel:Init(name)
    self.base.Init(self,name)
    
    if self.isInitEvent==false then
        self.Content=self:GetControl("svBag","ScrollRect").transform:Find("Viewport"):Find("Content")
    
        --为了和唐老师课程一致，将挂载的group组件失活,后续用代码排列Item
        self.Content:GetComponent(typeof(GridLayoutGroup)).enabled=false
        self.Content:GetComponent(typeof(ContentSizeFitter)).enabled=false
    
    end




    --关闭事件
    self:GetControl("btnClose","Button").onClick:AddListener(function ()
        self:HideMe()
    end)

    --多选框事件
    self:GetControl("togEquip","Toggle").onValueChanged:AddListener(function(value)
        if value==true then
            self:ChangeType(1)
        end
    end)
    self:GetControl("togItem","Toggle").onValueChanged:AddListener(function(value)
        if value==true then
            self:ChangeType(2)
        end
    end)
    self:GetControl("togGem","Toggle").onValueChanged:AddListener(function(value)
        if value==true then
            self:ChangeType(3)
        end
    end)

    self:ShowMe()
end

function BagPanel:ShowMe()
    self.base.ShowMe(self)
    if self.nowType==-1 then
        self:ChangeType(1)
    end
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





