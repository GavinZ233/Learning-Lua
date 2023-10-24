print("**********************多函数替换**********************")



xlua.hotfix(CS.HotfixMain,{
	Update=function(self)
		print(os.time())
	end,
	Add=function (self,a,b)
		return a+b
	end,
	Speak=function (s)
		print("说话内容"..s)
	end
})


xlua.hotfix(CS.HotfixTest2,{

	--构造函数热补丁，固定写法
	[".ctor"]=function ()
		print("热补丁后的构造函数")
	end,
	Speak=function(self,a)
		print("热补丁后的Speak："..a)
	end,
	--析构函数固定写法
	Finalize=function ()
		-- body
	end
})

--构造函数和析构函数，不是替换，是先调用原来的逻辑，再调用lua逻辑

























