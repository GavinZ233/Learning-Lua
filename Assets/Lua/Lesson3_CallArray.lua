print("**********************Lua调用C#数组 List Dic**********************")


local obj=CS.Lesson3()


--当前结构保留了C#的结构，属于userdata,C#怎么用，lua就怎么用，不能用#去获取长度
print("数组长度：  "..obj.array.Length)

print("访问数组：  "..obj.array[0])

--遍历时，还是需要按照C#的标准来，索引从0开始
--因为lua的for循环最后是等于，所以这里的Length需要-1
for i=0,obj.array.Length-1 do
	print(obj.array[i])
end

--创建数组
--使用Array类中的静态方法
local array2=CS.System.Array.CreateInstance(typeof(CS.System.Int32),5)
print("数组长度： "..array2.Length )
print("数组内容：  ".. array2[4])


print("**********************Lua调用C# List**********************")

obj.list:Add(12)
obj.list:Add(13)

for i=0,obj.list.Count-1 do
	print(obj.list[i])
end


--老版本
local list2=CS.System.Collections.Generic["List`1[System.String]"]()
print(list2)
list2:Add("加入元素1")
list2:Add("加入元素2")
print(list2[1])
--新版本  > Xlua版本 v2.1.12

--先记录String类型List
local List_String=CS.System.Collections.Generic.List(CS.System.String)
--再实例化
local list3=List_String() 
list3:Add("添加元素3")
print(list3[0])





print("**********************Lua调用C# Dic**********************")


obj.dic:Add(1,"111")
obj.dic:Add(2,"222")
obj.dic:Add(3,"333")

print(obj.dic[1])

for k,v in pairs(obj.dic) do
	print(k,v)
end

--新版本

--记录一个Dic<string,V3>的字典
local Dic_String_Vector3=CS.System.Collections.Generic.Dictionary(CS.System.String,CS.UnityEngine.Vector3)
--实例化字典
local dic2=Dic_String_Vector3()

dic2:Add("right",CS.UnityEngine.Vector3.right)

for k,v in pairs(dic2) do
	print(k,v)
end

--在lua中创建的字典，通过键直接访问得不到
print(dic2["right"])
--需要通过get_Item方法获得
print(dic2:get_Item("right"))
--修改通过set_Item
dic2:set_Item("right",CS.UnityEngine.Vector3.up)
print(dic2:get_Item("right"))
--TryGetValue有两个返回值，一个返回是否成功，一个返回值
print(dic2:TryGetValue("right3"))



