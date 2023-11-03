
Object:subClass("BasePanel")

BasePanel.panelObj=nil

--记录所有控件的键值对表
BasePanel.controls={}
--事件监听标识,避免重复添加
BasePanel.isInitEvent=false

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
            local controlName=allUIComponents[i].name
            if string.find(controlName,"btn")~=nil or
            string.find(controlName,"tog")~=nil or
            string.find(controlName,"img")~=nil or
            string.find(controlName,"sv")~=nil or
            string.find(controlName,"txt")~=nil 
            then
                --为了让得到的时候，能够确定控件类型，需要存储类型
                --通过反射Type得到控件的类名
                local typeName=allUIComponents[i]:GetType().Name

               --判断该名称的键值是否为空，证明是否已经记录该表
                if self.controls[allUIComponents[i].name]~=nil then
                     --已经存在该表，直接对着索引复制
                    self.controls[controlName][typeName]=allUIComponents[i]
                else
                    --不存在该表，就对该索引复制一个记录该GameObject的表
                    self.controls[controlName]={[typeName]=allUIComponents[i]}
                end
                --数据示例
                --{btnRole={Image=Image ,Button=Button},togItem={Toggle=Toggle }}
            end
        end
    end
end

function BasePanel:GetControl(name,typeName)
    --先判断是否存在
    if self.controls[name]~=nil then
        --找到控件表，得到控件下的components
        local sameNameControls=self.controls[name]
        --验证该控件下是否有该component
        if sameNameControls[typeName]~=nil then
            --返回该component
            return sameNameControls[typeName]
        end
    end
end

function BasePanel:ShowMe()
    
    self.panelObj:SetActive(true)
end

function BasePanel:HideMe()
    self.panelObj:SetActive(false)
end






















