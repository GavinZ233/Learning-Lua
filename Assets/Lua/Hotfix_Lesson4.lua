print("*************************属性和索引器替换***************************")


xlua.hotfix(CS.HotfixMain,{
	--set_属性名  set方法
	--get_属性名  get方法
	set_Age=function (self,v)
		print("lua重定向的set")
	end,
	get_Age=function (self,v)
		return 99
	end,

	--set_Item  索引器设置
	--get_Item  索引器获取
	set_Item=function (self,index,v)
		print("lua重定向set"..index.."值："..v)
	end,
	get_Item=function (self,index)
		return 99
	end




})































