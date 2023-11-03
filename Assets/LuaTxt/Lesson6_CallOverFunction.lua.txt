print("********************lua调用C#重载函数**********************")


local obj=CS.Lesson6()

print(obj:Calc())
print(obj:Calc(2))
print(obj:Calc(3,1))
print(obj:Calc(3.3))
--lua虽然支持调用C#重载函数
--但是lua的数值类型只有number，对C#多经度的重载函数支持不好
--使用中避免使用经度不同的入参


--解决重载函数含糊的问题
--Xlua提供了解决方案——反射机制
--只做了解


--得到指定函数的相关信息
local m1=typeof(CS.Lesson6):GetMethod("Calc",{typeof(CS.System.Int32)})
local m2=typeof(CS.Lesson6):GetMethod("Calc",{typeof(CS.System.Single)}) --Float的类名


--通过xlua提供的方法，转成lua函数使用
--转一次，重复使用
local  f1=xlua.tofunction(m1)
local  f2=xlua.tofunction(m2)



print(f1(obj,99))
print(f2(obj,9.9))





























