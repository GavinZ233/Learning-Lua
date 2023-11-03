print("************************泛型类***************************")


--泛型类T是不确定的，lua中要将每个类型都替换

xlua.hotfix(CS.HotfixGenericity(CS.System.String),{
	Test=function (self,t)
		print("lua补丁打印："..t)
	end
})

xlua.hotfix(CS.HotfixGenericity(CS.System.Int32),{
	Test=function (self,t)
		print("lua补丁打印："..t)
	end
})























