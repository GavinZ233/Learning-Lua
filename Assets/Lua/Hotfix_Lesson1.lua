print("************************第一个热补丁*************************")


--lua当中热补丁固定写法		
--xlua.hotfix(类，函数名，lua函数)

hf_Add=function(self,a,b)
	return a+b
end

hf_Speak=function (s)
	print(s)
end

xlua.hotfix(CS.HotfixMain,"Add",hf_Add)

xlua.hotfix(CS.HotfixMain,"Speak",hf_Speak)

--写好代码后，需要
--1.加特性   [Hotfix]
--2.加宏     ProjectSettings==>Player==>OtherSettings==>ScriptingDefineSymbols  填写HOTFIX_ENABLE
--3.生成代码	 Xlua==>GenerateCode
--4.hotfix注入 Xlua==>HotfixInjectInEditor
--注入时，可能提示引入Tools Tools在xLua-master==>Tools
--Tools复制到项目总文件夹下
--重新注入


--热补丁的缺点：只要修改了被热补丁类的代码，就需要重新注入


hf_GetAge=function (self)
	return self.age
end

xlua.hotfix(CS.HotfixTest,"GetAge",hf_GetAge)


hf_GetAge1=function (self)
	return self.age
end

xlua.hotfix(CS.HotfixTest1,"GetAge",hf_GetAge1)
