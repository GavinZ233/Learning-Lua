print("*********************二维数组**************************")

local obj=CS.Lesson8()

print("行:"..obj.array:GetLength(0))
print("列:"..obj.array:GetLength(1))

--读取元素使用父类array提供的成员方法
print(obj.array:GetValue(0,0))
print(obj.array:GetValue(1,0))

for i=0,obj.array:GetLength(0)-1 do
	for j=0,obj.array:GetLength(1)-1 do
		print(obj.array:GetValue(i,j))
	end
end


print("*********************null和nil**************************")

--往场景对象上加应该脚本，如果存在就不加，不存在就加

local obj1=CS.UnityEngine.GameObject()
Rigidbody=CS.UnityEngine.Rigidbody
Transform=CS.UnityEngine.Transform
 
local rig  = obj1:GetComponent(typeof(Rigidbody))



--nil和null 无法==比较
--要用equals（nil）




if rig:IsNull() then
	print("无")
else
	print("有")
end



obj1:AddComponent(typeof(Rigidbody))
local rig  = obj1:GetComponent(typeof(Rigidbody))

if rig:Equals(nil) then
	print("无")
else
	print("有")
end


local trans  = obj1:GetComponent(typeof(Transform))
print(111)
if IsNull(trans) then
	print("无")
else
	print("有")
end










