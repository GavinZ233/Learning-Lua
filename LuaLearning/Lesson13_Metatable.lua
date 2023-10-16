print("***********************元表概念**************************")
--任何表变量都可以作为另一个表变量的元表
--任何表变量都可以有自己的元表
--当子表进行特定操作时，会执行元表的内容



print("***********************设置元表**************************")
meta={}
myTable={}
--设置元表
--（子表，元表）
setmetatable(myTable,meta)


print("***********************_tostring**************************")

meta2={
	__tostring = function(t)
		return t.name
	end
}
myTable2={
	name="吴彦祖"
}
--设置元表
--（子表，元表）
setmetatable(myTable2,meta2)

print(myTable2)



print("***********************_call**************************")


meta3={
	__tostring = function(t)
		return t.name
	end,
	__call = function(a,b)
		print("表name:"..a.name.."   传入参数:"..b) 
		--call的第一个参数是调用者,第二个是外部入参
	end

}
myTable3 = {
	name="表格名称table3"
}
--设置元表
--（子表，元表）
setmetatable(myTable3,meta3)
print(myTable3)
myTable3(3)
--子表当函数调用时，调用元表的__call方法

print("***********************运算符重载**************************")

meta4={
	--运算符+
	__add =function(t1,t2)
		return t1.age+t2.age
	end,
	--运算符-
	__sub=function(t1,t2)
		return t1.age-t2.age
	end,
	--运算符*
	__mul=function(t1,t2)
		return t1.age*t2.age
	end,
	--运算符/
	__div=function(t1,t2)
		return t1.age/t2.age
	end,
	--运算符%
	__mod=function(t1,t2)
		return t1.age%t2.age
	end,
	--运算符^
	__pow=function(t1,t2)
		return t1.age^t2.age
	end,
	--运算符==
	__eq=function(t1,t2)
		return t1.age==t2.age
	end,
	--运算符<
	__lt=function(t1,t2)
		return t1.age<t2.age
	end,
	--运算符<=
	__le=function(t1,t2)
		return t1.age<=t2.age
	end,
	--运算符..
	__concat=function(t1,t2)
		return "字符串"
	end,

}
myTable4={age=3}
setmetatable(myTable4,meta4)
myTable5={age=5}
setmetatable(myTable5,meta4)

--通过元表的方法重载运算符
print(myTable4+myTable5)
print(myTable4-myTable5)
print(myTable4*myTable5)
print(myTable4/myTable5)
print(myTable4%myTable5)
print(myTable4^myTable5)


print(myTable4==myTable5) --用条件运算符，需要两个对象的元表一致
print(myTable4>myTable5) -- > 就是 < 的反向，只需要实现 < 在调用 > 时lua会自动将两个参数调换 
print(myTable4<=myTable5)

print(myTable4..myTable5)


print("***********************_index  _newIndex**************************")
--元表的__index=自身声明在表内部时，外部访问不到属性，声明在表外部时可以访问到
meta6Father={age=2}
meta6Father.__index=meta6Father
meta6={
	--age=1,
	--__index=meta6
}
meta6.__index=meta6
myTable6={}
setmetatable(meta6,meta6Father)
setmetatable(myTable6,meta6)

--__index 当子表中找不到某属性，会到元表中 __index指定的表找索引
--这种元表的__index向上寻找可以嵌套
print(myTable6.age)

--rawget只会再自身寻找变量
print(rawget(myTable6,"age"))


--newIndex 当赋值时，如果赋值一个不存在的索引
--那么会把这个值赋值到newindex所指的表中，不会修改自己

meta7={}
meta7.__newindex={}
myTable7={}
setmetatable(myTable7,meta7)
myTable7.age=1
print(myTable7.age)--这里是默认向index寻找，但是age被指向的newindex保存了
print(meta7.__newindex.age)--这里是确切的向newindex寻找age，才能找到

rawset(myTable7,"age",2) --只会写入到自己，忽略newindex
print(myTable7.age)









