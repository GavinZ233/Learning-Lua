print("*************************lua调用C#泛型方法**************************")


Lesson=CS.Lesson12
local obj=Lesson()
local child=Lesson.TestChild()
local father=Lesson.TestFather()


--有约束有参
obj:TestFun1(child,father)
obj:TestFun1(father,child)

--无约束有参的泛型,不支持
--obj:TestFun2(child)

--有约束无参数，不支持
--obj:TestFun3()

--有约束有参数约束接口的，lua不支持非class的约束
--obj:TestFun4(child)



--有一定的使用限制
--支持Mono打包
--Il2Cpp打包时，如果是泛型参数是引用类型才能用，值类型除非C#调用过了同类型的泛型参数,lua才能使用

--新版xlua可以支持使用泛型函数
--得到通用函数
--设置泛型类型再用

local testFun2 =xlua.get_generic_method(Lesson,"TestFun2")
local testFun2_int =testFun2(CS.System.Int32)

--成员方法，第一个参数传对象
--静态方法不用传
testFun2_int(obj,3)












