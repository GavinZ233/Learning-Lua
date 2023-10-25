--面向对象实现 
--万物之父 所有对象的基类 Object
--封装
Object = {}
--实例化方法
function Object:new()
	local obj = {}
	--给空对象设置元表 以及 __index
	self.__index = self
	setmetatable(obj, self)
	return obj
end
--继承
function Object:subClass(className)
	--根据名字生成一张表 就是一个类
	_G[className] = {}
	local obj = _G[className]
	--设置自己的“父类”
	obj.base = self
	--给子类设置元表 以及 __index
	self.__index = self
	setmetatable(obj, self)
end