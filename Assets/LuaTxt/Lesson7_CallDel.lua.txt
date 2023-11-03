print("****************************lua调用C#委托*****************************")

local obj=CS.Lesson7()

local fun=function()
	print("lua函数Fun")
end


--第一次是nil不能直接+
--第一次需要先等于
obj.del=fun

--这种函数没有名称记录，后面无法指定移出
obj.del=obj.del+function()
	print("类似的匿名函数")
end

obj.del()

--移出函数
obj.del=obj.del-fun
obj.del()

--委托置空
obj.del=nil

obj.del=fun
obj.del()


print("****************************lua调用C#事件*****************************")

local fun2=function()
	print("事件函数")
end

obj:eventAction("+",fun2)
obj:eventAction("+",function()
	print("事件的匿名函数")
end)

obj:DoEvent()

obj:eventAction("-",fun2)

obj:DoEvent()

--事件不能直接置空，就像C#的规则一样，只能在类里开一个置空的方法

obj:Clear()

--obj5:eventAction()





















