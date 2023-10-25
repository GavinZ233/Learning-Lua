
--读取json包的textasset文件
local txt=ABMgr:LoadRes("json","ItemData",typeof(TextAsset))

--json反序列化成表
local itemList=Json.decode(txt.text)

--加载出来的是一个像数组结构的数据
--需要用一个新表转存，方便使用

--键值对形式，key是id，值是道具表

ItemData={}
for _, value in pairs(itemList) do
    ItemData[value.id]=value
end





