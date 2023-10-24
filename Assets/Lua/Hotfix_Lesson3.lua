print("*************************************************")


util=require("xlua.util")


hf_Re=function ()
			while true do
				coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
				print("lua补丁后的协程打印")
			end
end

hf_Coroutine=function (self)
			--返回一个xlua处理过的lua协程函数
		return util.cs_generator(hf_Re)
end



xlua.hotfix(CS.HotfixMain,{
	TestCoroutine=hf_Coroutine

})

























