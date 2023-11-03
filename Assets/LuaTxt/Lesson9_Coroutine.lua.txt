print("**************************协程**************************")

GameObject =CS.UnityEngine.GameObject
WaitForSeconds=CS.UnityEngine.WaitForSeconds

--xlua提供给的工具表
util=require("xlua.util")

local obj=GameObject("Coroutine")

local mono=obj:AddComponent(typeof(CS.LuaCallCSharp))



fun=function()
	local i=1
	while i<11 do
		--yield返回Unity的类WaitForSeconds
		coroutine.yield(WaitForSeconds(1))
		print(i)
		i=i+1
		if i>3 then
			--停止本协程
			mono:StopCoroutine(co)
		end
	end
end


--执行协程方法时，需要使用util的方法cs_generator转换fun
co =mono:StartCoroutine(util.cs_generator(fun)) 













