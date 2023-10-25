print("*******************事件加减******************")


xlua.hotfix(CS.HotfixMain,{

add_myEvent=function (self,del)
	print(del)
	print("添加事件函数")
	--添加方法被重定向后，就无法正常添加了，不能继续调用C#的添加方法，会造成死循环
	--一般是将函数存在lua中

end,
remove_myEvent=function (self,del)
	print(del)
	print("移除事件函数")
end

})























