print("******************Lua调用C#枚举*******************")

--记录枚举的路径
PrimitiveType=CS.UnityEngine.PrimitiveType
GameObject=CS.UnityEngine.GameObject
MyEnum=CS.E_MyEnum


local obj=GameObject.CreatePrimitive(PrimitiveType.Cube)

local idle=MyEnum.Idle
print(idle)


local intEnum=MyEnum.__CastFrom(5)
print(intEnum)

local stringEnum = MyEnum.__CastFrom("Move")
print(stringEnum)


stringEnum=intEnum
print(stringEnum)

























