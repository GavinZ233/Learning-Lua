
Object:subClass("BasePanel")

BasePanel.panelObj=nil

--记录所有控件的键值对表
BasePanel.controls={}

--初始化方法，传入预制体名字
function BasePanel:Init(name)
    if self.panelObj==nil then
        self.panelObj=ABMgr:LoadRes("ui",name,typeof(GameObject))
        self.panelObj.transform:SetParent(Canvas,false)
        --GetComponentsInChildren
        --寻找UI控件存起来
        local allUIComponents=self.panelObj:GetComponentsInChildren(typeof(UIBehaviour))
        --为了避免记录无用的控件，定控件命名规则
        --Button btn
        --Toggle tog
        --Image img
        --ScrollRect sv
        --Text txt
        for i=0,allUIComponents.Length-1 do
            local componentName=allUIComponents[i].name
            if string.find(componentName,"btn")~=nil or
            string.find(componentName,"tog")~=nil or
            string.find(componentName,"img")~=nil or
            string.find(componentName,"sv")~=nil or
            string.find(componentName,"txt")~=nil 
            then
                --表中该名称的键值对不为空，说明有记录该名称的表，直接插入
                if self.controls[allUIComponents[i].name]~=nil then
                    table.insert(self.controls[allUIComponents[i].name],allUIComponents[i])
                else--无该名称的表，创建一个表
                    self.controls[allUIComponents[i].name]={allUIComponents[i]}
                end
                
            end
        end


    end
end

function BasePanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)
end

function BasePanel:HideMe()
    self.panelObj:SetActive(false)
end






















