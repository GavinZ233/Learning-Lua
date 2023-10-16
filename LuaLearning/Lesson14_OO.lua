print("****************面向对象***************")
print("****************封装***************")
--面向对象类都是table实现的

Object={}
Object.id=1

function Object:DebugId()
	print(self.id)
end

--使用：是为了传入自身
function Object:new()
	--self默认第一个参数

	--对象就是变量，返回一个新的变量
	--返回出去的内容，本质上是表对象

	local obj={}
	--如果去元表找id，需要访问元表的index，此处需要给index目标是自己
	self.__index=self
	setmetatable(obj,self)
	return obj

end


local myObj=Object:new()
print(myObj)
print(myObj.id)
myObj.id=3
--当myObj自己有了id，就不会去元表找id
myObj:DebugId()




print("****************继承***************")


function Object:subClass(className)
	_G[className]={}

	local obj =_G[className]
	self.__index=self
	--子类 定义一个base属性，base属性代表父类
	obj.base=self
	setmetatable(obj,self)
end
print(_G)
_G["a"]=1
print(a)

Object:subClass("Person")
print(Person.id)

Person:DebugId()

local p1=Person:new()
print(p1.id)



print("****************多态***************")

Object:subClass("GameObject")

GameObject.posX=0;
GameObject.posY=0;

function GameObject:Move()
	self.posX=self.posX+1
	self.posY=self.posY+1
	print("Move_X:"..self.posX)
	print("Move_Y:"..self.posY)
end

GameObject:subClass("Player")


function Player:Move()
	--避免把基类表传入到方法中
	--需要执行父类逻辑时，不用冒号执行，冒号传入的self就是base，base也就是父表，这样所有子类都在一起操作父表
	--自己用点调用方法第一个参数传入自己，正好对应父方法中的self,这样每次操作的就是子表自己
	self.base.Move(self)
	print("Move".. self.id)
end

local p1=Player:new()
p1:Move()


local  p2=Player:new()
p2:Move()

