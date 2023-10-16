--所有的基类 Object

Object={}


--实例化方法
function Object:new()
	local obj={}
	--给空对象设置元表，和__index
	self.__index=self
	setmetatable(obj,self)
	return obj
end

--继承
function Object:subClass(className)
	--根据名字生成一个表,记录在全局_G表
	_G[className] ={}
	local obj =_G[className]
	--给子表记录父表,命名为base
	obj.base=self

	--给子类设置元表，和__index
	setmetatable(obj,self)
	self.__index=self

end

--申明一个新的类
Object:subClass("GameObject")
--成员变量
GameObject.posX=0;
GameObject.posY=0;

--成员方法
function GameObject:Move()
	self.posX=self.posX+1
	self.posY=self.posY+1
end

--实例化对象使用
local obj=GameObject:new()
print(obj.posX)
obj:Move()
print(obj.posX)

local obj2=GameObject:new()
print(obj2.posX)
obj2:Move()
obj2:Move()
print(obj2.posX)


GameObject:subClass("Player")
function Player:Move()
	self.base.Move(self)
end
 
--实例化player对象
local p1=Player:new()
p1:Move()
print(p1.posX)

local p2=Player:new()
p2:Move()
p2:Move()

print(p2.posX)

