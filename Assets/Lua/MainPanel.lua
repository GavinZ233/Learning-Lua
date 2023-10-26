MainPanel={}

--提前声明变量会略微繁琐，因为可以在使用时直接加入，但这样便于以后阅读

--关联面板对象
MainPanel.panelObj=nil
--面板空间
MainPanel.btnRole=nil
MainPanel.btnSkill=nil

--实例化面板对象
--为面板处理对应的逻辑

--初始化面板实例化对象以及控件事件等
function MainPanel:Init()
    --实例化面板对象
    self.panelObj=ABMgr:LoadRes("ui","MainPanel",typeof(GameObject))
    self.panelObj.transform:SetParent(Canvas,false)
    --找到控件
    self.btnRole=self.panelObj.transform:Find("btnRole"):GetComponent(typeof(Button))
    self.btnSkill=self.panelObj.transform:Find("btnSkill"):GetComponent(typeof(Button))
    --加监听
    --这里是传入一个函数，并不是调用一个函数，所以只能去`.`，导致不能传入self，
    --致使函数执行时访问不到self的数据
    --如果要用需要外面套一个匿名函数
    --self.btnRole.onClick:AddListener(self.BtnRoleClick)
    self.btnRole.onClick:AddListener(function ()
        self:BtnRoleClick()
    end)
    self.btnSkill.onClick:AddListener(function ()
        self:BtnSkillClick()
    end)
end
function MainPanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)
end
function MainPanel:HideMe()
    self.panelObj:SetActive(false)

end

function  MainPanel:BtnRoleClick()
    print("点击角色按钮")
    BagPanel:ShowMe()
end
function  MainPanel:BtnSkillClick()
    print("点击技能按钮")
    print(self.btnRole)
end




