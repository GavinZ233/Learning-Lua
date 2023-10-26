BagPanel={}

--控件
BagPanel.panelObj=nil
BagPanel.btnClose=nil
BagPanel.togEquip=nil
BagPanel.togItem=nil
BagPanel.togGem=nil
BagPanel.svBag=nil
BagPanel.Content=nil


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
function BagPanel:ChangeType(type)
    print("类型切换为:"..type)


end





