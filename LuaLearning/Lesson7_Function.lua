print("****************函数***************")

function  FunName( ... )
	-- body
end

FunName=function()
	-- body
end

print("****************无参无返回值***************")
function F1()
	print("F1函数")
end
F1()

F2 = function()
	print("Func2")
end
F2()
print("****************有参***************")
function F3(a)
	print("参数："..a)
end
F3(32)
F3(tostring(true),3)

--如果入参多，舍弃多余，少就补空

print("****************有返回值***************")
function F4(a)
	return a
end
temp=F4("213")
print(temp)
print("****************函数的类型***************")
F5=function()
	print("123")
end
print(type(F5))



print("****************函数的重载***************")
-- lua不支持函数重载，默认调用最后声明的函数




print("****************变长参数***************")
function F7(...) 
	arg={...}
	for i=1 ,#arg do
		print(arg[i])
	end
end
F7(3,1,4,76,"weq32")

print("****************函数嵌套***************")

function F8()
	F9 =function()
		print(123);
	end
	return F9
end
f9=F8()
f9()

function F9(x)
	return function(y)
		return x+y 
	end
end
print(F9(10)(1))
