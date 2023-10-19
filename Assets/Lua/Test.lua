print('执行Test')


testNumber=5
testBool=true
testFloat=3.15926
testString="string啊啊啊啊"


--无参无返回
testNoINAndOUT =function ()
	print("无参无返回")
end



--有参有返回
testHasINAndOUT =function (a)
	print("有参有返回"..a)
	return a+1
end


--多返回值
testMultipleOUT =function ()
	print("多返回值")
	return 3,"wqe",false
end


--变长参数

testMultipleIn =function (...)
	args={...}
	print("变长参数")
	for k,v in pairs(args) do
		print(k,v)
	end
end



