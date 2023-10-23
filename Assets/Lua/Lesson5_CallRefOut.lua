print("*********************lua调用C#的ref和out方法**********************")

Lesson5=CS.Lesson5

local obj=Lesson5()

--ref参数，会以多返回值的形式返回给lua

--函数多返回值，第一个是返回值，后面的是ref结果
--ref需要传入初始值
local a,b,c  =obj:RefFun(1,1,2,2)
print(a)
print(b)
print(c)


--out不需要传默认值
local a,b,c=obj:OutFun(20,30)
print(a)
print(b)
print(c)



local a,b,c=obj:RefOutFun(2,1)
print(a)
print(b)
print(c)
















