print("**********************lua调用C#*********************")


--CS.命名空间.类名

--CS.UnityEngine.GameObject

--lua中没有New，直接调用该类名就会执行无参构造

local obj1=CS.UnityEngine.GameObject()

local obj2=CS.UnityEngine.GameObject("新物体")

--定义全局变量存储C#的类

GameObject =CS.UnityEngine.GameObject

local obj3=GameObject("全局变量中的物体类")

local newObj =GameObject.Find("新物体")

Debug=CS.UnityEngine.Debug

Debug.Log(newObj.transform.position)


Vector3=CS.UnityEngine.Vector3




--Translate是成员方法，用:,
--C#简化了需要传入本身类的操作，不然就相当于少传一个参数
--translate只给一个向量没有gameobject是不能执行的
newObj.transform:Translate(Vector3.right)

--无命名空间直接不写
Test1=CS.Test
t1=Test1()

t1:Speak("开始")

Test2=CS.NewSpace.Test
t2=Test2()

t2:Speak("开始")


--继承Mono的类，无法直接New
local obj5=GameObject("添加脚本")

obj5:AddComponent(typeof(CS.LuaCallCSharp))
--Unity中只能使用泛型和Type添加脚本
--xlua不支持无参泛型函数，就需要考虑Type
--Xlua提供一个方法，typeof可以得到类的type








