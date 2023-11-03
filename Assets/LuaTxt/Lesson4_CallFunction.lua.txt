print("*****************lua调用C#拓展方法*******************")

Lesson4=CS.Lesson4

--静态方法，类名.静态方法()
Lesson4.Eat()

local obj=Lesson4()
obj:Speak("开始说话")



--使用拓展方法和成员方法一致
obj:Move()
--拓展方法的类需要加特性[LuaCallCSharp]
















